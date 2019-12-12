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
      numericInput("sigama1", "элемент [1,1] ковариационной матрица первого класса:", 2,min = 1,max=30, width = '400px'),
      numericInput("sigama2", "элемент [2,2] ковариационной матрица первого класса:", 2,min = 1,max=30, width = '400px')
      
    ),
    mainPanel(
      HTML("<center><h1><b>Линейный дискриминант Фишера</b></h1>"),
      HTML("<img src=\" https://sun9-61.userapi.com/c857024/v857024200/19344/AZPCxAUgZ-E.jpg\">"),
      plotOutput(outputId = "plot", height = "500px"),
      HTML("<h4>Уравнение разделяющей поверхности</h4>"),
      HTML("<img src=\"https://sun9-16.userapi.com/c857724/v857724200/11558a/r5NmEOthxuY.jpg\">"),
      HTML("<h4>Восстановленная ковариационная матрица для классов</h4>"),
      textOutput(outputId = "covMessage1"),
      textOutput(outputId = "covMessage2"),
      HTML("<h4>Восстановленный центр нормального распределения для первого класса</h4>"),
      textOutput(outputId = "Mu1"),
      HTML("<h4>Восстановленный центр нормального распределения для второго класса</h4>"),
      textOutput(outputId = "Mu2")
    )
  )
)

server <- function(input, output) {
  
  output$plot = renderPlot ({
    restorMu <- function(objects)
    {
      ## mu = 1 / m * sum_{i=1}^m(objects_i)
      rows <- dim(objects)[1]
      cols <- dim(objects)[2]
      mu <- matrix(NA, 1, cols)
      for (col in 1:cols)
      {
        mu[1, col] = mean(objects[,col])
      }
      return(mu)
    }
    ## Восстановление ковариационной матрицы нормального распределения
   
    restorCovarianceMatrix <- function(objects1,objects2, mu1, mu2)
    {
      rows1 <- dim(objects1)[1]
      rows2 <- dim(objects2)[1]
      rows <- rows1 + rows2
      cols <- dim(objects1)[2]
      sigma <- matrix(0, cols, cols)
      for (i in 1:rows1)
      {
        sigma <- sigma + (t(objects1[i,] - mu1) %*%
                            (objects1[i,] - mu1)) / (rows + 2)
      }
      for (i in 1:rows2)
      {
        sigma <- sigma + (t(objects2[i,] - mu2) %*%
                            (objects2[i,] - mu2)) / (rows + 2)
      }
      return (sigma)
    }
    ## Генерируем тестовые данные
    Sigma <- matrix(c(input$sigama1, 0, 0, input$sigama2), 2, 2)
    Mu1 <- c(input$m1, 0)
    Mu2 <- c(input$m2, 0)
    xy1 <- mvrnorm(n=input$NumberOfSamples1, Mu1, Sigma)
    xy2 <- mvrnorm(n=input$NumberOfSamples2, Mu2, Sigma)
    ## Собираем два класса в одну выборку
    xl <- rbind(cbind(xy1, 1), cbind(xy2, 2))
    ## Рисуем обучающую выборку
    colors <- c("#6699CC", "#FF9966")
    plot(xl[,1], xl[,2], pch = 21, bg = colors[xl[,3]], asp =  1)
    ## Оценивание
    objectsOfFirstClass <- xl[xl[,3] == 1, 1:2]
    objectsOfSecondClass <- xl[xl[,3] == 2, 1:2]
    
    
    getRiskLDF <- function(mu1, mu2, sigma) {
      minusM <- mu1 - mu2
      m <- minusM %*% solve(sigma) %*% t(minusM)
      m <- m * -0.5
      res <- gausian(m, 0, 1)
    }
    
    getCoefLDF <- function(mu1,mu2,sigma)
    {
      invsigma <- solve(sigma)
      
      b <- invsigma %*% t(mu1) - invsigma %*% t(mu2)
      D <- -2*b[1,1]
      E <- -2*b[2,1]
      
      F <- c(mu1 %*% invsigma %*% t(mu1) - mu2 %*% invsigma %*% t(mu2))
      
      func <- function(x, y) {
        x*D + y*E + F
      }
      return(c("x" = D, "y" = E,"f"= F ))
    }
    getCoefLDFfunction <- function(mu1,mu2,sigma)
    {
      invsigma <- solve(sigma)
      
      b <- invsigma %*% t(mu1) - invsigma %*% t(mu2)
      D <- -2*b[1,1]
      E <- -2*b[2,1]
      
      F <- c(mu1 %*% invsigma %*% t(mu1) - mu2 %*% invsigma %*% t(mu2))
      
      func <- function(x, y) {
        x*D + y*E + F
      }
      return(func)
    }
    Gaus <- function(x, mu, sigma){
      return( (1/(sigma*sqrt(2*pi))) * exp(-(x - mu)^2/2*sigma^2) )
    }
    a <-function(xl,mu1,mu2, sigma,lamda1,P1,lamda2,P2){
      l <- log(lamda1*P1) - log(lamda2 * P2)
      cff <- getCoefLDF(mu1, mu2, sigma)
      if (l+ cff["x"]*xl[1]
          + cff["y"]*xl[2] 
          + cff["f"] < 0){
        class <- 1
      }
      else  class <- 2
      return (class)
    }
    
    
    output$covMessage1 = renderText({
      paste(round(sigma[1], digits = 3),round(sigma[2], digits = 3),sep=" ")
    })
    output$covMessage2 = renderText({
      paste(round(sigma[3], digits = 3),round(sigma[4], digits = 3),sep=" ")
    })  
    output$Mu1 = renderText({
      paste(round(mu1, digits = 3),sep=" ")
    }) 
    output$Mu2 = renderText({
      paste(round(mu2, digits = 3),sep=" ")
    }) 
    mu1 <- restorMu(xy1)
    mu2 <- restorMu(xy2)
    
    sigma <-restorCovarianceMatrix(xy1,xy2,mu1,mu2)
    
    x <- seq(-20, 20, len = 300)
    y <- seq(-20, 20, len = 300)
    
    cff <- getCoefLDF(mu1, mu2, sigma)
    
    z <- outer(x, y, function(x, y) cff["x"]*x + cff["y"]*y + cff["f"])
    print(z)
    contour(x, y, z, levels=0, drawlabels=FALSE, lwd = 2, col = "#FF3300", add = TRUE)
    
    if(input$cl){
      x1 <- -10
      
      colors <- c("#6699CC", "#FF9966")
      while(x1 < 30){
        x2 <- -10
        while (x2< 10){
          x <- c(x1,x2)
          class <- a(x,mu1,mu2, sigma,1,0.5,2,0.5)
          print(class)
          points(x1, x2, pch = 21, col=colors[class], asp = 1)
          x2 <- x2 +0.4
        }
        x1 <- x1 +0.4 
      }
      
    }
    
  })
}
# Run the application 
shinyApp(ui = ui, server = server)


