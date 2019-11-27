
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

looFromQ <- function(xl, k){
  n<-dim(xl)[1]
  LOO<-rep(0,n)
  K<-seq(0.05,1,length.out = 20)
  accuracy<-c(0,n)
  for(i in 1:n)
  {
    z<-c(xl[i,1],xl[i,2])
    
    x<-sortObjectsByDist(xl[, 1:3][-i,], z)
    
    for(j in 1:20)
    {
      class<-kwNN(x,z,k=19,K[j])
      if(class != xl[i,3])LOO[j]<-LOO[j]+1
    }
  }
  for (i in 1:20)
  {
    accuracy[i]<-LOO[i]/n
  }
  
  m <- min(accuracy,na.rm = FALSE)
  w <- which.min(accuracy) 
  t <- K[w]
  
  print(m)
  print(t)
  
  plot(K,accuracy,type = "l",xlab = "Значения q", ylab = "Значения LOO, %",
       main = "Поиск оптимального q")
  points( t, m,lty="solid", pch = 21, bg = "green", asp = 1)
  text(t+ 0.1, m ,  labels = (paste("min q = ", t)) )
}


u<-c(1,2)
looFromQ(iris[,3:5], 6)
#looFromK(iris[sample(1:150,30),3:5], 0.6)

