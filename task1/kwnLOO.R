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
#нужно оптимизировать значение q
loo <- function(xl, k, q){
  l <- dim(xl)[1] 
  n <- dim(xl)[1] - 1
  
  K<-c(0,k)
  LOO<-rep(0,k)
  loo<-c(0,k)
  for(i in 1:l)
  {
    z<-c(xl[i,1],xl[i,2])
    x<-sortObjectsByDist(xl[, 1:3][-i,], z)
    #мы знаем что q изменяется от 0 до 1
    for(j in 1:k)
    {
      class<-kwnn(x,z,k=j,q)
      if(class != xl[i,3])LOO[j]<-LOO[j]+1
    }
  }
  for (i in 1:k)
  {
    K[i]<-i
    loo[i]<-LOO[i]/l
  }
  m <- min(loo,na.rm = FALSE)
  w <- which.min(loo)
  
  print(w)
  print(m)
  plot(K,loo,type = "l",xlab = "Значения k, №", ylab = "Значения LOO, %",
       main = "Минимальная ошибка kNN")
  points( w, m,lty="solid", pch = 21, bg = "green", asp = 1)
  text(w, m + 0.2 , labels = (paste("min k = ", w)) )
}