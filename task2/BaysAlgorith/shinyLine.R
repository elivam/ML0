library(shiny)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("x",
                  "¬‚Â‰ËÚÂ ÁÌ‡˜ÂÌËÂ ı:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1),
      sliderInput("mu",
                  "¬‚Â‰ËÚÂ ÁÌ‡˜ÂÌËÂ mu:",
                  min = 0,
                  max = 5,
                  value = 0,
                  step = 1),
      sliderInput("y",
                  "¬‚Â‰ËÚÂ ÁÌ‡˜ÂÌËÂ y:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1         
    )
  ),
  mainPanel(
    HTML("<center><h1><b>–ì—Ä–∞—Ñ–∏–∫ –ª–∏–Ω–∏–π —É—Ä–æ–≤–Ω—è –Ω–æ—Ä–º–∞–ª—å–Ω–æ–≥–æ —Ä–∞—Å–ø—Ä–µ–¥–µ–ª–µ–Ω–∏—è</b></h1>"),
    textOutput(outputId = "covMessage"),
    plotOutput(outputId = "plot", height = "600px")
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
      
      if (det(sigma) <= 0) {
        output$covMessage = renderText({
          "Det sigma <= 0"
        })
        return()
      }else{
      
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
        contour(x, y, z, levels = level, drawlabels = T, lwd = 1, col = '#FF9999', add = add, asp = 1)
        add = T
      }
      }
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

