library(shiny)
shinyUI(fluidPage(
    titlePanel("Predict Mileage from HP"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("sliderHp", "Slide your HorsePower of the car:", 40, 400, value = 60),
            sliderInput("weight",
                        "Slide your Vehicle Weight in lbs:",
                        min = 1000,
                        max = 6000,
                        value = 2000),
            selectInput("var", "Select an optional metric for your vehicle:",
                        list("Number of Cylinders (4,6,8)"="cyl",
                             "Transmission Type  (0 = automatic, 1 = manual)" = "am",
                             "Number of forward Gears (3,4,5)" = "gear")),
            uiOutput("secondSelection"),
            actionButton("full_phase", "Submit")
        ),
        mainPanel(
            plotOutput("plot1"),
            plotOutput("plot2"),
            h3("Predicted Mileage from Model:"),
            textOutput("pred")
        )
    )
))
