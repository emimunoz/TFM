### TRABAJO FINAL DE MÁSTER
### Emiliano Muñoz Torres
### Preparación y limpieza de datos

### Librerías requeridas: ---------------

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

# Importación de datos:

accidentes_2016 <- read.csv("https://dl.dropbox.com/s/mu5toz8vbe5rluv/2016_accidents_gu_bcn.csv?dl=0", header = TRUE, sep = ",", stringsAsFactors = FALSE)
accidentes_2017 <- read.csv("https://dl.dropbox.com/s/jvq2oey5drhx7fv/2017_accidents_gu_bcn.csv?dl=0", header = TRUE, sep = ",", stringsAsFactors = FALSE)
accidentes_2018 <- read.csv("https://dl.dropbox.com/s/i4syy7ccvawkylj/2018_accidents_gu_bcn.csv?dl=0", header = TRUE, sep = ",", stringsAsFactors = FALSE)

# Transformación a Tibble:
accidentes_2016 <-  as_tibble(accidentes_2016)
accidentes_2017 <-  as_tibble(accidentes_2017) 
accidentes_2018 <-  as_tibble(accidentes_2018) 

# Unir DataFrames
# Como el valor de la primera columna es el identificador de cada caso de accidente, podremos unificar los 3 DataFrames en un 
# único DF:
accidentes <- rbind(accidentes_2016, accidentes_2017, accidentes_2018)

# Borrado de columnas innecesarias:
# Hay algunas columnas que no van a ser necesarias para el estudio, 
# por lo que lo mejor es deshacerse de ellas cuanto antes.
accidentes <- accidentes %>% select(-c(Codi_districte, Codi_barri, Codi_carrer, Dia_setmana, Nom_mes, Descripcio_tipus_dia, Coordenada_UTM_X, Coordenada_UTM_Y, Longitud, Latitud, Num_postal))


### Traducción de los valores al español: ------------------------------------------------------------------------------------------

# Antes de comenzar a trabajar sobre los duplicados vamos a traducir al español los valores
# para tener una mejor comprensión del DataSet, ya que está todo en catalán.
str(accidentes)

# Renombrar columnas de "accidentes":
accidentes <- accidentes %>% 
  rename(
    Num_exp=Numero_expedient, Distrito=Nom_districte, Barrio=Nom_barri, Calle=Nom_carrer, 
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


### Creación de la columna fecha y hora, 
# Como los datos relacionados con la fecha y hora están en columnas separadas, vamos a unificarlos en una única columna y pasarlos a formato date.
accidentes <- accidentes %>% 
  mutate(Fecha = paste(accidentes$Año, accidentes$Mes, accidentes$Dia, sep="-"))
accidentes$Fecha <-  as.Date(accidentes$Fecha,"%Y-%m-%d")


# Exportar CSV para trabajar con los datos en Tableau y realizar el Forecasting:
write_csv2(accidentes, file("accidentes_barcelona.csv"))
