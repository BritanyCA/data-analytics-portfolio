library(tidyverse)
##Data Import##
hr <- read.csv("C:/Users/50660/Desktop/Portafolio data analysis/HR Employee Attrition/data/WA_Fn-UseC_-HR-Employee-Attrition.csv", stringsAsFactors=FALSE)

##Data check
str(hr)
summary(hr)
head(hr)
##values categorical
categorical_cols <- c(
  "Attrition", "BusinessTravel", "Department", "Education",
  "EducationField", "EnvironmentSatisfaction", "Gender",
  "JobInvolvement", "JobLevel", "JobRole", "JobSatisfaction",
  "MaritalStatus", "OverTime", "PerformanceRating",
  "RelationshipSatisfaction", "WorkLifeBalance"
)

hr[categorical_cols] <- lapply(hr[categorical_cols], as.factor)

##Duplicates and missing values
colSums(is.na(hr))
sum(duplicated(hr))

##EDA
#General Rotation Distribution
library(ggplot2)

ggplot(hr, aes(Attrition)) +
  geom_bar(fill = "#E74C3C") +
  labs(
    title = "Distribución de Rotación de Empleados",
    x = "Attrition",
    y = "Cantidad de empleados"
  ) +
  theme_minimal()

#Rate department rotation
ggplot(hr, aes(Department, fill = Attrition)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Tasa de Rotación por Departamento",
    x = "Departamento",
    y = "Porcentaje"
  ) +
  theme_minimal()

#JobRole Rotation
ggplot(hr, aes(JobRole, fill = Attrition)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  coord_flip() +
  labs(
    title = "Rotación por Rol",
    x = "Rol",
    y = "Porcentaje"
  ) +
  theme_minimal()

#Salary and Rotation relationship
ggplot(hr, aes(Attrition, MonthlyIncome, fill = Attrition)) +
  geom_boxplot() +
  labs(
    title = "Relación entre Salario y Rotación",
    x = "Attrition",
    y = "Ingreso Mensual"
  ) +
  theme_minimal()

#Company Tenure
ggplot(hr, aes(YearsAtCompany, fill = Attrition)) +
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.6) +
  labs(
    title = "Antigüedad vs Rotación",
    x = "Años en la Empresa",
    y = "Cantidad de empleados"
  ) +
  theme_minimal()

#Rotation and Job Satisfaction
ggplot(hr, aes(JobSatisfaction, fill = Attrition)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Satisfacción Laboral vs Rotación",
    x = "Nivel de Satisfacción",
    y = "Porcentaje"
  ) +
  theme_minimal()

