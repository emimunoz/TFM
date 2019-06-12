### TRABAJO FINAL DE MÁSTER
### Emiliano Muñoz Torres
### Forecasting con Prophet

### Librerías requeridas: 
install.packages("tidyverse")
install.packages("data.table")
install.packages("forecast")
install.packages("prophet")

library(tidyverse)
library(data.table)
library(forecast)
library(prophet)

##Importación de datos: 
accidentes <- read.csv("https://dl.dropbox.com/s/n9l6tl5i01h6lle/accidentes_barcelona.csv?dl=0", header = TRUE, sep = ";", stringsAsFactors = FALSE)

# Al importar se ha perdido la clase fecha para la columna Fecha.
accidentes$Fecha <- as.Date(accidentes$Fecha)

# Creamos una columna con el valor 1 para realizar después un sumatorio de accidentes por día.
accidentes <- accidentes %>% 
  arrange(accidentes$Fecha) %>% 
  mutate(num_acc = 1)

# Este será el DataFrame con el que realizaremos el Forecasting, ya que tiene únicamente 2 columnas con la fecha y cifra de accidentes por día.
accidentes_dia <- accidentes %>% 
  group_by(Fecha) %>% 
  summarize(num_acc = sum(num_acc))

### FORECASTING CON PROPHET ----------------------------------------------------------------------------------------------------------------------------
accidentes_dia_prophet <- mutate(accidentes_dia, ds = Fecha, y = num_acc)
accidentes_dia_prophet <- column_to_rownames(accidentes_dia_prophet, var = "Fecha")

# Visualización de la serie temporal con datos diarios de accidentes: 
g <- ggplot(data = accidentes_dia, aes(x = accidentes_dia$Fecha, y = accidentes_dia$num_acc)) + geom_line(color='#334f8d') + 
  scale_y_continuous(name = 'Accidentes al día', labels = c("0", "5", "10", "15", "20","25","30","35", "40","45","50","55","60"), breaks=c(0,5,10,15,20,25,30,35,40,45,50,55,60)) + 
  geom_vline(aes(xintercept=as.numeric(as.Date("2017-01-01"))), color='#334f8d', linetype="dashed") +
  geom_vline(aes(xintercept=as.numeric(as.Date("2018-01-01"))), color='#334f8d', linetype="dashed") +
  scale_x_date(date_labels = "%b %Y", date_breaks = "4 months") + 
  theme_bw() 

g + theme(panel.border = element_blank(), axis.ticks = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.title.x=element_blank())


### Forecasting
m <- prophet(accidentes_dia_prophet)
future <- make_future_dataframe(m, periods = 365)
forecast <- predict(m, future)
tail(forecast)
plot(m, forecast)

prophet_plot_components(m, forecast)














