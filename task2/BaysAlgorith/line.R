library(shiny)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("x",
                  "Значение x :",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1),
      sliderInput("mu",
                  "Значение μ :",
                  min = 0,
                  max = 5,
                  value = 0,
                  step = 1),
      sliderInput("y",
                  "Значение y :",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1         
      )
    ),
    mainPanel(
      HTML("<center><h1><b>График линий уровня нормального распределения</b></h1>"),
      HTML("<img src=\"  https://sun9-4.userapi.com/c853528/v853528186/15c6b0/blI7kVCoJE0.jpg   \"></center>"),
      #HTML("<a href=\"https://www.codecogs.com/eqnedit.php?latex=N(x;\mu,\Sigma)&space;=&space;\frac{1}{(2\pi)^2&space;|S|}&space;\exp&space;\left&space;(&space;-&space;\frac{1}{2}(x&space;-&space;\mu)^T&space;S&space;^{-1}(x&space;-&space;\mu)&space;\right&space;),&space;S&space;=&space;\binom{x~~~~~\mu}{\mu~~~~~y}\" target=\"_blank\"><img src=\"https://latex.codecogs.com/gif.latex?N(x;\mu,\Sigma)&space;=&space;\frac{1}{(2\pi)^2&space;|S|}&space;\exp&space;\left&space;(&space;-&space;\frac{1}{2}(x&space;-&space;\mu)^T&space;S&space;^{-1}(x&space;-&space;\mu)&space;\right&space;),&space;S&space;=&space;\binom{x~~~~~\mu}{\mu~~~~~y}\" title=\"N(x;\mu,\Sigma) = \frac{1}{(2\pi)^2 |S|} \exp \left ( - \frac{1}{2}(x - \mu)^T S ^{-1}(x - \mu) \right ), S = \binom{x~~~~~\mu}{\mu~~~~~y}\" /></a></center>"),
      HTML("<h4>Ковариционная матрица</h4>"),
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

