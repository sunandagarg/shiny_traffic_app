 ## @knitr ui.R
## ui.R
require(rCharts)


shinyUI(pageWithSidebar(
  headerPanel("Traffic Over Last 4 Weeks"),
  
  
  
  sidebarPanel(
    
    # network input -----------------------------------------------------------   
    selectInput(inputId = 'network',
                label = "Select Network",
                choices = networks,
                selected = "ASMI",
       
                )
  ,


 

br(),

##whether network traffic overview or site traffic overview

checkboxInput(inputId="all_sites",label="All Sites",value=T),

conditionalPanel(
    condition = "input.all_sites == true",
    div("Uncheck to see the traffic at site level & Update View",style="color:green")),


# site input -----------------------------------------------------------

conditionalPanel(
    condition = "input.all_sites == false",
                 uiOutput("sitecontrol")),
                 
                 
##update the view once inputs have been changed

submitButton("Update View")

  ),


  mainPanel(
    tabsetPanel(
    tabPanel("Plot",showOutput("myChart", "polycharts")),
    tabPanel("Data",tableOutput("table")),
    downloadButton('downloadData', 'Download Data')
  ))
))





