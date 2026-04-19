# 📊 Gold Price Forecasting Dashboard  
Power BI | Proyecto de Portafolio  

**Autora:** Britany Campos • **Herramientas:** Power BI, DAX, Excel  

---

## Gold Price Forecasting — Proyecto Completo en Power BI  

### 📌 Tabla de Contenidos  
1. Objetivo  
2. Metodología  
3. Preparación de Datos  
4. Análisis Exploratorio de Datos (EDA)  
5. Dashboard en Power BI  
6. Hallazgos Clave  
7. Recomendaciones  
8. Conclusión  

---

### 🎯 Objetivo  
Analizar los precios históricos del oro, identificar los principales factores del mercado y construir un modelo de pronóstico con múltiples métodos en Power BI para apoyar la toma de decisiones financieras estratégicas.  

---

### 🧠 Metodología  
- Limpieza y preparación de datos en Excel  
- Creación de tabla calendario y estructuras de inteligencia de tiempo  
- Análisis Exploratorio de Datos (EDA)  
- Desarrollo de medidas de pronóstico (Lineal, CAGR, basado en escenarios)  
- Métricas móviles: promedios y volatilidad  
- Parámetros What-if para análisis de sensibilidad  
- Diseño de dashboard interactivo en Power BI  

---

### 🧹 Preparación de Datos  

#### 🔸 Carga del Dataset  
El dataset fue limpiado y estructurado en Excel antes de ser importado a Power BI.  

#### 🔸 Tabla Calendario  
Se creó una tabla de fechas completa para habilitar cálculos de inteligencia de tiempo.  

```DAX
Calendar =
ADDCOLUMNS(
    CALENDAR(MIN(tblGold[Date]), MAX(tblGold[Date])),
    "Year", YEAR([Date]),
    "Month", FORMAT([Date], "MMMM"),
    "MonthNumber", MONTH([Date])
)
```
## 📊 Análisis Exploratorio de Datos (EDA)
### 🔸 Tendencia Histórica
Identifica la dirección de largo plazo y cambios estructurales en el precio.
### 🔸 Variación Año contra Año (YoY)
Resalta periodos de crecimiento acelerado o contracción.
### 🔸 Volatilidad Móvil
Muestra la estabilidad del mercado y la concentración de riesgo en el tiempo.
### 🔸 Promedios Móviles (7 días y 30 días)
Suavizan las fluctuaciones de corto plazo para revelar tendencias subyacentes.

## 📈 Dashboard en Power BI
- KPIs Clave
- Precio Promedio Actual de Cierre
- Variación % Año contra Año (YoY)
- Pronóstico (Año Actual)
- Pronóstico Basado en Escenarios
## 🧮 Medidas DAX
### 🔸 Pronóstico Lineal (Basado en Regresión)
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
### 🔸 Pronóstico CAGR
```DAX
CAGR =
VAR StartValue = CALCULATE(MIN(tblGold[Close]), FIRSTDATE(tblGold[Date]))
VAR EndValue = CALCULATE(MAX(tblGold[Close]), LASTDATE(tblGold[Date]))
VAR Years = DATEDIFF(FIRSTDATE(tblGold[Date]), LASTDATE(tblGold[Date]), YEAR)
RETURN
(EndValue / StartValue) ^ (1 / Years) - 1
```
### 🔸 Pronóstico Basado en Escenarios
```DAX 
Forecast Escenario =
[Forecast Lineal] *
SELECTEDVALUE(Escenario[Factor], 1)
```
### 🔸 Promedios Móviles
```DAX
Promedio 7 días =
AVERAGEX(
    DATESINPERIOD(Calendar[Date], MAX(Calendar[Date]), -7, DAY),
    CALCULATE(AVERAGE(tblGold[Close]))
)

Promedio 30 días =
AVERAGEX(
    DATESINPERIOD(Calendar[Date], MAX(Calendar[Date]), -30, DAY),
    CALCULATE(AVERAGE(tblGold[Close]))
)
```
### 🔍 Hallazgos Clave
- Los precios del oro muestran una fuerte tendencia alcista a largo plazo, con crecimiento acelerado proyectado hacia 2026.
- La volatilidad aumenta significativamente en los años recientes, indicando mayor incertidumbre en el mercado.
- El pronóstico basado en escenarios muestra diferencias importantes entre supuestos optimistas y pesimistas.
### 🛠 Recomendaciones
- Monitorear picos de volatilidad como indicadores tempranos de inestabilidad del mercado.
- Utilizar pronósticos basados en escenarios para planificación estratégica bajo incertidumbre.
- Combinar promedios móviles con pronósticos de regresión para una detección de tendencias más robusta.
### 🏁 Conclusión
- El comportamiento del precio del oro está impulsado por una tendencia alcista de largo plazo, aumento de la volatilidad y sensibilidad a los supuestos del mercado.
- Este dashboard proporciona un marco analítico completo para pronóstico, evaluación de riesgos y toma de decisiones estratégicas.