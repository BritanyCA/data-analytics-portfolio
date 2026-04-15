library(tidyverse)
##Data Import##
df <- read.csv("C:/Users/50660/Desktop/Portafolio data analysis/HR Employee Attrition/data/WA_Fn-UseC_-HR-Employee-Attrition.csv", stringsAsFactors=FALSE)
str(df)
summary(df)
##Categorize columns
df <- df %>%
  mutate(
    Attrition = factor(Attrition),
    BusinessTravel = factor(BusinessTravel),
    Department = factor(Department),
    EducationField = factor(EducationField),
    EnvironmentSatisfaction = factor(EnvironmentSatisfaction),
    Gender = factor(Gender),
    JobRole = factor(JobRole),
    JobSatisfaction = factor(JobSatisfaction),
    MaritalStatus = factor(MaritalStatus),
    Over18 = factor(Over18),
    OverTime = factor(OverTime)
  )

##Check for blanc values
colSums(is.na(df))
##Check columns
sapply(df, function(x) length(unique(x)))
#Check duplicates
sum(duplicated(df))
df <- df %>% distinct()
#Check risk outlier
df %>% filter(Age < 18 | Age > 70)
boxplot(df$MonthlyIncome)
boxplot(df$DistanceFromHome)
##Check coherency
df %>% filter(YearsInCurrentRole > YearsAtCompany)
df %>% filter(YearsAtCompany > TotalWorkingYears)





