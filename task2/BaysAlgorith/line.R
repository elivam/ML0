library(shiny)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("x",
                  "Значение [1,1] :",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 0.5),
      sliderInput("mu",
                  "Значение [1,2] и [2,1] :",
                  min = 0,
                  max = 5,
                  value = 0,
                  step = 0.5),
      sliderInput("y",
                  "Значение [2,2] :",
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
    
    sigma = matrix(c(x, mu, mu, y), 2, 2)
    
    
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
      zfunc <- function(x, y) {
        sapply(1:length(x), function(i) normDist(x[i], y[i], mu, sigma))
      }
      radius <- 3
      
      minX = -sigma[1, 1] - radius
      maxX = sigma[1, 1] + radius
      minY = -sigma[2, 2] - radius
      maxY = sigma[2, 2] + radius
      
      x = seq(minX, maxX, len=200)
      y = seq(minY, maxY, len=200)
      z = outer(x, y, zfunc)
      
      add = F
      for (level in seq(0.02, 0.2, 0.01)) {
        # contour(x, y, z,asp= 1)
        contour(x, y, z, levels = level, drawlabels = T, lwd = 1, col = '#FF3333', add = add, asp = 1)
        add = T
      }
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

