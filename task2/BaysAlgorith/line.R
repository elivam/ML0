x <- 1
y <- 0
mu <- 1
radius <- 1
  
sigma = matrix(c(x, y, y, mu), 2, 2)  

NormDistribution <- function(x, y, mu, sigma) {
  x <- matrix(c(x, y), 1, 2)
  n <- 2
  k = 1 / sqrt((2 * pi) ^ n * det(sigma))
  e = exp(-0.5 * (x - mu) %*% solve(sigma) %*% t(x - mu))
  return (k * e)
}

zfunc <- function(x, y) {
  sapply(1:length(x), function(i) NormDistribution(x[i], y[i], mu, sigma))
}
#ylim = c(-2,4),xlim = c(-2,4),
  radius <- 3
  
  sigma <- matrix(c(x, y, y,  mu), 2, 2) 
  minX <- -sigma[1, 1] - radius
  maxX <- sigma[1, 1] + radius
  minY <- -sigma[2, 2] - radius
  maxY <- sigma[2, 2] + radius
  
  x <- seq(minX, maxX, len=150)
  y <- seq(minY, maxY, len=150)
  z <- outer(x, y, zfunc)
  # plot(0, 0,ylim = c(-1,4),xlim = c(-1,4) ,type = "n",  xlab = "", ylab = "")
  # contour(x, y, z, drawlabels = TRUE, lwd = 1, col = 'blue', add = TRUE, asp = 1)
  
  add = F
  #plot(0, 0,ylim = c(-2,4),xlim = c(-2,4) ,type = "n",  xlab = "", ylab = "")
   for (level in seq(0.02, 0.2, 0.02)) {
    col = rgb(level*2+0.3,0,1-(level*4)-0.2)
    contour(x, y, z, levels = level, drawlabels = T, lwd = 1, col = col, add = add)
    add = T
   }

