### Trabajo Final de Máster
### Emiliano Muñoz Torres

### Librerías requeridas: ---------------

install.packages("tidyverse")
install.packages("data.table")
install.packages("janitor")
install.packages("DataExplorer")


library(dplyr)
library(data.table)
library(janitor)
library(DataExplorer)

### Importación de datos: ---------------

accidentes_2016 <- fread("/Users/emi/Documents/Data_Science/K_School/TFM/Accidentes/2016_accidents_gu_bcn.csv")
accidentes_2017 <- fread("/Users/emi/Documents/Data_Science/K_School/TFM/Accidentes/2017_accidents_gu_bcn.csv")
accidentes_2018 <- fread("/Users/emi/Documents/Data_Science/K_School/TFM/Accidentes/2018_accidents_gu_bcn.csv") 

# Transformación a Tibble

accidentes_2016 <-  as_tibble(accidentes_2016)
accidentes_2017 <-  as_tibble(accidentes_2017) 
accidentes_2018 <-  as_tibble(accidentes_2018) 

### Borrado de columnas innecesarias:------------

# Hay algunas columnas que no van a ser necesarias para el estudio, 
# por lo que lo mejor es deshacerse de ellas cuanto antes.

accidentes_2016 <- accidentes_2016 %>% select(-c(Codi_districte, Codi_barri, Codi_carrer, Dia_setmana, Nom_mes))
accidentes_2017 <- accidentes_2017 %>% select(-c(Codi_districte, Codi_barri, Codi_carrer, Dia_setmana, Nom_mes))
accidentes_2018 <- accidentes_2018 %>% select(-c(Codi_districte, Codi_barri, Codi_carrer, Dia_setmana, Nom_mes))

### Traducción de los valores al español: ------------------------------------------------------------------------------------------

# Antes de comenzar a trabajar sobre los duplicados vamos a traducir al español los valores
# para tener una mejor comprensión del DataSet, ya que está todo en catalán.
str(accidentes_2016)

# Renombrar columnas de "accidentes_2016":
accidentes_2016 <- accidentes_2016 %>% 
  rename(
    Num_exp=Numero_expedient, Distrito=Nom_districte, Barrio=Nom_barri, Calle=Nom_carrer, Cod_postal=Num_postal, 
    Dia_semana=Descripcio_dia_setmana,  Dia_tipo=Descripcio_tipus_dia, Año=Any, Mes=Mes_any, Dia=Dia_mes, Hora=Hora_dia, 
    Momento_dia=Descripcio_torn, Causa_acc=Descripcio_causa_vianant, Num_muertos=Numero_morts, Num_les_leves=Numero_lesionats_lleus,
    Num_les_graves=Numero_lesionats_greus, Num_victimas=Numero_victimes, Num_vehiculos_impl=Numero_vehicles_implicats)

# Renombrar columnas de "accidentes_2017":
accidentes_2017 <- accidentes_2017 %>% 
  rename(
    Num_exp=Numero_expedient, Distrito=Nom_districte, Barrio=Nom_barri, Calle=Nom_carrer, Cod_postal=Num_postal, 
    Dia_semana=Descripcio_dia_setmana,  Dia_tipo=Descripcio_tipus_dia, Año=Any, Mes=Mes_any, Dia=Dia_mes, Hora=Hora_dia, 
    Momento_dia=Descripcio_torn, Causa_acc=Descripcio_causa_vianant, Num_muertos=Numero_morts, Num_les_leves=Numero_lesionats_lleus,
    Num_les_graves=Numero_lesionats_greus, Num_victimas=Numero_victimes, Num_vehiculos_impl=Numero_vehicles_implicats)

# Renombrar columnas de "accidentes_2018":
accidentes_2018 <- accidentes_2018 %>% 
  rename(
    Num_exp=Numero_expedient, Distrito=Nom_districte, Barrio=Nom_barri, Calle=Nom_carrer, Cod_postal=Num_postal, 
    Dia_semana=Descripcio_dia_setmana,  Dia_tipo=Descripcio_tipus_dia, Año=Any, Mes=Mes_any, Dia=Dia_mes, Hora=Hora_dia, 
    Momento_dia=Descripcio_torn, Causa_acc=Descripcio_causa_vianant, Num_muertos=Numero_morts, Num_les_leves=Numero_lesionats_lleus,
    Num_les_graves=Numero_lesionats_greus, Num_victimas=Numero_victimes, Num_vehiculos_impl=Numero_vehicles_implicats)


# Ahora vamos a traducir los valores que pueden tomar las variables del catalán al español. Por ejemplo, en vez de indicar en la 
# columna Dia_semana 'Dimecres' que muestre 'Miercoles'.

# Renombrar valores de "accidentes_2016":


### Comprobación de missing values: ----------

# Sorprendentemente no tenemos missing values, los policías de Barcelona 
# hacen muy bien su trabajo a la hora de rellenar la información de accidentes.
plot_missing(accidentes_2016)
plot_missing(accidentes_2017)
plot_missing(accidentes_2018)





### Comprobación de duplicados: --------------

# En el DataSet de 2016 todos los valores son únicos
length(unique(accidentes_2016$Numero_expedient))

# En el DataSet de 2017 tenemos 4 duplicados
length(unique(accidentes_2017$Numero_expedient))

# En el DataSet de 2018 tenemos 10 duplicados
length(unique(accidentes_2018$Numero_expedient))


accidentes_2017$Numero_expedient[duplicated(accidentes_2017$Numero_expedient)]
accidentes_2017 %>% 
  filter(Numero_expedient %in% c(accidentes_2017$Numero_expedient[duplicated(accidentes_2017$Numero_expedient)])) %>% 
  arrange(Numero_expedient)



accidentes_2017 %>% 
  filter(Descripcio_causa_vianant == "Altres")
  
  #"2017S003286","2017S008856", == , Numero_expedient == "2017S008856", Numero_expedient == "2017S003750", Numero_expedient == "2017S004447")

accidentes_2017[duplicated(accidentes_2017$Numero_expedient)]


### Traducción de los valores al español:

# Vemos que hay nombres de columnas y valores que están en catalán,
# habrá que traducirlos para tener una mejor comprensión de los mismos.
str(accidentes_2016)






datos2 <- fread('/Users/emi/Documents/Data_Science/K_School/TFM/Accidentes/2018_accidents_gu_bcn.csv', header=TRUE)

head(datos2)

View(datos2)

dat3 <- datos2 %>% filter(Numero_expedient == "2018S000001")
View(dat3)

unique(datos2)

describe(datos2)

dupli <-  fread('/Users/emi/Documents/Data_Science/K_School/TFM/Personas_involucradas/2016_accidents_persones_gu_bcn.csv')
head(dupli)
dat3 <- datos2 %>% filter(Numero_expedient == "2018S002285")
View(dat3)

datos2 %>% 
  order_by(Numero_expedient)

summary(datos2)

length(unique(datos2$Descripcio_causa_vianant))
datos2[duplicated(datos2$Numero_expedient)]
