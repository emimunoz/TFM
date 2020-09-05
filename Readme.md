# Trabajo Final de Máster: Predicción de accidentes en la ciudad de Barcelona
# Emiliano Muñoz Torres

## Descripción de los archivos
* **Preparación y limpieza de datos:** En este código se importan los datos directamente como se descargan desde la web Open Data del Ayuntamiento de Barcelona. Se realiza exploración y limpieza de los datos para prepararlos para usarlos en Tableau y para el forecasting.
* **Coordenadas:** Para poder trabajar con los datos de coordenadas en Tableau, es necesario transformar las coordenadas que están en formato UTM a formato de latitud/longitud.
* **Forecasting:** En este código se preparan los datos y se estudian las características de la serie temporal para realización de la predicción del número de accidentes utilizando los métodos: Auto.ARIMA, ETS, SNAIVE, Holt Winters y Prophet. 
* **Visualization:** El archivo con los gráficos para visualizar los datos en Tableau.
* **Map Visualization:** El archivo con la visualización de los puntos de accidentes en la ciudad de Barcelona. 

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
![](https://i.imgur.com/ywWqGCX.jpg)
![](https://i.imgur.com/6eh9R2F.jpg)

### SNAIVE
Los resultados obtenidos usando el método de SNAIVE son los siguientes:

![](https://i.imgur.com/X7fjKba.png)
![](https://i.imgur.com/VfeiFJZ.jpg)
![](https://i.imgur.com/1du1JdC.jpg)

### ETS 
En el caso de este método, se consiguen los mejores resultados de los 4, en parte es debido a que es el más adecuado para series como la que estamos tratando que tiene una fuerte estacionalidad. Los resultados obtenidos usando el método de ETS (error, trend, seasonal) son los siguientes:

![](https://i.imgur.com/N97T9Kv.png)
![](https://i.imgur.com/CW7QELb.jpg)
![](https://i.imgur.com/jrvQZE1.jpg)

### Holt Winters
Este método de predicción también está muy indicado para series con fuerte estacionalidad, pero los resultados obtenidos son peores, aunque el gráfico de predicción es más ajustado que el del modelo ETS:

![](https://i.imgur.com/fIa5ro1.png)
![](https://i.imgur.com/F3J4Pws.jpg)
![](https://i.imgur.com/3yfKwQ9.jpg)

### Resultados
Comparando los KPIs resultado de los 4 métodos de predicción, se comprueba que métodos como el ETS y Holt Winters son los que mejores resultados han obtenido. Estos resultados cuadran con lo esperado, ya que son dos métodos que trabajan bien con datos que tienen estacionalidad, y como se podrá comprobar en la parte de visualización, la gráfica de la distribución de accidentes a lo largo de cada año se repite con gran similitud. 

![](https://i.imgur.com/95dGpvz.png)

Sin embargo, comparando los histogramas que muestra el checkresiduals, el método de Auto.ARIMA es el que mantiene una distribución que se asemeja más a la normal para los errores. En el caso de Holt Winters hay un pico que sobresale considerablemente de la distribución normal, y con ETS en la zona izquierda de la distribución se aprecia que se queda por debajo de la curva. 

### Predicción utilizando Prophet
Los métodos anteriores se quedan como referencia para comparar con Prophet, un método de predicción de series temporales que es **ideal para trabajar con datos con periodicidad diaria y con al menos un año de datos en el dataset**. En mi caso como dispongo de datos diarios de 5 años de accidentes con fuerte estacionalidad, por lo que con los datos que estamos trabajando debería justarse adecuadamente y obtener unos resultados mejores que con los métodos previos.

Con Prophet se puede ver la descomposición de los componentes de la serie. Tal y como se aprecia aplicándolo a la serie de accidentes en Barcelona, se comprueba que la tendencia era a subir hasta pasado el año 2017 que comienza a tener una tendencia a descender año tras año ligeramente (apenas hablamos de una variación de 8 accidentes diarios como rango máximo para el caso máximo real y el mínimo estimado para el año 2022 por Prophet). Se aprecia también que en la época del verano es cuando disminuyen los accidentes, especialmente durante el mes de agosto.  

![](https://i.imgur.com/U6F3BB1.jpg)

Representando la gráfica de la predicción de Prophet se aprecia como ha captado la estacionalidad de la serie y le aplica una tendencia ligeramente a la baja para el número de accidentes para los años 2019 a 2022: 

![](https://i.imgur.com/j8jPxbl.jpg)

### Resultados de Prophet
Finalmente se cumple lo que había estimado: **la predicción utilizando Prophet es mucho más precisa que con el resto de métodos más simples.** En el caso del ETS se obtenían unos KPIs al comparar el algoritmo con los datos de test con valor de RMSE 9.28 y MAE: 7.56, y con Holt Winters los resultados eran RMSE: 9.84 y MAE: 10.79. 

Los resultados utilizando Prophet han sido los siguientes:

![](https://i.imgur.com/sM6ujy2.png)

Hay una diferencia de más de 2 puntos en el KPI del RMSE y MAE, si comparamos ya con Auto.ARIMA (MRSE: 11.65 y MAE: 9.54)que fue la que peores KPIs dio de los 4 métodos de predicción simples, la diferencia es aun más considerable. Por lo tanto, podemos confirmar que Prophet ha sido el algoritmo que, con diferencia, **ha conseguido los resultados más ajustados y precisos** a la hora de predecir el número de accidentes que habrá en la ciudad de Barcelona para los próximos 3 años.


## Visualización con Tableau
### Accidentes por distrito y momento del día
En este gráfico se comprueba que claramente la zona de Eixample es la que más accidentes reúne de toda la ciudad de Barcelona. Se trata de un **distrito que se encuentra justo en el centro de la ciudad**, por lo que es lógico. Aunque sorprende ver la considerable diferencia con respecto al resto de distritos.

![](https://i.imgur.com/BEjivPO.png)


### Accidentes durante el día y víctimas graves
Este gráfico puede resultar un poco difícil de interpretar a simple vista. Las columnas muestran el número de accidentes en cada hora del día en los años 2014 a 2018. La intensidad del color azul muestra el número de víctimas afectadas en cada accidente, es decir, más personas iban en cada uno de los vehículos afectados o más vehículos se han visto involucrados en el accidentes. Y el ancho de cada columna indica el número resultante de víctimas graves al accidente. 

Se comprueba que la hora con más accidentes y víctimas afectadas es las 2 de la tarde, y cuando más afectados graves es a las 6 de la tarde. También se aprecia como en las horas que más movimiento habrá de usuarios **yendo al trabajo o saliendo del trabajo, es cuando más accidentes hay**. Entre las 8 y 9 de la mañana va aumentando el número de accidentes, que se reduce a las 10 y progresivamente asciende hasta las 2 de la tarde.  

![](https://i.imgur.com/tT1qg8f.png)



### Accidentes a lo largo de la semana
Aquí se confirma que claramente la inmensa mayoría de los accidentes se producen durante desplazamientos al trabajo, ya que el sábado y domingo la cifra de accidentes disminuye considerablemente. Es curioso comprobar como el **número de accidentes va aumentando progresivamente** desde el lunes hasta el número más alto el viernes, quizás porque la gente conducirá con más ansia y nervios conforme más días trabajando pasan, deseando que llegue el fin de semana. 

Es destacable que el sábado se alcance la cifra máxima de víctimas mortales junto con el lunes. Quizás es debido a que aunque haya bastantes menos accidentes que durante la semana, los accidentes que sucedan se dan en condiciones de más riesgo y por lo tanto acaban resultando en el fallecimiento de víctimas afectadas. 

![](https://i.imgur.com/HLzlsN6.png)

### Puntos calientes de accidentes en el mapa de Barcelona
Finalmente, aquí se puede visualizar todos los accidentes sucedidos en los 5 años analizados en este proyecto (de 2014 a 2018). Como se ha visto previamente, la zona céntrica de Barcelona es la que más accidentes acumula, pero también se puede apreciar cómo en la carreteras que circunvalan la ciudad también aparece una acumulación de puntos de accidentes. 

![](https://i.imgur.com/WlohiX2.jpg)
![](https://i.imgur.com/9GMu6m4.jpg)

## Conclusiones finales
Todo proyecto de análisis de datos surge de una necesidad de conocer unos datos que se poseen y sacar información que pueda ser de utilidad para solventar un problema o necesidad que haya. La conclusión que se podría sacar después de haber realizado este análisis de los accidentes de la ciudad de Barcelona es que sería recomendable incentivar el uso del transporte público para ir al trabajo. Se ha comprobado que la mayoría de accidentes suceden en desplazamientos durante el horario normalmente laboral. Si se redujera el número de personas que recurren a vehículos particulares para acudir al trabajo, se reducirían los accidentes. 

Tras todo lo acontecido durante la actual pandemia debida al COVID-19, el número de accidentes se habrá visto reducido muchísimo más de lo estimado con los datos de años previos, pero también es de esperar que una vez pase todo, haya menos accidentes ya que muchas empresas seguirán recurriendo al teletrabajo para reducir costes y ofrecer facilidades a sus empleados. 
