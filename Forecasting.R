### TRABAJO FINAL DE MÁSTER
### Emiliano Muñoz Torres
### Forecasting con Prophet

### Librerías requeridas: ---------------

install.packages("tidyverse")
install.packages("data.table")
install.packages("forecast")
install.packages("prophet")

library(tidyverse)
library(data.table)
library(forecast)
library(prophet)

### Importación de datos: ---------------

accidentes <- fread("/Users/emi/Documents/Data_Science/K_School/TFM/accidentes_barcelona.csv") 

# Creamos una columna con el valor 1 para realizar después un sumatorio de accidentes por día.
accidentes <- accidentes %>% 
  arrange(accidentes$Fecha) %>% 
  mutate(num_acc = 1)

View(accidentes)

# Este será el DataFrame con el que realizaremos el Forecasting, ya que tiene únicamente 2 columnas con la cifra de accidentes por día.
accidentes_por_dia <- accidentes %>% 
  group_by(Fecha) %>% 
  summarize(num_acc = sum(num_acc))

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


