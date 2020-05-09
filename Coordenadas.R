install.packages("rgdal")

library(tidyverse)
library(data.table)
library(rgdal)

accidentes<- read.csv("/Users/emi/Documents/Documentos/Data_Science/K_School/TFM/TFM_v3/accidentes_barcelona.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)
coords <-  select(accidentes, Coordenada_UTM_X, Coordenada_UTM_Y)
write_csv2(coords, file("coords.csv"))

#### ---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Las coordenadas UTM se importan como characters, para poderlas convertir en tipo numeric había que sustituir la "," por un ".", estuve probando diferentes
# formas que encontré pero ninguna conseguiía darme un resultado óptimo, por lo que al final por desesperación he acabado recurriendo a hacer los cambios directamente
# desde el Bloc de notas de Windows. 

X <- tail(coordX, -2) #Se eliminan las 2 primeras filas que tienen valor "-1" 
X[] <- lapply(X, function(x) as.numeric(gsub(",", ".", x))) 
X[is.na(X)] <- 0

parse_double(coordsX, locale = locale(decimal_mark = ","))

coords2 <- transform(coords, Coordenada_UTM_X= as.numeric(sub(",", ".", Coordenada_UTM_X, fixed = TRUE)))
#### ---------------------------------------------------------------------------------------------------------------------------------------------------------------


coords_good<- read.csv2("/Users/emi/Documents/Documentos/Data_Science/K_School/TFM/TFM_v3/coords.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)


utms <- SpatialPoints(coords[, c("Coordenada_UTM_X", "Coordenada_UTM_Y")], proj4string=CRS("+proj=utm +zone=31"))                   

longlats <- spTransform(coords, CRS("+proj=longlat”)) 

