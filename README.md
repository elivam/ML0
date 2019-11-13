# Метрические алгоритмы классификации
Метрические методы обучения методы, основанные на анализе сходтства объектов.
Метрические алгоритмы классификации с обучающей выборкой <a href="https://www.codecogs.com/eqnedit.php?latex=X^l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?X^l" title="X^l" /></a> относят
u к тому классу , для которого суммарный вес ближайших обучающих объектов 
<a href="https://www.codecogs.com/eqnedit.php?latex=w(i,u)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?w(i,u)" title="w(i,u)" /></a> наибольший.

| Метод         | Точность (LOO) |   Значение параметра |
| ------------- | ------------- | -------------------- |
| kNN           | 0.03          |  k = 6               |
| kwNN          | 0.04          |  q = 0.05, k = 6     |
| Прямоугольное парзеновское окно| 0.04          | h = 0.4              |
| Квадратическое парзеновское окно|  0.04             | h = 0.4               |
| Парзеновское окно Епанечникова  |  0.04             | h =  0.4              |
| Треугольное парзеновское окно  |   0.04            | h =  0.4              |
| Гауссовское парзеновское окно  |    0.03           | h =  0.4                |
| Метод потенциальных функций гауссовское ядро   |                               | Max число ошибок = 5 |
| Метода потенциальных функций ядро Епачечникова |                 | Max число ошибок = 6 |
##  Алгоритм k-ближайших соседей                                  
### Метод 1: Метод ближайшего соседа (1nn)
Алгоритм ближайшего соседа (nearest neighbor, NN) является самым простым
алгоритмом классификации. Он относит классифицируемый объект u к тому
классу, которому принадлежит ближайший обучающий объект:
 
<a href="https://www.codecogs.com/eqnedit.php?latex=a(u;X^l)&space;=&space;y_u^{(1)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a(u;X^l)&space;=&space;y_u^{(1)}" title="a(u;X^l) = y_u^{(1)}" /></a>

где <a href="https://www.codecogs.com/eqnedit.php?latex=a" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a" title="a" /></a> - это алгоритм, <a href="https://www.codecogs.com/eqnedit.php?latex=X^l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?X^l" title="X^l" /></a> - обучающая выборка, <a href="https://www.codecogs.com/eqnedit.php?latex=u" target="_blank"><img src="https://latex.codecogs.com/gif.latex?u" title="u" /></a> - классифицируемый объект, 
<a href="https://www.codecogs.com/eqnedit.php?latex=y_u^{(1)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?y_u^{(1)}" title="y_u^{(1)}" /></a> - класс, которому алгоритм дает предпочтение при классификации объекта u

Обучение NN сводится к запоминанию выборки.

 **вход :** 
 
 <a href="https://www.codecogs.com/eqnedit.php?latex=X^l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?X^l" title="X^l" /></a>: matrix 
 
     обучающая выборка, на последнем месте метка класса;
 <a href="https://www.codecogs.com/eqnedit.php?latex=u" target="_blank"><img src="https://latex.codecogs.com/gif.latex?u" title="u" /></a>:  vector
 
     классифицируемый объект;
	 
 <a href="https://www.codecogs.com/eqnedit.php?latex=q" target="_blank"><img src="https://latex.codecogs.com/gif.latex?q" title="q" /></a>: number
 
     определить функцию расстояния;
 
 **выход:** 
 
	имя класса
 
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


