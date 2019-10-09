evcliDestance <- function (x, u){
  return (sqrt(sum((x - u)^2)))
}

sortObjByDist <-function(xl, u,q = evcliDestance){
  l <- dim(xl)[1] #кол-во строк 
  n <- dim(xl)[2] - 1 #кол-во признаков
  # в общем у xl 3 признака , х - координата , у - координата и третий - класс
  # cl - это класс точки из выборки 
  
  dist <- matrix(NA, l, 2)
  for (i in 1:l) {
    dist[i, ] <- c(i, q(xl[i, 1:n],u)) 
  }
  sortXl <- xl[order(dist[, 2]), ]
  
  return(sortXl)
}

#Фукция прямоугольного ядра
ker_rect <- function(dist, h) {
  if(abs(dist / h) <= 1) {
    return (1 / 2)
  } else {
    return(0)
  }
}

#Функция епанечникова ядра
ker_epanech<- function(dist, h) {
  if(abs(dist / h) <= 1) {
    return(3 / 4 * (1 - (dist / h)^2))
  } else {
    return(0)
  }
}

#Функция квадратического ядра
ker_quar <- function(dist, h) {
  if(abs(dist / h) <= 1) {
    return(15 / 16 * (1 - (dist / h)^2)^2)
  } else {
    return(0)
  }
}

#Функция треугольного ядра
triang_kernel <- function(dist, h) {
  if(abs(dist / h) <= 1) {
    return(1 - abs(dist / h))
  } else {
    return(0)
  }
}

#Функция гауссовского ядра
gauss_kernel <- function(dist, h) {
  if(abs(dist / h) <= 1) {
    return((2 * pi)^((-1 / 2) * exp(-1 / 2 * (dist / h)^2)))
  } else {
    return(0)
  }
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
  
  class <- names(which.max(counts))
  return(class)
}



loo <- function(xl, kerFunc) {
  l <- dim(xl)[1]
  hLooArray <- array(0, length(seqH))
  j <- 1
  Hseq <- seq(0.1, 5, 0.1)
  for(h in Hseq) {
    cnt <- 0
    for(i in 1:l) {
      u <- c(xl[i, 1], xl[i, 2])
      x <- xl[-i, 1:3]
      class <- parzen_window(x, u, h, kerFunc)
      
      if(xl[i, 3] != class) {
        cnt <- cnt + 1
      }
    }
    hLooArray[j] <- cnt / l
    j <- j + 1
    print(j)
  }

  plot(Hseq, hLooArray, xlab = "h", ylab = "LOO(h)", type = "l")
  
  looDataFrame <- data.frame(Hseq, hLooArray)
  minH <- looDataFrame[which.min(looDataFrame$hLooArray),]
  print(minH)
  points(minH, pch=21, bg="red")
}

loo(iris[,3:5],ker_rect)

