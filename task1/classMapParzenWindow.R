euclidDist <- function (x, u){
  return (sqrt(sum((x - u)^2)))
}

sortObjByDist <- function(xl, u) {
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  # формируем матрицу расстояний состоящую из индекса и расстояния евклида из выборки для некоторой точки
  distances <- matrix(NA, l, 2)
  for (i in 1:l) {
    distances[i, ] <- c(i, euclidDist(xl[i, 1:n], u))
  }
  
  # сортируем по расстоянию
  orderedXl <- xl[order(distances[, 2]), ]
  return (orderedXl <- cbind(orderedXl, euclidDist = sort(distances[, 2], decreasing = FALSE)))
}

#Фукция прямоугольного ядра
ker_rect <- function(d, h) {
  if(abs(d / h) <= 1) {
    return (1 / 2)
  } else {
    return(0)
  }
}

#Функция епанечникова ядра
ker_epanech<- function(d, h) {
  if(abs(d / h) <= 1) {
    return(3 / 4 * (1 - (d / h)^2))
  } else {
    return(0)
  }
}

#Функция квадратического ядра
ker_quar <- function(d, h) {
  if(abs(d / h) <= 1) {
    return(15 / 16 * (1 - (d / h)^2)^2)
  } else {
    return(0)
  }
}

#Функция треугольного ядра
triang_kernel <- function(d, h) {
  if(abs(d / h) <= 1) {
    return(1 - abs(d / h))
  } else {
    return(0)
  }
}

#Функция гауссовского ядра
gauss_kernel <- function(dist, h) {
  return (2*pi)^(1/2) * exp((-1/2) * (dist / h)^2)
}

parzen_window <- function(xl, u, h, kerFunc) {
  l <- dim(xl)[1]
  orderedXl <- sortObjectsByDist(xl, u)
  n <- dim(orderedXl)[2] - 1
  classes <- orderedXl[1:l, n]
  
  counts <- table(orderedXl[0, 3])
  
  for (i in seq(1:l)) {
    counts[classes[i]] <- counts[classes[i]] + kerFunc(orderedXl[i, 4], h)
  }
  
  if(class==0)class<-"not-class"
  else  
  class <- names(which.max(counts))
 
  
  if(sum(counts) > 0) {
    class <- names(which.max(counts))
  } else {
    class <- "no-Class"
  } 
  return(class)
}

classificationMapParzenWind <- function(xl, h, kernelFunc) {
  colors <- c("setosa" = "#FFCC33", "versicolor" = "#0033FF",
              "virginica" = "#CC00CC" ,"no-Class" = "#CCCCFF")
  plot(xl[1:2], pch = 21, col = colors[xl$Species], bg = colors[xl$Species])
  
  for (i in seq(1.0, 7.0, 0.1)) {
    for (j in seq(0.1, 2.5, 0.1)) {
      u <- c(i, j)
      class <- parzen_window(xl, u, h, kernelFunc)
      points(i, j, pch = 21, col = colors[class])
    }
  }
}

classificationMapParzenWind(iris[sample(1:150,30),3:5], 0.4,ker_quar)