<a href="https://www.codecogs.com/eqnedit.php?latex=a(u;X^l,k)&space;=&space;arg&space;\max&space;_{y&space;\in&space;Y}&space;\sum&space;_{i=1}^{k}[y_u^{(i)}=y]" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a(u;X^l,k)&space;=&space;arg&space;\max&space;_{y&space;\in&space;Y}&space;\sum&space;_{i=1}^{k}[y_u^{(i)}=y]" title="a(u;X^l,k) = arg \max _{y \in Y} \sum _{i=1}^{k}[y_u^{(i)}=y]" /></a>
 
 **вход :** 
 
 <a href="https://www.codecogs.com/eqnedit.php?latex=X^l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?X^l" title="X^l" /></a>: matrix 
 
     обучающая выборка, на последнем месте метка класса
	 
 <a href="https://www.codecogs.com/eqnedit.php?latex=u" target="_blank"><img src="https://latex.codecogs.com/gif.latex?u" title="u" /></a>:  vector
 
     классифицируемый объект
	 
 <a href="https://www.codecogs.com/eqnedit.php?latex=q" target="_blank"><img src="https://latex.codecogs.com/gif.latex?q" title="q" /></a>: number
 
     определить функцию расстояния
	 
 <a href="https://www.codecogs.com/eqnedit.php?latex=k" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k" title="k" /></a>: number  
 
	кол-во соседей  
	 
 **выход** 
 
	имя класса
 
 Сам Алгоритм
 1. находим расстояния от точки u до k-ближайших-соседей образуя новый массив, 
   где будет записан класс этой k-точки-соседа и расстояние 
 2. сортируем этот массив 
 3. считаем какие классы соседей встречаются чаще всего и даем предпочтение одному классу
     
 На языке R алгоритм реализован следующим образом :
 [kNN.R](https://github.com/elivam/ML0/blob/master/task1/knnShiny.R)
 
[knn and Shiny](https://elivam.shinyapps.io/task1/)
 
  ###  Найти оптимальное кол-во соседей методом LOO (критерий скользящего контроля)
  При <a href="https://www.codecogs.com/eqnedit.php?latex=k" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k" title="k" /></a> = 1 этот алгоритм совпадает с предыдущим, следовательно, неустойчив
к шуму. При <a href="https://www.codecogs.com/eqnedit.php?latex=k" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k" title="k" /></a> = <a href="https://www.codecogs.com/eqnedit.php?latex=l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?l" title="l" /></a>, наоборот, он чрезмерно устойчив и вырождается в константу.
Таким образом, крайние значения <a href="https://www.codecogs.com/eqnedit.php?latex=k" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k" title="k" /></a> нежелательны. На практике оптимальное значение параметра <a href="https://www.codecogs.com/eqnedit.php?latex=k" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k" title="k" /></a> 
определяют по критерию скользящего контроля с исключением
объектов по одному (leave-one-out, LOO). Для каждого объекта 
<a href="https://www.codecogs.com/eqnedit.php?latex=x_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?x_i" title="x_i" /></a>  проверяется,
правильно ли он классифицируется по своим <a href="https://www.codecogs.com/eqnedit.php?latex=k" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k" title="k" /></a> ближайшим соседям
  
  ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LOOFormula.PNG) 
  
 **вход :** 
 
 <a href="https://www.codecogs.com/eqnedit.php?latex=X^l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?X^l" title="X^l" /></a>: matrix 
 
     обучающая выборка, на последнем месте метка класса
	 
 <a href="https://www.codecogs.com/eqnedit.php?latex=k" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k" title="k" /></a>:  number
 
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
В задачах с двумя классами этого можно избежать, если брать только нечётные значения <a href="https://www.codecogs.com/eqnedit.php?latex=k" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k" title="k" /></a>. 
Более общая тактика, которая годится и для случая многих классов — ввести
строго убывающую последовательность вещественных весов  <a href="https://www.codecogs.com/eqnedit.php?latex=w_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?w_i" title="w_i" /></a>, задающая вклад i-го соседа при классификации объекта <a href="https://www.codecogs.com/eqnedit.php?latex=u" target="_blank"><img src="https://latex.codecogs.com/gif.latex?u" title="u" /></a>.
	
	
<a href="https://www.codecogs.com/eqnedit.php?latex=a(u;X^l,k)&space;=&space;arg&space;\max&space;_{y&space;\in&space;Y}&space;\sum&space;_{i=1}&space;^k&space;[y_u^i&space;=&space;y]&space;w(i)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a(u;X^l,k)&space;=&space;arg&space;\max&space;_{y&space;\in&space;Y}&space;\sum&space;_{i=1}&space;^k&space;[y_u^i&space;=&space;y]&space;w(i)" title="a(u;X^l,k) = arg \max _{y \in Y} \sum _{i=1} ^k [y_u^i = y] w(i)" /></a>
,где <a href="https://www.codecogs.com/eqnedit.php?latex=w_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?w_i" title="w_i" /></a> функция веса, строго убывающая последовательность вещественных весов, 
Например: <a href="https://www.codecogs.com/eqnedit.php?latex=q^i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?q^i" title="q^i" /></a> , где <a href="https://www.codecogs.com/eqnedit.php?latex=q" target="_blank"><img src="https://latex.codecogs.com/gif.latex?q" title="q" /></a> из диапазона (0,1)
 
 На языке R алгоритм реализован следующим образом :
 [kwNN.R](https://github.com/elivam/ML0/blob/master/task1/kwn.R)
 
 Далее построим карту классификации для метода kwNN:
	![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapkwNN.PNG)
	
 На языке R алгоритм реализован следующим образом :
 [classMapkwNN.R](https://github.com/elivam/ML0/blob/master/task1/classMapkwNN.R)
	
 
 ###  Найти оптимальное q методом LOO (критерий скользящего контроля)

![alt text](https://github.com/elivam/ML0/blob/master/pictures/kwnLoo.PNG)
  Недостаток kNN в том, что максимальная сумма голосов может достигаться на нескольких классах одновременно. И тогда не понятно какой 
 класс выбирать. Приведем пример.
 
 | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/exampleKNN.PNG)       | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/exampleKwnn.PNG)|
| ------------- | ------------- | 
Метод k-ближайших соседей| Метод k-ближайших взвешенных соседей
 
 Пример : [Example KwNN and KNN](https://github.com/elivam/ML0/blob/master/task1/examplekwNNandkNN.R)
 
 ##  Метод парзеновского окна
 Ещё один способ задать веса соседям — определить <a href="https://www.codecogs.com/eqnedit.php?latex=w_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?w_i" title="w_i" /></a> как функцию от расстояния 
 <a href="https://www.codecogs.com/eqnedit.php?latex=p(u,x_u^{(i)})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p(u,x_u^{(i)})" title="p(u,x_u^{(i)})" /></a>, а не от ранга соседа <a href="https://www.codecogs.com/eqnedit.php?latex=i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?i" title="i" /></a>. Введём функцию ядра <a href="https://www.codecogs.com/eqnedit.php?latex=K(z)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?K(z)" title="K(z)" /></a>, невозрастающую
на <a href="https://www.codecogs.com/eqnedit.php?latex=[0,&space;\infty]" target="_blank"><img src="https://latex.codecogs.com/gif.latex?[0,&space;\infty]" title="[0, \infty]" /></a>, и рассмотрим алгоритм
<a href="https://www.codecogs.com/eqnedit.php?latex=a(u;X^l,h,K)=&space;arg&space;\max&space;_{y&space;\in&space;Y}&space;\sum&space;_{i=1}^l[y_u^{(i)}&space;=&space;y]&space;K(\frac{p(u,x_u^{(i)}}{h}&space;)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a(u;X^l,h,K)=&space;arg&space;\max&space;_{y&space;\in&space;Y}&space;\sum&space;_{i=1}^l[y_u^{(i)}&space;=&space;y]&space;K(\frac{p(u,x_u^{(i)}}{h}&space;)" title="a(u;X^l,h,K)= arg \max _{y \in Y} \sum _{i=1}^l[y_u^{(i)} = y] K(\frac{p(u,x_u^{(i)}}{h} )" /></a>

Параметр <a href="https://www.codecogs.com/eqnedit.php?latex=h" target="_blank"><img src="https://latex.codecogs.com/gif.latex?h" title="h" /></a> называется шириной окна и играет примерно ту же роль, что и число соседей <a href="https://www.codecogs.com/eqnedit.php?latex=k" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k" title="k" /></a>. 

 **вход :** 
 
 <a href="https://www.codecogs.com/eqnedit.php?latex=X^l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?X^l" title="X^l" /></a>: matrix 
 
     обучающая выборка, на последнем месте метка класса;
 <a href="https://www.codecogs.com/eqnedit.php?latex=u" target="_blank"><img src="https://latex.codecogs.com/gif.latex?u" title="u" /></a>:  vector
 
     классифицируемый объект;
	 
 <a href="https://www.codecogs.com/eqnedit.php?latex=q" target="_blank"><img src="https://latex.codecogs.com/gif.latex?q" title="q" /></a>: расстояние
 
     определить функцию расстояния;
	 
 <a href="https://www.codecogs.com/eqnedit.php?latex=h" target="_blank"><img src="https://latex.codecogs.com/gif.latex?h" title="h" /></a>: расстояние
 
	определить ширину окна;
 
 **выход:** 
 
	имя класса
 
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

<a href="https://www.codecogs.com/eqnedit.php?latex=Q(Z)=\frac{15}{16}(1-z^2)^2&space;\cdot[|z&space;\leq&space;1|]" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Q(Z)=\frac{15}{16}(1-z^2)^2&space;\cdot[|z&space;\leq&space;1|]" title="Q(Z)=\frac{15}{16}(1-z^2)^2 \cdot[|z \leq 1|]" /></a>

| ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LooKerQuar.PNG)       | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapker_quar.PNG)|
| ------------- | ------------- | 
Оптимальный параметр ширины окна h=0.4, оценка LOO= 0.04.| Карта классификации


### Ядро Епанечникова 

<a href="https://www.codecogs.com/eqnedit.php?latex=E(Z)=\frac{3}{4}(1-z^2)\cdot[|z&space;\leq&space;1|]" target="_blank"><img src="https://latex.codecogs.com/gif.latex?E(Z)=\frac{3}{4}(1-z^2)\cdot[|z&space;\leq&space;1|]" title="E(Z)=\frac{3}{4}(1-z^2)\cdot[|z \leq 1|]" /></a>

| ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LooKerEpanech.PNG)      | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapker_epanech.PNG)|
| ------------- | ------------- | 
Оптимальный параметр ширины окна h=0.4, оценка LOO= 0.04.| Карта классификации


