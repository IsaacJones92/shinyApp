library(shiny)
library(e1071)



data(cats, package = "MASS")
make.grid = function(x, n = 150) {
      grange = apply(x, 2, range)
      x1 = seq(from = grange[1, 1], to = grange[2, 1], length = n)
      x2 = seq(from = grange[1, 2], to = grange[2, 2], length = n)
      expand.grid(Bwt = x1, Hwt = x2)
}

shinyServer(function(input, output) {
      
      modelInput  = reactive({
            m = svm(Sex ~ . , data = cats, kernel = input$kernel, cost = input$cost, degree = input$degree,
                    gamma = input$gamma)
            inputs = cats[,2:3]
            xgrid = make.grid(inputs)
            ygrid = predict(m, xgrid)
            p = plot(xgrid, col = c("red", "blue")[as.numeric(ygrid)], pch = 20, cex = 0.2, 
                     xlab = "Body Weight (Kg)", ylab = "Heart Weight (kg)", main = "MASS Cats Dataset SVM Visulation")
            p = p + points(inputs, col = ifelse(cats$Sex == 'F' , "red", "blue") , pch = 19)
      })
      
      predictions  = reactive({
            m = svm(Sex ~ . , data = cats, kernel = input$kernel, cost = input$cost, degree = input$degree,
                    gamma = input$gamma)
            mean(predict(m) == cats$Sex)
      })
      
      #support vectors 
      #points(inputs[m$index, ], pch = 5, cex = 2)
      output$plot <- renderPlot(modelInput())
      output$result <- renderText(paste("Classification Results:", as.character(round(predictions(),digits = 2)), sep = " "))
      output$table <- renderDataTable(cats, options = list(pageLength = 10))
      
}
)
