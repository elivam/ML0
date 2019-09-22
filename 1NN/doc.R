#' выход : 
#' Xl: matrix 
#'     обучающая выборка, на последнем месте метка класса
#' u:  vector
#'     классифицираемый объект
#' q : расстояние
#'     определить функцию расстояния
#' 
#' @return имя класса
#' 
#' 
#' 1. нахожу расстояние от точки u до точек из выборки, образуя новую матрицу
#' 2. нахожу минимальное расстояние в матрице и запоминаю точку А
#' 3. узнаю какому классу принадлежит эта точка А и точку u окрашиваю в тот  же класс что и точку u
evcliDestance <- function (x1,y1,x2,y2){
  return(sqrt((x2-x1)^2+(y2-y1)^2)) 
}
nn <- function(xl, u1, u2){
      
    l <- dim(xl)[1] #кол-во строк 
    n <- dim(xl)[2] - 1 #кол-во признаков
    # в общем у xl 3 признака , х - координата , у - координата и третий - класс
    
    dist <- array(NA,l)
    for (i in 1:l){
      dist[i] = evcliDestance(xl[i,1],xl[i,2],u1,u2) 
    } 
     minXl  <- which.min(dist)
     return (xl[minXl, ])
}   
x <- 1
y <- 0.5
colors <- c("setosa" = "red", "versicolor" = "green3",
            "virginica" = "blue")
la <-nn(iris[, 3:5], x, y)
plot(iris[, 3:4], pch = 10, bg = colors[iris$Species], col = colors[iris$Species], asp = 1)
points(x, y, pch = 22, bg = colors[la[1,3]], asp = 1)
s