### Треугольное ядро 
<a href="https://www.codecogs.com/eqnedit.php?latex=T(Z)=(1&space;-&space;|z|)\cdot&space;[|z&space;\leq&space;1|]" target="_blank"><img src="https://latex.codecogs.com/gif.latex?T(Z)=(1&space;-&space;|z|)\cdot&space;[|z&space;\leq&space;1|]" title="T(Z)=(1 - |z|)\cdot [|z \leq 1|]" /></a>

| ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LooKerTriang.PNG)      | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMApTriangl_ker.PNG)|
| ------------- | ------------- | 
Оптимальный параметр ширины окна h=0.4, оценка LOO= 0.04.| Карта классификации


### Гауссовское ядро 

<a href="https://www.codecogs.com/eqnedit.php?latex=G(Z)=&space;dnorm(z)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?G(Z)=&space;dnorm(z)" title="G(Z)= dnorm(z)" /></a>

| ![alt text](https://github.com/elivam/ML0/blob/master/pictures/LooKerGauss.PNG)      | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapKerGauss.PNG)|
| ------------- | ------------- | 
Оптимальный параметр ширины окна h=0.4, оценка LOO= 0.03.| Карта классификации

##  Метод потенциальных функций
 Допустим теперь, что ядро помещается в каждый
обучающий объект <a href="https://www.codecogs.com/eqnedit.php?latex=x_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?x_i" title="x_i" /></a>  и «притягивает» объект <a href="https://www.codecogs.com/eqnedit.php?latex=u" target="_blank"><img src="https://latex.codecogs.com/gif.latex?u" title="u" /></a> к классу <a href="https://www.codecogs.com/eqnedit.php?latex=y_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?y_i" title="y_i" /></a>, если он попадает в его
окрестность радиуса <a href="https://www.codecogs.com/eqnedit.php?latex=h_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?h_i" title="h_i" /></a>

<a href="https://www.codecogs.com/eqnedit.php?latex=a(u;X^l,h,K)=&space;arg&space;\max&space;_{y&space;\in&space;Y}&space;\sum&space;_{i=1}^l[y_i&space;=&space;y]&space;\gamma_i&space;K(\frac{p(u,x_i)}{h_i}&space;)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a(u;X^l,h,K)=&space;arg&space;\max&space;_{y&space;\in&space;Y}&space;\sum&space;_{i=1}^l[y_i&space;=&space;y]&space;\gamma_i&space;K(\frac{p(u,x_i)}{h_i}&space;)" title="a(u;X^l,h,K)= arg \max _{y \in Y} \sum _{i=1}^l[y_i = y] \gamma_i K(\frac{p(u,x_i)}{h_i} )" /></a>
 
 ширина окна <a href="https://www.codecogs.com/eqnedit.php?latex=h_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?h_i" title="h_i" /></a>
зависит от обучающего объекта <a href="https://www.codecogs.com/eqnedit.php?latex=x_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?x_i" title="x_i" /></a> , 
 а не от классифицирыуемого объекта <a href="https://www.codecogs.com/eqnedit.php?latex=u" target="_blank"><img src="https://latex.codecogs.com/gif.latex?u" title="u" /></a>.
 
 | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/potetialWindGauS.PNG)      | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/parzenWindEpach.PNG) 
