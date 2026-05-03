# 📊 Dashboard de Migración Global, Remesas y Movilidad Laboral
Proyecto en Power BI que analiza los flujos migratorios, la diáspora global, la migración laboral desde Pakistán y el impacto económico de las remesas en el sur de Asia.

Autora: Britany Campos • Tools: Power BI, SQL

## 🚀 Descripción del Proyecto
Este proyecto estudia cómo los patrones migratorios influyen en los resultados económicos de la región.
Incluye análisis de:

- Corredores migratorios
- Distribución de la diáspora
- Migración laboral
- Remesas y su impacto macroeconómico

El objetivo es entender cómo se mueven las personas, a dónde van y cómo sus aportes financieros afectan a sus países de origen.

## 🛠️ Tecnologías Utilizadas
- **SQL Server** — Limpieza, joins, CTEs y creación de vistas analíticas
- **Power BI** — Modelado, DAX y visualizaciones
- **DAX** — Inteligencia de tiempo y cálculos avanzados
- **Modelo en Estrella** — Dimensión calendario + vistas de hechos

## 📐 Modelo de Datos
El modelo sigue un esquema en estrella con:

- Calendar (dimensión temporal)
- vw_Diaspora_By_Country
- vw_Migration_Corridors
- vw_Remittances_By_Country
- vw_Pakistan_Emigration
- vw_Pakistan_Migration

Todas las vistas se relacionan con Calendar[Year] para habilitar cálculos de inteligencia de tiempo.

## 🔍 Insights Clave 
1. India lidera las remesas globales.
India supera ampliamente al resto de países del sur de Asia, reflejando una diáspora grande y globalmente distribuida.
2. Las remesas muestran un crecimiento sostenido y resiliente.
Incluso en periodos de incertidumbre global, las remesas continúan aumentando, demostrando su estabilidad como fuente de ingresos.
3. La migración impulsa directamente las remesas.
A mayor número de migrantes, mayor volumen de remesas, confirmando la dependencia estructural entre movilidad laboral y economía.

## 🧮 Medidas DAX Utilizadas
#### 🔸Total Remittances
Calcula el total de remesas recibidas. Es el indicador financiero principal del aporte de la diáspora.
``` DAX
Total Remittances =
SUM(vw_Remittances_By_Country[remittances_usd_billion])
```

#### 🔸Total Migrants
Cuenta el total de trabajadores emigrados desde Pakistán. Mide la magnitud de la migración laboral.
``` DAX
Total Migrants =
SUM(vw_Pakistan_Emigration[workers_emigrated])

```

#### 🔸YoY Growth
Mide cuánto crecieron o disminuyeron las remesas respecto al año anterior.
``` DAX
Remittances YoY =
VAR CurrentYear = [Total Remittances]
VAR PreviousYear =
    CALCULATE([Total Remittances], DATEADD(Calendar[Date], -1, YEAR))
RETURN
CurrentYear - PreviousYear
```

#### 🔸Moving Average (3Y)
Promedia las remesas de los últimos 3 años para suavizar variaciones y mostrar tendencias.
``` DAX
Remittances Moving Avg 3Y =
AVERAGEX(
    DATESINPERIOD(Calendar[Date], MAX(Calendar[Date]), -3, YEAR),
    [Total Remittances]
)
```
#### 🔸Skilled vs Unskilled %
Muestra la proporción de trabajadores calificados y no calificados dentro del total de migrantes.

``` DAX
Skilled % =
DIVIDE([Skilled Workers], [Total Migrants])

Unskilled % =
DIVIDE([Unskilled Workers], [Total Migrants])
```
#### 🔸Remittances per Migrant
Calcula el promedio de remesas enviadas por cada migrante. Indica poder adquisitivo y aporte económico individual.
``` DAX
Remittances per Migrant =
DIVIDE([Total Remittances], [Total Migrants])
```

## 🎯 Propósito del Proyecto
Este dashboard está diseñado para:

- Análisis de políticas públicas
- Investigación económica
- Estudios de migración
- Demostración de portafolio profesional
- Storytelling con datos

Muestra habilidades avanzadas de Business Intelligence: modelado de datos, DAX, visualización y narrativa analítica.

# ⭐ Conclusión 
La migración y las remesas forman un sistema económico profundamente interconectado.
Los datos muestran que las remesas crecen de manera constante, impulsadas por la movilidad laboral y la fortaleza de la diáspora. Los corredores migratorios revelan rutas clave que moldean estos flujos, mientras que las remesas se mantienen como una fuente estable de ingresos incluso en periodos de incertidumbre global.
En conjunto, el proyecto demuestra que la movilidad humana no es solo un fenómeno social, sino un motor económico esencial para los países del sur de Asia.