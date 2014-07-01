

## @knitr server.R
## server.R
require(rCharts)
require(dplyr)



########Server Code


shinyServer(function(input, output) {
  
  # Generating the dropdows -------------------------------------------------   
  
  
  ##creating the dynamic dropdown for sites based on selected network
  
  output$sitecontrol <- renderUI({
    site_choice <- unique(results[results$net.name == input$network,"site.name"])
    site_choice <- site_choice[order(site_choice)]
    selectInput("sites","Sites",choices=site_choice,multiple=F)
    
  })
  
  ##creating the function for appropriate data
  
  dataset <- reactive({
    
    if(input$all_sites) {
      data <- subset(mltd_traffic_net,net.name == input$network)
      
    } else {
      
      data <- subset(mltd_results,net.name == input$network & site.name == input$sites)
      
    }
  })
  
  data_table <- reactive({
    
    if(input$all_sites) {
      data <- subset(agg_traffic,net.name == input$network)
      
    } else {
      
      data <- subset(results,net.name == input$network & site.name == input$sites)
      
    }
  })
  
  output$myChart <- renderChart2({
    mytooltip = "#! function(item){return item.Traffic + ' in ' + item.week} !#"
    p1 <- rPlot(Traffic ~ week|variable,
                data = dataset(),type = 'bar',tooltip = mytooltip,color='variable')
    
    p1$set(height = 450)
    
     
    return(p1)
  })
  
  
  # Generate an HTML table view of the data
  output$table <- renderTable({
    data.frame(x=data_table())
  })
  
  
  #Downloading the data
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$network, '.csv',sep = "") },
    content = function(file) {
      write.csv(data_table(), file)
    }
  )
  
  
})