| ------------- | ------------- | 
Гауссовское ядро. Максимальное число ошибок 5 | Ядро Епанечникова. Максимальное число ошибок 6

Карта классификации :
 
| ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapPotGaus.PNG)      | ![alt text](https://github.com/elivam/ML0/blob/master/pictures/classMapPotentEpach.PNG) 
| ------------- | ------------- |
#### Достоинства метрических алгоритмов.
 
• Простота реализации и возможность введения различных модификаций весовой функции  <a href="https://www.codecogs.com/eqnedit.php?latex=w(i,u)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?w(i,u)" title="w(i,u)" /></a>.

• Возможность интерпретировать классификацию объекта путём предъявления
пользователю ближайшего объекта или нескольких. 

#### Недостатки метрических алгоритмов.

• Приходится хранить обучающую выборку целиком. Это приводит к неэффективному расходу памяти и чрезмерному усложнению решающего правила.
Имеет смысл отбирать минимальное подмножество эталонных объектов, действительно необходимых для классификации.

• Поиск ближайшего соседа предполагает сравнение классифицируемого объекта
со всеми объектами выборки .

 

# Байесовские алгоритмы классификации

## Линии уровня нормального распределения 
Случайная величина <a href="https://www.codecogs.com/eqnedit.php?latex=x&space;\in&space;R" target="_blank"><img src="https://latex.codecogs.com/gif.latex?x&space;\in&space;R" title="x \in R" /></a>  имеет нормальное (гауссовское) распределение с параметрами 
<a href="https://www.codecogs.com/eqnedit.php?latex=\mu" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\mu" title="\mu" /></a> и <a href="https://www.codecogs.com/eqnedit.php?latex=\sigma^2" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\sigma^2" title="\sigma^2" /></a>, если ее плотность задается выражением:

<a href="https://www.codecogs.com/eqnedit.php?latex=N(x;\mu,\Sigma)&space;=&space;\frac{1}{(2\pi)^n&space;|\Sigma|}&space;\exp&space;(-\frac{1}{2}(x&space;-&space;\mu)^T&space;\Sigma&space;^{-1}(x&space;-&space;\mu))" target="_blank"><img src="https://latex.codecogs.com/gif.latex?N(x;\mu,\Sigma)&space;=&space;\frac{1}{(2\pi)^n&space;|\Sigma|}&space;\exp&space;(-\frac{1}{2}(x&space;-&space;\mu)^T&space;\Sigma&space;^{-1}(x&space;-&space;\mu))" title="N(x;\mu,\Sigma) = \frac{1}{(2\pi)^n |\Sigma|} \exp (-\frac{1}{2}(x - \mu)^T \Sigma ^{-1}(x - \mu))" /></a>

По центральной предельной теореме среднее арифметическое независимых случайных величин с ограниченными мат.ожиданием
и дисперсией стремится к нормальному распределению. 

Всего возможно 3 случая : 
1) Если признаки некоррелируемы, т.е. коварициаонаая матрица - диагональна. И линии уровня
имеют форму эллипсоидов с центром в <a href="https://www.codecogs.com/eqnedit.php?latex=\mu" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\mu" title="\mu" /></a>  и осями параллельными осям координат.

2) Если признаки имеют одинаковые дисперсии , то линиями уровня являются сферами.

3) Если признаки коррелируемы, то ковариционная матрица не диагональна и линии уровня 
имеют форму эллипсоидов , оси которых повернуты вдоль собсвенных векторов ковариционной
матрицы.

Все случаи рассмотрены по следущей ссылке  
[Shiny](https://elivam.shinyapps.io/LevelsLines/)