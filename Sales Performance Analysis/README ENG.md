# 📊 Retail Sales & Demand Dashboard  
### Power BI | Portfolio Project  
**Author:** Britany Campos • **Tools:** Power BI, DAX, Excel  

---

## 📌 Project Description  
This dashboard analyzes sales performance, demand patterns, promotions, and inventory behavior in a retail environment.  
It helps understand how customers purchase over time and identify opportunities to optimize inventory and commercial strategies.

---

## 🎯 Objectives  
- Analyze sales by day, month, and quarter  
- Evaluate performance by product and store  
- Compare sales with and without promotions  
- Identify seasonality and demand patterns  
- Detect misalignment between inventory and sales  

---

## 🗂 Dashboard Structure  

### **Page 1 — Overview**
- KPIs: Total Sales, Units Sold, Avg Price, Avg Discount  
- Monthly trend  
- Store ranking  
- Filters by Year, Month, Category, Store  

### **Page 2 — Products Analysis**
- Top products  
- Sales by category  
- Price vs units scatter plot  
- Product performance matrix  

### **Page 3 — Stores Performance**
- Store ranking  
- Category heatmap  
- Promotion impact  
- Average inventory by store  

### **Page 4 — Time & Demand Patterns**
- Sales by day of the week  
- Monthly heatmap  
- Sales with vs without promotion  
- Sales vs inventory by quarter  

---

## 🧠 Key Insights  
- Sales are concentrated between **Thursday–Saturday**.  
- Strong months: **Aug, Sep, Nov, Dec**; weak months: March and July.  
- Inventory remains stable while sales increase, showing **misalignment**.  

---

# 📐 Main DAX Measures  

### **1. Total Sales**  
Calculates total revenue by multiplying units sold by price and adjusting for discounts.

```DAX
Total Sales =
SUMX (
    'Sales',
    'Sales'[UnitsSold] * 'Sales'[Price] * (1 - 'Sales'[Discount])
)
```
### **2. Average Inventory**
Calculates the average recorded inventory level.
```DAX
Avg Inventory Level =
AVERAGE ( 'Sales'[InventoryLevel] )
```
### **3. Sales with or without Promotion**
Measures total sales with and without promotion.
```DAX
Sales with Promotion =
CALCULATE ( [Total Sales], 'Sales'[PromotionFlag] = 1 )

Sales without Promotion =
CALCULATE ( [Total Sales], 'Sales'[PromotionFlag] = 0 )
```
### **4. Calendar Table**
Creates a complete date table with year, month, weekday, and useful formats for time analysis.
```DAX
Calendar =
ADDCOLUMNS (
    CALENDAR ( MIN ( 'Sales'[Date] ), MAX ( 'Sales'[Date] ) ),
    "Year", YEAR ( [Date] ),
    "MonthNumber", MONTH ( [Date] ),
    "MonthName", FORMAT ( [Date], "MMM" ),
    "YearMonth", FORMAT ( [Date], "YYYY-MM" ),
    "WeekdayName", FORMAT ( [Date], "dddd" ),
    "WeekdayNumber", WEEKDAY ( [Date], 2 )
)
```