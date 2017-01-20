output$uiHF <- renderUI({
  Items <- HF$Brukernavn
  #names(Items) <- HF$Virkelignavn
  selectInput(inputId = "HF", 
              label   = "Hospital", 
              choices = Items)
})
    
output$uiChart <- renderUI({
  checkboxInput(inputId = "chart", 
                label   = "Show Figure", 
                value   = FALSE)
})

output$uiMapType <- renderUI({
  radioButtons(inputId = "mapType", 
               label   = "",
               c("Open street" = "openstreet", 
                 "Open cycle"  = "opencycle", 
                 "ESRI image"  = "statllite"))
})
   
output$uiHeatmap <- renderUI({
  checkboxInput(inputId = "heatmap",
                label   = "Heat map",
                value   = FALSE)
})

output$uiCluster <- renderUI({
  checkboxInput(inputId = "cluster",
                label   = "Markers cluster",
                value   = FALSE)
})

output$uiMarkers <- renderUI({
  checkboxInput(inputId = "markers",
                label   = "Markers",
                value   = TRUE)
})

