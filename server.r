library(shiny)
library(quantmod)
library(PerformanceAnalytics)


shinyServer
(
  
  
  function(input,output)
  {
    
    output$prime_stock<-renderText(input$stock_menu)
    output$prime_chart<-renderPlot({barChart(.GlobalEnv[[input$stock_menu]],name=input$stock_menu,subset='2012-12::2015',theme="white")})
    output$stock_summary<-renderTable(summary((.GlobalEnv[[input$stock_menu]])[,6]))
   
    output$plot_chart<-renderPlot({chartSeries((.GlobalEnv[[input$stock_menu]]),
                                        name      = input$stock_menu,
                                        type      = input$chart,
                                        subset    = paste("last", input$time_num, input$time_unit),
                                        log.scale = input$log_y,
                                        
                                        TA="addVo();addBBands();addCCI()",
                                        theme     = "white")})
    output$prime_var<-renderPlot({chart.BarVaR((.GlobalEnv[[input$stock_menu]])[,6])})
    output$bench_var<-renderPlot({chart.BarVaR((.GlobalEnv[[input$compare_menu]])[,6])})
    
    output$prime_sharpe<-renderText({round(SharpeRatio(Return.calculate((.GlobalEnv[[input$stock_menu]])[,6],method="discrete"), Rf=.035/12, FUN="StdDev"),4)})
    output$bench_sharpe<-renderText({round(SharpeRatio(Return.calculate((.GlobalEnv[[input$compare_menu]])[,6],method="discrete"), Rf=.035/12, FUN="StdDev"),4)})
     
    output$prime_sortino<-renderText({round(SortinoRatio(Return.calculate((.GlobalEnv[[input$stock_menu]])[,6],method="discrete"), Rf=.035/12, FUN="StdDev"),4)})
    output$bench_sortino<-renderText({round(SortinoRatio(Return.calculate((.GlobalEnv[[input$compare_menu]])[,6],method="discrete"), Rf=.035/12, FUN="StdDev"),4)})
    output$dl<-downloadHandler(
      filename=function(){paste("plot",input$down,sep=".")},
      content=function(file){
        if("input$down"=="png")
          png(file)
        else
          pdf(file)
        chartSeries((.GlobalEnv[[input$stock_menu]]),
                    name      = input$stock_menu,
                    type      = input$chart,
                    subset    = paste("last", input$time_num, input$time_unit),
                    log.scale = input$log_y,
                    
                    TA="addVo();addBBands();addCCI()",
                    theme     = "white")
        dev.off()
        
      })
  
  }
  
    
    )
