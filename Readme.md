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

No hay muchos valores duplicados en el dataset, pero los pocos que hay, el motivo de estar duplicados es a la hora de clasificar la causa del accidente. En algunas ocasiones se indica como causa “Otros” y una causa más particular, por lo que me he quedado con los valores que ofrecen más información sobre la causa del accidente.

Ya para finalizar con la preparación previa de los datos he creado una columna con la fecha en la que  sucedió cada accidente. Exportando al final el archivo CSV con el que se trabajará después para realizar el Forecasting y para la visualización en Tableau.

## Forecasting
Para el estudio de la predicción de accidentes he decidido utilizar Prophet porque es una librería que permite realizar predicciones de series temporales de una manera fácil y fiable. Especialmente pensada para trabajar con datos con periodicidad diaria y al menos un año de datos. En mi caso como dispongo de datos diarios de 3 años de accidentes, en un principio estaría todo correcto para obtener una buena predicción.

Lo primero será crear una columna con el valor ‘1’ que nos servirá para realizar un sumatorio y obtener la cifra de accidentes que ha habido por cada día. Una vez realizado esto para trabajar con Prophet simplemente se tiene que editar el dataframe de datos añadiendo una columna ‘ds’ con la fecha y otra ‘y’ con los valores obtenidos en cada día.  Representamos la serie temporal con los datos de accidentes de 2016, 2017 y 2018, separados por una línea vertical:

*

Intenté realizar una transformación Box-Cox utilizando la función _Box-Cox.lambda()_ para tratar de averiguar el valor de lambda más adecuado para dicha transformación. Pero al representar ambos valores obtenidos en una visualización no se conseguía observar ninguna variación en la serie temporal. Por lo que decidí realizar directamente el forecasting con el dataset de accidentes preparado para Prophet, obteniendo la siguiente representación de la predicción:

*

Con la función _prophet_plot_components()_ es posible visualizar una representación general de la tendencia de los datos de accidentes en la ciudad de Barcelona:

Se puede comprobar que la tendencia es que el número de accidentes continúen disminuyendo después de alcanzar un valor máximo en el año 2017, alcanzando un pico de 28 accidentes diarios. Para el año 2020 se estima que baje a 26. No es un cambio considerable pero es una relativamente buena noticia que el número de accidentes disminuyan.

La distribución semanal de accidentes se verá más claramente después en una visualización de Tableau. Sin embargo, en la distribución anual, llama la atención comprobar cómo en el mes de Agosto disminuye considerablemente el número de accidentes. Algo que habría que estudiar a ver si realmente es un fallo de los datos o no, ya que en teoría Barcelona es una ciudad muy turística y en dicho mes tendría un gran número de visitantes extranjeros. 

## Visualización con Tableau




