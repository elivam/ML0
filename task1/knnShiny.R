#' kNN
#' вход : 
#' Xl: matrix 
#'     обучающая выборка, на последнем месте метка класса
#' u:  vector
#'     классифицираемый объект
#' q : расстояниеы
#'     определить функцию расстояния
#' k:  кол-во соседей
#'     определять кол-во требуемых соседей по LOO для оптимальности алгоритма 
#' @return имя класса
#' 
#' нахожу расстояния от точки u до k-ближайших-соседей образуя новый массив, 
#'   где будет записан класс этой k-точки-соседа и расстояние 
#' сортирую этот массив 
#' я считаю какие классы соседей встречаются и даю предпочтение наибольшему 
#' (в случае если их одинаковое кол-во то отдаю точку u тому классу, 
#'                точка которого находится ближе всего)

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
      ),
      sliderInput("k",
                  "Задайте значение k:",
                  min = 1,
                  max = 149,
                  value = 2,
                  step = 1
      )
    ),
    mainPanel(
      plotOutput("carsPlot")
    )
    
  )
)

server <- function(input, output) {
  
  evcliDestance <- function (x, u){
    return (sqrt(sum((x - u)^2)))
  }
  sortObjByDist <-function(xl, u,q = evcliDestance){
    l <- dim(xl)[1] #кол-во строк 
    n <- dim(xl)[2] - 1 #кол-во признаков
    # в общем у xl 3 признака , х - координата , у - координата и третий - класс
    dist <- matrix(NA, l, 2)
    for (i in 1:l) {
      dist[i, ] <- c(i, q(xl[i, 1:n],u)) 
    }
    sortXl <- xl[order(dist[, 2]), ]
    
    return(sortXl)
  }
  knn <- function(sortXl,u ,k, q = evcliDestance){
    n <- dim(sortXl)[2] 
    # в classes хранятся классы
    classes <- sortXl[1:k, n]
    counts <- table(classes)
    mClass <- names(which.max(counts))
    
    return (mClass)
  }
  
  output$carsPlot <- renderPlot({
    x <- input$x
    y <- input$y
    k <- input$k
    u <- c(x ,y)
    colors <- c("setosa" = "#FFCC33", "versicolor" = "#0033FF",
                "virginica" = "#CC00CC")
    sortx <- sortObjByDist (iris[, 3:5],u,q = evcliDestance )
    cl <-knn(sortx, u, k ,q = evcliDestance)
    plot(iris[, 3:4], pch = 20, bg = colors[iris$Species], col = colors[iris$Species], asp = 1)
    points(u[1], u[2], pch = 21, bg = colors[cl], asp = 1)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
