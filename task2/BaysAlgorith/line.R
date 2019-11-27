library(shiny)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("x",
                  "Задайте значение [1,1] ковариационной матрицы:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 0.5),
      sliderInput("mu",
                  "Задайте значения [1,2] и [2,1] ковариационной матрицы:",
                  min = 0,
                  max = 5,
                  value = 0,
                  step = 0.5),
      sliderInput("y",
                  "Задайте значение [2,2] ковариационной матрицы:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 0.5         
      )
    ),
    mainPanel(
      HTML("<center><h1><b>График линий уровня нормального распределения</b></h1>"),
      HTML("<img src=\"  https://sun9-31.userapi.com/c856036/v856036153/1674f5/Qa84Boha90w.jpg   \">"),
      HTML("<h5>Ковариационная матрица <img src=\"  https://sun9-59.userapi.com/c858220/v858220119/e398c/s4TAizoM8to.jpg  \"> </h5>"),
      textOutput(outputId = "sigmaMess1"),
      textOutput(outputId = "sigmaMess2"),
      textOutput(outputId = "covMessage"),
      plotOutput(outputId = "plot", height = "500px")
    )
  )
  
)

server <- function(input, output) {
  
  # output$carsPlot <- renderPlot({
  output$plot = renderPlot ({
    
    x <- input$x
    mu <- input$mu
    y <- input$y
    center <- matrix(0, 1, 2) # центр 0, 0
    
    sigma = matrix(c(x, mu, mu, y), 2, 2)
    detSigma <- det(sigma)
    
    output$sigmaMess1 = renderText({
      paste(sigma[1,1],sigma[1,2],sep=" ")
    })
    output$sigmaMess2 = renderText({
      paste(sigma[2,1],sigma[2,2],sep=" ")
    })
    
    if (det(sigma) <= 0) {
      output$covMessage = renderText({
        "Определитель ковариационной матрицы <= 0"
      })
      return()
    }else{
      output$covMessage = renderText({
        ""
      })
      normDist = function(x, y, mu, sigma) {
        x = matrix(c(x, y), 1, 2)
        n = 2
        k = 1 / sqrt((2 * pi) ^ n * det(sigma))
        e = exp(-0.5 * (x - mu) %*% solve(sigma) %*% t(x - mu))
        k * e
      }
      a <- sigma[1, 1]
      b <- sigma[1, 2]
      c <- sigma[2, 1]
      d <- sigma[2, 2]
      A <- d / detSigma
      B <- (-b - c) / detSigma
      C <- a / detSigma
      D <- (-2 * d * center[1, 1] + b * center[1, 2] + c * center[1, 2]) / detSigma
      E <- (b * center[1, 1] + c * center[1, 1] - 2 * a * center[1, 2]) / detSigma
      f <- (d * center[1, 1] * center[1, 1] - b * center[1, 1] * center[1, 2] - c * center[1, 1] * center[1, 2] + a * center[1, 2] * center[1, 2]) / detSigma
      
      zfunc <- function(x, y) {
        1 / sqrt(2 * pi * d) * exp(-0.5 * (A * x * x + B * y *x + C * y * y + D * x + E * y + f))
      }
      radius <- 3
      
      minX <- -sigma[1, 1] - radius
      maxX <- sigma[1, 1] + radius
      minY <- -sigma[2, 2] - radius
      maxY <- sigma[2, 2] + radius
      
      x <- seq(minX, maxX, len=150)
      y <- seq(minY, maxY, len=150)
      z <- outer(x, y, zfunc)
      
      contour(x, y, z, lwd = 1, col = '#FF3333', asp = 1)
        
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

