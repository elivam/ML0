x<-2
mu<-0
y<-1


sigma = matrix(c(x, mu, mu, y), 2, 2)

norm = function(x, y, mu, sigma) {
  x = matrix(c(x, y), 1, 2)
  n = 2
  k = 1 / sqrt((2 * pi) ^ n * det(sigma))
  e = exp(-0.5 * (x - mu) %*% solve(sigma) %*% t(x - mu))
  k * e
}
zfunc <- function(x, y) {
  sapply(1:length(x), function(i) norm(x[i], y[i], mu, sigma))
}



minX = -sigma[1, 1] - 2
maxX = sigma[1, 1] + 2
minY = -sigma[2, 2] - 2
maxY = sigma[2, 2] + 2

x = seq(minX, maxX, len=200)
y = seq(minY, maxY, len=200)
z = outer(x, y, zfunc)

add = F
for (level in seq(0.02, 0.2, 0.02)) {
  col = rgb(level*3+0.4,1-(level*3)-0.2,0)
  contour(x, y, z,asp= 1)
  # contour(x, y, z, levels = level, drawlabels = T, lwd = 1, col = col, add = add, asp = 1)
  add = T
}

