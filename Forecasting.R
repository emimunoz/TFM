### FORECASTING --------------------------------------------------------------
###---------------------------------------------------------------------------


### Librerías requeridas: 
install.packages("tidyverse")
install.packages("data.table")
install.packages("janitor")
install.packages("DataExplorer")
install.packages("lubridate")
install.packages("plyr")
install.packages("tseries")
install.packages("forecast")
install.packages("TSstudio")
install.packages("prophet")

library(tidyverse)
library(data.table)
library(janitor)
library(DataExplorer)
library(lubridate)
library(plyr)
library(tseries)
library(forecast)
library(TSstudio)
library(prophet)

### CREACIÓN DE LA SERIE TEMPORAL ----------------------------------------------

accidentes_ds_completo <- read.csv("/Users/emi/Documents/Documentos/Data_Science/K_School/TFM/TFM_v3/accidentes_barcelona.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)

# Al importar se ha perdido la clase 'fecha' para la columna del dataset llamada Fecha.
accidentes_ds_completo$Fecha <- as.Date(accidentes_ds_completo$Fecha)

# Creamos una columna con el valor 1 para realizar después un sumatorio de accidentes por día
accidentes_1 <- accidentes_ds_completo %>% 
  arrange(Fecha) %>% 
  mutate(num_acc=1) 

# Se suman los accidentes de cada día
accidentes_sum_dia <- aggregate(accidentes_1["num_acc"], by=accidentes_1["Fecha"],sum)


#---------------------------------

# Quitamos la columna con la fecha para poder pasar a crear ya la serie temporal con todos los accidentes
accidentes_sum_dia$Fecha <- NULL

# Creamos la serie temporal con frecuencia diaria desde el día 1 de enero de 2014
accidentes_ts <- ts(accidentes_sum_dia, start = c(2014,1,1) , frequency = 365)
plot(accidentes_ts)


### ANÁLISIS DE LA SERIE TEMPORAL ---------------------------------------------------------

# Comprobamos si la serie temporal es estacionaria:
#   H0: Tendencia estacionaria 
#   H1: No estacionaria 
kpss.test(accidentes_ts, null = "Trend") # 0.08934 > 0.05 -> No podemos rechazar H0, por lo que no hay evidencia de que la serie no sea estacionaria


# Comprobamos la estacionariedad con un adf test:
adf.test(accidentes_ts) # Es una serie temporal estacionaria.


# Extraemos la estacionalidad, tendencia y error de los componentes de la serie temporal para poder visualizarlos
accidentes_descomp <- decompose(accidentes_ts, type = "additive")
plot(accidentes_descomp)
# Tendencia: Se comprueba que hay una ligera variación en la tendencia que va entre 26.5 y 28.5 accidentes diarios, un cambio de un 7%.
# Estacionalidad: Hay una fuerte estacionalidad que se va repitiendo cada año con una forma muy similar al anterior.
# Ruido: Tiene mucha amplitud ya que los valores varían entre 20 y -20 accidentes diarios.  


# Obtenemos las gráficas de autocorrelación y autocorrelación parcial, y en ambas se puede observar que aunque no llega a haber
# una correlación muy elevada (el valor máximo alcanza una correlación de 0.469), si se verifica la estacionalidad de la serie temporal
acf(accidentes_ts)
pacf(accidentes_ts)


### FORECASTING DE LA SERIE TEMPORAL ---------------------------------------------------------

checkresiduals(arimaFit)
autoplot(forecast(autoArimaFit))

# Separamos la serie temporal completa en train y test para poder comprobar la eficacia del algoritmo
split_accidentes <-  ts_split(ts.obj = accidentes_ts, sample.out=365)
training <- split_accidentes$train
test <- split_accidentes$test

length(training) # 1461 valores
length(test) # 365 valores



### FORECASTING CON ARIMA 
# 'arima_ses <- forecast(auto.arima(ts(accidentes_ts, frequency = 365),D=1),h=365)' Intenté "forzar" la detección de estacionalidad por parte del modelo ARIMA, pero estaba muchísimo rato el PC 
# pensando sin llegar nunca a dar ningún resultado.

arima_acc <- auto.arima(training)
checkresiduals(arima_acc)
accuracy(arima_acc)
autoplot(forecast(arima_acc))



### FORECASTING CON ETS

ets_acc <- ets(training) # Muestra aviso de que la estacionalidad será ignorada, ETS y ARIMA no son buenos métodos para series estacionales. 
checkresiduals(ets_acc)
accuracy(ets_acc)
autoplot(forecast(ets_acc))

### FORECASTING CON SNAIVE

snaive_acc <- snaive(training)
plot(snaive_acc)
checkresiduals(snaive_acc)

### FORECASTING CON HOLT WINTERS METHOD

hwm_acc <- HoltWinters(training)

### COMPARATIVA DE LOS MODELOS CON AUTO ARIMA, ETS, SNAIVE, 

accuracy_arima <- arima_acc %>% forecast(h=365) %>% accuracy(test)
accuracy_arima[,c("RMSE","MAE","MAPE","MASE")]

accuracy_ets <- ets_acc %>% forecast(h=365) %>% accuracy(test)
accuracy_ets[,c("RMSE","MAE","MAPE","MASE")]

accuracy_snaive <- snaive_acc %>% forecast(h=365) %>% accuracy(test)
accuracy_snaive[,c("RMSE","MAE","MAPE","MASE")]

accuracy_hwm <- hwm_acc %>% forecast(h=365) %>% accuracy(test)
accuracy_hwm[,c("RMSE","MAE","MAPE","MASE")]

accidentes_ts  %>%  auto.arima() %>% forecast(h=365)  %>% autoplot()

## dm test para comparar el accuracy de 2 forecastings https://www.rdocumentation.org/packages/forecast/versions/8.12/topics/dm.test
dm.test




### FORECASTING CON PROPHET -------------------------------------------------------------

# mirar efectos de añadir días de vacaciones https://facebook.github.io/prophet/docs/seasonality,_holiday_effects,_and_regressors.html
# https://nextjournal.com/eric-brown/forecasting-with-prophet-part-3

accidentes_prophet <- mutate(accidentes_sum_dia, ds = Fecha, y = num_acc)
accidentes_prophet <- column_to_rownames(accidentes_prophet, var = "Fecha")

m <- prophet(accidentes_prophet, growth = "linear", yearly.seasonality = TRUE) 
future <- make_future_dataframe(m, periods = 1060) # Predicción de número de accidentes para los próximos 4 años
forecast <- predict(m, future)
plot(m, forecast) + add_changepoints_to_plot(m) # En 2017 comienza el cambio de tendencia de bajada del número de accidentes diarios

tail(forecast)

prophet_plot_components(m, forecast) # Gráfico de componentes de la serie temporal

dyplot.prophet(m, forecast) # gráfico dinámico


## CROSS VALIDATION PROHPET -----------------------------------------------------------------------------


df.cv <- cross_validation(m, initial = 1095, period = 180, horizon = 365, units = 'days')
df.p <- performance_metrics(df.cv)
head(df.p)
plot_cross_validation_metric(df.cv, metric = 'mae')





## -------------------

accidentes_ts_prophet <- ts(accidentes_sum_dia, start = c(2014,1,1) , frequency = 365)

split_accidentes_prophet <-  ts_split(ts.obj = accidentes_ts_prophet, sample.out=365)
training_prophet <- split_accidentes_prophet$train
test_prophet <- split_accidentes_prophet$test


