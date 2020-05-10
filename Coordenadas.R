#### CONVERSIÓN DE COORDENDAS -------------------------------------------------------------------------------------------------------------------------------------
# Para poder trabajar con los datos de coordenadas en Tableau, es necesario transformar las coordenadas que están en formato UTM a formato de latitud/longitud, pero
# los datos del dataframe de accidentes están como characters y con comas para los decimales.

install.packages("rgdal")
install.packages("sp")

library(tidyverse)
library(rgdal)
library(sp)

accidentes<- read.csv("/Users/emi/Documents/Documentos/Data_Science/K_School/TFM/TFM_v3/accidentes_barcelona.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)
coords <-  select(accidentes, Coordenada_UTM_X, Coordenada_UTM_Y)
write_csv2(coords, file("coordenadas.csv"))


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

coords<- read.csv2("/Users/emi/Documents/Documentos/Data_Science/K_School/TFM/TFM_v3/coordenadas.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)
coords <- as.data.frame(sapply(coords, as.numeric))


# Se elimina la fila con NAs ya que al tratarse de 50102 datos de  coordenadas de accidentes, eliminar un valor no será representativo para el resultado final y 
# tampoco tendría sentido sustituir dichos NAs por un valor medio de las coordenadas.
sapply(coords, function(x) sum(is.na(x))) # Se detecta que hay una fila que tiene valor NA
coords <- coords %>% drop_na()


# Para poder pasar las coordenadas UTM a latitud/longitud primero será necesario transformar la lista con las coordenadas a un objeto tipo SpatialPoints
# y después con spTransform obtenemos las coordenadas en lat/long:
typeof(coords)
SP_UTM<- SpatialPoints(coords, proj4string=CRS("+proj=utm +zone=31 +datum=WGS84"))  
SP_LatLong <- spTransform(SP_UTM, CRS("+proj=longlat +datum=WGS84"))
head(SP_LatLong)
str(SP_LatLong)

# Convertimos el objeto SpatialPoints a un DataFrame para después exportarlo en CSV y poder trabajar en Tableau:
SP_LatLong <- as.data.frame(SP_LatLong)
SP_LatLong <-  SP_LatLong %>% rename(Norte=Coordenada_UTM_X, Este=Coordenada_UTM_Y)
head(SP_LatLong) # Todo correcto

write_csv2(SP_LatLong, file("coord_latlong.csv"))
