
evcliDestance <- function (x, u){
  return (sqrt(sum((x - u)^2)))
}
sortObjByDist <-function(xl, u,q = evcliDestance){
  l <- dim(xl)[1] #кол-во строк 
  n <- dim(xl)[2] - 1 #кол-во признаков
  # в общем у xl 3 признака , х - координата , у - координата и третий - класс
  
  dist <- matrix(NA, l, 2)
  for (i in 1:l) {
    dist[i, ] <- c(i, q(xl[i, 1:n],u)) 
  }
  sortXl <- xl[order(dist[, 2]), ]
  
  return(sortXl)
}
knn <- function(sortXl,u ,k, q = evcliDestance){
  n <- dim(sortXl)[2] 
  # в classes хранятся классы
  classes <- sortXl[1:k, n]
  counts <- table(classes)
  mClass <- names(which.max(counts))
  
  return (mClass)
}
kwNN <- function(xl, u, k, q)
{
  m <- c("setosa" = 0, "versicolor" = 0, "virginica" = 0)
  xl <- sortObjByDist(xl, u)
  n <- dim(xl)[2] 
  classes <- xl[1:k, n ]
  for(i in i:k)
  {
    w <- q ^ i
    m[classes[i]] <- m[classes[i]]+w
  }
  mainClass <- names(which.max(m))
  return (mainClass)
}
classMapkwNN <- function(xl) {
  colors <- c("setosa" = "#FFCC33", "versicolor" = "#0033FF",
              "virginica" = "#CC00CC")
  plot(xl[1:2], pch = 21, col = colors[xl$Species], bg = colors[xl$Species])
  
  for (i in seq(1.0, 7.0, 0.1)) {
    for (j in seq(0.1, 2.5, 0.1)) {
      u <- c(i, j)
      cl <- kwNN(sortObjByDist(xl, u),u ,6,0.5)
      points(i, j, pch = 21, col = colors[cl])
    }
  }
} 
xl <- iris[, 3:5]

#k <- loo(xl, dim(xl)[1])
#u <- c(3.5, 1)
#knnPlot(k, u)

classiFicationMap(xl)

