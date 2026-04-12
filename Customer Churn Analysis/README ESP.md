# 📊 Análisis de Churn y Estrategia de Retención  
### Dashboard en Power BI | Proyecto de Portafolio  
**Autora:** Britany Campos
**Herramientas:** Power BI, DAX, Excel  

---

## 📌 Descripción del Proyecto  
Este proyecto analiza el comportamiento de churn (deserción) en una empresa de telecomunicaciones y desarrolla una estrategia completa de retención basada en datos.  
El dashboard identifica patrones de comportamiento, drivers de churn, segmentos de alto riesgo y oportunidades estratégicas para reducir la deserción.

---

## 🎯 Objetivos  
- Identificar los principales factores que impulsan el churn  
- Analizar el comportamiento y perfil del cliente  
- Crear segmentaciones basadas en riesgo  
- Simular escenarios de retención con un parámetro What‑If  
- Diseñar un dashboard profesional de múltiples páginas  

---

## 🗂 Estructura del Dashboard  

### **Página 1 — Overview & KPIs**  
- Total de clientes  
- Churn rate  
- Impacto en ingresos  
- Segmentación general  

### **Página 2 — Perfil del Cliente**  
- Distribución de tenure  
- Tipos de contrato  
- Servicios de internet  
- Métodos de pago  

### **Página 3 — Drivers de Churn**  
- Cargos mensuales (Churned vs Retained)  
- Antigüedad promedio  
- Migración clientes por TechSupport  
- Migración clientes por OnlineSecurity  
- Migración clientes por InternetService  
- Orden jerárquico

### **Página 4 — Oportunidades de Retención**  
- Segmentos de alto riesgo  
- Matriz de oportunidades  
- Simulación de descuento (What‑If)  
- Acciones recomendadas  
- Embudo de retención  

---

## 🧠 Insights Clave  
- Los clientes con **cargos mensuales altos** presentan mayor churn.  
- Los clientes con **bajo tenure** son los más propensos a irse.  
- La falta de **TechSupport** y **OnlineSecurity** aumenta significativamente el riesgo.  
- Los contratos **month‑to‑month** son el mayor driver de migración de clientes.  
- Los clientes de **fiber optic** muestran la tasa de migración de clientes más alto.  
- Las estrategias de retención pueden reducir la migración entre **10–20%**.

---

# 📐 Medidas DAX Principales (con explicación detallada)

---

## **1. Churn Rate**  
Calcula el porcentaje de clientes que abandonaron el servicio.  
Es el KPI principal del proyecto.

```DAX
Churn Rate =
DIVIDE(
    CALCULATE(COUNTROWS(Customers), Customers[Churn] = "Yes"),
    COUNTROWS(Customers)
)
```
## **2.Tenure Group**
Crea grupos categóricos de antigüedad para facilitar el análisis.
Tenure Group =
```DAX
SWITCH(
    TRUE(),
    Customers[tenure] <= 6, "0–6",
    Customers[tenure] <= 12, "7–12",
    Customers[tenure] <= 24, "13–24",
    Customers[tenure] <= 48, "25–48",
    "48+"
)
```
## **3.Adjusted Chun Rate(Simulacion de What-If)**
Simula como cambiaria la salida de clientes si se aplica en descuento.
```DAX
Adjusted Churn Rate =
[Churn Rate] *
(1 - 'Discount Parameter'[Discount Parameter Value Selected] / 100)
```
## **4.Métricas de embudo de retención**
- Contacted Rate: porcentaje de clientes de alto riesgo contactados.
- Engagement Rate: porcentaje de clientes contactados que interactuaron.
- Offer Acceptance Rate: porcentaje de clientes que aceptaron una oferta.
- Retention Rate: porcentaje final de clientes retenidos.
```DAX
Contacted Rate = DIVIDE([Contacted], [High-Risk Customers])
Engagement Rate = DIVIDE([Engaged], [Contacted])
Offer Acceptance Rate = DIVIDE([Offered Retention Plan], [Engaged])
Retention Rate = DIVIDE([Retained], [Offered Retention Plan])
```
