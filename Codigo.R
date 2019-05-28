### Trabajo Final de Máster
### Emiliano Muñoz Torres

### Librerías requeridas: ---------------

install.packages("tidyverse")
install.packages("data.table")
install.packages("janitor")
install.packages("DataExplorer")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("shiny")
install.packages("forecast")
install.packages("prophet")

library(tidyverse)
library(data.table)
library(janitor)
library(DataExplorer)
library(lubridate)
library(ggplot2)
library(shiny)
library(forecast)
library(prophet)

### Importación de datos: ---------------

accidentes_2016 <- fread("/Users/emi/Documents/Data_Science/K_School/TFM/Accidentes/2016_accidents_gu_bcn.csv")
accidentes_2017 <- fread("/Users/emi/Documents/Data_Science/K_School/TFM/Accidentes/2017_accidents_gu_bcn.csv")
accidentes_2018 <- fread("/Users/emi/Documents/Data_Science/K_School/TFM/Accidentes/2018_accidents_gu_bcn.csv") 

# Transformación a Tibble

accidentes_2016 <-  as_tibble(accidentes_2016)
accidentes_2017 <-  as_tibble(accidentes_2017) 
accidentes_2018 <-  as_tibble(accidentes_2018) 

# Unir DataFrames
# Como el valor de la primera columna es el identificador de cada caso de accidente, podremos unificar los 3 DataFrames en un 
# único DF:
accidentes <- rbind(accidentes_2016, accidentes_2017, accidentes_2018)

### Borrado de columnas innecesarias:
# Hay algunas columnas que no van a ser necesarias para el estudio, 
# por lo que lo mejor es deshacerse de ellas cuanto antes.
accidentes <- accidentes %>% select(-c(Codi_districte, Codi_barri, Codi_carrer, Dia_setmana, Nom_mes, Descripcio_tipus_dia))


### Traducción de los valores al español: ------------------------------------------------------------------------------------------

# Antes de comenzar a trabajar sobre los duplicados vamos a traducir al español los valores
# para tener una mejor comprensión del DataSet, ya que está todo en catalán.
str(accidentes)

# Renombrar columnas de "accidentes":
accidentes <- accidentes %>% 
  rename(
    Num_exp=Numero_expedient, Distrito=Nom_districte, Barrio=Nom_barri, Calle=Nom_carrer, Cod_postal=Num_postal, 
    Dia_semana=Descripcio_dia_setmana, Año=Any, Mes=Mes_any, Dia=Dia_mes, Hora=Hora_dia, 
    Momento_dia=Descripcio_torn, Causa_acc=Descripcio_causa_vianant, Num_muertos=Numero_morts, Num_les_leves=Numero_lesionats_lleus,
    Num_les_graves=Numero_lesionats_greus, Num_victimas=Numero_victimes, Num_vehiculos_impl=Numero_vehicles_implicats)

# Ahora vamos a traducir los valores que pueden tomar las variables del catalán al español. Por ejemplo, en vez de indicar en la 
# columna Dia_semana 'Dimecres' que muestre 'Miercoles'.

# Renombrar valores de "accidentes":
accidentes$Dia_semana <- as.factor(accidentes$Dia_semana)
accidentes$Momento_dia <- as.factor(accidentes$Momento_dia)
accidentes$Causa_acc <- as.factor(accidentes$Causa_acc)
accidentes$Dia_semana <- recode(accidentes$Dia_semana, "Dilluns"="Lunes", "Dimarts"="Martes", "Dimecres"="Miércoles", "Dijous"="Jueves", "Divendres"="Viernes", "Dissabte"="Sábado", "Diumenge"="Domingo")  
accidentes$Momento_dia <- recode(accidentes$Momento_dia, "Matí"="Mañana", "Tarda"="Tarde", "Nit"="Noche")
accidentes$Causa_acc <- recode(accidentes$Causa_acc, "No és causa del  vianant"="No es debido al peatón", "Creuar per fora pas de vianants"="Cruzar fuera del paso de peatones", "Transitar a peu per la calçada"="Caminar por la calzada", "Desobeir el senyal del semàfor"="Desobedecer la señal del semáforo", "Altres"="Otros", "Desobeir altres senyals"="Desobedecer otras señales")
accidentes$Distrito <- recode(accidentes$Distrito, "Desconegut"="Desconocido")
accidentes$Barrio <- recode(accidentes$Barrio, "Desconegut"="Desconocido")

