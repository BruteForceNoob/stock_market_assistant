library(shiny)
library(quantmod)
library(PerformanceAnalytics)

shinyUI(
          fluidPage
        ( theme="bootstrap.css",
          titlePanel(title=h1("Dr.Stock")),
          sidebarLayout
          (
            sidebarPanel( 
              conditionalPanel(
                                condition="input.conditionedPanels == 'Summary'" ,
                                selectInput("stock_menu","Choose a stock",c("AXISBANK.BO","BHEL.BO","BHARTIARTL.BO","CIPLA.BO","HEROMOTOCO.BO","HINDALCO.BO","INFY.BO","ITC.BO","RELIANCE.BO","WIPRO.BO"))
                              ),    
             
              conditionalPanel(condition="input.conditionedPanels == 'News'"),
              
              conditionalPanel(condition="input.conditionedPanels == 'Compare'",
                               selectInput("compare_menu","Choose a benchmark",c("AXISBANK.BO","BHEL.BO","BHARTIARTL.BO","CIPLA.BO","HEROMOTOCO.BO","HINDALCO.BO","INFY.BO","ITC.BO","RELIANCE.BO","WIPRO.BO"))
                               
                               ),
              
              conditionalPanel(
                                condition="input.conditionedPanels == 'Plot'",
                                radioButtons("chart","Choose a type of chart",c("Candlestick" = "candlesticks",
                                                                                "Matchstick" = "matchsticks",
                                                                                "Bar" = "bars",
                                                                                "Line" = "line")),
                                checkboxInput(inputId = "log_y", label = "log y axis", value = FALSE),
                                wellPanel(
                                  p(strong("Date range (back from present)")),
                                  sliderInput(inputId = "time_num",
                                              label = "Time number",
                                              min = 1, max = 24, step = 1, value = 6),
                                  
                                  selectInput(inputId = "time_unit",
                                              label = "Time unit",
                                              choices = c("Days" = "days",
                                                          "Weeks" = "weeks",
                                                          "Months" = "months",
                                                          "Years" = "years"),
                                              selected = "months"),
                                  radioButtons("down","Select file type",choices=list("png","pdf"))
                                )
                                
                              )
            ),
            
            mainPanel(
              tabsetPanel(
                tabPanel(
                         "Summary",
                         br(),textOutput("prime_stock"),
                         plotOutput("prime_chart"),br(),br(),
                         tableOutput("stock_summary")
               ),
                tabPanel("News",div(tags$embed(src="http://output18.rssinclude.com/output?type=direct&id=1035621&hash=15d9d5575fe066ea9753f9eb29855854", width="800", height="800"))),
                         
                tabPanel(
                          "Compare",
                          plotOutput("prime_var"),br(),
                          p("Sharpe Ratio:"),
                          textOutput("prime_sharpe"),br(),
                          p("Sortino Ratio:"),
                          textOutput("prime_sortino"),br(),
                          
                          
                          plotOutput("bench_var"),br(),
                          p("Sharpe Ratio:"),br(),
                          textOutput("bench_sharpe"),br(),
                          p("Sortino Ratio:"),br(),
                          textOutput("bench_sortino"),br(),
                          p("For more information on risk ratios: "),br(),
                          tags$a(href="http://en.wikipedia.org/wiki/Sharpe_ratio","Sharpe Ratio"),
                          tags$a(href="http://en.wikipedia.org/wiki/Sortino_ratio","Sortino Ratio")
                          
                          
                          ),
                tabPanel("Plot",
                         br(),
                         
                         div(plotOutput("plot_chart")),br(),
                         downloadButton("dl","Download")
                         ),
                id = "conditionedPanels"                
              )
            )
  
  )))