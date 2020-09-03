### PREPARACIÓN DE LOS DATOS --------------------------------------------------------------------------------------
### En este código se importan los datos directamente como se descargan desde la web 
### open data del Ayuntamiento de Barcelona. Se realiza exploración y limpieza
### de los datos para prepararlos para usarlos en Tableau y para el forecasting. 
### --------------------------------------------------------------------------------------------------------------


### Librerías requeridas: 
install.packages("tidyverse")
install.packages("data.table")
install.packages("janitor")
install.packages("DataExplorer")
install.packages("lubridate")

library(tidyverse)
library(data.table)
library(janitor)
library(DataExplorer)
library(lubridate)



# Importación de datos desde un archivo en Dropbox:
accidentes_2014 <- read.csv("https://dl.dropbox.com/s/nqzh9yytym8ayvk/2014_ACCIDENTS_GU_BCN_2014.csv?dl=0", header = TRUE, sep = ",", stringsAsFactors = FALSE, fileEncoding="latin1")
accidentes_2015 <- read.csv("https://dl.dropbox.com/s/yoiwbx1e8lb5jzb/2015_accidents_gu_bcn.csv?dl=0", header = TRUE, sep = ";", stringsAsFactors = FALSE, fileEncoding="latin1")
accidentes_2016 <- read.csv("https://dl.dropbox.com/s/mu5toz8vbe5rluv/2016_accidents_gu_bcn.csv?dl=0", header = TRUE, sep = ",", stringsAsFactors = FALSE)
accidentes_2017 <- read.csv("https://dl.dropbox.com/s/jvq2oey5drhx7fv/2017_accidents_gu_bcn.csv?dl=0", header = TRUE, sep = ",", stringsAsFactors = FALSE)
accidentes_2018 <- read.csv("https://dl.dropbox.com/s/i4syy7ccvawkylj/2018_accidents_gu_bcn.csv?dl=0", header = TRUE, sep = ",", stringsAsFactors = FALSE)


----------------------------
# He comprobado que la importación desde Dropbox puede ser un poco inconsistente y dar errores a veces  
# y otras no, en caso de que sucediera se tendrían que descargar desde la carpeta de Datos en GitHub.
# e importarlos cambiando la ruta 
  