### Comprobación de missing values: ----------

# Sorprendentemente no tenemos missing values, los policías de Barcelona 
# hacen muy bien su trabajo a la hora de rellenar la información de accidentes.
plot_missing(accidentes)

### Comprobación de duplicados: --------------
# En el DataSet de 2016 todos los valores son únicos
length(unique(accidentes_2016$Numero_expedient))

# En el DataSet de 2017 tenemos 4 duplicados
length(unique(accidentes_2017$Numero_expedient))

# En el DataSet de 2018 tenemos 10 duplicados
length(unique(accidentes_2018$Numero_expedient))

# En el DataSet de 2017 nos vamos a quedar con los valores que indican una causa para el accidente
# Comprobamos valores duplicados:
accidentes$Num_exp[duplicated(accidentes$Num_exp)]
accidentes_2017_dupl <- accidentes %>% 
  filter(Num_exp %in% c(accidentes$Num_exp[duplicated(accidentes$Num_exp)])) %>% 
  arrange(Num_exp)
# Nos quedamos con los que ofrecen información más detallada:
accidentes <- accidentes[!(accidentes$Num_exp=="2017S003750" & accidentes$Causa_acc=="Otros"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2017S008856" & accidentes$Causa_acc=="Otros"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2017S003286" & accidentes$Causa_acc=="Cruzar fuera del paso de peatones"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2017S004447" & accidentes$Causa_acc=="Cruzar fuera del paso de peatones"),]


# Ahora haremos lo mismo para los datos de 2018:
accidentes$Num_exp[duplicated(accidentes$Num_exp)]
accidentes_2018_dupl <- accidentes %>% 
  filter(Num_exp %in% c(accidentes$Num_exp[duplicated(accidentes$Num_exp)])) %>% 
  arrange(Num_exp)
accidentes <- accidentes[!(accidentes$Num_exp=="2018S000183" & accidentes$Causa_acc=="Otros"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2018S000261" & accidentes$Causa_acc=="Otros"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2018S001500" & accidentes$Causa_acc=="Otros"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2018S001774" & accidentes$Causa_acc=="Desobedecer la señal del semáforo"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2018S002285" & accidentes$Causa_acc=="Cruzar fuera del paso de peatones"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2018S002344" & accidentes$Causa_acc=="Desobedecer la señal del semáforo"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2018S002968" & accidentes$Causa_acc=="Cruzar fuera del paso de peatones"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2018S003156" & accidentes$Causa_acc=="Otros"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2018S005992" & accidentes$Causa_acc=="Cruzar fuera del paso de peatones"),]
accidentes <- accidentes[!(accidentes$Num_exp=="2018S009504" & accidentes$Causa_acc=="Otros"),]

# Eliminamos los DataFrames que no vamos a utilizar más:
rm("accidentes_2016","accidentes_2017","accidentes_2018","accidentes_2018_dupl","accidentes_2017_dupl")

# Exportar CSV para trabajar con los datos en Tableau:
write_csv2(accidentes, file("accidentes_barcelona.csv"))




###### SHINY --------------------------------

ui <- fluidPage()

server <-  function(input, output) {}

shinyApp(ui - ui, server - server)





### Creación de la columna fecha y hora, 
# Como los datos relacionados con la fecha y hora están en columnas separadas, vamos a unificarlos en una única columna y pasarlos a formato date.
accidentes_con_fecha <- accidentes %>% 
  mutate(Fecha = paste(accidentes$Año, accidentes$Mes, accidentes$Dia, sep="-"))
accidentes_con_fecha$Fecha <-  as.Date(accidentes_con_fecha$Fecha,"%Y-%m-%d")


str(accidentes_con_fecha)
View(accidentes_con_fecha)

# Creamos una columna con el valor 1 para realizar después un sumatorio de accidentes por día.
accidentes_con_fecha <- accidentes_con_fecha %>% 
  arrange(accidentes_con_fecha$Fecha) %>% 
  mutate(num_acc = 1)

View(accidentes_con_fecha)

# Este será el DataFrame con el que realizaremos el Forecasting, ya que tiene únicamente 2 columnas con la cifra de accidentes por día.
accidentes_por_dia <- accidentes_con_fecha %>% 
  group_by(Fecha) %>% 
  summarize(num_acc = sum(num_acc))

View(accidentes_por_dia)


## Forecasting con Prophet: ----------------------------------------
accidentes_por_dia_2 <- mutate(accidentes_por_dia, ds = Fecha, y = num_acc)
accidentes_por_dia_2 <- column_to_rownames(accidentes_por_dia_2, var = "Fecha")

# Create ggplot object 
g <- ggplot(data = accidentes_por_dia, aes(x = accidentes_por_dia$Fecha, y = accidentes_por_dia$num_acc)) +
  geom_line(color='#334f8d') + 
  scale_y_continuous(name = 'Accidentes al día', labels = c("0", "5", "10", "15", "20","25","30","35", "40","45","50","55","60"), 
                     breaks=c(0,5,10,15,20,25,30,35,40,45,50,55,60)) + 
  geom_vline(aes(xintercept=as.numeric(as.Date("2017-01-01"))), color='#334f8d', linetype="dashed") +
  geom_vline(aes(xintercept=as.numeric(as.Date("2018-01-01"))), color='#334f8d', linetype="dashed") +
  scale_x_date(date_labels = "%b %Y", date_breaks = "4 months") + 
  theme_bw() 

# Plot 
g + theme(panel.border = element_blank(),
          axis.ticks = element_blank(),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.title.x=element_blank())



lam = BoxCox.lambda(accidentes_por_dia_2$num_acc, method = "loglik")
accidentes_por_dia_2$y = BoxCox(accidentes_por_dia_2$num_acc, lam)
accidentes_por_dia_2.m <- melt(accidentes_por_dia_2, measure.vars=c("num_acc","y"))


str(accidentes_por_dia_2)







vnames <-list(
  'value' = 'Untransformed',
  'y' = 'Box-Cox Transformed')

vlabeller <- function(variable,value){
  return(vnames[value])
}

options(repr.plot.width=7, repr.plot.height=4) # set plot size

g1 <- ggplot(accidentes_por_dia_2.m, aes(x=ds, y=value, group=variable)) + 
  geom_line(color='#334f8d') + 
  facet_wrap(~ variable, nrow=2, labeller =  vlabeller,scales="free_y") + #using scales="free_y" allows the y-axis to vary while keeping x-axis constant among plots+
  scale_x_date(date_labels = "%b %Y", date_breaks = "5 months") +
  theme_bw()

#Plot
g1 + theme(panel.border = element_blank(),
           axis.ticks = element_blank(),
           panel.grid.major = element_blank(), 
           panel.grid.minor = element_blank(),
           axis.title.x=element_blank(),
           axis.title.y=element_blank(),
           strip.background = element_blank())  







### Forecasting

m <- prophet(accidentes_por_dia_2)
future <- make_future_dataframe(m, periods = 365)
forecast <- predict(m, future)
tail(forecast)
plot(m, forecast)

prophet_plot_components(m, forecast)





# Invertir transformación BoxCox
inverse_forecast <- forecast
inverse_forecast <- column_to_rownames(inverse_forecast, var = "ds")
inverse_forecast$yhat_untransformed = InvBoxCox(forecast$yhat, lam)



indx <- inverse_forecast$yhat_untransformed[rownames(inverse_forecast) > max(rownames(df))]
date <- forecast$ds[forecast$ds > max(rownames(df))]

f <- data.frame(date, indx)
head(f)









#Create ggplot object
g <- ggplot() + 
  geom_line(data=accidentes_por_dia_2, aes(x=ds, y= num_acc), color='#334f8d') +
  geom_line(data=f, aes(x=date, y= indx), color='#334f8d', alpha=0.3) + 
  scale_y_continuous(name = 'Orders', labels = c("0", "100,000", "200,000", "300,000", "400,000","500,000","600,000","700,000", "800,000"), 
                     breaks=c(0,100000,200000,300000,400000,500000,600000,700000, 800000)) + 
  scale_x_date(date_labels = "%b %Y", date_breaks = "5 months" ) +
  theme_bw()  

#Plot
g + theme(panel.border = element_blank(),
          axis.ticks = element_blank(),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.title.x=element_blank())








accidentes_ymas <- accidentes %>% group_by(month=floor_date(date, "month")) %>%
  summarize(num_acc=sum(num_acc))



