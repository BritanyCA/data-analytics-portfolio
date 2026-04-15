# 📊 Dashboard de Ventas y Demanda Retail  
### Power BI | Proyecto de Portafolio  
**Autora:** Britany Campos • **Herramientas:** Power BI, DAX, Excel, RStudio

---
# HR Attrition Analysis — Proyecto Completo en R y Power BI

## 📌 Tabla de Contenidos
1. [Objetivo](#objetivo)
2. [Metodología](#metodología)
3. [Preparación de Datos en R](#preparación-de-datos-en-r)
4. [Análisis Exploratorio (EDA)](#análisis-exploratorio-eda)
5. [Dashboard en Power BI](#dashboard-en-power-bi)
6. [Hallazgos Clave](#hallazgos-clave)
7. [Recomendaciones](#recomendaciones)
8. [Conclusión](#conclusión)

---

## 🎯 Objetivo
Analizar los factores que influyen en la rotación de empleados utilizando **R** para el análisis exploratorio y **Power BI** para la visualización ejecutiva.

---

## 🧠 Metodología
- Limpieza y preparación del dataset en R  
- Conversión de variables categóricas  
- Análisis exploratorio (EDA)  
- Creación de KPIs y medidas DAX  
- Dashboard interactivo en Power BI  
- Interpretación de patrones y recomendaciones  

---

## 🧹 Preparación de Datos en R

### 🔸 Carga del dataset
Se carga el archivo original para iniciar el proceso de limpieza
```r
hr <- read.csv("WA_Fn-UseC_-HR-Employee-Attrition.csv")
```
### 🔸Conversión de columnas categóricas.
Estas columnas representan niveles o categorías, Convertirlas en factor permite el análisis estadístico correcto y sus respectivas visualizaciones.
```r
categorical_cols <- c(
  "Attrition","BusinessTravel","Department","Education","EducationField",
  "EnvironmentSatisfaction","Gender","JobInvolvement","JobLevel","JobRole",
  "JobSatisfaction","MaritalStatus","OverTime","PerformanceRating",
  "RelationshipSatisfaction","WorkLifeBalance"
)
hr[categorical_cols] <- lapply(hr[categorical_cols], as.factor)
```

### 🔸 Revisión de estructura
Permite verificar tipos de datos, rangos y detectar valores anómalos.
```r
str(hr)
summary(hr)
```
## 📊Análisis Exploratorio (EDA)

### 🔸Distribución de Rotación
Muestra cuantos empleados quedan vs los que renuncian.
```r 
ggplot(hr, aes(Attrition)) +
  geom_bar(fill = "#E74C3C") +
  theme_minimal()
```
### 🔸Rotación por departamento
Compara la proporción de renuncias entre departamentos.
```r
ggplot(hr, aes(Department, fill = Attrition)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent)
```
### 🔸Ingreso Mensual vs Rotación
Permite observar diferencias salariales entre quienes se quedan y renuncian.
```r
ggplot(hr, aes(Attrition, MonthlyIncome, fill = Attrition)) +
  geom_boxplot()
```
### 🔸Antigüedad vs Rotación
Identifica en qué etapa del ciclo laboral ocurre más rotación.
```r
ggplot(hr, aes(YearsAtCompany, fill = Attrition)) +
  geom_histogram(binwidth = 1)
```
## 📈Dashboard Power BI
### 🔸KPIs principales
- Attrition Rate
- Total Employees
- Employees Left
- Avg Monthly Income
- Avg Tenure

### 🔸Medidas DAX
#### Attrition Rate
Calcula el porcentaje de empleados que renunciaron.
```DAX
Attrition Rate = 
DIVIDE(
    CALCULATE(COUNTROWS('WA_Fn-UseC_-HR-Employee-Attrition'), 'WA_Fn-UseC_-HR-Employee-Attrition'[Attrition]= "Yes"),
    COUNTROWS('WA_Fn-UseC_-HR-Employee-Attrition')
)
```
#### Total Employees
Cuenta el total de empleados.
```DAX
Total Employees = COUNTROWS('WA_Fn-UseC_-HR-Employee-Attrition')
```
#### Employees Left
Cuenta únicamente empleados con Attrition ="YES"
```DAX
Employees left = CALCULATE(COUNTROWS('WA_Fn-UseC_-HR-Employee-Attrition'),'WA_Fn-UseC_-HR-Employee-Attrition'[Attrition]="YES"
```
#### Avg Monthly Income
Promedio del ingreso mensual
```DAX
Avg Monthly Income = AVERAGE('WA_Fn-UseC_-HR-Employee-Attrition'[MonthlyIncome])
```
#### Avg Tenure
Promedio de años en la empresa
```DAX
Avg Tenure = AVERAGE('WA_Fn-UseC_-HR-Employee-Attrition'[YearsAtCompany])
```

## 🔍 Hallazgos Clave

1️⃣ La rotación ocurre principalmente en los primeros 1–3 años.
Indica problemas en onboarding y adaptación temprana.

2️⃣ Los empleados que renuncian ganan menos.
La compensación es un factor crítico de retención.

3️⃣ La satisfacción laboral baja predice mayor rotación.
Los niveles 1–2 muestran mayor riesgo.

## 🛠 Recomendaciones
✔ Mejorar el onboarding
Mentoría, claridad de rol, seguimiento mensual.

✔ Revisar bandas salariales
Especialmente en roles con alta rotación.

✔ Mejorar la experiencia laboral
Programas de bienestar, liderazgo, clima laboral.

## 🏁 Conclusión
La rotación está impulsada por salarios bajos, baja satisfacción y poca antigüedad.
El dashboard permite identificar segmentos críticos y tomar decisiones estratégicas.