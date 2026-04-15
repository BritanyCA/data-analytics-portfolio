# 📊 Retail Sales & Demand Dashboard

**Power BI | Portfolio Project** 

**Author: Britany Campos • Tools: Power BI, DAX, Excel, RStudio**

------------------------------------------------------------------------

## HR Attrition Analysis — Full Project in R and Power BI

### 📌 Table of Contents

1.  Objective
2.  Methodology
3.  Data Preparation in R
4.  Exploratory Data Analysis (EDA)
5.  Power BI Dashboard
6.  Key Findings
7.  Recommendations
8.  Conclusion

------------------------------------------------------------------------

## 🎯 Objective

Analyze the factors influencing employee attrition using R for
exploratory analysis and Power BI for executive-level visualization.

------------------------------------------------------------------------

## 🧠 Methodology

-   Data cleaning and preparation in R
-   Conversion of categorical variables
-   Exploratory Data Analysis (EDA)
-   Creation of KPIs and DAX measures
-   Interactive dashboard in Power BI
-   Pattern interpretation and recommendations

------------------------------------------------------------------------

## 🧹 Data Preparation in R

### 🔸Dataset Loading
Load the original file to begin the data cleaning process
```r
hr <- read.csv(“WA_Fn-UseC_-HR-Employee-Attrition.csv”)
```

### 🔸Conversion of Categorical Columns
These columns represent categories or levels. Converting them to factors enables proper statistical analysis and visualization.
```r
categorical_cols <- c(
“Attrition”,“BusinessTravel”,“Department”,“Education”,“EducationField”,
“EnvironmentSatisfaction”,“Gender”,“JobInvolvement”,“JobLevel”,“JobRole”,
“JobSatisfaction”,“MaritalStatus”,“OverTime”,“PerformanceRating”,
“RelationshipSatisfaction”,“WorkLifeBalance” ) hr[categorical_cols] <-
lapply(hr[categorical_cols], as.factor)
```

### 🔸Structure Review
Allows validation of data types, ranges, and detection of anomalies.
```r
str(hr) summary(hr)
```

------------------------------------------------------------------------

## 📊 Exploratory Data Analysis (EDA)

### 🔸Attrition Distribution
Shows how many employees stay vs leave.
```r 
ggplot(hr, aes(Attrition)) + geom_bar(fill = “#E74C3C”) +
theme_minimal()
```  

### 🔸Attrition by Department
Compares the proportion of attrition across departments.
```r ggplot(hr, aes(Department, fill = Attrition)) + geom_bar(position =
“fill”) + scale_y_continuous(labels = scales::percent)
```

### 🔸Monthly Income vs Attrition
Shows salary differences between employees who stay and those who leave.
```r 
ggplot(hr, aes(Attrition, MonthlyIncome, fill = Attrition)) +
geom_boxplot()
```

### 🔸Tenure vs Attrition
Identifies at which stage of the employee lifecycle attrition occurs more frequently.
```r
ggplot(hr, aes(YearsAtCompany, fill = Attrition)) +
geom_histogram(binwidth = 1)
```
------------------------------------------------------------------------

## 📈 Power BI Dashboard

### Key KPIs

-   Attrition Rate
-   Total Employees
-   Employees Left
-   Avg Monthly Income
-   Avg Tenure

## DAX Measures
### 🔸Attrition Rate
Calculates the percentage of employees who left.
```r
Attrition Rate = DIVIDE( CALCULATE(
COUNTROWS(‘WA_Fn-UseC_-HR-Employee-Attrition’),
‘WA_Fn-UseC_-HR-Employee-Attrition’[Attrition] = “Yes” ),
COUNTROWS(‘WA_Fn-UseC_-HR-Employee-Attrition’) )
```

### 🔸Total Employees
```r
Total Employees = COUNTROWS(‘WA_Fn-UseC_-HR-Employee-Attrition’)
```
### 🔸Employees Left
Counts employees with Attrition = "Yes".
```r 
Employees Left = CALCULATE(
COUNTROWS(‘WA_Fn-UseC_-HR-Employee-Attrition’),
‘WA_Fn-UseC_-HR-Employee-Attrition’[Attrition] = “Yes” )
```
### 🔸Avg Monthly Income
```r
Avg Monthly Income =
AVERAGE(‘WA_Fn-UseC_-HR-Employee-Attrition’[MonthlyIncome])
```
### 🔸Avg Tenure=
```r
Avg Tenure =
AVERAGE(‘WA_Fn-UseC_-HR-Employee-Attrition’[YearsAtCompany])
```

------------------------------------------------------------------------

## 🔍 Key Findings

1.  Attrition mainly occurs within the first 1–3 years.
2.  Employees who leave tend to earn less.
3.  Low job satisfaction predicts higher attrition.

------------------------------------------------------------------------

## 🛠 Recommendations

-   Improve onboarding
-   Review salary bands
-   Enhance employee experience

------------------------------------------------------------------------

## 🏁 Conclusion

Attrition is primarily driven by low salaries, low satisfaction, and
short tenure.
