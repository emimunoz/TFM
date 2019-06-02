# TFM
# Predicción de accidentes en la ciudad de Barcelona
# Emiliano Muñoz Torres
## La idea
La idea inicial y que me habría gustado desarrollar consistía en un estudio sobre la asistencia a las urgencias de diversos hospitales, para encontrar la más que sabida relación entre la saturación de las urgencias en fechas que no coinciden con festivos o eventos deportivos relevantes. Después de ponerme en contacto con el INE y el Ministerio de Sanidad me fue imposible conseguir los datos para dicho estudio, y ante la proximidad de la fecha límite para entregar el Trabajo Final de Máster, me decidí por realizar una versión alternativa de dicho estudio pero con datos de accidentes en la ciudad de Barcelona. 

Al igual que con la idea previa de los hospitales, quería haber cruzado datos de clima o de festivos para encontrar las relaciones que existen entre el número de accidentes y estas variables. Por falta de tiempo no he podido meterlas en el estudio. Me gustaría más adelante, ya una vez haya finalizado todo el Máster, continuar con este estudio e ir metiendo más datos y variables. 

Lo he realizado todo en lenguaje R ya que ha sido el lenguaje con el que más cómodo me he sentido a la hora de trabajar durante todo el Máster. Además, de las ventajas que ofrece R Studio a la hora de comodidad para realizar un proyecto de análisis y modificación de datos. Me habría gustado en un principio realizar una parte en Python y otra en R, pero lo dejaré para más adelante a modo de reto personal. 

## Desarrollo
Los [datos](https://opendata-ajuntament.barcelona.cat/data/es/dataset/accidents-gu-bcn) los he descargado desde la web [Open Data BCN](https://opendata-ajuntament.barcelona.cat/es/) que pone a disposición el Ayuntamiento de Barcelona. En concreto he querido trabajar con los datos de los últimos 3 años: 2016, 2017 y 2018. El trabajo de limpieza y preparación de los mismos ha sido bastante sencillo, ya que apenas he tenido que realizar modificaciones para poder trabajar con ellos en la predicción y después con Tableau. 

Para facilitar el proceso de corrección los he subido a una carpeta en Dropbox y se descargan directamente desde el código en R. Los cambios que he realizado en el dataset ha sido retirar columnas que no iba a utilizar, traducir los nombres de columnas y valores que estaban en catalán al español y la búsqueda de valores duplicados. 

No hay muchos valores duplicados en el dataset, pero los pocos que hay el motivo de estar duplicados es que a la hora de clasificar la causa del accidente 

