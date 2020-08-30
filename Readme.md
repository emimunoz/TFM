# Trabajo Final de Máster: Predicción de accidentes en la ciudad de Barcelona
# Emiliano Muñoz Torres

## Descripción de los archivos
* **Preparación y limpieza de datos:** En este código se importan los datos directamente como se descargan desde la web Open Data del Ayuntamiento de Barcelona. Se realiza exploración y limpieza de los datos para prepararlos para usarlos en Tableau y para el forecasting.
* **Coordenadas:** Para poder trabajar con los datos de coordenadas en Tableau, es necesario transformar las coordenadas que están en formato UTM a formato de latitud/longitud.
* **Forecasting:** En este código se preparan los datos y se estudian las características de la serie temporal para realización de la predicción del número de accidentes utilizando los métodos: Auto.ARIMA, ETS, SNAIVE, Holt Winters y Prophet. 
* **Visualization:** El archivo con los gráficos para visualizar los datos en Tableau.
* **Map Visualization:** El archivo con la visualización de los puntos de accidentes en la ciudad de Barcelona. 
* He intentado que todos los archivos necesarios para ejecutar el código se descarguen directamente desde Dropbox para facilitar el proceso de revisión del código. Pero he comprobado que el proceso de importación es inconsistente y a veces ha dado errores, por lo que en caso de que fallara, se pueden descargar todos los archivos necesarios desde este link -> https://www.dropbox.com/sh/wvzucdfnn5gihir/AAACX7QqEc7AGPbDlyA4upkCa?dl=0 

## La idea
La idea inicial que me habría gustado desarrollar como Trabajo Final de Máster consistía en un estudio sobre la asistencia a las urgencias de diversos hospitales dependiendo del día y los eventos sociales de cada día. La finalidad era encontrar la más que sabida relación entre la saturación de las urgencias y días que no coinciden con festivos o eventos deportivos relevantes, ya que los días que hay eventos sociales de ese tipo, las urgencias están menos saturadas. 

Después de ponerme en contacto con el INE y el Ministerio de Sanidad me fue imposible conseguir los datos para dicho estudio, y ante la proximidad de la fecha límite para entregar el Trabajo Final de Máster, me decidí por realizar una versión alternativa de dicho estudio pero con datos de accidentes en la ciudad de Barcelona. 

Lo he realizado todo en lenguaje R ya que ha sido el lenguaje con el que más cómodo me he sentido a la hora de trabajar durante todo el Máster. Además, por las ventajas que ofrece R Studio a la hora de realizar un proyecto de análisis y modificación de datos. 

