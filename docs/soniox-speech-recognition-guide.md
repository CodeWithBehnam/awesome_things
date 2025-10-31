# Soniox Speech Recognition API Guide

A comprehensive guide to Soniox's universal speech AI platform for transcription, translation, and real-time audio processing across 60+ languages.

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Getting Started](#getting-started)
- [API Architecture](#api-architecture)
- [Models](#models)
- [Real-Time Transcription](#real-time-transcription)
- [Asynchronous Transcription](#asynchronous-transcription)
- [WebSocket API](#websocket-api)
- [Advanced Features](#advanced-features)
- [SDKs and Integrations](#sdks-and-integrations)
- [Code Examples](#code-examples)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## Overview

Soniox Speech-to-Text is a **universal speech AI** platform that provides highly accurate, scalable audio transcription and translation capabilities. The platform supports 60+ languages with seamless language switching within conversations, making it ideal for multilingual applications, real-time communication, and enterprise-scale audio processing.

### Core Capabilities

- **Real-time transcription** with ultra-low latency
- **Asynchronous file processing** for batch operations
- **Live translation** between multiple languages
- **Speaker diarization** for multi-speaker scenarios
- **Context customisation** for domain-specific accuracy
- **Automatic language identification**
- **Endpoint detection** for natural conversation flow

## Key Features

### Universal Language Support
- **60+ languages** supported with automatic detection
- **Mixed-language conversations** handled seamlessly
- **Real-time language switching** without interruption
- **High accuracy** across all supported languages

### Real-Time Processing
- **WebSocket-based streaming** for live audio
- **Ultra-low latency** transcription
- **Partial results** for immediate feedback
- **Confidence scores** for each token

### Advanced Audio Intelligence
- **Speaker diarization** identifies individual speakers
- **Context awareness** improves accuracy for specific domains
- **Custom vocabulary** for specialised terminology
- **Translation terms** for consistent multilingual output

### Enterprise Features
- **Scalable architecture** for high-volume processing
- **REST and WebSocket APIs** for flexible integration
- **Temporary API keys** for secure client-side usage
- **Comprehensive error handling** and monitoring

## Getting Started

### Prerequisites

- Soniox account ([Sign up here](https://console.soniox.com/signup))
- API key from the [Soniox Console](https://console.soniox.com)
- Supported programming language (Python, Node.js, or Web SDK)

### Quick Setup

1. **Create Account and Get API Key**
   ```bash
   # Sign up at https://console.soniox.com/signup
   # Navigate to "My First Project" → "API Keys"
   # Generate your API key
   ```

2. **Set Environment Variable**
   ```bash
   export SONIOX_API_KEY="your-api-key-here"
   ```

3. **Clone Examples Repository**
   ```bash
   git clone https://github.com/soniox/soniox_examples
   cd soniox_examples/speech_to_text
   ```

4. **Run Your First Transcription**
   ```bash
   # Python
   cd python
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   python soniox_realtime.py --audio_path ../assets/coffee_shop.mp3
   
   # Node.js
   cd nodejs
   npm install
   node soniox_realtime.js --audio_path ../assets/coffee_shop.mp3
   ```

## API Architecture

Soniox provides two primary API interfaces:

### REST API
- **Base URL**: `https://api.soniox.com/v1`
- **Use Cases**: File uploads, batch processing, management operations
- **Endpoints**:
  - **Auth API**: Temporary API key creation
  - **Files API**: Audio file management
  - **Models API**: Available model listing
  - **Transcriptions API**: Async transcription processing

### WebSocket API
- **Endpoint**: `wss://stt-rt.soniox.com/transcribe-websocket`
- **Use Cases**: Real-time streaming, live transcription
- **Features**: Persistent connection, low latency, bidirectional communication

## Models

### Current Models (Active)

| Model | Type | Status | Key Features |
|-------|------|--------|--------------|
| **stt-rt-v3** | Real-time | **Active** | Latest real-time model with enhanced accuracy |
| **stt-async-v3** | Async | **Active** | Latest async model with translation support |

### Model Aliases

| Alias | Points to | Notes |
|-------|-----------|-------|
| **stt-rt-v3-preview** | `stt-rt-v3` | Always points to latest real-time model |

### Deprecated Models (Retiring November 30, 2025)

- `stt-rt-preview-v2`
- `stt-async-preview-v1`

**Migration Required**: Update to v3 models before November 30, 2025.

### Model Capabilities

#### stt-rt-v3 (Real-time)
- **Languages**: 60+ languages with automatic detection
- **Latency**: Ultra-low latency streaming
- **Features**: Speaker diarization, language identification, endpoint detection
- **Translation**: One-way and two-way translation support
- **Context**: Advanced structured context support
- **Duration**: Up to 5 hours per stream

#### stt-async-v3 (Asynchronous)
- **Languages**: 60+ languages with automatic detection
- **Features**: Speaker diarization, language identification
- **Translation**: One-way and two-way translation support
- **Context**: Advanced structured context support
- **Duration**: Up to 5 hours per file
- **Processing**: Batch processing with webhook notifications

## Real-Time Transcription

### WebSocket Configuration

```json
{
  "api_key": "your-api-key",
  "model": "stt-rt-v3",
  "audio_format": "auto",
  "language_hints": ["en", "es"],
  "context": {
    "general": [
      { "key": "domain", "value": "Healthcare" },
      { "key": "topic", "value": "Patient consultation" }
    ],
    "text": "Previous consultation notes...",
    "terms": ["Celebrex", "Zyrtec", "Xanax"],
    "translation_terms": [
      { "source": "Mr. Smith", "target": "Sr. Smith" }
    ]
  },
  "enable_speaker_diarization": true,
  "enable_language_identification": true,
  "enable_endpoint_detection": true,
  "translation": {
    "type": "two_way",
    "language_a": "en",
    "language_b": "es"
  }
}
```

### Audio Formats

| Format | Description | Channels | Sample Rate |
|--------|-------------|----------|-------------|
| `auto` | Automatic detection | Any | Any |
| `pcm_s16le` | 16-bit PCM little-endian | 1-2 | 8000-48000 |
| `pcm_s24le` | 24-bit PCM little-endian | 1-2 | 8000-48000 |
| `pcm_s32le` | 32-bit PCM little-endian | 1-2 | 8000-48000 |
| `mulaw` | μ-law encoding | 1 | 8000 |
| `alaw` | A-law encoding | 1 | 8000 |

### Response Format

```json
{
  "tokens": [
    {
      "text": "Hello",
      "start_ms": 600,
      "end_ms": 760,
      "confidence": 0.97,
      "is_final": true,
      "speaker": "1",
      "language": "en"
    }
  ],
  "final_audio_proc_ms": 760,
  "total_audio_proc_ms": 880
}
```

## Asynchronous Transcription

### File Upload Process

1. **Upload Audio File**
   ```bash
   curl -X POST "https://api.soniox.com/v1/files" \
     -H "Authorization: Bearer $SONIOX_API_KEY" \
     -F "file=@audio.mp3"
   ```

2. **Create Transcription**
   ```bash
   curl -X POST "https://api.soniox.com/v1/transcriptions" \
     -H "Authorization: Bearer $SONIOX_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{
       "file_id": "file_id_from_upload",
       "model": "stt-async-v3",
       "enable_speaker_diarization": true
     }'
   ```

3. **Poll for Results**
   ```bash
   curl -X GET "https://api.soniox.com/v1/transcriptions/transcription_id" \
     -H "Authorization: Bearer $SONIOX_API_KEY"
   ```

### Webhook Integration

Configure webhooks for automatic result delivery:

```json
{
  "webhook_url": "https://your-app.com/webhook",
  "webhook_secret": "your-secret-key"
}
```

## WebSocket API

### Connection Flow

1. **Establish WebSocket Connection**
   ```javascript
   const ws = new WebSocket('wss://stt-rt.soniox.com/transcribe-websocket');
   ```

2. **Send Configuration**
   ```javascript
   ws.send(JSON.stringify({
     api_key: 'your-api-key',
     model: 'stt-rt-v3',
     audio_format: 'auto',
     enable_speaker_diarization: true
   }));
   ```

3. **Stream Audio Data**
   ```javascript
   // Send binary audio frames
   ws.send(audioBuffer);
   ```

4. **Handle Responses**
   ```javascript
   ws.onmessage = (event) => {
     const result = JSON.parse(event.data);
     // Process transcription tokens
   };
   ```

5. **End Stream**
   ```javascript
   // Send empty frame to end gracefully
   ws.send('');
   ```

### Error Handling

```json
{
  "tokens": [],
  "error_code": 503,
  "error_message": "Service temporarily unavailable"
}
```

## Advanced Features

### Speaker Diarization

Identifies and separates different speakers in multi-speaker audio:

```json
{
  "enable_speaker_diarization": true
}
```

**Response includes speaker labels:**
```json
{
  "tokens": [
    {
      "text": "Hello",
      "speaker": "1"
    },
    {
      "text": "Hi there",
      "speaker": "2"
    }
  ]
}
```

### Language Identification

Automatically detects the language being spoken:

```json
{
  "enable_language_identification": true
}
```

**Response includes language information:**
```json
{
  "tokens": [
    {
      "text": "Hola",
      "language": "es"
    }
  ]
}
```

### Context Customisation

Improve accuracy with domain-specific context:

```json
{
  "context": {
    "general": [
      { "key": "domain", "value": "Healthcare" },
      { "key": "specialty", "value": "Cardiology" }
    ],
    "text": "Patient history and previous consultations...",
    "terms": [
      "myocardial infarction",
      "angioplasty",
      "stent placement"
    ]
  }
}
```

### Real-Time Translation

#### One-Way Translation
```json
{
  "translation": {
    "type": "one_way",
    "target_language": "es"
  }
}
```

#### Two-Way Translation
```json
{
  "translation": {
    "type": "two_way",
    "language_a": "en",
    "language_b": "es"
  }
}
```

### Endpoint Detection

Automatically detects natural speech boundaries:

```json
{
  "enable_endpoint_detection": true
}
```

## SDKs and Integrations

### Python SDK

**Installation:**
```bash
pip install soniox
```

**Basic Usage:**
```python
import soniox

# Real-time transcription
client = soniox.SpeechClient(api_key="your-api-key")

# Stream audio and get results
for result in client.transcribe_stream(audio_stream):
    print(f"Text: {result.text}")
    print(f"Confidence: {result.confidence}")
```

### Node.js SDK

**Installation:**
```bash
npm install soniox
```

**Basic Usage:**
```javascript
const soniox = require('soniox');

const client = new soniox.SpeechClient({
  apiKey: 'your-api-key'
});

// Real-time transcription
client.transcribeStream(audioStream, (result) => {
  console.log('Text:', result.text);
  console.log('Confidence:', result.confidence);
});
```

### Web SDK

**Installation:**
```html
<script src="https://unpkg.com/@soniox/soniox-web-sdk@latest/dist/soniox-web-sdk.js"></script>
```

**Basic Usage:**
```javascript
const sonioxClient = new SonioxClient({
  apiKey: 'your-api-key',
  onPartialResult: (result) => {
    console.log('Partial:', result.tokens);
  },
  onFinalResult: (result) => {
    console.log('Final:', result.tokens);
  }
});

// Start transcription
sonioxClient.start({
  model: 'stt-rt-v3',
  audioFormat: 's16le',
  numChannels: 1,
  sampleRate: 16000
});
```

### Pipecat Integration

**Installation:**
```bash
pip install "pipecat-ai[soniox]"
```

**Usage:**
```python
from pipecat.services.soniox.config import SonioxInputParams

SonioxInputParams(
  context="Medical terminology: Celebrex, Zyrtec, Xanax",
  enable_speaker_diarization=True
)
```

## Code Examples

### Python Real-Time Transcription

```python
import soniox
import pyaudio
import threading
import queue

class RealTimeTranscriber:
    def __init__(self, api_key):
        self.client = soniox.SpeechClient(api_key=api_key)
        self.audio_queue = queue.Queue()
        self.running = False
    
    def audio_callback(self, in_data, frame_count, time_info, status):
        self.audio_queue.put(in_data)
        return (None, pyaudio.paContinue)
    
    def start_transcription(self):
        # Configure audio
        audio = pyaudio.PyAudio()
        stream = audio.open(
            format=pyaudio.paInt16,
            channels=1,
            rate=16000,
            input=True,
            stream_callback=self.audio_callback
        )
        
        # Start transcription
        self.running = True
        stream.start_stream()
        
        # Process audio stream
        for result in self.client.transcribe_stream(self.audio_generator()):
            if result.is_final:
                print(f"Final: {result.text}")
            else:
                print(f"Partial: {result.text}")
    
    def audio_generator(self):
        while self.running:
            try:
                yield self.audio_queue.get(timeout=0.1)
            except queue.Empty:
                continue

# Usage
transcriber = RealTimeTranscriber("your-api-key")
transcriber.start_transcription()
```

### Node.js WebSocket Implementation

```javascript
const WebSocket = require('ws');
const fs = require('fs');

class SonioxWebSocketClient {
  constructor(apiKey) {
    this.apiKey = apiKey;
    this.ws = null;
  }
  
  connect() {
    this.ws = new WebSocket('wss://stt-rt.soniox.com/transcribe-websocket');
    
    this.ws.on('open', () => {
      console.log('Connected to Soniox WebSocket');
      this.sendConfiguration();
    });
    
    this.ws.on('message', (data) => {
      const result = JSON.parse(data);
      this.handleResult(result);
    });
    
    this.ws.on('close', () => {
      console.log('WebSocket connection closed');
    });
  }
  
  sendConfiguration() {
    const config = {
      api_key: this.apiKey,
      model: 'stt-rt-v3',
      audio_format: 'pcm_s16le',
      num_channels: 1,
      sample_rate: 16000,
      enable_speaker_diarization: true,
      enable_language_identification: true
    };
    
    this.ws.send(JSON.stringify(config));
  }
  
  sendAudio(audioBuffer) {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(audioBuffer);
    }
  }
  
  handleResult(result) {
    if (result.error_message) {
      console.error('Error:', result.error_message);
      return;
    }
    
    if (result.tokens) {
      result.tokens.forEach(token => {
        if (token.is_final) {
          console.log(`[Speaker ${token.speaker}] ${token.text}`);
        }
      });
    }
  }
  
  endStream() {
    if (this.ws) {
      this.ws.send(''); // Send empty frame to end
    }
  }
}

// Usage
const client = new SonioxWebSocketClient('your-api-key');
client.connect();

// Stream audio data
const audioStream = fs.createReadStream('audio.wav');
audioStream.on('data', (chunk) => {
  client.sendAudio(chunk);
});

audioStream.on('end', () => {
  client.endStream();
});
```

### JavaScript Web SDK Example

```html
<!DOCTYPE html>
<html>
<head>
    <title>Soniox Real-Time Transcription</title>
    <script src="https://unpkg.com/@soniox/soniox-web-sdk@latest/dist/soniox-web-sdk.js"></script>
</head>
<body>
    <div id="transcript"></div>
    <button id="startBtn">Start</button>
    <button id="stopBtn">Stop</button>

    <script>
        const transcriptEl = document.getElementById('transcript');
        const startBtn = document.getElementById('startBtn');
        const stopBtn = document.getElementById('stopBtn');
        
        let sonioxClient;
        let isRecording = false;
        
        // Initialize Soniox client
        sonioxClient = new SonioxClient({
            apiKey: 'your-api-key',
            onPartialResult: (result) => {
                updateTranscript(result.tokens, false);
            },
            onFinalResult: (result) => {
                updateTranscript(result.tokens, true);
            },
            onError: (error) => {
                console.error('Soniox error:', error);
            }
        });
        
        function updateTranscript(tokens, isFinal) {
            let text = '';
            tokens.forEach(token => {
                text += token.text;
            });
            
            const div = document.createElement('div');
            div.textContent = text;
            div.className = isFinal ? 'final' : 'partial';
            transcriptEl.appendChild(div);
        }
        
        startBtn.onclick = () => {
            if (!isRecording) {
                sonioxClient.start({
                    model: 'stt-rt-v3',
                    audioFormat: 's16le',
                    numChannels: 1,
                    sampleRate: 16000,
                    enableSpeakerDiarization: true,
                    enableLanguageIdentification: true
                });
                isRecording = true;
                startBtn.textContent = 'Recording...';
            }
        };
        
        stopBtn.onclick = () => {
            if (isRecording) {
                sonioxClient.stop();
                isRecording = false;
                startBtn.textContent = 'Start';
            }
        };
    </script>
    
    <style>
        .final { font-weight: bold; color: #000; }
        .partial { color: #666; font-style: italic; }
    </style>
</body>
</html>
```

## Best Practices

### Performance Optimisation

1. **Audio Format Selection**
   - Use `pcm_s16le` for optimal performance
   - 16kHz sample rate for most use cases
   - Single channel for speech recognition

2. **Streaming Efficiency**
   - Send audio in 100-200ms chunks
   - Use appropriate buffer sizes
   - Handle backpressure gracefully

3. **Error Handling**
   - Implement retry logic for transient errors
   - Handle network interruptions
   - Monitor API rate limits

### Security Considerations

1. **API Key Management**
   - Use temporary API keys for client-side applications
   - Rotate API keys regularly
   - Never expose API keys in client-side code

2. **Data Privacy**
   - Implement proper data retention policies
   - Use secure transmission (HTTPS/WSS)
   - Consider data residency requirements

### Accuracy Optimisation

1. **Context Usage**
   - Provide relevant domain context
   - Include custom vocabulary
   - Use translation terms for consistency

2. **Language Hints**
   - Specify expected languages
   - Enable language identification
   - Handle mixed-language scenarios

3. **Audio Quality**
   - Use high-quality microphones
   - Minimise background noise
   - Ensure proper audio levels

## Troubleshooting

### Common Issues

#### 1. Connection Errors

**Problem**: WebSocket connection fails
**Solutions**:
- Verify API key is correct
- Check network connectivity
- Ensure WebSocket support in environment
- Try temporary API key for testing

#### 2. Audio Format Issues

**Problem**: Audio not being processed
**Solutions**:
- Verify audio format is supported
- Check sample rate and channel configuration
- Ensure audio data is being sent correctly
- Try different audio formats

#### 3. Low Accuracy

**Problem**: Poor transcription quality
**Solutions**:
- Improve audio quality
- Add relevant context
- Use language hints
- Enable speaker diarization if needed

#### 4. Rate Limiting

**Problem**: Too many requests error
**Solutions**:
- Implement exponential backoff
- Monitor API usage
- Upgrade plan if needed
- Batch requests when possible

### Error Codes

| Code | Description | Solution |
|------|-------------|----------|
| 400 | Bad Request | Check request parameters |
| 401 | Unauthorised | Verify API key |
| 402 | Payment Required | Check account billing |
| 408 | Request Timeout | Retry with backoff |
| 429 | Too Many Requests | Implement rate limiting |
| 500 | Internal Server Error | Contact support |
| 503 | Service Unavailable | Retry later |

### Debugging Tips

1. **Enable Logging**
   ```python
   import logging
   logging.basicConfig(level=logging.DEBUG)
   ```

2. **Test with Sample Audio**
   - Use provided sample files
   - Verify basic functionality
   - Compare with expected results

3. **Monitor Performance**
   - Track latency metrics
   - Monitor error rates
   - Analyse usage patterns

## Resources

### Official Documentation
- [Soniox Documentation](https://soniox.com/docs)
- [API Reference](https://soniox.com/docs/stt/api-reference)
- [Models Guide](https://soniox.com/docs/stt/models)
- [WebSocket API](https://soniox.com/docs/stt/api-reference/websocket-api)

### Code Examples
- [GitHub Examples](https://github.com/soniox/soniox_examples)
- [Python SDK](https://github.com/soniox/soniox_python)
- [Web SDK](https://github.com/soniox/speech-to-text-web)
- [Twilio Integration](https://github.com/soniox/soniox-twilio-realtime-transcription)

### Community and Support
- [Soniox Console](https://console.soniox.com)
- [Support Portal](https://soniox.com/support)
- [Status Page](https://status.soniox.com)

### Integration Guides
- [Pipecat Integration](https://docs.pipecat.ai/server/services/stt/soniox)
- [Web SDK Guide](https://soniox.com/docs/stt/SDKs/web-sdk)
- [Real-time Translation](https://soniox.com/docs/stt/rt/real-time-translation)

---

*This guide provides comprehensive coverage of Soniox's speech recognition capabilities. For the most up-to-date information, always refer to the official documentation at [soniox.com/docs](https://soniox.com/docs).*