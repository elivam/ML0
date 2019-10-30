x <- 2
y <- 0
mu <- 3

  
sigma = matrix(c(x, y, y, mu), 2, 2)  
NormDistribution <- function(x, y, mu, sigma) {
  x = matrix(c(x, y), 1, 2)
  n = 2
  k = 1 / sqrt((2 * pi) ^ n * det(sigma))
  e = exp(-0.5 * (x - mu) %*% solve(sigma) %*% t(x - mu))
  return (k * e)
}

zfunc <- function(x, y) {
  sapply(1:length(x), function(i) NormDistribution(x[i], y[i], mu, sigma))
}

z <- outer(x, y, zfunc)
draw  <- function(x,y,mu,sigma){
  sigma <- matrix(c(x, y, y, mu), 2, 2) 
  minX <- -sigma[1, 1] - 2
  maxX <- sigma[1, 1] + 2
  minY <- -sigma[2, 2] - 2
  maxY <- sigma[2, 2] + 2
  
  x = seq(minX, maxX, len=100)
  y = seq(minY, maxY, len=100)
  z <- outer(x, y, zfunc)
  plot(0, 0,ylim = c(-1,5),xlim = c(-1,5) ,type = "n",  xlab = "", ylab = "")
  add = FALSE
  for (level in seq(0, 0.2, 1)) {
    col = rgb(level*3+0.4,1-(level*3)-0.2,0)
    contour(x, y, z, drawlabels = TRUE, lwd = 1, col = col, add = add, asp = 1)
    add = TRUE
  }
  
}

 draw(1,0,1,sigma(1,0,1))
minX <- -sigma[1, 1] - 2
maxX <- sigma[1, 1] + 2
minY <- -sigma[2, 2] - 2
maxY <- sigma[2, 2] + 2

x = seq(minX, maxX, len=100)
y = seq(minY, maxY, len=100)
z <- outer(x, y, zfunc)
plot(0, 0,ylim = c(-1,5),xlim = c(-1,5) ,type = "n",  xlab = "", ylab = "")
contour(x, y, z, drawlabels = TRUE, lwd = 1, col = 'blue', add = TRUE, asp = 1)