## Desarrollo
Los [datos](https://opendata-ajuntament.barcelona.cat/data/es/dataset/accidents-gu-bcn) los he descargado desde la web [Open Data BCN](https://opendata-ajuntament.barcelona.cat/es/) que pone a disposición el Ayuntamiento de Barcelona. En concreto he querido trabajar con los datos de los **últimos 5 años: 2014, 2015, 2016, 2017 y 2018**. El trabajo de limpieza y preparación de los mismos ha sido bastante sencillo, ya que apenas he tenido que realizar modificaciones para poder trabajar con ellos en la predicción y en la visualización a posteriori con Tableau. 

![](https://i.imgur.com/vDjZkq8.jpg)

Los cambios que he realizado en el dataset ha sido retirar columnas que no iba a utilizar, traducir los nombres de columnas y valores que estaban en catalán al español y la búsqueda de valores duplicados. 

No hay muchos valores duplicados en el dataset, pero los pocos que hay, el motivo de estar duplicados es por la clasificación de la causa del accidente. En algunas ocasiones se indica como causa _“Otros”_ y otro dato con una causa más específica, por lo que me he quedado con los valores que ofrecen más información sobre la causa del accidente. Ya para finalizar con la preparación previa de los datos he creado una columna con la fecha en la que  sucedió cada accidente. Exportando al final el archivo _CSV_ con el que se trabajará después para realizar el Forecasting y para la visualización en Tableau.

## Forecasting
A raíz de los comentarios que recibí cuando presenté inicialmente mi Trabajo Final de Máster, he decidido introducir otros métodos de predicción más simples para comparar los resultados con los que se obtienen con Prophet. En concreto he utilizado Auto.ARIMA, ETS, SNAIVE y Holt Winters que he visto que son de los más populares a la hora de trabajar con series temporales.

### Auto.ARIMA
Para tratar de conseguir un resultado que se ajustara más a la forma de la serie temporal con la que se trabaja, intenté "forzar" la detección de estacionalidad en el modelo con Auto.ARIMA, pero después de dejar el ordenador durante bastante rato procesando, nunca llegaba a dar ningún resultado. Los resultados obtenidos con Auto.ARIMA son los siguientes:

![](https://i.imgur.com/YB8GxXb.png)


Para el estudio de la predicción de accidentes he decidido utilizar **Prophet** ya que es una librería que permite realizar predicciones de series temporales de una manera sencilla y fiable. **Ideal para trabajar con datos con periodicidad diaria y con al menos un año de datos en el dataset**. En mi caso como dispongo de datos diarios de 3 años de accidentes, en un principio estaría todo correcto para obtener una buena predicción.

Lo primero será crear una columna con el valor _‘1’_ que nos servirá para realizar un sumatorio y obtener la cifra de accidentes que ha habido por día. Una vez realizado esto para trabajar con Prophet simplemente se tiene que editar el dataframe de datos añadiendo una columna _‘ds’_ con la fecha y otra _‘y’_ con los valores obtenidos en cada día.  Representamos la serie temporal con los datos de accidentes de 2016, 2017 y 2018, separados por una línea vertical:

![](https://i.imgur.com/LnM6w2F.jpg)

Intenté realizar una **transformación Box-Cox** utilizando la función _Box-Cox.lambda()_ para tratar de averiguar el valor de lambda más adecuado para dicha transformación. Pero al representar ambos valores obtenidos en una visualización no se observaba ninguna variación en la serie temporal. Por lo que decidí realizar directamente el forecasting con el dataset de accidentes preparado para Prophet, obteniendo la siguiente representación de la predicción:

![](https://i.imgur.com/gVpGYn6.jpg)

Con la función _prophet_plot_components()_ es posible visualizar una **visualización general de la tendencia** de los datos de accidentes en la ciudad de Barcelona:

![](https://i.imgur.com/0jBu3DU.jpg)

Se puede comprobar que la tendencia es que el número de accidentes continúen **disminuyendo después de haber alcanzado un valor máximo en el año 2017**,  con una media de 28 accidentes diarios. Para el año 2020 se estima que baje a 26. No es un cambio considerable pero es una relativamente buena noticia que el número de accidentes tienda a disminuir.

La distribución semanal de accidentes se verá más claramente después en una visualización de Tableau. Sin embargo, en la distribución anual, llama la atención comprobar cómo en el mes de Agosto disminuye considerablemente el número de accidentes. Algo que habría que estudiar a ver si realmente es un fallo de los datos o no, ya que en teoría Barcelona es una ciudad muy turística y en dicho mes tendría un gran número de visitantes extranjeros. 

## Visualización con Tableau
### Accidentes al año
En el primer gráfico se puede ver que la tendencia es que a cada año que pasa, **el número de accidentes es inferior al del año anterior**.  Lo cual coincide con lo estimado por Prophet que indicaba que la tendencia era a que disminuyera el número de accidentes. También es bastante representativo comprobar cómo claramente el mes con menos accidentes siempre es agosto. Para una ciudad tan turística como es Barcelona, este mes será de los que más visitantes extranjeros recibe, pero aún así hay menos accidentes. Por lo que podríamos suponer que los principales responsables de los accidentes en Barcelona son personas en horario laboral. Ya que en agosto es cuando más gente se va de vacaciones normalmente. 

![](https://i.imgur.com/EXC99bU.png)



### Accidentes por distrito

Aquí también podemos ver que durante la tarde y la mañana es la hora del día en la que más accidentes suele haber. El distrito de **Eixample es el que más accidentes acumula** ya que es de las zonas más céntricas de Barcelona, por lo que es por donde más gente circula y es obvio que sucederán más accidentes. El distrito de Sant Martí es junto al de Sants-Montjuic el que más accidentes por la noche. En Sant Martí es donde podemos encontrar una de las zonas de fiesta de Barcelona con discotecas como Razzmatazz. Por lo que tiene cierta lógica que acumule más accidentes. 

![](https://i.imgur.com/nmkSPur.jpg)



### Accidentes a lo largo de la semana

Por último, tenemos un gráfico donde se ven los accidentes en cada día de la semana y el número de accidentes mortales de media para cada día. Este gráfico vuelve a confirmar lo que sospechábamos en los gráficos previos: **la mayoría de accidentes ocurren durante jornada laboral.** Los sábados y domingos el número de accidentes disminuye considerablemente. Los días con más accidentes mortales son el lunes y viernes, siendo este último el día con más accidentes en general también. 
![](https://i.imgur.com/SjjlKSr.jpg)
