# Метрические алгоритмы классификации
Метрические методы обучения методы, основанные на анализе сходтства объектов.
Метрические алгоритмы классификации с обучающей выборкой ![alt text](https://github.com/elivam/ML0/blob/master/pictures/Xlformula.PNG) относят
u к тому классу , для которого суммарный вес ближайших обучающих объектов 
![alt text](https://github.com/elivam/ML0/blob/master/pictures/WI(u,x)Text.PNG) наибольший.

| Метод         | Точность (LOO) |   Значение параметра |
| ------------- | ------------- | -------------------- |
| kNN           | 0.03          |  k = 6               |
| kwNN          | 0.04          |  q = 0.05, k = 6     |
| Прямоугольное парзеновское окно| 0.04          | h = 0.4              |
| Квадратическое парзеновское окно|  0.04             | h = 0.4               |
| Парзеновское окно Епанечникова  |  0.04             | h =  0.4              |
| Треугольное парзеновское окно  |   0.04            | h =  0.4              |
| Гауссовское парзеновское окно  |    0.03           | h =  0.4                |
| Метод потенциальных функций   |               |                      |

##  Алгоритм k-ближайших соседей                                  
### Метод 1: Метод ближайшего соседа (1nn)
Алгоритм ближайшего соседа (nearest neighbor, NN) является самым простым
алгоритмом классификации. Он относит классифицируемый объект u к тому
классу, которому принадлежит ближайший обучающий объект:

![alt text](https://github.com/elivam/ML0/blob/master/pictures/1nnFormula.PNG), 

где а - это алгоритм, ![alt text](https://github.com/elivam/ML0/blob/master/pictures/Xlformula.PNG) - обучающая выборка, u - классифицируемый объект, 
![alt text](https://github.com/elivam/ML0/blob/master/pictures/Yformula.PNG) - класс, которому алгоритм дает предпочтение при классификации объекта u

Обучение NN сводится к запоминанию выборки.

 **вход :** 
 
 Xl: matrix 
 
     обучающая выборка, на последнем месте метка класса;
 u:  vector
 
     классифицируемый объект;
	 
 q : расстояние
 
     определить функцию расстояния;
 
 **выход:** имя класса
 
 **Сам алгоритм:**
 1. находим расстояние от точки u до точек из выборки, образуя новый вектор
 2. находим минимальное расстояние в векторе и запоминаем точку А(это именно та точка расстояние до которой минимально)
 3. узнаем какому классу принадлежит точка А и относим u к тому классу какому принадлежит точка А
    
 На языке R алгоритм реализован следующим образом :
 [1NN.R](https://github.com/elivam/ML0/blob/master/task1/Shiny.R)
 
 [1NN and Shiny](https://elivam.shinyapps.io/NearNeighboard/)
 ### Метод k-ближайших соседей (knn)
 Чтобы сгладить влияние шумовых выбросов, будем классифицировать объекты путём голосования
по k ближайшим соседям.


![alt text](https://github.com/elivam/ML0/blob/master/pictures/knnFormula.PNG)
 
 **вход :** 
 
 Xl: matrix 
 
     обучающая выборка, на последнем месте метка класса
	 
 u:  vector
 
     классифицируемый объект
	 
 q : расстояниe
 
     определить функцию расстояния
	 
 k:  
 
	кол-во соседей  
	 
 **выход** имя класса
 
 Сам Алгоритм
 1. находим расстояния от точки u до k-ближайших-соседей образуя новый массив, 
   где будет записан класс этой k-точки-соседа и расстояние 
 2. сортируем этот массив 
 3. считаем какие классы соседей встречаются чаще всего и даем предпочтение одному классу
     
 На языке R алгоритм реализован следующим образом :
 [kNN.R](https://github.com/elivam/ML0/blob/master/task1/knnShiny.R)
 
[knn and Shiny](https://elivam.shinyapps.io/task1/)
 
  ###  Найти оптимальное кол-во соседей методом LOO (критерий скользящего контроля)
  При k = 1 этот алгоритм совпадает с предыдущим, следовательно, неустойчив
к шуму. При k = l, наоборот, он чрезмерно устойчив и вырождается в константу.
Таким образом, крайние значения k нежелательны. На практике оптимальное значение параметра k 
определяют по критерию скользящего контроля с исключением
объектов по одному (leave-one-out, LOO). Для каждого объекта 
![alt text](https://github.com/elivam/ML0/blob/master/pictures/Xitext.PNG)  проверяется,
правильно ли он классифицируется по своим k ближайшим соседям
  
  ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LOOFormula.PNG) 
  
 **вход :** 
 
 Xl: matrix 
 
     обучающая выборка, на последнем месте метка класса
	 
 k:  кол-во соседей
 
     определить оптимальное кол-во требуемых соседей , используя LOO 
	 
 **выход** 
 k, при котором допускается наименьшая ошибка   
 На языке R алгоритм реализован следующим образом :
 [kNN and LOO.R](https://github.com/elivam/ML0/blob/master/task1/kNNLOO.R)
  ![alt text](https://github.com/elivam/ML0/blob/master/pictures/knnLoo.PNG)

 Далее построим карту классификации для метода kNN:
 [classMapkNN.R](https://github.com/elivam/ML0/blob/master/task1/classMapkNN.R)
  ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapkNN.PNG)
  ###  Алгоритм k-взвешенных ближайших соседей
  
   Недостаток kNN в том, что максимальная сумма голосов может достигаться на нескольких классах одновременно.
В задачах с двумя классами этого можно избежать, если брать только нечётные значения k. Более общая тактика, которая годится и для случая многих классов — ввести
строго убывающую последовательность вещественных весов  ![alt text](https://github.com/elivam/ML0/blob/master/pictures/Witext.PNG), задающих вклад i-го соседа в классификацию
	![alt text](https://github.com/elivam/ML0/blob/master/pictures/kwnnForm.PNG)
	
 На языке R алгоритм реализован следующим образом :
 [kwNN.R](https://github.com/elivam/ML0/blob/master/task1/kwn.R)
 
  Ccылка на shiny
 
 Далее построим карту классификации для метода kwNN:
	![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapkwNN.PNG)
	,где ![alt text](https://github.com/elivam/ML0/blob/master/pictures/Witext.PNG) функция веса, строго убывающая последовательность вещественных весов, 
	задающая вклад i-го соседа при классификации объекта u. Например: ![alt text](https://github.com/elivam/ML0/blob/master/pictures/Qtext.PNG) , где q из диапазона (0,1)
 
 На языке R алгоритм реализован следующим образом :
 [classMapkwNN.R](https://github.com/elivam/ML0/blob/master/task1/classMapkwNN.R)
	
 
 ###  Найти оптимальное q методом LOO (критерий скользящего контроля)

![alt text](https://github.com/elivam/ML0/blob/master/pictures/kwnLoo.PNG)
  Недостаток kNN в том, что максимальная сумма голосов может достигаться на нескольких классах одновременно. И тогда не понятно какой 
 класс выбирать. Приведем пример.
 ![alt text](https://github.com/elivam/ML0/blob/master/pictures/exampleKNN.PNG)
 Метод k-ближайших соседей
 ![alt text](https://github.com/elivam/ML0/blob/master/pictures/exampleKwnn.PNG)
 Метод k-ближайших взвешенных соседей
 
 Пример : [Example KwNN and KNN](https://github.com/elivam/ML0/blob/master/task1/examplekwNNandkNN.R)
 
 #### Достоинства метрических алгоритмов.
 
• Простота реализации и возможность введения различных модификаций весовой функции  ![alt text](https://github.com/elivam/ML0/blob/master/pictures/WI(u,x)Text.PNG).


• Возможность интерпретировать классификацию объекта путём предъявления
пользователю ближайшего объекта или нескольких. 

#### Недостатки метрических алгоритмов.

• Приходится хранить обучающую выборку целиком. Это приводит к неэффективному расходу памяти и чрезмерному усложнению решающего правила.
Имеет смысл отбирать минимальное подмножество эталонных объектов, действительно необходимых для классификации.

• Поиск ближайшего соседа предполагает сравнение классифицируемого объекта
со всеми объектами выборки .

 
 ##  Метод парзеновского окна
 Ещё один способ задать веса соседям — определить ![alt text](https://github.com/elivam/ML0/blob/master/pictures/Witext.PNG). как функцию от расстояния 
 ![alt text](https://github.com/elivam/ML0/blob/master/pictures/Ptext.PNG), а не от ранга соседа i. Введём функцию ядра K(z), невозрастающую
на [0,∞), и рассмотрим алгоритм

![alt text](https://github.com/elivam/ML0/blob/master/pictures/parz_wind.PNG)

Параметр h называется шириной окна и играет примерно ту же роль, что и число соседей k. 

 **вход :** 
 
 Xl: matrix 
 
     обучающая выборка, на последнем месте метка класса;
 u:  vector
 
     классифицируемый объект;
	 
 q : расстояние
 
     определить функцию расстояния;
	 
 h : расстояние
 
	определить ширину окна;
 
 **выход:** имя класса
 
 **Сам алгоритм:**
 1. находим расстояние от точки u до точек из выборки, образуя новый вектор
 2. сортируем в порядке уменьшения расстояния
 3. определяем функцию ядра (прямоугольное, квадратичное, гауссовское, Епанечникова  и треугольное) по формулам
 4. добавляем таблицу встречаемости каждого класса
 5. заполняем таблицу
 6. выясняем имя класса, который чаще всего встречался 

 Карта классификации выполнена для 30 случайно выбранных элеметов выборки.
 
### Прямоугольное ядро
![alt text](https://github.com/elivam/ML0/blob/master/pictures/R(Z).PNG)

#### Найдем оптимальное h методом LOO
| ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LooKerRect.PNG)       | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapker_rect.PNG)|
| ------------- | ------------- | 
Оптимальный параметр ширины окна h=0.4, оценка LOO= 0.04.| Карта классификации


### Квадратическое ядро
![alt text](https://github.com/elivam/ML0/blob/master/pictures/sqare.PNG)

| ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LooKerQuar.PNG)       | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapker_quar.PNG)|
| ------------- | ------------- | 
Оптимальный параметр ширины окна h=0.4, оценка LOO= 0.04.| Карта классификации


### Ядро Епанечникова 
![alt text](https://github.com/elivam/ML0/blob/master/pictures/epanc_ker.PNG)

| ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LooKerEpanech.PNG)      | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapker_epanech.PNG)|
| ------------- | ------------- | 
Оптимальный параметр ширины окна h=0.4, оценка LOO= 0.04.| Карта классификации


### Треугольное ядро 
![alt text](https://github.com/elivam/ML0/blob/master/pictures/triangle.PNG)

| ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LooKerTriang.PNG)      | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMApTriangl_ker.PNG)|
| ------------- | ------------- | 
Оптимальный параметр ширины окна h=0.4, оценка LOO= 0.04.| Карта классификации


### Гауссовское ядро 
![alt text](https://github.com/elivam/ML0/blob/master/pictures/Gaus_ker.PNG)

| ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LooKerGauss.PNG)      | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapKerGauss.PNG)|
| ------------- | ------------- | 
Оптимальный параметр ширины окна h=0.4, оценка LOO= 0.03.| Карта классификации

##  Метод потенциальных функций
 Допустим теперь, что ядро помещается в каждый
обучающий объект ![alt text](https://github.com/elivam/ML0/blob/master/pictures/Xitext.PNG)  
и «притягивает» объект u к классу ![alt text](https://github.com/elivam/ML0/blob/master/pictures/yi.PNG) если он попадает в его
окрестность радиуса ![alt text](https://github.com/elivam/ML0/blob/master/pictures/hi.PNG)

![alt text](https://github.com/elivam/ML0/blob/master/pictures/potenFunck.PNG)