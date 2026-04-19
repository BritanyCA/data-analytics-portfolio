# 📊 Gold Price Forecasting Dashboard
Power BI | Portfolio Project

Author: Britany Campos • Tools: Power BI, DAX, Excel

## Gold Price Forecasting — Full Project in Power BI
### 📌 Table of Contents
1. Objective
2. Methodology
3. Data Preparation
4. Exploratory Data Analysis (EDA)
5. Power BI Dashboard
6. Key Findings
7. Recommendations
8. Conclusion

### 🎯 Objective
Analyze historical gold prices, identify key market drivers, and build a multi‑method forecasting model using Power BI to support strategic financial decision‑making.

### 🧠 Methodology
- Data cleaning and preparation in Excel
- Creation of Calendar table and time‑intelligence structures
- Exploratory Data Analysis (EDA)
- Development of forecasting measures (Linear, CAGR, Scenario‑based)
- Rolling metrics: moving averages and volatility
- What‑if parameters for sensitivity analysis
- Interactive dashboard design in Power BI

### 🧹 Data Preparation
#### 🔸 Dataset Loading
The dataset was cleaned and structured in Excel before being imported into Power BI.

#### 🔸 Calendar Table
A full date table was created to enable time‑intelligence calculations.

``` DAX
Calendar =
ADDCOLUMNS(
    CALENDAR(MIN(tblGold[Date]), MAX(tblGold[Date])),
    "Year", YEAR([Date]),
    "Month", FORMAT([Date], "MMMM"),
    "MonthNumber", MONTH([Date])
)
```
#### 🔸 Time Index
A sequential index was created to support regression‑based forecasting.

``` DAX
Time Index =
RANKX(ALL(Calendar), Calendar[Date], , ASC)
```

### 📊 Exploratory Data Analysis (EDA)
##### 🔸 Historical Trend
Identifies long‑term price direction and structural changes.
##### 🔸 Year‑over‑Year Variation
Highlights periods of accelerated growth or contraction.
##### 🔸 Rolling Volatility
Shows market stability and risk concentration over time.
##### 🔸 Moving Averages (7‑day & 30‑day)
Smooth short‑term fluctuations to reveal underlying trends.
### 📈 Power BI Dashboard
#### Key KPIs
- Current Avg Close Price
- YoY Price Change %
- Forecast (Current Year)
- Scenario‑Based Forecast

### DAX Measures
#### 🔸 Linear Forecast (Regression‑based)
```DAX
Forecast Lineal =
VAR _X = RELATED(Calendar[Time Index])
VAR _AvgX = AVERAGE(Calendar[Time Index])
VAR _AvgY = AVERAGE(tblGold[Close])
VAR _CovXY =
    AVERAGEX(
        tblGold,
        (RELATED(Calendar[Time Index]) - _AvgX) *
        (tblGold[Close] - _AvgY)
    )
VAR _VarX =
    AVERAGEX(
        tblGold,
        (RELATED(Calendar[Time Index]) - _AvgX) ^ 2
    )
VAR Slope = DIVIDE(_CovXY, _VarX)
VAR Intercept = _AvgY - Slope * _AvgX
RETURN
    Slope * _X + Intercept
```

#### 🔸 CAGR Forecast
```DAX
CAGR =
VAR StartValue = CALCULATE(MIN(tblGold[Close]), FIRSTDATE(tblGold[Date]))
VAR EndValue = CALCULATE(MAX(tblGold[Close]), LASTDATE(tblGold[Date]))
VAR Years = DATEDIFF(FIRSTDATE(tblGold[Date]), LASTDATE(tblGold[Date]), YEAR)
RETURN
(EndValue / StartValue) ^ (1 / Years) - 1
```
#### 🔸 Scenario‑Based Forecast
```DAX
Forecast Escenario =
[Forecast Lineal] *
SELECTEDVALUE(Escenario[Factor], 1)
```
#### 🔸 Moving Averages
``` DAX
Promedio 7 días =
AVERAGEX(
    DATESINPERIOD(Calendar[Date], MAX(Calendar[Date]), -7, DAY),
    CALCULATE(AVERAGE(tblGold[Close]))
)
```
```DAX
Promedio 30 días =
AVERAGEX(
    DATESINPERIOD(Calendar[Date], MAX(Calendar[Date]), -30, DAY),
    CALCULATE(AVERAGE(tblGold[Close]))
)
```
### 🔍 Key Findings
- Gold prices show a strong long‑term upward trend, with accelerated growth projected toward 2026.
- Volatility increases significantly in later years, indicating rising market uncertainty.
- Scenario‑based forecasting reveals meaningful divergence between optimistic and pessimistic assumptions.

### 🛠 Recommendations
- Monitor volatility spikes as early indicators of market instability.
- Use scenario‑based forecasting for strategic planning under uncertainty.
- Combine moving averages with regression forecasts for more robust trend detection.

### 🏁 Conclusion
- Gold price behavior is driven by long‑term upward momentum, increasing volatility, and sensitivity to market assumptions.
- This dashboard provides a complete analytical framework for forecasting, risk evaluation, and strategic decision‑making.