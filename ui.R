library(rCharts)
shinyUI(bootstrapPage(
  # Add custom CSS & Javascript;
  tagList(
    tags$head(
      tags$style("hr {margin: 5px 0;}"),
      tags$script(src="jquery-ui.js"),
      tags$script(src="app.js"),
#       tags$script(src="PruneCluster.js"),
#       tags$script(src="PruneCluster.css"),
      tags$link(rel="stylesheet", type="text/css",href="style.css")
    ),
    tags$body(
      tags$script(src="jquery.ba-resize.js")
    )
  ),
  ## Language;
  
  img(id = "control", src = "control.png"),
  
  div(class = "Input", 
      HTML("<div class='drag'></div>"),
      uiOutput("uiHF"),
      HTML("<hr></hr>"),
      uiOutput("uiChart"),
      HTML("<hr></hr>"),
      uiOutput("uiMarkers"),
      uiOutput("uiCluster"),
      uiOutput("uiHeatmap")),
  
  div(class = "control", 
      uiOutput("uiMapType")),
  
  div(class = "Output", 
      HTML("<div class='drag'></div>"),
      showOutput("fig", lib = "highcharts")),
  
  showOutput("myMap", "leaflet")
  
))
