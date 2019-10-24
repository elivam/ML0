require("plotrix")

evcliDestance<- function(u, v){    
  sqrt(sum((u - v)^2))  
}
#Функция епанечникова ядра
ker_epanech <- function(r) {
if (abs(r) > 1) {
  return (0)
}
return ((3/4) * (1 - r*r))
}
# Гауссовское
gauss_kernel <- function(r) 
{
  (2*pi)^0.5 * exp(-0.5 * r*r)
}
kR<- function(r) (1 - abs(r)) * (abs(r) <= 1)


sortObjByDist <- function(xl, z, metricFunction =evcliDestance){
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  distances <- matrix(NA, l, 2)
  for (i in 1:l)
  {
    distances[i, ] <- c(i, metricFunction(xl[i, 1:n], z))
  }
  return (distances);
}

potential <- function(xl, z, gamma, h) {
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  distances <- sortObjByDist(xl, z)
  m <- c("setosa" = 0, "versicolor" = 0, "virginica" = 0)
  classes <- xl[1:l, n + 1]
  for(i in 1:l)
  {
    w <- gamma[i]*gauss_kernel(distances[i,2]/h)
    m[classes[i]] <- m[classes[i]]+w
  }
  # if(sum(m) > 0) {
  #    class <- names(which.max(counts))
  # } else {
  #    class <- "no-Class"
  # } 
  return (class)
}

gamma <-function (xl){
  n <- dim(xl)[1]
  print(n)
  h<-1
  gamma<-rep(0,n)
  Error <- 7
  # Q - число ошибок  
  # пока число ошибок на выборке не окажется достаточно мало
  # у меня достаточно мало это 10
  Q <- Error+1
  while(Q > Error)
  {
    t <- 1
    while(t)
    {
      i <- sample(1:n, 1)
      z <- c(xl[i,1],xl[i,2])
      class <- potential(xl,z,gamma,h)
      print(class)
      if(class != xl[i,3]){
        gamma[i] <- gamma[i] + 1
        t <- 0
      }
    }
    Q <- 0
    for(i in 1:n)
    {
      z <- c(xl[i,1],xl[i,2])
      class <- potential(xl,z,gamma,h)
      if(class!=xl[i,3])Q <- Q + 1
    }
  }
  
  return (gamma)
  
}
draw(xl,gamma){
  for(i in 1:n){
    z<-c(xl[i,1],xl[i,2])
    if(gamma[i]>0){
      color<-adjustcolor(colors[xl[i,3]],gamma[i]/E/gammamax)
      draw.circle(z[1],z[2],h,50,border = color, col = color)
    }
  }
}


xl<- iris[, 3:5]
# gam <- gamma(iris[sample(1:30,30), 3:5])
colors <- c("setosa" = "#FFCC33", "versicolor" = "#0033FF",
            "virginica" = "#CC00CC", "no-Class" = "#CCCCFF")

 plot(iris[, 3:4], pch = 20, bg = colors[iris$Species], col = colors[iris$Species], asp = 1)
 # z <- c(4,1)
 # class <- potential(iris[sample(1:150,30), 3:5], z,gam, 0.4)
 # points(z[1], z[2], pch = 21, bg = colors[class], asp = 1)

n <- length(gamma(xl))
gammamax <- max(gamma(xl))
gamma <- gamma(xl)
draw(xl,gamma)


