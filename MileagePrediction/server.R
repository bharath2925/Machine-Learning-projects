library(shiny)
shinyServer(function(input, output) {
    
    output$secondSelection<-renderUI({
        varInput = input$var
        if (varInput == "am"){
            selectInput("val", "Transmission Type  (0 = automatic, 1 = manual)",list(0,1))
        }else if(varInput == "cyl"){
            selectInput("val", "Number of Cylinders (4,6,8)",list(4,6,8))
        }else {
            selectInput("val", "Number of forward Gears (3,4,5)",list(3,4,5))
        }
    })
    
    mtcars$am<-factor(mtcars$am)
    mtcars$cyl<-ordered(mtcars$cyl)
    mtcars$gear<-ordered(mtcars$gear)
    varout<-reactive({input$var})
    
    model<-reactive({
        lm(reformulate(paste("hp+wt+",varout()), "mpg"), data = mtcars)
    })
    
    modelpred<-eventReactive(
        input$full_phase,{
            
            # reactive({
            hpInput <- input$sliderHp
            wtInput = input$weight/1000
            varInput = input$var
            valInput = factor(input$val)
            if (varInput == "am"){
                predict(model(), newdata = data.frame(hp = hpInput,wt = wtInput, am = valInput))
            }else if(varInput == "cyl"){
                predict(model(), newdata = data.frame(hp = hpInput,wt = wtInput, cyl = valInput))
            }else {
                predict(model(), newdata = data.frame(hp = hpInput,wt = wtInput, gear = valInput))
            }
        }
    )
    
    output$plot1 <- renderPlot({
        hpInput <- input$sliderHp
        
        plot(mtcars$hp, mtcars$mpg, ylab = "Miles Per Gallon", 
             xlab = "Horsepower", bty = "n", pch = 16,
             ylim = c(10, 35), xlim = c(50, 350))
        points(hpInput, modelpred(), col = "blue", pch = 16, cex = 2)
    })
    
    output$plot2 <- renderPlot({
        wtInput = input$weight/1000
        
        plot(mtcars$wt, mtcars$mpg, ylab = "Miles Per Gallon", 
             xlab = "Weight of vehicle in 1000 lbs", #bty = "n", pch = 16,
             ylim = c(10, 35), xlim = c(0.5, 6))
        points(wtInput, modelpred(), col = "green", pch = 16, cex = 2)
    })
    
    output$pred <- renderText({
        modelpred()
    })
})