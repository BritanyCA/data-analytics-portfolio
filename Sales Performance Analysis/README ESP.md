# 📊 Dashboard de Ventas y Demanda Retail  
### Power BI | Proyecto de Portafolio  
**Autora:** Britany Campos • **Herramientas:** Power BI, DAX, Excel  

---

## 📌 Descripción del Proyecto  
Este dashboard analiza el comportamiento de ventas, patrones de demanda, promociones e inventario en un entorno retail.  
Permite entender cómo compran los clientes a lo largo del tiempo y detectar oportunidades para optimizar inventario y estrategias comerciales.

---

## 🎯 Objetivos  
- Analizar ventas por día, mes y trimestre  
- Evaluar desempeño por producto y tienda  
- Comparar ventas con y sin promoción  
- Identificar estacionalidad y patrones de demanda  
- Detectar desalineación entre inventario y ventas  

---

## 🗂 Estructura del Dashboard  

### **Página 1 — Overview**
- KPIs: Total Sales, Units Sold, Avg Price, Avg Discount  
- Tendencia mensual  
- Ranking de tiendas  
- Segmentadores por Año, Mes, Categoría, Tienda  

### **Página 2 — Products Analysis**
- Top productos  
- Ventas por categoría  
- Dispersión precio vs unidades  
- Matriz de desempeño por producto  

### **Página 3 — Stores Performance**
- Ranking de tiendas  
- Heatmap por categoría  
- Impacto de promociones  
- Inventario promedio por tienda  

### **Página 4 — Time & Demand Patterns**
- Ventas por día de la semana  
- Heatmap mensual  
- Ventas con vs sin promoción  
- Ventas vs inventario por trimestre  

---

## 🧠 Insights Clave  
- Las ventas se concentran **jueves–sábado**.  
- Meses fuertes: **ago, sep, nov, dic**; meses débiles: marzo y julio.  
- El inventario se mantiene estable mientras las ventas suben, mostrando **desalineación**.  

---

# 📐 Medidas DAX Principales  

### **1. Total Sales**
Calcula los ingresos totales multiplicando unidades vendidas por precio y ajustando el descuento.
```DAX
Total Sales =
SUMX (
    'Sales',
    'Sales'[UnitsSold] * 'Sales'[Price] * (1 - 'Sales'[Discount])
)
```
### **2. Promedio de Inventario**
Calcula el nivel promedio de inventario registrado.
```DAX
Avg Inventory Level =
AVERAGE ( 'Sales'[InventoryLevel] )
```
### **3.Ventas con o sin promoción**
Mide las ventas totales con y sin promoción.
```DAX
Sales with Promotion =
CALCULATE ( [Total Sales], 'Sales'[PromotionFlag] = 1 )

Sales without Promotion =
CALCULATE ( [Total Sales], 'Sales'[PromotionFlag] = 0 )
```
### **4.Tabla Calendar**
Crea una tabla de fechas completa con año, mes, día de la semana y formatos útiles para análisis temporal.
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