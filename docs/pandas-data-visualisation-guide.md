# Pandas Data Visualisation Guide

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Tooling Setup](#tooling-setup)
4. [Step-by-Step Implementation](#step-by-step-implementation)
5. [Examples](#examples)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)
8. [Resources](#resources)
9. [References](#references)

## Overview

Pandas builds on top of Matplotlib to provide a high-level plotting API for exploratory and production-ready data visualisation directly from `Series` and `DataFrame` objects.[^pandas-visualisation] The `.plot()` and specialised helpers such as `.plot.bar()`, `.plot.scatter()`, `.hist()`, and `.boxplot()` cover the majority of analytic chart types while keeping Matplotlib customisation available via returned `Axes` objects.[^pandas-dataframe-plot] From pandas 0.25 onwards the plotting backend is configurable, enabling interactive alternatives such as Plotly without rewiring existing code paths.[^plotly-backend]

## Prerequisites

- Python 3.10+ (align with the organisation’s supported runtime)
- UV package manager installed and initialised (see `docs/uv-python-guide.md`)
- Familiarity with pandas DataFrame operations and NumPy arrays
- Optional: JupyterLab for iterative chart development, VS Code or Cursor for scripted workflows

## Tooling Setup

1. **Initialise the project**
   ```bash
   uv init pandas-visualisation-demo
   cd pandas-visualisation-demo
   ```
2. **Add plotting dependencies**
   ```bash
   uv add pandas matplotlib seaborn plotly
   ```
   - `matplotlib` is the default pandas backend.
   - `seaborn` supplies statistically aware styles and colour palettes.
   - `plotly` unlocks interactive charts through the pandas backend.
3. **Optional developer extras**
   ```bash
   uv add --dev jupyterlab ruff mypy
   ```
4. **Run commands through UV** to guarantee repeatability:
   ```bash
   uv run python -c "import pandas as pd; print(pd.__version__)"
   ```

## Step-by-Step Implementation

### 1. Prepare or import data

Use pandas ingestion utilities (`read_csv`, `read_parquet`, `read_sql`) and ensure datetime parsing and categorical typing occur before plotting to avoid ambiguous axes.

```python
import pandas as pd

sales = (
    pd.read_csv("data/monthly_sales.csv", parse_dates=["month"])
      .set_index("month")
      .sort_index()
)
```

- Call `df.info()` and `df.describe()` to validate column types.
- Apply `rename()` for readable labels before plotting.
- Handle missing values explicitly (`fillna`, `dropna`) to avoid pandas’ plot-specific defaults.[^pandas-visualisation-missing]

### 2. Select chart type with `DataFrame.plot`

```python
import matplotlib.pyplot as plt

ax = (
    sales["revenue"]
    .plot(kind="line", marker="o", figsize=(10, 6), title="Monthly Revenue")
)
ax.set_ylabel("Revenue (£)")
ax.figure.tight_layout()
ax.figure.savefig("artifacts/monthly_revenue.png", dpi=144)
plt.close(ax.figure)
```

- `kind` values such as `line`, `bar`, `area`, `scatter`, `hist`, `hexbin`, `pie`, or `box` map onto Matplotlib primitives.[^pandas-dataframe-plot]
- `subplots=True` produces per-column charts; combine with `layout=(rows, cols)` for dashboards.
- Use `secondary_y` when overlaying different scales.

### 3. Extend with specialised plotting helpers

```python
multi_bar = (
    sales[["new_customers", "returning_customers"]]
    .resample("Q")
    .sum()
    .plot.bar(stacked=True, cmap="viridis", title="Quarterly Customer Mix")
)
multi_bar.set_xlabel("Quarter")
multi_bar.set_ylabel("Customer Count")
multi_bar.figure.tight_layout()
```

- `DataFrame.hist()` renders column-wise distributions with shared axes.
- `pandas.plotting.scatter_matrix()` or `andrews_curves()` provide multivariate diagnostics for feature engineering.[^pandas-visualisation-advanced]

### 4. Customise styling and labelling

```python
import matplotlib as mpl

mpl.style.use("seaborn-v0_8-deep")

ax = (
    sales.assign(growth=sales["revenue"].pct_change() * 100)
    .plot(
        y="growth",
        kind="bar",
        color="#004b87",
        title="Revenue Growth Rate",
        legend=False,
    )
)
ax.axhline(0, color="#6c6f7d", linewidth=1.2, linestyle="--")
ax.set_ylabel("Growth (%)")
ax.set_xlabel("")
for label in ax.get_xticklabels():
    label.set_rotation(45)
ax.figure.tight_layout()
```

- Apply `plt.annotate` or `ax.text` for call-outs on critical points.
- Reuse colour palettes via `mpl.colormaps["viridis"]` to maintain accessibility.
- For publication, set `dpi`, `bbox_inches="tight"`, and explicit figure sizes for reproducible assets.

### 5. Switch to an interactive backend (optional)

```python
import pandas as pd

pd.options.plotting.backend = "plotly"

interactive = (
    sales.reset_index()
    .plot.bar(
        x="month",
        y=["revenue", "operating_costs"],
        title="Revenue vs Costs",
        template="plotly_white",
    )
)
interactive.update_layout(xaxis_title="", legend_title_text="")
interactive.write_html("artifacts/revenue_vs_costs.html", include_plotlyjs="cdn")
```

- Plotly supports `facet_row` and `facet_col` arguments in place of Matplotlib subplots.[^plotly-backend]
- Remember to pin Plotly versions in `pyproject.toml` to prevent frontend regressions.

### 6. Automate validation

Add a lightweight regression check that renders charts during CI without displaying windows:

```bash
uv run python - <<'PY'
import matplotlib
matplotlib.use("Agg")
from pathlib import Path
from visualisations import build_all_charts

output_dir = Path("artifacts")
output_dir.mkdir(parents=True, exist_ok=True)
build_all_charts(output_dir)
PY
```

Ensure the script closes figures (`plt.close`) and writes artefacts deterministically so golden-image tests can diff outputs.

## Examples

### Consolidated plotting module (`visualisations.py`)

```python
from __future__ import annotations

from pathlib import Path
import matplotlib.pyplot as plt
import pandas as pd

def build_all_charts(output_dir: Path) -> None:
    """Generate core dashboards for analytics reporting."""
    sales = (
        pd.read_csv("data/monthly_sales.csv", parse_dates=["month"])
        .set_index("month")
        .sort_index()
    )

    ax = sales["revenue"].plot(
        kind="line",
        marker="o",
        figsize=(10, 6),
        title="Monthly Revenue",
        ylabel="Revenue (£)",
    )
    ax.figure.tight_layout()
    ax.figure.savefig(output_dir / "monthly_revenue.png", dpi=150)
    plt.close(ax.figure)

    quarterly = sales.resample("Q").sum()
    ax = quarterly[["revenue", "operating_costs"]].plot.bar(
        title="Quarterly Revenue vs Costs",
        figsize=(10, 6),
        ylabel="£",
        xlabel="Quarter",
    )
    ax.figure.tight_layout()
    ax.figure.savefig(output_dir / "quarterly_revenue_costs.png", dpi=150)
    plt.close(ax.figure)
```

Run locally with:

```bash
uv run python -c "from visualisations import build_all_charts; \
import pathlib; build_all_charts(pathlib.Path('artifacts'))"
```

### Interactive dashboard snippet (Jupyter)

```python
import pandas as pd
pd.options.plotting.backend = "plotly"

df = pd.read_parquet("data/marketing_campaign.parquet")

fig = (
    df.groupby(["campaign", "channel"])
    ["conversions"]
    .sum()
    .reset_index()
    .plot.bar(
        x="campaign",
        y="conversions",
        color="channel",
        barmode="group",
        title="Conversions by Campaign and Channel",
    )
)
fig.update_traces(hovertemplate="<b>%{x}</b><br>%{legendgroup}: %{y:,}")
fig.show()
```

## Best Practices

- **Model plotting after data contracts:** Clean column names, convert datatypes, and document transformations before visualising to keep provenance clear.
- **Optimise performance:** Aggregate with `groupby`/`resample` before plotting to reduce point counts; leverage categorical dtypes to shrink legend payloads.
- **Align styling:** Set global `mpl.style.use()` and seaborn themes once per session to avoid inconsistent branding.
- **Automate artefact generation:** Package plotting code into functions/modules so CI can render and regression-test charts headlessly.
- **Secure outputs:** Store generated artefacts in tracked buckets or immutable stores, avoiding transient `/tmp` paths in CI.
- **Interactive separation:** Use Plotly or alternative backends for analyst-focused notebooks while keeping Matplotlib pipelines for production exports.

## Troubleshooting

| Symptom | Likely cause | Resolution |
| --- | --- | --- |
| `UserWarning: Matplotlib is currently using agg, which is a non-GUI backend, so cannot show the figure` | Attempting to display plots in headless environments | Switch to `plt.savefig` in CI and call `matplotlib.use("Agg")` explicitly before plotting. |
| Blank charts or mismatched axes | Datetime strings not parsed or columns stored as objects | Parse dates with `parse_dates`, convert categoricals via `astype("category")`, and sort the index before plotting. |
| Legends obscuring data | Multiple columns plotted without layout configuration | Pass `legend=False` and build a custom legend (`ax.legend(loc="lower right")`) or reposition using `bbox_to_anchor`. |
| Excessive memory consumption | Very large DataFrames plotted directly | Downsample using `df.iloc[::N]`, aggregate beforehand, or limit columns with `usecols`. |
| Plotly backend missing features (e.g. `subplots=True`) | Plotly backend omits Matplotlib-only arguments | Use `facet_row`/`facet_col` or fall back to Matplotlib for that chart type.[^plotly-backend] |

## Resources

- pandas chart visualisation user guide[^pandas-visualisation]
- pandas `DataFrame.plot` API reference[^pandas-dataframe-plot]
- Plotly × pandas backend documentation[^plotly-backend]
- Matplotlib style gallery for brand-aligned templates: `matplotlib.style.available`
- Seaborn colour palette explorer: `seaborn.color_palette()`

## References

[^pandas-visualisation]: [Chart visualisation — pandas documentation](https://pandas.pydata.org/docs/user_guide/visualization.html)
[^pandas-visualisation-missing]: [Chart visualisation — pandas documentation, missing data handling](https://pandas.pydata.org/docs/user_guide/visualization.html#plotting-with-missing-data)
[^pandas-visualisation-advanced]: [Chart visualisation — pandas documentation, pandas.plotting tools](https://pandas.pydata.org/docs/user_guide/visualization.html#plotting-tools)
[^pandas-dataframe-plot]: [`pandas.DataFrame.plot` API reference](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.plot.html)
[^plotly-backend]: [Pandas plotting backend in Python — Plotly documentation](https://plotly.com/python/pandas-backend/)
