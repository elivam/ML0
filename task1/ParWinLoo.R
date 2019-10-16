 evcliDestance <- function (x, u){
   return (sqrt(sum((x - u)^2)))
 }
 
 sortObjByDist <- function(xl, u) {
    l <- dim(xl)[1]
    n <- dim(xl)[2] - 1
    # формируем матрицу расстояний состоящую из индекса и расстояния евклида из выборки для некоторой точки
    distances <- matrix(NA, l, 2)
    for (i in 1:l) {
       distances[i, ] <- c(i, evcliDestance(xl[i, 1:n], u))
    }
    
    # сортируем по расстоянию
    orderedXl <- xl[order(distances[, 2]), ]
    return (orderedXl <- cbind(orderedXl, evcliDestance = sort(distances[, 2], decreasing = FALSE)))
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
    return (2*pi)^(1/2) * exp((-1/2) * (dist / h)^2)
 }
 
 parzen_window <- function(xl, u, h, kerFunc) {
   l <- dim(xl)[1]
   orderedXl <- sortObjByDist(xl, u)
   n <- dim(orderedXl)[2] - 1
   classes <- orderedXl[1:l, n]
   
   counts <- table(orderedXl[0, 3])
  
   for (i in 1:l) {
     counts[classes[i]] <- counts[classes[i]] + kerFunc(orderedXl[i, 4], h)
   }
   
   class <- names(which.max(counts))
   return(class)
}
 #parzen_window(iris[,3:5], c(1,1), 0.4, ker_quar)
 
 
 loo <- function(xl, kerFunc) {
   l <- dim(xl)[1]
   Hseq <- seq(0.1, 5, 0.15)
   hLooArray <- array(0, length(Hseq))
   j <- 1
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
   
   View(hLooArray)
   plot(Hseq, hLooArray, xlab = "h", ylab = "LOO(h)", type = "l")
   
   minLoo <- which.min(hLooArray)
   looDataFrame <- data.frame(Hseq, hLooArray)
   minH <- looDataFrame[which.min(looDataFrame$hLooArray),]
   
   #print(minLoo)
   print(minH)
   # for (i in 1:length(hLooArray)){
      # if(hLooArray[i] = minH[3]){
       #   print(hLooArray[i])
         points(minH, pch=21, bg="green")
          
}
 #LooforKer <- loo(iris[sample(1:150,10),3:5], kerFunc <-  ker_rect)
 LooforKer <- loo(iris[,3:5], kerFunc <-  gauss_kernel)
 

