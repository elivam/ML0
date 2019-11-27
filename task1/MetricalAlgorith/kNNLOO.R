
#'LOO       
#' вход : 
#' Xl: matrix 
#'     обучающая выборка, на последнем месте метка класса
#' k:  кол-во соседей
#'     определять кол-во требуемых соседей по LOO для оптимальности алгоритма 
#' @return k, при котором наименьшая ошибка допускается

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
knn <- function(sortXl,u ,k, q = evcliDestance){
  n <- dim(sortXl)[2] 
  # в classes хранятся классы
  classes <- sortXl[1:k, n]
  counts <- table(classes)
  mClass <- names(which.max(counts))
  
  return (mClass)
}
#' 1. идем по всей выборке
#' 2. result = получаем i-й объект и его класс реальный
#' 3. kNNclass = класс выписанный алгоритмом  
#' 4. если knnClass != result то loo++ 
#' 5. loo/длина выборки
loo <- function(xl, k){
  l <- dim(xl)[1] 
  n <- dim(xl)[1] - 1
  
  K<-c(0,k)
  LOO<-rep(0,k)
  o<-c(0,k)
  for(i in 1:l)
  {
    z<-c(xl[i,1],xl[i,2])
    x<-sortObjectsByDist(xl[, 1:3][-i,], z)
    
    for(j in 1:k)
    {
      class<-knn(x,z,k=j)
      if(class != xl[i,3])LOO[j]<-LOO[j]+1
    }
  }
  for (i in 1:k)
  {
    K[i]<-i
    o[i]<-LOO[i]/l
  }
  m <- min(loo,na.rm = FALSE)
  w <- which.min(o)
  
  print(w)
  print(m)
  plot(K,loo,type = "l",xlab = "Значения k, №", ylab = "Значения LOO, %",
       main = "Минимальная ошибка kNN")
  points( w, m,lty="solid", pch = 21, bg = "green", asp = 1)
  text(w, m + 0.2 , labels = (paste("min k = ", w)) )
}



loo(iris[,3:5], 150)


