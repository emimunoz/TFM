### CONVERSIÓN DE COORDENADAS --------------------------------------------------------------------------------------
### Para poder trabajar con los datos de coordenadas en Tableau, es necesario transformar las coordenadas que están 
### en formato UTM a formato de latitud/longitud, pero los datos del dataframe de accidentes están como
### characters y con comas para los decimales, por lo necesitan un tratamiento previo en R Studio.
### --------------------------------------------------------------------------------------------------------------


install.packages("rgdal")
install.packages("sp")

library(tidyverse)
library(rgdal)
library(sp)


# Resulta imposible importar directamente desde Dropbox el CSV con todos los accidentes de 2014 a 2018, ya que R Studio da error y cierra la sesión.
# Dejaré el código para su importación desde Dropbox por si fuera un error particular de mi ordenador, en caso contrario, es posible descargarse los datos
# desde este link (importar el archivo llamado "accidentes_barcelona.csv"): https://www.dropbox.com/sh/wvzucdfnn5gihir/AAACX7QqEc7AGPbDlyA4upkCa?dl=0 

accidentes<- read.csv("https://dl.dropbox.com/s/5xzjuw2doii5dqg/accidentes_barcelona.csv?dl=0", header = TRUE, sep = ";", stringsAsFactors = FALSE)

# Se seleccionan las columnas que interesan del dataset:
coords <-  select(accidentes, Coordenada_UTM_X, Coordenada_UTM_Y)




#### ---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Las coordenadas UTM se importan como characters, para poderlas convertir en tipo numeric había que sustituir la "," por un ".", estuve probando diferentes
# formas que encontré pero ninguna conseguiía darme un resultado óptimo, por lo que al final por desesperación he acabado recurriendo a hacer los cambios directamente
# desde el Bloc de notas de Windows. He dejado sólo una parte del código de algunos métodos que he intentado sin éxito. 

X <- tail(coords, -2) # Se eliminan las 2 primeras filas que tienen valor "-1" 
X[] <- lapply(X, function(x) as.numeric(gsub(",", ".", x))) 
X[is.na(X)] <- 0

parse_double(coords, locale = locale(decimal_mark = ","))

coords2 <- transform(coords, Coordenada_UTM_X= as.numeric(gsub(",", ".", Coordenada_UTM_X, fixed = TRUE)))
#### ---------------------------------------------------------------------------------------------------------------------------------------------------------------


options(digits = 9) # Para mostrar correctamente todos los decimales de las coordenadas UTM



# Se importa el dataset corregido usando el Bloc de notas de Windows, sé que no es muy profesional, 
# pero ha resultado ser el método más efectivo para conseguir esa sencilla tarea sin que diera errores a posteriori.
# Este archivo no se puede importar directamente desde Dropbox ya que da error al importarlo con read.csv2.

coords<- read.csv2("/Users/emi/Documents/Documentos/Data_Science/K_School/TFM/TFM_v3/coordenadas.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)
coords <- as.data.frame(sapply(coords, as.numeric))



# Se elimina la fila con NAs ya que al tratarse de 50102 datos de  coordenadas de accidentes, eliminar un valor no será representativo para el resultado final y 
# tampoco tendría sentido sustituir dichos NAs por un valor medio de las coordenadas.
sapply(coords, function(x) sum(is.na(x))) # Se detecta que hay una fila que tiene valor NA
coords <- coords %>% drop_na()



# Para poder pasar las coordenadas UTM a latitud/longitud primero será necesario transformar la lista con las 
# coordenadas a un objeto tipo SpatialPoints y después con spTransform obtenemos las coordenadas en lat/long:
typeof(coords)
SP_UTM<- SpatialPoints(coords, proj4string=CRS("+proj=utm +zone=31 +datum=WGS84"))  
SP_LatLong <- spTransform(SP_UTM, CRS("+proj=longlat +datum=WGS84"))
head(SP_LatLong)
str(SP_LatLong)



# Convertimos el objeto SpatialPoints a un DataFrame para después exportarlo en CSV y poder trabajar en Tableau:
SP_LatLong <- as.data.frame(SP_LatLong)
SP_LatLong <-  SP_LatLong %>% rename(Norte=Coordenada_UTM_X, Este=Coordenada_UTM_Y)
head(SP_LatLong) # Comprobamos que está todo correcto



# Exportación del CSV para importarlo en Tableau:
write_csv2(SP_LatLong, file("coord_latlong.csv"))
