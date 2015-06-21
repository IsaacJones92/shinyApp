#Shiny User-Interface

shinyUI(fluidPage(
      
      titlePanel(h4("Support Vector Machine (SVM) Decision Boundary Visulation")),
      
      fluidRow(

            shiny::column(3,
                  wellPanel(
                  p("The model uses the R package 'MASS' datset 'cats' to build an SVM  model. The SVM decision
                    boundary can be seen in the plot (blue represents male cats and red represents female cats). 
                    The purpose of the visulization is to illustrate by tuning differient SVM parameters and 
                    using differient SVM kernels you can produce highly flexible decision boundaries.")
            ), 
            wellPanel(selectInput("kernel", label = "Select Kernel function", 
                                     choices = list( "Linear" = "linear", "Radial" = "radial",
                                                    "Polynomial" = "poly"), selected = 1),
                  numericInput("cost", label = "Input Penalty Perameter Value",
                                     value = 1),actionButton("go", "Submit"),
                  conditionalPanel(
                        condition = "input.kernel == 'radial'",
                        numericInput("gamma", label = "Select Gamma Value",
                                    min = .001, max = 100, value = .1)),
                  conditionalPanel(
                        condition = "input.kernel == 'poly'",
                        sliderInput("degree", label = "Select Degree Value",
                                    min = 1, max = 12, value = 2))),
            verbatimTextOutput('result')),
            column(9, tabsetPanel(
                  tabPanel("Plot",plotOutput('plot')),
                  tabPanel("Data", dataTableOutput("table"))
            ))
                   
      )
      ))