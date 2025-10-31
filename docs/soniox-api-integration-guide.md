# Soniox Speech API Integration Guide

Comprehensive instructions for building production-grade integrations on top of Soniox's Speech-to-Text REST and WebSocket APIs, with an emphasis on secure key handling, asynchronous batch jobs, real-time streaming, and translation features.[[Soniox API Reference](https://soniox.com/docs/stt/api-reference)]

## Table of Contents
- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Authentication & Temporary Keys](#authentication--temporary-keys)
- [File Management for Async Pipelines](#file-management-for-async-pipelines)
- [Asynchronous Transcriptions](#asynchronous-transcriptions)
- [WebSocket Streaming API](#websocket-streaming-api)
- [Real-Time Translation](#real-time-translation)
- [SDK & Tooling Examples](#sdk--tooling-examples)
- [Observability & Troubleshooting](#observability--troubleshooting)
- [Resources](#resources)

## Overview

Soniox exposes a versioned REST API at `https://api.soniox.com/v1` for CRUD-style operations (authentication, file lifecycle management, asynchronous transcription) and a low-latency WebSocket endpoint at `wss://stt-rt.soniox.com/transcribe-websocket` for live audio streaming with diarisation, context customisation, and translation.[[Soniox API Reference](https://soniox.com/docs/stt/api-reference)] Both surfaces share the same models, support 60+ languages, and emit consistent token structures so you can mix async batch jobs with real-time sessions in the same platform.

## System Architecture

### Async Batch Flow
1. **Upload media** via `POST /v1/files` (supports 500 MB multipart uploads) and persist the returned `file_id` for auditing.[[Soniox Files API](https://soniox.com/docs/stt/api-reference/files/upload_file)]
2. **Submit a transcription job** with `POST /v1/transcriptions`, referencing either `file_id` or a signed `audio_url`, and include context, diarisation, translation, and webhook settings as needed.[[Soniox Transcriptions API](https://soniox.com/docs/stt/api-reference/transcriptions/create_transcription)]
3. **Consume results** by polling `GET /v1/transcriptions/{id}` or by handling webhook callbacks that Soniox issues once processing completes.[[Soniox Transcriptions API](https://soniox.com/docs/stt/api-reference/transcriptions/create_transcription)]
4. **Perform retention or deletion** through `DELETE /v1/files/{id}` once governance policies allow, and store `request_id` values for observability.[[Soniox Files API](https://soniox.com/docs/stt/api-reference/files/upload_file)]

### Real-Time Flow
1. **Mint temporary keys** scoped to streaming clients so browsers or edge devices never see long-lived secrets.[[Soniox Auth API](https://soniox.com/docs/stt/api-reference/auth/create_temporary_api_key)]
2. **Open a WebSocket**, send a JSON configuration envelope (model, audio format, diarisation, translation, context), then stream 16-bit PCM frames in 100–200 ms batches.[[Soniox WebSocket API](https://soniox.com/docs/stt/api-reference/websocket-api)]
3. **Process incremental tokens** that include `text`, timestamps, speaker labels, confidence, and translation metadata, and gracefully close the stream by sending an empty binary frame so Soniox returns a `finished` message.[[Soniox WebSocket API](https://soniox.com/docs/stt/api-reference/websocket-api)]
4. **Display ultra-low-latency translations** by checking every token's `translation_status` and `source_language`, enabling live bilingual experiences.[[Soniox Real-time Translation](https://soniox.com/docs/stt/rt/real-time-translation)]

### Security & Compliance Notes
- Use `client_reference_id` for every REST call so you can correlate requests with audit trails.
- Terminate temp keys within 60 minutes (`expires_in_seconds ≤ 3600`) and log the `expires_at` timestamp server-side.[[Soniox Auth API](https://soniox.com/docs/stt/api-reference/auth/create_temporary_api_key)]
- Guard webhook endpoints with the provided `webhook_auth_header_name/value` pair, and treat `request_id` as the canonical trace id across retries.[[Soniox Transcriptions API](https://soniox.com/docs/stt/api-reference/transcriptions/create_transcription)]

## Authentication & Temporary Keys

Use the Auth API to mint purpose-built credentials that your backend can hand to browsers, mobile apps, or media servers without exposing long-lived API keys.[[Soniox Auth API](https://soniox.com/docs/stt/api-reference/auth/create_temporary_api_key)]

```bash
curl -X POST "https://api.soniox.com/v1/auth/temporary-api-key" \
  -H "Authorization: Bearer $SONIOX_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "usage_type": "transcribe_websocket",
    "expires_in_seconds": 900,
    "client_reference_id": "agent-frontend-123"
  }'
```

**Key fields**
- `usage_type` *(required)*: Currently accepts `transcribe_websocket` for live clients.
- `expires_in_seconds` *(required)*: 1–3600 seconds; Soniox enforces the ceiling and returns validation errors if you exceed it.
- `client_reference_id` *(optional)*: Up to 256 characters for tracing.

**Response**
- `api_key`: Scoped secret prefixed with `temp:`.
- `expires_at`: ISO-8601 timestamp – persist this to drive automatic refreshes.

Reject requests lacking a valid Bearer token (`401`) and bubble up `request_id` strings from error payloads to speed up support escalations.

## File Management for Async Pipelines

Upload source audio once, then re-use the `file_id` for multiple experiments or model comparisons.[[Soniox Files API](https://soniox.com/docs/stt/api-reference/files/upload_file)]

```bash
curl -X POST "https://api.soniox.com/v1/files" \
  -H "Authorization: Bearer $SONIOX_API_KEY" \
  -F "file=@call_recording.wav" \
  -F "client_reference_id=case-4821"
```

- Content type must be `multipart/form-data`.
- File size cap: 524 288 000 bytes (500 MB); Soniox returns `400 invalid_request` when exceeded.
- Response includes `id` (UUID), `filename`, `size`, `created_at`, and echoes `client_reference_id`.

Store uploads in object storage if you prefer `audio_url` workflows, but remember that URLs must be HTTPS and publicly reachable or pre-signed for Soniox to fetch them.

## Asynchronous Transcriptions

Submit batch jobs through `POST /v1/transcriptions` and configure accuracy, translation, and delivery preferences per request.[[Soniox Transcriptions API](https://soniox.com/docs/stt/api-reference/transcriptions/create_transcription)]

```bash
curl -X POST "https://api.soniox.com/v1/transcriptions" \
  -H "Authorization: Bearer $SONIOX_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "stt-async-v3",
    "file_id": "84c32fc6-4fb5-4e7a-b656-b5ec70493753",
    "language_hints": ["en", "fr"],
    "enable_speaker_diarization": true,
    "enable_language_identification": true,
    "translation": {
      "type": "two_way",
      "language_a": "en",
      "language_b": "fr"
    },
    "context": {
      "general": [
        { "key": "domain", "value": "Healthcare" },
        { "key": "topic", "value": "Diabetes management" }
      ],
      "text": "Follow-up appointment 20 Feb",
      "terms": ["metformin", "HbA1c"],
      "translation_terms": [
        { "source": "CGM", "target": "capteur de glucose" }
      ]
    },
    "webhook_url": "https://hooks.example.com/soniox",
    "webhook_auth_header_name": "X-Soniox-Signature",
    "webhook_auth_header_value": "sha256=***redacted***",
    "client_reference_id": "case-4821"
  }'
```

**Required inputs**
- `model`: e.g., `stt-async-v3`; keep the value ≤ 32 characters.
- One of `file_id` *(UUID of an uploaded file)* or `audio_url` *(public HTTPS URL)*.

**Optional accuracy levers**
- `language_hints`: Array of expected ISO language codes.
- `enable_speaker_diarization` / `enable_language_identification`: Booleans for speaker and language labelling.
- `context`: Structured hints (general key/value pairs, free-form `text`, domain-specific `terms`, plus `translation_terms` for consistent bilingual phrasing).
- `translation`: Mirror the streaming translation object by specifying `type` (`one_way` or `two_way`) and the appropriate language fields, unlocking real-time bilingual output even in async jobs.[[Soniox Real-time Translation](https://soniox.com/docs/stt/rt/real-time-translation)]

**Delivery**
- `webhook_url`: HTTPS endpoint for completion/failure callbacks.
- Optional authentication headers protect the webhook receiver.
- Poll `GET /v1/transcriptions/{id}` if webhooks are unavailable.

**Response highlights**
- `id`, `status` (`queued`, `processing`, `completed`, `failed`), `model`, `file_id`, `language_hints`, `context`, `audio_duration_ms`, `webhook_*`, `client_reference_id`.
- Errors follow a consistent schema with `status_code`, `error_type` (`invalid_request`, `unauthenticated`, etc.), `validation_errors[]`, and `request_id`.

## WebSocket Streaming API

Use the WebSocket API for live captioning, translation, and diarisation in meetings, broadcasts, or interactive tools.[[Soniox WebSocket API](https://soniox.com/docs/stt/api-reference/websocket-api)]

### Session Setup
1. Connect to `wss://stt-rt.soniox.com/transcribe-websocket`.
2. Immediately send a JSON config message similar to:

```json
{
  "api_key": "temp:WYJ67RBEF...",
  "model": "stt-rt-v3",
  "audio_format": "pcm_s16le",
  "num_channels": 1,
  "sample_rate": 16000,
  "language_hints": ["en", "es"],
  "enable_speaker_diarization": true,
  "enable_language_identification": true,
  "enable_endpoint_detection": true,
  "translation": {
    "type": "two_way",
    "language_a": "en",
    "language_b": "es"
  },
  "context": {
    "general": [
      { "key": "domain", "value": "Customer support" }
    ],
    "terms": ["RMA", "omnichannel"]
  }
}
```

3. Stream binary audio frames (100–200 ms chunks) and honour backpressure from the server to avoid dropped frames.
4. To finish, send an empty binary message; Soniox replies with `{"finished": true, ...}` and then closes the socket.

### Responses
- `tokens[]`: Incremental units that include `text`, `start_ms`, `end_ms`, `confidence`, `is_final`, `speaker`, `translation_status`, `language`, and `source_language` (for translation tokens).
- `final_audio_proc_ms` / `total_audio_proc_ms`: Server-side timing metrics.
- Errors surface as `{ "error_code": 4xx/5xx, "error_message": "..." }` followed by an immediate connection close.

Implement heartbeat handling (e.g., respond to pings or send periodic keepalive bytes) to keep longer conversations alive, and propagate `error_code` mappings (400, 401, 402, 408, 429, 500, 503) into your monitoring pipeline for alerting.[[Soniox WebSocket API](https://soniox.com/docs/stt/api-reference/websocket-api)]

## Real-Time Translation

Soniox's translation pipeline emits transcription and translation tokens in the same stream, enabling bilingual captions with minimal latency.[[Soniox Real-time Translation](https://soniox.com/docs/stt/rt/real-time-translation)]

- **One-way translation**: Provide `{"translation": {"type": "one_way", "target_language": "fr"}}` to translate every utterance into a single target language while still receiving the source transcription tokens.
- **Two-way translation**: Provide `language_a` and `language_b` to build conversational bridges (e.g., Japanese ↔ Korean). Soniox automatically detects which participant is speaking and issues translations in the opposite language.
- **Token semantics**:
  - Spoken tokens have `translation_status: "none"` or `"original"` and include timestamps (`start_ms`, `end_ms`).
  - Translation tokens have `translation_status: "translation"`, include both `language` (target) and `source_language`, and deliberately omit timestamps because they immediately follow the spoken segment.
- **Display strategy**: Render tokens as they arrive; do not wait for sentence boundaries. Use `is_final` to know when to promote interim captions to the final transcript.

## SDK & Tooling Examples

### Python async pipeline (uv + HTTPX)

```bash
uv pip install httpx
```

```python
import asyncio
import httpx
from pathlib import Path

API_KEY = Path(".soniox-key").read_text().strip()
HEADERS = {"Authorization": f"Bearer {API_KEY}"}


async def upload_file(client: httpx.AsyncClient, path: Path) -> str:
    with path.open("rb") as fh:
        files = {"file": (path.name, fh, "audio/wav")}
        resp = await client.post("/files", headers=HEADERS, files=files, data={"client_reference_id": "case-4821"})
    resp.raise_for_status()
    return resp.json()["id"]


async def create_transcription(client: httpx.AsyncClient, file_id: str) -> dict:
    payload = {
        "model": "stt-async-v3",
        "file_id": file_id,
        "enable_speaker_diarization": True,
        "webhook_url": "https://hooks.example.com/soniox",
    }
    resp = await client.post("/transcriptions", headers=HEADERS, json=payload)
    resp.raise_for_status()
    return resp.json()


async def main():
    async with httpx.AsyncClient(base_url="https://api.soniox.com/v1", timeout=60) as client:
        file_id = await upload_file(client, Path("call.wav"))
        job = await create_transcription(client, file_id)
        print("Transcription job:", job["id"])


if __name__ == "__main__":
    asyncio.run(main())
```

This script aligns with the REST reference endpoints, surfaces HTTP errors, and keeps API keys outside the codebase via `PATH` reads.[[Soniox Files API](https://soniox.com/docs/stt/api-reference/files/upload_file)][[Soniox Transcriptions API](https://soniox.com/docs/stt/api-reference/transcriptions/create_transcription)]

### Node.js WebSocket streamer

```bash
npm install ws
```

```javascript
import { WebSocket } from "ws";
import fs from "node:fs";

const tempKey = process.env.SONIOX_TEMP_KEY;
const audio = fs.readFileSync("live.wav");

const ws = new WebSocket("wss://stt-rt.soniox.com/transcribe-websocket");

ws.on("open", () => {
  ws.send(JSON.stringify({
    api_key: tempKey,
    model: "stt-rt-v3",
    audio_format: "pcm_s16le",
    sample_rate: 16000,
    enable_speaker_diarization: true,
  }));
  ws.send(audio);
  ws.send(Buffer.alloc(0)); // graceful end
});

ws.on("message", (data) => {
  const payload = JSON.parse(data.toString("utf8"));
  if (payload.tokens) {
    const text = payload.tokens.map((t) => t.text).join("");
    console.log(payload.tokens[0]?.is_final ? "FINAL:" : "PARTIAL:", text);
  }
  if (payload.finished) {
    ws.close();
  }
});
```

Couple this with a backend service that calls `POST /v1/auth/temporary-api-key` and injects the returned `temp:` key via `SONIOX_TEMP_KEY` to keep front-end clients stateless and secure.[[Soniox Auth API](https://soniox.com/docs/stt/api-reference/auth/create_temporary_api_key)][[Soniox WebSocket API](https://soniox.com/docs/stt/api-reference/websocket-api)]

### Tooling & Deployment Tips
- Use `uv` workspaces and lockfiles for deterministic Python builds (see `docs/uv-python-guide.md`) and bake them into the multi-stage Docker workflow outlined in `docs/docker-uv-guide.md` for reproducible CI artifacts.
- Front-end or edge agents should request temporary keys from a hardened backend rather than storing static API keys in browsers.
- Cache Soniox responses together with `request_id` to quickly replay or diagnose failures.

## Observability & Troubleshooting

- **Common HTTP errors**: `400 invalid_request` (schema validation), `401 unauthenticated`, `402 payment_required`, `408 request_timeout`, `429 too_many_requests`, `500/503` server-side issues. Always log `error_type`, `validation_errors`, and `request_id` from the payload.[[Soniox Files API](https://soniox.com/docs/stt/api-reference/files/upload_file)][[Soniox Transcriptions API](https://soniox.com/docs/stt/api-reference/transcriptions/create_transcription)]
- **WebSocket failures**: Inspect `error_code` + `error_message`, then reconnect with exponential backoff. Avoid resending the configuration envelope unless the socket is re-established.[[Soniox WebSocket API](https://soniox.com/docs/stt/api-reference/websocket-api)]
- **Webhook delivery**: Treat webhook callbacks as idempotent and validate your auth header before processing. If Soniox cannot reach your endpoint, jobs remain accessible via polling so you can fall back gracefully.
- **Translation drift**: Translation tokens may not align 1:1 with source tokens; use `translation_status` and `source_language` instead of relying on positional indexes.[[Soniox Real-time Translation](https://soniox.com/docs/stt/rt/real-time-translation)]

## Resources
- Soniox API Reference: https://soniox.com/docs/stt/api-reference
- Temporary Key Endpoint: https://soniox.com/docs/stt/api-reference/auth/create_temporary_api_key
- File Upload Endpoint: https://soniox.com/docs/stt/api-reference/files/upload_file
- Create Transcription Endpoint: https://soniox.com/docs/stt/api-reference/transcriptions/create_transcription
- WebSocket Streaming Reference: https://soniox.com/docs/stt/api-reference/websocket-api
- Real-Time Translation Guide: https://soniox.com/docs/stt/rt/real-time-translation
