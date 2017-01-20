observe({
  if (!is.null(input$chart)) {
    if (input$chart) {
      output$fig <- renderChart({
        ## Highchart basic;
        
        H <- Highcharts$new()
        H$addParams(dom = "fig")
        H$chart(type = "column", zoomType = "xy", width=1000, height = 600, spacingTop = 1)
        H$subtitle(text = " ", style = list(fontSize = "14px", color = "black"))
        
        center <- HF[which(HF$Brukernavn == input$HF), c("Lat", "Lon")]
        center <- c(center[1,1], center[1,2])
        Post$dist <- 10000*(Post$Lat - center[1])^2 + (Post$Long - center[2])^2
        post <- Post[order(Post$dist)[1:100], ]
        post <- post[order(post$Nr),]
        H$data(post$dist)
        H$xAxis(tickLength = 0, categories = post$Nr)
        H
      })
    }
  }
})




observe({
  if (!is.null(input$HF)) {
    output$myMap <- renderMap({
      m <- Leaflet$new()
      m$addParams(width="100%", 
                  height=1000, 
                  layerOpts = list(maxZoom = 18))
      if (input$mapType == "openstreet") {
        m$addParams(urlTemplate= 'http://{s}.tile.openstreetmap.de/tiles/osmde/{z}/{x}/{y}.png')
      } else if (input$mapType == "statllite") {
        m$addParams(urlTemplate= 'http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}')
      } else if (input$mapType == "opencycle") {
        m$addParams(urlTemplate= 'http://{s}.tile3.opencyclemap.org/landscape/{z}/{x}/{y}.png')
      }
      
      center <- HF[which(HF$Brukernavn == input$HF), c("Lat", "Lon")]
      center <- c(center[1,1], center[1,2])
      Post$dist <- (Post$Lat - center[1])^2 + (Post$Long - center[2])^2
      post <- Post[order(Post$dist)[1:100], ]
      
 
      Points <- as.list(rep(NA, nrow(post)))
      for (i in 1:nrow(post)) {
        Points[[i]] <- c(lat = post$Lat[i], lon = post$Long[i], value = sample(1:10, 1))
      }
      
      if (!is.null(input$heatmap)) {
        if (input$heatmap) {
          m$addParams(heatmap = Points)
        }
      }
      if (!is.null(input$cluster)) {
        if (input$cluster) {
          m$addParams(cluster = Points)
        }
      }    
  
      
      m$addParams(bounds = list(c(min(post$Lat),min(post$Long)),
                                c(max(post$Lat),max(post$Long))))
#       m$setView(c((min(post$Lat)+max(post$Lat))/2, (min(post$Long)+max(post$Long))/2), zoom = 10)
      
      ## Build GeoJSON list;
      Dat <- list()

      ## Post codes;
      if (!is.null(input$markers)) {
        if (input$markers) {
          for (i in 1:nrow(post)) {
            geoList <- list(type = "Feature", 
                            geometry = list(type = "Point", coordinates = c(post$Lon[i], post$Lat[i])),
                            properties = list(color = "black", 
                                              fillColor = "black",
                                              fillOpacity = 1, 
                                              radius = 3,
                                              popup = post$Nr[i]
                            ))
            Dat[[length(Dat)+1L]] <- geoList
          }
        }
      }
      
      # Hospital;
      for (i in 1:nrow(HF)) {
        geoList <- list(type = "Feature", 
                        geometry = list(type = "Point", coordinates = c(HF$Lon[i], HF$Lat[i])),
                        properties = list(color = "blue", 
                                          fillColor = "blue",
                                          fillOpacity = 1, 
                                          radius = 3,
                                          popup = paste(HF$Brukernavn[i], HF$Virkelignavn[i], sep = "<br>")
                        ))
        Dat[[length(Dat)+1L]] <- geoList
      }
      
      ## Selected hospital;
      id <- which(HF$Brukernavn == input$HF)
      geoList <- list(type = "Feature", 
                      geometry = list(type = "Point", coordinates = c(HF$Lon[id], HF$Lat[id])),
                      properties = list(color = "red", 
                                        fillColor = "red",
                                        fillOpacity = 1, 
                                        radius = 8,
                                        popup = paste(HF$Brukernavn[id], HF$Virkelignavn[id], sep = "<br>")
                      ))
      Dat[[length(Dat)+1L]] <- geoList
      
      m$geoJson(Dat, onEachFeature = jsOnEachFeature,
                style = jsStyle, pointToLayer =jsPointToLayer)
      m
    })
  }
})

