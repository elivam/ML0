library(shiny)
library(MASS)
ui <- fluidPage(
  titlePanel("Изменяемые параметры"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("cl","Отобразить классификацию", FALSE),
      numericInput("NumberOfSamples1", "Количество элементов первого класса:", 150,min = 10,max=500, width = '200px'),
      numericInput("NumberOfSamples2", "Количество элементов второго класса:", 150,min = 10,max=500, width = '200px'),
      numericInput("m1", "μ для первого класса:", 1,min = 1,max=30, width = '200px'),
      numericInput("m2", "μ для второго класса:", 15,min = 1,max=30, width = '200px'),
      numericInput("sigama11forFirst", "элемент [1,1] ковариационной матрица первого класса:", 1,min = 1,max=30, width = '400px'),
      numericInput("sigama22forFirst", "элемент [2,2] ковариационной матрица первого класса:", 9,min = 1,max=30, width = '400px'),
      numericInput("sigama11forSecond", "элемент [1,1] ковариационной матрица второго класса:", 1,min = 1,max=30, width = '400px'),
      numericInput("sigama22forSecond", "элемент [2,2] ковариационной матрица второго класса:", 1,min = 1,max=30, width = '400px')
      
    ),
    mainPanel(
      HTML("<center><h1><b>Подстановочный алгоритм</b></h1>"),
      HTML("<img src=\" https://sun9-47.userapi.com/c857724/v857724200/115572/p3yfcrBKnw4.jpg\">"),
      plotOutput(outputId = "plot", height = "500px"),
      HTML("<h4>Уравнение разделяющей поверхности</h4>"),
      HTML("<img src=\"https://sun9-16.userapi.com/c857724/v857724200/11558a/r5NmEOthxuY.jpg\">"),
      HTML("<h4>Восстановленная ковариационная матрица для первого класса</h4>"),
      textOutput(outputId = "covMessage1"),
      textOutput(outputId = "covMessage2"),
      HTML("<h4>Восстановленный центр нормального распределения для первого класса</h4>"),
      textOutput(outputId = "Mu1"),
      HTML("<h4>Восстановленная ковариационная матрица для второго класса</h4>"),
      textOutput(outputId = "covMessage12"),
      textOutput(outputId = "covMessage22"),
      HTML("<h4>Восстановленный центр нормального распределения для второго класса</h4>"),
      textOutput(outputId = "Mu2")
    )
  )
)
## Восстановление центра нормального распределения
restorMu <- function(obj) {
  cols <- dim(obj)[2]
  mu <- matrix(NA, 1, cols)
  for (i in 1:cols) {
    mu[1, i] <- mean(obj[, i])
  }
  return(mu)
}
## Восстановление ковариационной матрицы нормального распределения

restorCovMatrix <- function(obj, mu) {
  rows = dim(obj)[1]
  cols = dim(obj)[2]
  covar = matrix(0, cols, cols)
  for (i in 1:rows) {
    covar = covar + (t(obj[i,] - mu) %*% (obj[i,] - mu)) / (rows - 1)
  }
  return(covar)
}
## Получение коэффициентов подстановочного алгоритма
CoeffPlugIn <- function(mu1, sigma1, mu2, sigma2)
{
  invSigma1 <- solve(sigma1)
  invSigma2 <- solve(sigma2)
  f <- log(abs(det(sigma1))) - log(abs(det(sigma2))) +
    mu1 %*% invSigma1 %*% t(mu1) - mu2 %*% invSigma2 %*% t(mu2);
  alpha <- invSigma1 - invSigma2
  a <- alpha[1, 1] #x1^2
  b <- 2 * alpha[1, 2] #x1*x2
  c <- alpha[2, 2] #x2
  beta <- invSigma1 %*% t(mu1) - invSigma2 %*% t(mu2)
  d <- -2 * beta[1, 1] #x1
  e <- -2 * beta[2, 1] #x2
  return (c("x^2" = a, "xy" = b, "y^2" = c, "x" = d, "y"= e, "f" = f))
}
NormDist <-function(xl,mu, sigma,lamda,p){
  r <- log(p * lamda)
  l <- length(xl)
  print(xl)
  print(mu)
  print(sigma)      
  chisl <- exp(
    (-1/2)*(
      t(xl-as.vector(mu)) %*% solve(sigma) %*% (xl-as.vector(mu))
    )
  )
  res <-  chisl/((2*pi) * det(sigma)^(1/2))
  
  return(res)
}
plugInAlgo <- function(x, y, mu1, mu2, sigma1,sigma2, lamda, p){
  r1 <- log(p[1] * lamda[1])
  r2 <- log(p[2] * lamda[2])
  l <- length(xl)
  res1 <- NormDist(c(x, y), mu1, sigma1, lamda[1], p[1])
  res2 <- NormDist(c(x, y), mu2, sigma2, lamda[2], p[2])
  class <- ifelse(res1 > res2, 1, 2)
  return (class)
}

