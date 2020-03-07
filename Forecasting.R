#------------------------ FORECASTING

### Librerías requeridas: 
install.packages("tidyverse")
install.packages("data.table")
install.packages("janitor")
install.packages("DataExplorer")
install.packages("lubridate")
install.packages("plyr")
install.packages("tseries")

library(tidyverse)
library(data.table)
library(janitor)
library(DataExplorer)
library(lubridate)
library(plyr)
library(tseries)

accidentes <- read.csv("/Users/emi/Documents/Documentos/Data_Science/K_School/TFM/TFM_v3/accidentes_barcelona.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)

# Al importar se ha perdido la clase 'fecha' para la columna del dataset llamada Fecha.
accidentes$Fecha <- as.Date(accidentes$Fecha)

# Creamos una columna con el valor 1 para realizar después un sumatorio de accidentes por día
accidentes_1 <- accidentes %>% 
  arrange(Fecha) %>% 
  mutate(num_acc=1) 
  
# Ahora ya tenemos el dataset listo como una serie temporal para comenzar con el análisis del número de accidentes en cada día de los 5 años.
accidentes_ts <- aggregate(accidentes_1["num_acc"], by=accidentes_1["Fecha"],sum)
ts(accidentes_ts)


adf.test(accidentes)
