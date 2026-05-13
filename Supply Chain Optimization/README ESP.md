# 📊 Analítica Global de Riesgo en la Cadena de Suministro

SQL + Power BI | Proyecto de Portafolio
Autor: Britany Campos • Herramientas: SQL Server, Power BI, DAX

## 📌 Descripción del Proyecto

Este proyecto presenta una solución analítica completa de extremo a extremo para evaluar riesgos en cadenas de suministro globales.

Comienza con la preparación de datos mediante SQL, incluyendo limpieza, transformación, creación de vistas analíticas y análisis de correlación.

Posteriormente, los datos procesados se modelan en Power BI utilizando un esquema estrella profesional, seguido del desarrollo de un dashboard de 4 páginas que analiza interrupciones, modos de transporte, vulnerabilidades de productos, factores operacionales e indicadores predictivos.

---

# 🎯 Objetivos

## Objetivos en SQL

* Limpiar y estandarizar datos logísticos en bruto
* Construir vistas analíticas para Power BI
* Crear una tabla calendario para inteligencia temporal
* Calcular correlaciones para identificar factores de riesgo
* Preparar métricas de rutas, productos y operaciones

## Objetivos en Power BI

* Construir un modelo tipo estrella (Star Schema)
* Crear medidas DAX para riesgo, tiempos de entrega e interrupciones
* Visualizar riesgos por rutas, productos y tiempo
* Identificar envíos de alto riesgo y patrones predictivos

---

# 🗂 Ingeniería de Datos (SQL)

## 1. Limpieza y Estandarización de Datos

Las tablas originales fueron limpiadas utilizando SQL para garantizar formatos consistentes:

* Estandarización de formatos de fecha
* Normalización de nombres de puertos
* Conversión de campos categóricos
* Eliminación de duplicados
* Validación de rangos numéricos (lead time, distancia, puntajes de riesgo)

---

## 2. Vistas Analíticas para Power BI

Para evitar cargar tablas sin procesar en Power BI, se crearon vistas SQL limpias.

### Vista Principal de Hechos

```sql
CREATE VIEW dbo.vw_Fact_SupplyChainRisk AS
SELECT
    Shipment_ID,
    Date,
    Origin_Port,
    Destination_Port,
    Transport_Mode,
    Product_Category,
    Distance_km,
    Weight_MT,
    Fuel_Price_Index,
    Geopolitical_Risk_Score,
    Carrier_Reliability_Score,
    Lead_Time_Days,
    Disruption_Occurred,
    Composite_Risk_Score,
    Lead_Time_Category,
    Distance_Category,
    Month,
    Quarter,
    High_Risk_Route,
    Fuel_Cost_Impact,
    Weight_Distance_Interaction
FROM dbo.Global_Supply_Chain_Risk_FE;
```

### Vistas Dimensionales

```sql
CREATE VIEW dbo.vw_Dim_OriginPort AS
SELECT DISTINCT
    Origin_Port AS Port_Name
FROM dbo.Global_Supply_Chain_Risk_FE;
```

```sql
CREATE VIEW vw_Dim_Port AS
SELECT DISTINCT Origin_Port AS Port_Name
FROM vw_Fact_SupplyChainRisk
WHERE Origin_Port IS NOT NULL

UNION

SELECT DISTINCT Destination_Port
FROM vw_Fact_SupplyChainRisk
WHERE Destination_Port IS NOT NULL;
```

---

## 3. Análisis de Correlación (Base de Importancia de Variables)

Para comprender qué variables impulsan las interrupciones, se calcularon correlaciones en SQL:

