library(shiny)
library(MASS)
require("plotrix")

ui <- fluidPage(
  titlePanel("Изменяемые параметры"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("class1","Отобразить промежуточные линии для ADALINE", FALSE),
      checkboxInput("classMap1","Отобразить карту классификации для ADALINE", FALSE),
      checkboxInput("class2","Отобразить промежуточные линии для правила Хебба", FALSE),
      checkboxInput("classMap2","Отобразить карту классификации для правила Хебба", FALSE),
      checkboxInput("class3","Отобразить промежуточные линии для логистической регрессии", FALSE),
      checkboxInput("classMap3","Отобразить карту классификации для логистической регрессии", FALSE),
      numericInput("NumberOfSamples1", "Кол-во элементов первого класса:", 150,min = 1,max=500, width = '200px'),
      numericInput("NumberOfSamples2", "Кол-во элементов второго класса:", 150,min = 1,max=500, width = '200px'),
      numericInput("mu1", "μ для первого класса", 1,min=1,max=10, width = '200px'),
      numericInput("mu2", "μ для второго класса", 4,min=1,max=10, width = '200px'),
      # checkboxInput("vib","Выборка не меняется", FALSE),
      numericInput("sigma11", "Элемент[1][1] ковариационной матрицы для первого класса", 2,min=1,max=20, width = '400px'),
      numericInput("sigma12", "Элемент[2][2] ковариационной матрицы для первого класса", 2,min=1,max=20, width = '400px'),
      numericInput("sigma21", "Элемент [1][1] ковариационной матрицы для второго класса", 2,min=1,max=20, width = '400px'),
      numericInput("sigma22", "Элемент [2][2] ковариационной матрицы для второго класса", 2,min=1,max=20, width = '400px')
      
    ),  
    # Show a plot of the generated distribution
    mainPanel(
      HTML("<center><h1><b>ADALine and Hebb and LogReg</b></h1>"),
      h3(textOutput("label")),
      # textOutput(outputId = "covMessage22"),
      plotOutput(outputId = "plot", height = "700px"),
        tags$h2("Адаптивный линейный элемент", style = "color: #FF0000"),
        plotOutput(
          outputId = "q1",
          height =  "300px",
        ),
        tags$h2("Правило Хебба", style = "color: #006633"),
        plotOutput(
          outputId = "q2",
          height =  "300px",
        ),
        tags$h2("Логистическая регрессия", style = "color: #660099"),
        plotOutput(
          outputId = "q3",
          height =  "300px",
        )
    )
  )
)


