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
  m <- c("1" = 0, "2" = 0)
  xl <- sortObjByDist(xl, u)
  l<- dim(xl)[1]
  n <- dim(xl)[2] 
  classes <- xl[1:l, n ]
  for(i in i:k)
  {
    w <- q ^ i
    m[classes[i]] <- m[classes[i]]+w
  }
  mainClass <- names(which.max(m))
  return (mainClass)
}
xl <- matrix(NA, l, 3)
xl[1,1] <- 0.3
xl[1,2] <- 0.3
xl[1,3] <- 1

xl[2,1] <- 1
xl[2,2] <- 0.3
xl[2,3] <- 1

xl[3,1] <- 4
xl[3,2] <- 6
xl[3,3] <- 2

xl[4,1] <- 3
xl[4,2] <- 7
xl[4,3] <- 2

xl[5,1] <- 2
xl[5,2] <- 6.5
xl[5,3] <- 2


u <- c(2.5,5)
colors <- c("1" = "red", "2" = "green")
sortx <- sortObjByDist(xl,c(2,3),q = evcliDestance )
cl <-knn(sortx, u, k = 6)
plot(xl, pch = 20, bg = colors[xl[,3]], col = colors[xl[,3]], asp = 1)
points(u[1], u[2], pch = 21, bg = colors[cl], asp = 1)

