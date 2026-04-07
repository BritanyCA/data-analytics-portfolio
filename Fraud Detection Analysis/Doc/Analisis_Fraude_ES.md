# 1. ¿Qué patrones y comportamientos caracterizan las transacciones normales vs fraudulentas?

## 1.1 Objetivo
Identificar diferencias de comportamiento entre transacciones legítimas y fraudulentas mediante análisis en SQL.

## 1.2 Metodología
- Comparación de montos  
- Análisis de fraude por hora del día  
- Evaluación por categoría y país  
- Uso de funciones ventana y agregaciones por grupo  

---

## 1.3 Análisis SQL

### Distribución de Montos

```sql
SELECT DISTINCT
    Fraud,
    COUNT(*) OVER (PARTITION BY Fraud) AS n_tx,
    AVG(Amount) OVER (PARTITION BY Fraud) AS avg_amount,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Amount)
        OVER (PARTITION BY Fraud) AS median_amount
FROM dbo.transactions;
```

### Fraude por Hora del día.
```sql
SELECT DATEPART(HOUR, Hour) AS hour_24,
       Fraud,
       COUNT(*) AS n_tx
FROM dbo.transactions
GROUP BY DATEPART(HOUR, Hour), Fraud
ORDER BY hour_24, Fraud;
```
### Tasa de fraude por categoría y país.
```sql
SELECT Merchant_Category,
       Country,
       SUM(CASE WHEN Fraud = 1 THEN 1 ELSE 0 END) AS Fraud_tx,
       COUNT(*) AS total_tx,
       1.0 * SUM(CASE WHEN Fraud = 1 THEN 1 ELSE 0 END) / COUNT(*) AS Fraud_rate
FROM dbo.transactions
GROUP BY Merchant_Category, Country
ORDER BY Fraud_rate DESC;
```
# 2.¿Qué anomalias o patrones inusuales pueden detectarse en los datos?
## 2.1 Objetivo
Identificar outliners, puntajes de riesgo extremos y usuarios sospechosos.

## 2.2 Metodología
- Detección estadística de outliners
- Umbrales de riesgo
- Análisis de comportamiento por usuario

## 2.3 Análisis SQL
### Outliners en Montos
```sql
SELECT *
FROM dbo.transactions
WHERE Amount > (
    SELECT AVG(Amount) + 3 * STDEV(Amount)
    FROM dbo.transactions
);
```
### Puntajes de Riesgo Extremos
```sql 
FROM dbo.transactions
WHERE Device_Risk_Score > 0.9
   OR IP_Risk_Score > 0.9;
```
### Usuarios sospechosos
```sql
SELECT User_ID,
       COUNT(*) AS total_tx,
       SUM(CASE WHEN Fraud = 1 THEN 1 ELSE 0 END) AS fraud_tx,
       1.0 * SUM(CASE WHEN Fraud = 1 THEN 1 ELSE 0 END) / COUNT(*) AS fraud_rate
FROM dbo.transactions
GROUP BY User_ID
HAVING COUNT(*) >= 10
ORDER BY fraud_rate DESC;
```
# 3.¿Qué recomendaciones pueden hacerse para reducir el riesgo de fraude?
## 3.1 Objetivo 
Transformar los hallazgos analíticos en estrategias accionables de prevencion de fraude.
## 3.2 Recomendaciones
### 3.2.1. Reforzar monitores en horas de alto riesgo 
- Alertas en tiempo real 
- Autentificación adicional 
- Límites temporales

### 3.2.2. Controles más estrictos en categorías y países de alto riesgo 
- Verificación adicional
- Límites más bajos
- Revisión de transacciones internacionales

### 3.2.3. Revisiones manuales basadas en puntajes de riesgo 
Revisar transacciones como:
- Device_Risk_Score >0.9
- IP_Risk_Score >0.9

### 3.2.4. Monitorear usuarios con comportamiento sospechoso
Usuarios con:
- Alta tasa de fraude
- Alto volumen
- Anomalías repetidas (requieren supervisión especial)

# 4. Conclusión
El análisis permite comprender patrones, anomalías y factores de riesgo, habilitando estrategias efectivas de prevención de fraude.


