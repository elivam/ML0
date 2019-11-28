library(shiny)
library(MASS)
ui <- fluidPage(
  
  titlePanel("Изменяемые параметры"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("class","Отобразить классификацию", FALSE),
      
      numericInput("NumberOfSamples", "Кол-во элементов:", 150,min = 1,max=500, width = '200px'),
      
      numericInput("mu1", "μ для первого класса", 1,min=1,max=10, width = '200px'),
      
      numericInput("mu2", "μ для второго класса", 4,min=1,max=10, width = '200px'),
      
      numericInput("sigma1", "Диагональные элементы ковариационной матрицы для первого класса", 2,min=1,max=20, width = '400px'),
      
      numericInput("sigma2", "Диагональные элементы ковариационной матрицы второго класса", 2,min=1,max=20, width = '400px'),
       
      numericInput("lmd1","Задайте степень важности для первого класса", 1,min=1,max=10, width = '400px'),
      
      numericInput("lmd2","Задайте степень важности для второго класса", 1,min=1,max=10, width = '400px'),
       
      sliderInput("p1",
                  "Задайте априорную вероятноть для первого класса",
                  min = 0,
                  max = 1,
                  value = 0.5,
                  step = 0.1         
      ),
      
      sliderInput("p2",
                  "Задайте априорную вероятноть для второго класса",
                  min = 0,
                  max = 1,
                  value = 0.5,
                  step = 0.1         
      )
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      HTML("<center><h1><b>Наивный нормальный байесовский классификатор</b></h1>"),
      h3(textOutput("label")),
      HTML("<h3> Восстанвленные параметры </h3>"),
      HTML("<h4> Для первого класса </h4>"),
      HTML("<h5> Мат ожидание </h5>"),
      textOutput(outputId = "covMessage12"),
      
      textOutput(outputId = "covMessage22"),
      plotOutput(outputId = "plot", height = "700px")
    )
  )
)

naivBays <- function(x, mu, sigma, lamda, P){
  n <- 2
  res <- log(lamda*P)
  
  for(i in 1 : n){
    formula <- (1/(sigma[i]*sqrt(2*pi))) * exp(-1 * ((x[i] - mu[i])^2)/(2*sigma[i]^2))
    res <- res + log(formula)
  }
  
  return(res)
}

get_mu <- function(xl){
  
  l <- dim(xl)[1] 
  return(c(sum(xl[,1])/l, sum(xl[,2])/l))
  
}

get_sigma <- function(xl, mu){
  
  l <- dim(xl)[1] 
  return(c(sum((xl[,1] - mu[1])^2)/l, sum((xl[,2] - mu[2])^2)/l))
  
}


server <- function(input, output) {
  
  classMap <-function(mu1, sigma1,mu2, sigma2,lmd1,p1,lmd2,p2){
    # lamda <- 1 #input$lmd
    # p <-  0.5 #input$p
    x1 <- -15;
    
    while(x1 < 20){
      x2 <- -8;
      
      while(x2 < 13){          
        
        class <- 0;
        
        if(naivBays(c(x1,x2), mu1, sigma1, lmd1, p1) > naivBays(c(x1,x2), mu2, sigma2, lmd2, p2)){
          class <- 1
        } 
        else {
          class <- 2
        }
        
        points(x1, x2, pch = 21, col=colors[class], asp = 1)
        x2 <- x2 + 0.2
      }
      x1 <- x1 + 0.2
    }
  }
  
  
  output$plot = renderPlot ({
  sigma1 <- matrix(c(input$sigma1, 0, 0, input$sigma1),2,2)
  sigma2 <- matrix(c(input$sigma2, 0, 0, input$sigma2),2,2)
  
  mu1 <- c(input$mu1,input$mu1)
  mu2 <- c(input$mu2,input$mu2)
  
  
  x1 <- mvrnorm(n = input$NumberOfSamples, mu1, sigma1)
  x2 <- mvrnorm(n = input$NumberOfSamples, mu2, sigma2)
  
  xy1 <- cbind(x1,1) 
  xy2 <- cbind(x2,2) 
  
  xl <- rbind(xy1,xy2)

  colors <- c("#FF6666", "#333399")
  plot(xl[,1],xl[,2],xlab = "Первый признак",ylab = "Второй признак" ,pch = 20, col = colors[xl[,3]], asp = 1, bg=colors[xl[,3]])


  mu1 <- get_mu(x1)
  mu2 <- get_mu(x2)     

  sigma1 <- get_sigma(x1, mu1)
  sigma2 <- get_sigma(x2, mu2)
  
   print(mu1)
   print(mu2)
   output$covMessage12 = renderText({
     paste(mu1,sep=" ")
   })
   
   
   output$covMessage22 = renderText({
      paste(mu2,sep=" ")
    })
  
 lmd1 <- input$lmd1
 p1 <- input$p1
 lmd2 <- input$lmd2
 p2 <- input$p2
 
  if(input$class){
    classMap(mu1, sigma1,mu2, sigma2,lmd1,p1, lmd2, p2)
  }
  })
}
shinyApp(ui = ui, server = server)