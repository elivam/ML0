#' вход : 
#' Xl: matrix 
#'     обучающая выборка, на последнем месте метка класса
#' u:  vector
#'     классифицираемый объект
#' q : расстояние
#'     определить функцию расстояния
#' 
#' @return имя класса
#' 
#' 
#' 1. нахожу расстояние от точки u до точек из выборки, образуя новую матрицу
#' 2. нахожу минимальное расстояние в матрице и запоминаю точку А
#' 3. узнаю какому классу принадлежит эта точка А и точку u окрашиваю в тот  же класс что и точку u


ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("x",
                  "Задайте знанчения x:",
                  min = 1,
                  max = 7,
                  value = 1,
                  step = 0.5),
      sliderInput("y",
                  "Задайте значения y:",
                  min = 0,
                  max = 3,
                  value = 0.25,
                  step = 0.1
                  )
    ),
    mainPanel(
      plotOutput("carsPlot")
    )
    
  )
)

server <- function(input, output) {

evcliDestance <- function (x,u){
  return (sqrt(sum((x - u)^2)))
}
nn <- function(xl, u, q = evcliDestance){
      
    l <- dim(xl)[1] #кол-во строк 
    n <- dim(xl)[2] - 1 #кол-во признаков
    # в общем у xl 3 признака , х - координата , у - координата и третий - класс
    
    dist <- array(NA,l)
    for (i in 1:l){
      dist[i] = q(xl[i, 1:n],u) 
    } 
     minXl  <- which.min(dist)
     return (xl[minXl, ])
}   


output$carsPlot <- renderPlot({
  x <- input$x
  y <- input$y
  u <- c(x ,y)
  colors <- c("setosa" = "#FFCC33", "versicolor" = "#0033FF",
              "virginica" = "#CC00CC")
  cl <-nn(iris[, 3:5], u)
  plot(iris[, 3:4], pch = 20, bg = colors[iris$Species], col = colors[iris$Species], asp = 1)
  points(u[1], u[2], pch = 21, bg = colors[cl[1,3]], asp = 1)
})
}

# Run the application 
shinyApp(ui = ui, server = server)