```sql
-- CTE de correlaciones clave
WITH Stats AS (
    SELECT
        AVG(Distance_km) AS Avg_Distance,
        AVG(Lead_Time_Days) AS Avg_LeadTime,
        AVG(Fuel_Price_Index) AS Avg_Fuel,
        AVG(Geopolitical_Risk_Score) AS Avg_GeoRisk,
        AVG(Carrier_Reliability_Score) AS Avg_Carrier,
        AVG(Disruption_Occurred) AS Avg_Y
    FROM dbo.Global_Supply_Chain_Risk_Model
),
Base AS (
    SELECT
        Distance_km, Lead_Time_Days, Fuel_Price_Index,
        Geopolitical_Risk_Score, Carrier_Reliability_Score,
        Disruption_Occurred AS Y
    FROM dbo.Global_Supply_Chain_Risk_Model
)
SELECT * FROM (
    SELECT 
        'Distance_km' AS Variable,
        SUM((Distance_km - s.Avg_Distance) * (Y - s.Avg_Y)) /
        SQRT(
            SUM(POWER(Distance_km - s.Avg_Distance, 2)) *
            SUM(POWER(Y - s.Avg_Y, 2))
        ) AS Correlation
    FROM Base, Stats s

    UNION ALL
    SELECT 
        'Lead_Time_Days',
        SUM((Lead_Time_Days - s.Avg_LeadTime) * (Y - s.Avg_Y)) /
        SQRT(
            SUM(POWER(Lead_Time_Days - s.Avg_LeadTime, 2)) *
            SUM(POWER(Y - s.Avg_Y, 2))
        )
    FROM Base, Stats s

    UNION ALL
    SELECT 
        'Fuel_Price_Index',
        SUM((Fuel_Price_Index - s.Avg_Fuel) * (Y - s.Avg_Y)) /
        SQRT(
            SUM(POWER(Fuel_Price_Index - s.Avg_Fuel, 2)) *
            SUM(POWER(Y - s.Avg_Y, 2))
        )
    FROM Base, Stats s

    UNION ALL
    SELECT 
        'Geopolitical_Risk_Score',
        SUM((Geopolitical_Risk_Score - s.Avg_GeoRisk) * (Y - s.Avg_Y)) /
        SQRT(
            SUM(POWER(Geopolitical_Risk_Score - s.Avg_GeoRisk, 2)) *
            SUM(POWER(Y - s.Avg_Y, 2))
        )
    FROM Base, Stats s

    UNION ALL
    SELECT 
        'Carrier_Reliability_Score',
        SUM((Carrier_Reliability_Score - s.Avg_Carrier) * (Y - s.Avg_Y)) /
        SQRT(
            SUM(POWER(Carrier_Reliability_Score - s.Avg_Carrier, 2)) *
            SUM(POWER(Y - s.Avg_Y, 2))
        )
    FROM Base, Stats s
) AS t
ORDER BY ABS(Correlation) DESC;
```

---

# 🧩 Modelado de Datos (Power BI)

## Esquema Estrella (Star Schema)

### Tabla de Hechos:

**vw_Fact_SupplyChainRisk**

### Dimensiones:

* vw_Dim_Product
* vw_Dim_OriginPort
* vw_Dim_DestinationPort
* vw_Calendar

Las relaciones se mantuvieron en una sola dirección, evitando ambigüedades y garantizando un comportamiento limpio en DAX.

---

# 📐 Principales Medidas DAX

## 1. Interrupción Real

```DAX
Actual Disruption =
AVERAGE ( vw_Fact_SupplyChainRisk[Disruption_Occurred] )
```

## 2. Tiempo Promedio de Entrega

```DAX
Avg Lead Time =
AVERAGE ( vw_Fact_SupplyChainRisk[Lead_Time_Days] )
```

## 3. Puntaje de Riesgo Compuesto (Promedio)

```DAX
Avg Risk Score =
AVERAGE ( vw_Fact_SupplyChainRisk[Composite_Risk_Score] )
```

## 4. Interrupción Predicha

```DAX
Predicted_Disruption = 
DIVIDE(
    AVERAGE(vw_Fact_SupplyChainRisk[Composite_Risk_Score]),
    100
) 
```

## 5. Etiqueta de Ruta

```DAX
Route =
vw_Fact_SupplyChainRisk[Origin_Port] & " → " &
vw_Fact_SupplyChainRisk[Destination_Port]
```

---

# 🗂 Estructura del Dashboard

## Página 1 — Resumen Ejecutivo

* KPIs
* Tendencia de interrupciones
* Riesgo por modo de transporte
* Matriz de interrupciones por puerto

## Página 2 — Riesgo de Rutas y Transporte

* Top 10 rutas de mayor riesgo
* Comparación de modos de transporte
* Distancia vs tiempo de entrega
* Mapa de rutas

## Página 3 — Riesgo Operacional y de Productos

* Interrupciones por producto
* Tiempo de entrega por producto
* Tendencia geopolítica
* Confiabilidad del transportista vs interrupciones

## Página 4 — Insights Predictivos

* Importancia de variables (basado en correlaciones SQL)
* Distribución del puntaje de riesgo
* Interrupciones predichas vs reales
* Envíos de alto riesgo

---

# 🧠 Principales Insights

### 1. El tiempo de entrega y el riesgo geopolítico son los principales predictores de interrupciones

Estas dos variables dominan tanto el análisis de correlación como el modelo predictivo.

### 2. Las rutas marítimas y los envíos de larga distancia presentan el mayor riesgo

El transporte marítimo se posiciona consistentemente como el modo más vulnerable.

### 3. Los textiles y productos farmacéuticos son las categorías más propensas a interrupciones

Presentan las tasas más altas de interrupción y los mayores tiempos de entrega.

---

# 🧾 Conclusión General

Este proyecto demuestra una solución completa de SQL + Power BI para el análisis global de riesgos en cadenas de suministro.

* SQL se utilizó para limpiar, transformar, modelar y analizar los datos.
* Power BI se utilizó para visualizar, explorar e interpretar patrones de riesgo.
* La combinación de ambas herramientas permitió desarrollar un enfoque predictivo y basado en datos sobre interrupciones logísticas.

El resultado es una solución analítica robusta que transforma datos logísticos sin procesar en inteligencia accionable, ayudando a las organizaciones a anticipar interrupciones, optimizar estrategias de rutas y construir una cadena de suministro más resiliente.