server <- function(input, output) {
  
  output$plot = renderPlot ({
    
    CountForFirst <- input$NumberOfSamples1
    CountForSecond <- input$NumberOfSamples2
    
    m1 <- input$m1
    m2 <- input$m2
    sigama11forFirst <- input$sigama11forFirst
    sigama22forFirst <- input$sigama22forFirst
    sigama11forSecond <- input$sigama11forSecond
    sigama22forSecond <- input$sigama22forSecond
    

    Sigma1 <- matrix(c(sigama11forFirst, 0, 0, sigama22forFirst), 2, 2)
    Sigma2 <- matrix(c(sigama11forSecond, 0, 0, sigama22forSecond), 2, 2)
    Mu1 <- c(m1, 0)
    Mu2 <- c(m2, 0)
    xy1 <- mvrnorm(n=CountForFirst, Mu1, Sigma1)
    xy2 <- mvrnorm(n=CountForSecond, Mu2, Sigma2)
    xl <- rbind(cbind(xy1, 1), cbind(xy2, 2))
    colors <- c("#FF66FF", "#3399CC")
    plot(xl[,1], xl[,2], pch = 21, bg = colors[xl[,3]], asp = 1)
    
    ## Оценивание
    objectsOfFirstClass <- xl[xl[,3] == 1, 1:2]
    objectsOfSecondClass <- xl[xl[,3] == 2, 1:2]
    mu1 <- restorMu(objectsOfFirstClass)
    mu2 <- restorMu(objectsOfSecondClass)
    # m <- c(m1,m2)
    sigma1 <- restorCovMatrix(objectsOfFirstClass,mu1)
    sigma2 <- restorCovMatrix(objectsOfSecondClass,mu2)
    
    output$covMessage1 = renderText({
      paste(round(sigma1[1], digits = 3),round(sigma1[2], digits = 3),sep=" ")
    })
    output$covMessage2 = renderText({
      paste(round(sigma1[3], digits = 3),round(sigma1[4], digits = 3),sep=" ")
    }) 
    
    output$Mu1 = renderText({
      paste(round(mu1, digits = 3),sep=" ")
    }) 
    output$Mu2 = renderText({
      paste(round(mu2, digits = 3),sep=" ")
    })
    
    output$covMessage12 = renderText({
      paste(round(sigma2[1], digits = 3),round(sigma2[2], digits = 3),sep=" ")
    })
    output$covMessage22 = renderText({
      paste(round(sigma2[3], digits = 3),round(sigma2[4], digits = 3),sep=" ")
    })
    
    ## Отображение дискриминантной кривой
    cff <- CoeffPlugIn(mu1, sigma1, mu2, sigma2)
    x <- y <- seq(-20, 20, len <- 100)
    p <- 1
    lamd <- 1
    l <- log(p * lamd)
    
    ## проверка значений
    # cff <- CoeffPlugIn(mu1, Sigma1, mu2, Sigma2)
    # w <- input$w
    # o <- input$o
    # l <- log(1*0.5) - log(2 * 0.5)
    # print(l+ cff["x^2"]*w*w
    #           + cff["xy"]*w*o 
    #           + cff["y^2"]*o*o 
    #           + cff["x"]*w+ cff["y"]*o 
    #           + cff["f"] )
    # 
    x <- seq(-20, 30, len = 100)
    y <- seq(-20, 20, len = 100)
    cff <- CoeffPlugIn(mu1, sigma1, mu2, sigma2)
    print(cff["x^2"]*(-20)*(-20))
    z <- outer(x, y, function (x, y)  cff["x^2"]*x*x 
               + cff["xy"]*x*y + cff["y^2"]*y*y + cff["x"]*x
               + cff["y"]*y + cff["f"])
    contour(x, y, z, levels=0, drawlabels=FALSE, lwd = 2, col = "#FF3300", add = TRUE)
    print(1)
    
    if(input$cl){
      x1 <- -10
      
      colors <- c("#FF66FF", "#3399CC")
       # x <- seq(-10, 30, 40/80)
       # y <- seq(-10, 10, 40/80)
       
       for (i in x) {
         for (j in y) {
           x <- c(i, j)
           m <- c(mu1, mu2)
           sigma <- c(Sigma1, Sigma2)
           p <- c(1, 1)
           lamda <- c(1, 1)
           class <- plugInAlgo(i, j, mu1, mu2, sigma1,sigma2 , lamda, p) 
           points(i, j, pch = 21, col = colors[class])
         }
       }
      
      # while(x1 < 30){
      #     x2 <- -10
      #     while (x2< 10){
      #      
      #     res1 <- NormDist(c(x1, x2), mu1, sigma1, 1, 1)
      #     res2 <- NormDist(c(x1, x2), mu2, sigma2, 1, 1)
      #     color <- ifelse(res1 > res2, "#FF66FF", "#3399CC")
      # 
      #     points(x1, x2, pch = 21, col=colors[class], asp = 1)
      #     x2 <- x2 +0.4
      #     }
      #    x1 <- x1 +0.4
      #  }
      
    }
    
  })
}
shinyApp(ui = ui, server = server)