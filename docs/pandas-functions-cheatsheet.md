# Pandas Functions Cheatsheet

A comprehensive reference guide for the most commonly used Pandas functions and methods for data manipulation and analysis in Python.

## Table of Contents

1. [Import and Setup](#import-and-setup)
2. [Data Creation](#data-creation)
3. [Data Input/Output](#data-inputoutput)
4. [Data Inspection](#data-inspection)
5. [Data Selection and Filtering](#data-selection-and-filtering)
6. [Data Manipulation](#data-manipulation)
7. [Grouping and Aggregation](#grouping-and-aggregation)
8. [Merging and Joining](#merging-and-joining)
9. [Data Cleaning](#data-cleaning)
10. [String Operations](#string-operations)
11. [DateTime Operations](#datetime-operations)
12. [Mathematical and Statistical Operations](#mathematical-and-statistical-operations)
13. [Reshaping Data](#reshaping-data)
14. [Plotting](#plotting)

---

## Import and Setup

```python
import pandas as pd
import numpy as np

# Common aliases
df = pd.DataFrame()
s = pd.Series()
```

---

## Data Creation

### Creating DataFrames

```python
# From dictionary
df = pd.DataFrame({
    'col1': [1, 2, 3],
    'col2': ['a', 'b', 'c'],
    'col3': [1.1, 2.2, 3.3]
})

# From list of lists
df = pd.DataFrame(
    [[1, 'a', 1.1], [2, 'b', 2.2], [3, 'c', 3.3]],
    columns=['col1', 'col2', 'col3'],
    index=[0, 1, 2]
)

# From NumPy array
df = pd.DataFrame(np.random.randn(5, 3), columns=['A', 'B', 'C'])

# With MultiIndex
df = pd.DataFrame(
    {'a': [4, 5, 6], 'b': [7, 8, 9], 'c': [10, 11, 12]},
    index=pd.MultiIndex.from_tuples(
        [('d', 1), ('d', 2), ('e', 2)],
        names=['n', 'v']
    )
)
```

### Creating Series

```python
# From list
s = pd.Series([1, 2, 3, 4, 5])

# From dictionary
s = pd.Series({'a': 1, 'b': 2, 'c': 3})

# With index
s = pd.Series([1, 2, 3], index=['x', 'y', 'z'])

# From NumPy array
s = pd.Series(np.random.randn(5))
```

---

## Data Input/Output

### Reading Data

```python
# CSV files
df = pd.read_csv('file.csv')
df = pd.read_csv('file.csv', sep=',', header=0, index_col=0)
df = pd.read_csv('file.csv', usecols=['col1', 'col2'])
df = pd.read_csv('file.csv', nrows=1000)

# Excel files
df = pd.read_excel('file.xlsx', sheet_name='Sheet1')
df = pd.read_excel('file.xlsx', sheet_name=0)

# JSON files
df = pd.read_json('file.json')
df = pd.read_json('file.json', orient='records')

# HTML tables
df = pd.read_html('url.html')[0]

# SQL databases
df = pd.read_sql('SELECT * FROM table', con=connection)
df = pd.read_sql_query('SELECT * FROM table', con=connection)
df = pd.read_sql_table('table_name', con=connection)

# Parquet files
df = pd.read_parquet('file.parquet')

# HDF5 files
df = pd.read_hdf('file.h5', key='data')

# Clipboard
df = pd.read_clipboard()

# Table from URL
df = pd.read_table('url.txt', sep='\t')
```

### Writing Data

```python
# CSV files
df.to_csv('file.csv')
df.to_csv('file.csv', index=False)
df.to_csv('file.csv', sep='\t')

# Excel files
df.to_excel('file.xlsx', sheet_name='Sheet1')
df.to_excel('file.xlsx', index=False)

# JSON files
df.to_json('file.json')
df.to_json('file.json', orient='records')

# SQL databases
df.to_sql('table_name', con=connection, if_exists='replace')

# Parquet files
df.to_parquet('file.parquet')

# HDF5 files
df.to_hdf('file.h5', key='data', mode='w')

# Clipboard
df.to_clipboard()

# HTML
df.to_html('file.html')
```

---

## Data Inspection

### Basic Information

```python
# Shape and dimensions
df.shape              # (rows, columns)
df.size               # Total number of elements
df.ndim               # Number of dimensions

# Index and columns
df.index              # Row index
df.columns            # Column names
df.axes               # Both index and columns

# Data types
df.dtypes             # Data types per column
df.dtypes.value_counts()  # Count of each dtype

# Memory usage
df.memory_usage()     # Memory usage per column
df.memory_usage(deep=True)  # Deep memory usage

# Basic info
df.info()             # Summary including dtypes and non-null counts
df.describe()         # Statistical summary
df.describe(include='all')  # Include all types
```

### Viewing Data

```python
# Head and tail
df.head()             # First 5 rows
df.head(10)           # First 10 rows
df.tail()             # Last 5 rows
df.tail(10)           # Last 10 rows

# Sample rows
df.sample(n=5)        # Random n rows
df.sample(frac=0.1)   # Random 10% of rows

# Value counts
df['col'].value_counts()           # Count of unique values
df['col'].value_counts(normalize=True)  # Normalised counts
df['col'].value_counts(dropna=False)   # Include NaN

# Unique values
df['col'].unique()    # Array of unique values
df['col'].nunique()   # Number of unique values

# Check for nulls
df.isnull()           # Boolean DataFrame of nulls
df.isna()             # Alias for isnull
df.notnull()          # Boolean DataFrame of non-nulls
df.notna()            # Alias for notnull
df.isnull().sum()     # Count of nulls per column
```

---

## Data Selection and Filtering

### Column Selection

```python
# Single column (returns Series)
df['col']             # Column by name
df.col                # Column by attribute (if valid identifier)

# Multiple columns (returns DataFrame)
df[['col1', 'col2']]  # Multiple columns

# Column by data type
df.select_dtypes(include=['int64', 'float64'])
df.select_dtypes(exclude=['object'])

# Filter columns
df.filter(items=['col1', 'col2'])
df.filter(regex='^col')  # Regex pattern
df.filter(like='name')   # Contains substring
```

### Row Selection

```python
# By index label (loc)
df.loc['row_label']              # Single row
df.loc[['row1', 'row2']]         # Multiple rows
df.loc['row1':'row3']            # Slice (inclusive)
df.loc[df['col'] > 5]            # Boolean indexing

# By integer position (iloc)
df.iloc[0]                       # First row
df.iloc[0:5]                     # Rows 0-4
df.iloc[[0, 2, 4]]               # Specific rows
df.iloc[:, 0]                    # First column
df.iloc[0:5, 0:3]                # Rows 0-4, columns 0-2

# At and iat (scalar access)
df.at['row', 'col']              # Single value by label
df.iat[0, 0]                     # Single value by position

# Boolean indexing
df[df['col'] > 5]                # Rows where condition is True
df[(df['col1'] > 5) & (df['col2'] < 10)]  # Multiple conditions
df[(df['col1'] > 5) | (df['col2'] < 10)]  # OR condition
df[~(df['col'] > 5)]             # NOT condition

# Query method
df.query('col > 5')
df.query('col1 > 5 & col2 < 10')
df.query('col in @list_of_values')

# Filter by index
df.filter(items=['row1', 'row2'], axis=0)
df.filter(regex='^row', axis=0)
```

### Combining Row and Column Selection

```python
# Using loc
df.loc['row1', 'col1']           # Single value
df.loc[['row1', 'row2'], 'col1'] # Multiple rows, single column
df.loc['row1', ['col1', 'col2']] # Single row, multiple columns
df.loc[['row1', 'row2'], ['col1', 'col2']]  # Multiple rows and columns
df.loc[df['col'] > 5, ['col1', 'col2']]  # Conditional selection

# Using iloc
df.iloc[0, 0]                    # Single value
df.iloc[0:5, 0:3]                # Rows and columns by position
df.iloc[[0, 2], [0, 2]]          # Specific rows and columns

# Chained indexing (not recommended)
df.loc[df['col'] > 5]['col1']     # May return copy or view
```

---

## Data Manipulation

### Adding and Removing Columns

```python
# Add column
df['new_col'] = values
df['new_col'] = df['col1'] + df['col2']
df.assign(new_col=df['col1'] * 2)  # Returns new DataFrame

# Insert column
df.insert(loc=0, column='new_col', value=values)

# Drop columns
df.drop(columns=['col1', 'col2'])
df.drop(['col1', 'col2'], axis=1)
df.drop(columns='col1', inplace=True)

# Rename columns
df.rename(columns={'old': 'new'})
df.rename(columns=str.upper)     # Apply function
df.columns = ['new1', 'new2', 'new3']  # Replace all

# Column operations
df.columns.str.strip()            # String operations on column names
df.columns.str.lower()
df.add_prefix('prefix_')          # Add prefix to column names
df.add_suffix('_suffix')          # Add suffix to column names
```

### Adding and Removing Rows

```python
# Append rows
df.append(other_df, ignore_index=True)  # Deprecated, use concat
pd.concat([df, other_df], ignore_index=True)

# Drop rows
df.drop(index=[0, 1, 2])
df.drop([0, 1, 2])                # Drop by index label
df.drop(labels=[0, 1, 2], axis=0)

# Drop duplicates
df.drop_duplicates()
df.drop_duplicates(subset=['col1', 'col2'])
df.drop_duplicates(keep='first')  # or 'last', False
df.drop_duplicates(inplace=True)
```

### Sorting

```python
# Sort by values
df.sort_values('col1')
df.sort_values(['col1', 'col2'])  # Multiple columns
df.sort_values('col1', ascending=False)
df.sort_values('col1', na_position='last')

# Sort by index
df.sort_index()
df.sort_index(ascending=False)
df.sort_index(level=0)             # MultiIndex

# Reset index
df.reset_index()                  # Moves index to column
df.reset_index(drop=True)        # Drops index entirely
df.reset_index(inplace=True)
```

### Index Operations

```python
# Set index
df.set_index('col')               # Set column as index
df.set_index(['col1', 'col2'])   # MultiIndex

# Reset index
df.reset_index()
df.reset_index(drop=True)

# Rename index
df.rename(index={'old': 'new'})
df.index.rename('new_name')
df.index = ['new1', 'new2', 'new3']

# Reindex
df.reindex(new_index)
df.reindex(['new1', 'new2', 'new3'])
df.reindex(columns=['new_col1', 'new_col2'])
```

---

## Grouping and Aggregation

### Basic GroupBy

```python
# Single column grouping
df.groupby('col')
df.groupby(['col1', 'col2'])     # Multiple columns

# GroupBy operations
df.groupby('col').sum()
df.groupby('col').mean()
df.groupby('col').count()
df.groupby('col').size()         # Size of each group

# Select column before grouping
df.groupby('col')['value_col'].mean()
df.groupby('col')[['col1', 'col2']].sum()

# Custom grouping
df.groupby(df['col'].str[0])     # Group by first character
df.groupby(lambda x: x % 2)      # Group by function
```

### Aggregation Functions

```python
# Single aggregation
df.groupby('col').agg('sum')
df.groupby('col').agg('mean')
df.groupby('col').agg(['sum', 'mean', 'std'])

# Named aggregations
df.groupby('col').agg(
    total=('value', 'sum'),
    average=('value', 'mean')
)

# Dictionary aggregation
df.groupby('col').agg({
    'col1': 'sum',
    'col2': ['mean', 'std']
})

# Multiple aggregations per column
df.groupby('col').agg({
    'col1': ['sum', 'mean'],
    'col2': ['min', 'max']
})

# Custom aggregation functions
df.groupby('col').agg(lambda x: x.max() - x.min())
```

### Transform and Apply

```python
# Transform (returns same shape)
df.groupby('col').transform('mean')
df.groupby('col').transform(lambda x: x - x.mean())  # Centring
df.groupby('col')['value'].transform('sum')

# Apply (flexible function application)
df.groupby('col').apply(lambda x: x.head(2))
df.groupby('col').apply(custom_function)

# Filter groups
df.groupby('col').filter(lambda x: x['value'].mean() > 5)

# Get groups
groups = df.groupby('col')
groups.get_group('group_name')
```

### Pivot Tables

```python
# Basic pivot table
df.pivot_table(
    values='value',
    index='row_col',
    columns='col_col',
    aggfunc='mean'
)

# Multiple aggregation functions
df.pivot_table(
    values='value',
    index='row_col',
    columns='col_col',
    aggfunc=['mean', 'sum']
)

# Multiple values
df.pivot_table(
    values=['val1', 'val2'],
    index='row_col',
    columns='col_col'
)

# Fill missing values
df.pivot_table(values='value', index='row', fill_value=0)

# Margins
df.pivot_table(values='value', index='row', margins=True)
```

---

## Merging and Joining

### Merge

```python
# Basic merge
pd.merge(df1, df2, on='key')
pd.merge(df1, df2, left_on='key1', right_on='key2')

# Merge types
pd.merge(df1, df2, on='key', how='inner')   # Default
pd.merge(df1, df2, on='key', how='left')
pd.merge(df1, df2, on='key', how='right')
pd.merge(df1, df2, on='key', how='outer')

# Multiple keys
pd.merge(df1, df2, on=['key1', 'key2'])

# Index merge
pd.merge(df1, df2, left_index=True, right_index=True)
pd.merge(df1, df2, left_on='key', right_index=True)

# Suffixes for overlapping columns
pd.merge(df1, df2, on='key', suffixes=('_left', '_right'))

# Indicator
pd.merge(df1, df2, on='key', indicator=True)
```

### Join

```python
# DataFrame join method
df1.join(df2, on='key', how='left')
df1.join(df2, how='inner')
df1.join(df2, lsuffix='_left', rsuffix='_right')

# Index join
df1.join(df2)                    # Joins on index
```

### Concatenation

```python
# Concatenate along rows
pd.concat([df1, df2])
pd.concat([df1, df2], ignore_index=True)
pd.concat([df1, df2], axis=0)

# Concatenate along columns
pd.concat([df1, df2], axis=1)

# Keys for hierarchical index
pd.concat([df1, df2], keys=['x', 'y'])

# Join types
pd.concat([df1, df2], join='inner')
pd.concat([df1, df2], join='outer')  # Default
```

---

## Data Cleaning

### Handling Missing Values

```python
# Check for missing values
df.isnull()
df.isna()
df.notnull()
df.notna()
df.isnull().sum()
df.isnull().any()

# Drop missing values
df.dropna()                      # Drop rows with any NaN
df.dropna(axis=1)                # Drop columns with any NaN
df.dropna(how='all')             # Drop rows/cols where all are NaN
df.dropna(subset=['col1'])       # Drop rows where col1 is NaN
df.dropna(thresh=2)              # Keep rows with at least 2 non-NaN

# Fill missing values
df.fillna(0)                     # Fill with scalar
df.fillna({'col1': 0, 'col2': 'unknown'})  # Column-specific
df.fillna(method='ffill')        # Forward fill (deprecated)
df.fillna(method='bfill')        # Backward fill (deprecated)
df.fillna(method='pad')          # Alias for ffill
df.ffill()                       # Forward fill (recommended)
df.bfill()                       # Backward fill (recommended)
df.fillna(df.mean())             # Fill with mean
df.fillna(df.median())           # Fill with median
df.fillna(df.mode().iloc[0])     # Fill with mode

# Interpolation
df.interpolate()                 # Linear interpolation
df.interpolate(method='polynomial', order=2)
df.interpolate(limit=2)          # Limit number of consecutive NaNs

# Replace values
df.replace(to_replace, value)
df.replace({'old': 'new'})
df.replace([1, 2, 3], [10, 20, 30])
df.replace(regex=r'^\s*$', value=np.nan)  # Regex replace
```

### Data Type Conversion

```python
# Convert types
df['col'].astype('int64')
df['col'].astype(float)
df['col'].astype('category')
df['col'].astype('datetime64[ns]')

# Convert entire DataFrame
df.astype({'col1': 'int64', 'col2': 'float64'})

# Convert to numeric
pd.to_numeric(df['col'])
pd.to_numeric(df['col'], errors='coerce')  # Invalid parsing -> NaN
pd.to_numeric(df['col'], errors='ignore')  # Invalid parsing -> keep as is

# Convert to datetime
pd.to_datetime(df['col'])
pd.to_datetime(df['col'], format='%Y-%m-%d')
pd.to_datetime(df['col'], errors='coerce')

# Convert to timedelta
pd.to_timedelta(df['col'])

# Infer better types
df.convert_dtypes()              # Infer and convert to better types
```

### Removing Duplicates

```python
# Find duplicates
df.duplicated()                  # Boolean Series
df.duplicated(subset=['col1', 'col2'])
df.duplicated(keep='first')      # or 'last', False

# Drop duplicates
df.drop_duplicates()
df.drop_duplicates(subset=['col1'])
df.drop_duplicates(keep='last')
df.drop_duplicates(inplace=True)
```

---

## String Operations

### String Accessor (str)

```python
# Basic string operations
df['col'].str.lower()
df['col'].str.upper()
df['col'].str.capitalize()
df['col'].str.title()
df['col'].str.swapcase()

# Strip whitespace
df['col'].str.strip()
df['col'].str.lstrip()
df['col'].str.rstrip()

# Split and join
df['col'].str.split(',')
df['col'].str.split(',', expand=True)  # Return DataFrame
df['col'].str.split(',', n=1)          # Max splits
df['col'].str.rsplit(',', n=1)         # Split from right
df['col'].str.join('-')

# Extract substrings
df['col'].str.slice(start=0, stop=5)
df['col'].str[0:5]                    # Slice notation
df['col'].str.get(0)                  # Get character at position

# Replace
df['col'].str.replace('old', 'new')
df['col'].str.replace('old', 'new', regex=True)
df['col'].str.replace(r'pattern', 'new', regex=True)

# Find and match
df['col'].str.contains('pattern')
df['col'].str.contains('pattern', case=False, na=False)
df['col'].str.match('pattern')
df['col'].str.startswith('prefix')
df['col'].str.endswith('suffix')
df['col'].str.find('substring')       # Returns index or -1

# Padding and alignment
df['col'].str.pad(width=10)
df['col'].str.pad(width=10, side='left', fillchar='0')
df['col'].str.center(width=10)
df['col'].str.ljust(width=10)
df['col'].str.rjust(width=10)

# Length and counting
df['col'].str.len()
df['col'].str.count('pattern')

# Extract with regex
df['col'].str.extract(r'(\d+)')
df['col'].str.extractall(r'(\d+)')
df['col'].str.findall(r'pattern')

# Repeat
df['col'].str.repeat(3)

# Zfill
df['col'].str.zfill(5)                # Zero-fill to width

# String methods chain
df['col'].str.strip().str.lower().str.replace(' ', '_')
```

---

## DateTime Operations

### DateTime Conversion

```python
# Convert to datetime
pd.to_datetime(df['col'])
pd.to_datetime(df['col'], format='%Y-%m-%d')
pd.to_datetime(df['col'], errors='coerce')
pd.to_datetime(df['col'], infer_datetime_format=True)

# Set as index
df.set_index(pd.to_datetime(df['col']))

# Access datetime components
df['datetime_col'].dt.year
df['datetime_col'].dt.month
df['datetime_col'].dt.day
df['datetime_col'].dt.hour
df['datetime_col'].dt.minute
df['datetime_col'].dt.second
df['datetime_col'].dt.microsecond
df['datetime_col'].dt.nanosecond
df['datetime_col'].dt.date
df['datetime_col'].dt.time
df['datetime_col'].dt.dayofweek      # Monday=0, Sunday=6
df['datetime_col'].dt.dayofyear
df['datetime_col'].dt.week
df['datetime_col'].dt.quarter
df['datetime_col'].dt.is_month_start
df['datetime_col'].dt.is_month_end
df['datetime_col'].dt.is_quarter_start
df['datetime_col'].dt.is_quarter_end
df['datetime_col'].dt.is_year_start
df['datetime_col'].dt.is_year_end
df['datetime_col'].dt.is_leap_year
```

### DateTime Operations

```python
# Date arithmetic
df['datetime_col'] + pd.Timedelta(days=1)
df['datetime_col'] + pd.Timedelta(hours=12)
df['datetime_col'] - pd.Timedelta(weeks=1)
df['datetime_col'] - df['datetime_col2']  # Returns Timedelta

# Round datetime
df['datetime_col'].dt.round('D')           # Round to day
df['datetime_col'].dt.round('H')           # Round to hour
df['datetime_col'].dt.floor('D')           # Floor to day
df['datetime_col'].dt.ceil('D')            # Ceil to day

# Format datetime
df['datetime_col'].dt.strftime('%Y-%m-%d')
df['datetime_col'].dt.strftime('%Y-%m-%d %H:%M:%S')

# Period conversion
df['datetime_col'].dt.to_period('D')        # Convert to Period
df['datetime_col'].dt.to_period('M')        # Convert to monthly Period
df['datetime_col'].dt.to_period('Y')        # Convert to yearly Period

# Timezone operations
df['datetime_col'].dt.tz_localize('UTC')
df['datetime_col'].dt.tz_convert('US/Eastern')
```

### Date Range

```python
# Create date range
pd.date_range(start='2020-01-01', end='2020-12-31')
pd.date_range(start='2020-01-01', periods=365)
pd.date_range(start='2020-01-01', end='2020-12-31', freq='D')
pd.date_range(start='2020-01-01', periods=12, freq='M')

# Common frequencies
# 'D' - daily, 'W' - weekly, 'M' - month end
# 'Q' - quarter end, 'Y' - year end
# 'H' - hourly, 'T' - minutely, 'S' - secondly
# 'B' - business day, 'BM' - business month end
```

---

## Mathematical and Statistical Operations

### Basic Statistics

```python
# Descriptive statistics
df.sum()
df.mean()
df.median()
df.mode()
df.std()
df.var()
df.min()
df.max()
df.abs()                        # Absolute values
df.prod()                        # Product
df.cumsum()                      # Cumulative sum
df.cumprod()                     # Cumulative product
df.cummax()                      # Cumulative maximum
df.cummin()                      # Cumulative minimum

# Percentiles and quantiles
df.quantile(0.25)                # 25th percentile
df.quantile([0.25, 0.5, 0.75])   # Multiple percentiles
df.describe()                    # Summary statistics

# Counts
df.count()                       # Non-null count
df.value_counts()                # For Series
df.nunique()                     # Number of unique values

# Ranking
df.rank()
df.rank(method='min')
df.rank(ascending=False)
df.rank(pct=True)                # Percentile rank

# Correlation and covariance
df.corr()                        # Correlation matrix
df.cov()                         # Covariance matrix
df['col1'].corr(df['col2'])     # Correlation between two columns

# Skewness and kurtosis
df.skew()
df.kurtosis()

# Window functions
df.rolling(window=3).mean()      # Rolling mean
df.rolling(window=3).sum()
df.rolling(window=3).std()
df.rolling(window=3).min()
df.rolling(window=3).max()

# Expanding window
df.expanding().mean()
df.expanding().sum()

# Exponential weighted
df.ewm(span=3).mean()
df.ewm(alpha=0.5).mean()
```

### Arithmetic Operations

```python
# Element-wise operations
df + 1
df - 1
df * 2
df / 2
df ** 2
df % 2

# Between DataFrames
df1 + df2
df1 - df2
df1 * df2
df1 / df2

# Column-wise operations
df['col1'] + df['col2']
df['col1'] * df['col2']
df['col1'] / df['col2']

# Broadcasting
df + df.iloc[0]                  # Add first row to all rows
df * df.iloc[:, 0]               # Multiply first column to all columns
```

### Applying Functions

```python
# Apply function along axis
df.apply(np.sum, axis=0)         # Column-wise
df.apply(np.sum, axis=1)         # Row-wise
df.apply(lambda x: x.max() - x.min())

# Apply to Series
df['col'].apply(function)
df['col'].apply(lambda x: x * 2)

# Applymap (element-wise)
df.applymap(lambda x: x * 2)    # Deprecated, use map
df.map(lambda x: x * 2)

# Transform
df.transform(lambda x: x - x.mean())
df.transform(['sqrt', 'exp'])

# Aggregation
df.agg(['sum', 'mean'])
df.agg({'col1': 'sum', 'col2': 'mean'})
```

---

## Reshaping Data

### Pivot and Melt

```python
# Pivot (wide to long)
df.pivot(index='row', columns='col', values='value')
df.pivot_table(values='value', index='row', columns='col')

# Melt (wide to long)
df.melt()
df.melt(id_vars=['id_col'], value_vars=['val1', 'val2'])
df.melt(var_name='variable', value_name='value')

# Stack and unstack
df.stack()                       # Wide to long
df.unstack()                     # Long to wide
df.unstack(level=0)
```

### Transpose

```python
# Transpose
df.T                             # Transpose rows and columns
df.transpose()
```

### Wide to Long / Long to Wide

```python
# Wide to long
pd.wide_to_long(df, stubnames=['col'], i='id', j='time')

# Long to wide
df.pivot(index='id', columns='time', values='value')
```

---

## Plotting

### Basic Plotting

```python
# Line plot
df.plot()
df.plot.line()
df.plot(x='col1', y='col2')

# Bar plot
df.plot.bar()
df.plot.barh()                   # Horizontal bar

# Histogram
df.plot.hist()
df.plot.hist(bins=30)

# Box plot
df.plot.box()

# Scatter plot
df.plot.scatter(x='col1', y='col2')

# Area plot
df.plot.area()

# Pie chart
df.plot.pie(y='col')

# Density plot
df.plot.density()

# Hexbin plot
df.plot.hexbin(x='col1', y='col2')

# Customisation
df.plot(title='Title', figsize=(10, 6))
df.plot(xlabel='X Label', ylabel='Y Label')
df.plot(style='--', color='red')
```

---

## Quick Reference

### Most Common Operations

```python
# Read CSV
df = pd.read_csv('file.csv')

# View data
df.head()
df.info()
df.describe()

# Select columns
df[['col1', 'col2']]
df.loc[:, 'col1':'col2']

# Filter rows
df[df['col'] > 5]
df.query('col > 5')

# Group and aggregate
df.groupby('col').agg({'value': 'mean'})

# Merge DataFrames
pd.merge(df1, df2, on='key')

# Handle missing values
df.fillna(0)
df.dropna()

# String operations
df['col'].str.lower()
df['col'].str.contains('pattern')

# DateTime operations
pd.to_datetime(df['col'])
df['datetime_col'].dt.year

# Save to CSV
df.to_csv('output.csv', index=False)
```

---

## Resources

- [Official Pandas Documentation](https://pandas.pydata.org/docs/)
- [Pandas API Reference](https://pandas.pydata.org/docs/reference/index.html)
- [Pandas User Guide](https://pandas.pydata.org/docs/user_guide/index.html)
- [10 Minutes to Pandas](https://pandas.pydata.org/docs/user_guide/10min.html)

---

*Last updated: 2025-01-27*