server <- function(input, output) {
  
  output$plot = renderPlot ({
    #нормализуем функцию потерь
    normalize = function(points) {
      for (i in 1:dim(points)[2]) {
        points[, i] = (points[, i] - min(points[, i])) / (max(points[, i]) - min(points[, i]))
      }
      return(points)
    }
    ## Квадратичная функция потерль для ADALINE
    AdalLoss <- function(m) {
     return (1 - m) ^ 2
    }
    AdaUpdateW = function(w, eta, xi, yi){
      wx <- c(crossprod(w, xi))
      Sum <- eta * (wx - yi) * xi
      return (w - Sum)
    }
    
    HebbLoss <- function(m) {
      return (max(-m, 0))
    }  
    
    HebbUpdateW <- function(w, eta, xi, yi) {
      return (w + eta * yi * xi)
    }
    
    sigmoid <- function(z) {
     return ( 1 / (1 + exp(-z)))
    }
    
    RegLoss <- function(m) {
      return (log2(1 + exp(-m)))
    }
    
    RegUpdateW <- function(w, eta, xi, yi) {
      return (w + eta * xi * yi * sigmoid(-sum(w * xi) * yi))
    }
    
    drawPoints = function(x) {
      colors = c("#FFFF00", "#FF3333", "#FF9999")
      for(i in 1:dim(x)[1]) x[i,3] = x[i,3] + 2
      plot(x[, 1], x[, 2], pch = 21, col = "darkred", bg = colors[x[,3]],
            asp = 1, xlab = "X", ylab = "Y")
    }
    
    
    ## Стохастический градиент
    sgd = function(xl, classes, L, updateRule, drawIters=FALSE, ost=FALSE, eps=1e-5,it = 1000, c =  color) {
      rows = dim(xl)[1]
      xl = cbind(xl,seq(from=-1,to=-1,length.out=rows))
      cols = dim(xl)[2]
      w = runif(cols, -1 / (2 * cols), 1 / (2 * cols))
      lambda <- 1 / rows
      
      Q <- 0
      for (i in 1:rows) {
        Q = Q + L(sum(w * xl[i,]) * classes[i])
      }  
      Q0 <- Q
      
      iter = 0
      repeat {
        iter = iter + 1
        
        margins = rep(0, rows)
        for (i in 1:rows) {
          xi = xl[i,]
          yi = classes[i]
          margins[i] = sum(w * xi) * yi
        }
        ## выбираем объекты проклассифицированные с ошибкой
        errors <- which(margins <= 0)
        i <- sample(errors, 1)
        xi <- xl[i, 1:cols]
        # eta <- 1 / sqrt(sum(xi * xi))
        eta <- 1/6
        print (eta)
        
        if (length(errors) == 0 && ost == TRUE) {
          return(w)
        }
        
        if(length(errors) != 0){
          rnd_err = sample(errors, 1)
        } 
        else{ 
          rnd_err = sample(1:rows, 1)
        }
        
        xi = xl[rnd_err,]
        yi = classes[rnd_err]
        
        wn <- c(crossprod(w, xi))
        margin = sum(w * xi) * yi
        error = L(margin)
        
        w = updateRule(w, eta, xi, yi)
        
        Q = (1 - lambda) * Q + lambda * error
        if (abs(Q0 - Q) / abs(max(Q0, Q)) < eps) break;
        Q0 = Q
        if (iter == it)  break;
        if(drawIters) {
          drwLine(w, color)
        }
      }
      return(w)
    }
    drawGrad = function(data, reg){
      p = function(x,y,w) sigmoid(x*w[1]+y*w[2]-w[3])-sigmoid(-x*w[1]-y*w[2]+w[3])
      P = matrix(0, 100, 100)
      for(i in seq(from=0, to=1, by=0.1)){
        for(j in seq(from=0, to=1, by=0.1)){
          P[i*10+1,j*10+1] = p(i,j,reg)
        }
      }
      k = 1/max(max(P), -min(P))
      for(i in seq(from=0, to=1, by=0.05)){
        for(j in seq(from=0, to=1, by=0.05)){
          pp = p(i,j,reg)
          if(pp>0){
            color = adjustcolor("#FF9999",pp*k)
            draw.circle(i, j, 0.045, 4, border = color, col = color)
          }
          if(pp<0){
            color = adjustcolor("#FFFF00",-pp*k)
            draw.circle(i, j, 0.045, 4, border = color, col = color)
          } 
        }
      }
    }
    
    drwLine = function(w, color) {
      abline(a = w[3] / w[2], b = -w[1] / w[2], lwd = 2, col = color)
    }
    
    n1 = input$NumberOfSamples1
    n2 = input$NumberOfSamples2
    
    covar1 = matrix(c(input$sigma11, 0, 0, input$sigma12), 2, 2)
    covar2 = matrix(c(input$sigma21, 0, 0, input$sigma22), 2, 2)
    
    mu1 = c(input$mu1, 0)
    mu2 = c(input$mu2, 0)
    ind <- round(cbind(mu1,mu2,covar1[,1],covar1[,2],covar2[,1],covar2[,2]),1)
    imu1 <- matrix(mu1,2,1)
    imu2 <- matrix(mu2,2,1)
    icov1 <- cbind(covar1[,1],covar1[,2])
    icov2 <- cbind(covar2[,1],covar2[,2])
    
    xy1 = mvrnorm(n1, mu1, covar1)
    xy2 = mvrnorm(n2, mu2, covar2)
    
    ## В лин алгоритмах всего существует 2 класса {-1, +1}
    classes <- c(rep(-1, n1), rep(1, n2))
    
    normdata <- normalize(rbind(xy1,xy2))
    normdata <- cbind(normdata,classes)
    
    drawPoints(normdata)
    
    adaLine <- sgd(normdata[,1:2], normdata[,3], AdalLoss, AdaUpdateW, drawIters=F, ost=TRUE, c = "#FF0000")
    drwLine(adaLine, "#FF0000")
    
    HebbLine <- sgd(normdata[,1:2], normdata[,3], HebbLoss, HebbUpdateW, drawIters=F, ost=TRUE, c = "#006633")
    drwLine(HebbLine, "#006633")

    RegLine <- sgd(normdata[,1:2], normdata[,3], RegLoss, RegUpdateW, drawIters=F, ost=TRUE, c = "#660099")
    drwLine(RegLine, "#660099")
    
    if(input$class1) {
      sgd(normdata[,1:2], normdata[,3], AdalLoss, AdaUpdateW, drawIters=T, ost=TRUE, c = "#FF3300")
    }
    
    if(input$class2) {
      sgd(normdata[,1:2], normdata[,3], HebbLoss, HebbUpdateW, drawIters=T, ost=TRUE,c = "#339966")
    }    
    
    if(input$class3) {
      reg <- sgd(normdata[,1:2], normdata[,3], RegLoss, RegUpdateW, drawIters=T, ost=TRUE, c = "#996699")
    }
    
    if (input$classMap1){
      drawGrad(normdate, adaLine)
    }
    if (input$classMap2){
      drawGrad(normdate, HebbLine)
    }
    if (input$classMap3){
      drawGrad(normdate, RegLine)
    }
    
    output$q1 = renderPlot({
      q <- adaLine
      x <- seq(length(q))
      plot(x, q, type='l', lwd = 1)
    })
    output$q2 = renderPlot({
      q <- HebbLine
      x <- seq(length(q))
      plot(x, q, type='l', lwd = 1)
    })
    output$q3 = renderPlot({
      q <- RegLine
      x <- seq(length(q))
      plot(x, q, type='l', lwd = 1)
    })
    
   
})
}
shinyApp(ui = ui, server = server)