### Importación de datasets
accidentes_2014 <- read.csv("2014_ACCIDENTS_GU_BCN_2014.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE, fileEncoding="latin1")
accidentes_2015 <- read.csv("2015_accidents_gu_bcn.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE, fileEncoding="latin1")
accidentes_2016 <- read.csv("2016_accidents_gu_bcn.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
accidentes_2017 <- read.csv("2017_accidents_gu_bcn.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
accidentes_2018 <- read.csv("2018_accidents_gu_bcn.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
----------------------------
  
  
accidentes_2014 <-  as_tibble(accidentes_2014) 
accidentes_2015 <-  as_tibble(accidentes_2015)
accidentes_2016 <-  as_tibble(accidentes_2016)
accidentes_2017 <-  as_tibble(accidentes_2017) 
accidentes_2018 <-  as_tibble(accidentes_2018)

### Se comprueba que los datasets de 2014 y 2015 tienen 2 variables menos ("Latitud" y "Longitud"). 
### Además, tienen nombres de columnas diferentes que los datasets de 2016, 2017 y 2018.
str(accidentes_2015)
str(accidentes_2016)


### Se unen los datasets de 2016, 2017 y 2018. Posteriormente se cambiarán los nombres de las columnas a español. 
### Después se hará lo mismo con los datasets de 2014 y 2015 para finalmente unirlos en un único dataset.
accidentes_16_17_18 <- rbind(accidentes_2016, accidentes_2017, accidentes_2018)

accidentes_16_17_18 <- accidentes_16_17_18 %>% rename(Num_exp=Numero_expedient, Cod_distrito=Codi_districte, Distrito=Nom_districte, Cod_barrio=Codi_barri, Barrio=Nom_barri, Cod_calle=Codi_carrer, Calle=Nom_carrer, 
    Dia_semana=Descripcio_dia_setmana, Dia_semana_reducido=Dia_setmana, Tipo_dia=Descripcio_tipus_dia, Año=Any, Mes=Mes_any, Dia=Dia_mes, Hora=Hora_dia, 
    Momento_dia=Descripcio_torn, Causa_acc=Descripcio_causa_vianant, Num_muertos=Numero_morts, Num_leves=Numero_lesionats_lleus,
    Num_graves=Numero_lesionats_greus, Num_victimas=Numero_victimes, Num_vehiculos_impl=Numero_vehicles_implicats)


### Cambio de nombres a los datasets de 2014 y 2015
accidentes_2014 <- accidentes_2014 %>% 
  rename(
    Num_exp=Número.d.expedient, Cod_distrito=Codi.districte, Distrito=Nom.districte, Cod_barrio=NK.barri, Barrio=Nom.barri, Cod_calle=Codi.carrer, Calle=Nom.carrer, 
    Num_postal=Num.postal.caption, Dia_semana=Descripció.dia.setmana, Dia_semana_reducido=Dia.de.setmana, Tipo_dia=Descripció.tipus.dia, Año=NK.Any, Mes=Mes.de.any, Nom_mes=Nom.mes, 
    Dia=Dia.de.mes, Hora=Hora.de.dia, Momento_dia=Descripció.torn, Causa_acc=Descripció.causa.vianant, Num_muertos=Número.de.morts, Num_leves=Número.de.lesionats.lleus,
    Num_graves=Número.de.lesionats.greus, Num_victimas=Número.de.víctimes, Num_vehiculos_impl=Número.de.vehicles.implicats, Coordenada_UTM_X=Coordenada.UTM..X., Coordenada_UTM_Y=Coordenada.UTM..Y.)

accidentes_2015 <- accidentes_2015 %>% 
  rename(
    Num_exp=Número.d.expedient, Cod_distrito=Codi.districte, Distrito=Nom.districte, Cod_barrio=Codi.barri, Barrio=Nom.barri, Cod_calle=Codi.carrer, Calle=Nom.carrer, 
    Num_postal=Num.postal.caption, Dia_semana=Descripció.dia.setmana, Dia_semana_reducido=Dia.setmana, Tipo_dia=Descripció.tipus.dia, Año=NK.Any, Mes=Mes.de.any, Nom_mes=Nom.mes, 
    Dia=Dia.de.mes, Hora=Hora.de.dia, Momento_dia=Descripció.torn, Causa_acc=Descripció.causa.vianant, Num_muertos=Número.de.morts, Num_leves=Número.de.lesionats.lleus,
    Num_graves=Número.de.lesionats.greus, Num_victimas=Número.de.víctimes, Num_vehiculos_impl=Número.de.vehicles.implicats, Coordenada_UTM_X=Coordenada.UTM..X., Coordenada_UTM_Y=Coordenada.UTM..Y.)



### Ahora ya se pueden unir todos los datasets en un único dataset con todos los accidentes desde 2015 a 2018. 
### Los valores de las columnas Latitud y Longitud se rellenerán con NA's en los datos de 2014 y 2015, para no perder dicha información
### por si fuera útil cuando quiera representar en un mapa los puntos y quiero comparar su uso con respecto a las coordenadas UTMX/Y

accidentes <- plyr::rbind.fill(accidentes_2014, accidentes_2015, accidentes_16_17_18) 
# Plyr presenta incompatibilidades con dplyr, por lo que es mejor realizar esta parte del código así para evitar problemas en el paso previo de unión de datasets


### Traducción de los valores que pueden tomar las variables del catalán al español
accidentes$Dia_semana <- as.factor(accidentes$Dia_semana)
accidentes$Momento_dia <- as.factor(accidentes$Momento_dia)
accidentes$Causa_acc <- as.factor(accidentes$Causa_acc)
accidentes$Dia_semana <- recode(accidentes$Dia_semana, "Dilluns"="Lunes", "Dimarts"="Martes", "Dimecres"="Miércoles", "Dijous"="Jueves", "Divendres"="Viernes", "Dissabte"="Sábado", "Diumenge"="Domingo")  
accidentes$Momento_dia <- recode(accidentes$Momento_dia, "Matí"="Mañana", "Tarda"="Tarde", "Nit"="Noche")
accidentes$Causa_acc <- recode(accidentes$Causa_acc, "No és causa del  vianant"="No es debido al peatón", "Creuar per fora pas de vianants"="Cruzar fuera del paso de peatones", "Transitar a peu per la calçada"="Caminar por la calzada", "Desobeir el senyal del semàfor"="Desobedecer la señal del semáforo", "Altres"="Otros", "Desobeir altres senyals"="Desobedecer otras señales")
accidentes$Distrito <- recode(accidentes$Distrito, "Desconegut"="Desconocido")
accidentes$Barrio <- recode(accidentes$Barrio, "Desconegut"="Desconocido")



# BÚSQUEDA DE MISSING VALUES Y DUPLICADOS -------------------------------------------------------------------------------------------------

### Comprobamos si hay duplicados mirando el número de expediente de cada accidente. Si el número se repite, 
### quiere decir que un mismo accidente se ha introducido en la base de datos en más de una ocasión, por lo que 
### saldrá una cifra inferior al número de observaciones de cada dataset. 


# En el dataset de 2014 todos los valores son únicos
length(unique(accidentes_2014$Num_exp))

# En el dataset de 2015 todos los valores son únicos
length(unique(accidentes_2015$Num_exp))

# En el dataset de 2016 todos los valores son únicos
length(unique(accidentes_2016$Numero_expedient))

# En el dataset de 2017 tenemos 4 duplicados
length(unique(accidentes_2017$Numero_expedient))

# En el dataset de 2018 tenemos 10 duplicados
length(unique(accidentes_2018$Numero_expedient))



# En el dataset de 2017 nos vamos a quedar con los valores que indican una causa para el accidente
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
rm("accidentes_2014","accidentes_2015","accidentes_2016","accidentes_2017","accidentes_2018","accidentes_2018_dupl","accidentes_2017_dupl","accidentes_16_17_18")

# Como los datos relacionados con la fecha y hora están en columnas separadas, vamos a unificarlos en una única columna y pasarlos a formato date.
accidentes <- accidentes %>% 
  mutate(Fecha = paste(accidentes$Año, accidentes$Mes, accidentes$Dia, sep="-"))
accidentes$Fecha <-  as.Date(accidentes$Fecha,"%Y-%m-%d")
 

# Exportación final del dataset de Accidentes para trabajar con él en Tableau y en el forecasting:
write_csv2(accidentes, file("accidentes_barcelona.csv"))








