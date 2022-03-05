
rm(list=ls()) 

library(FedData)
library(raster)
library(rgdal)
library(sf)
library(tmap)
library(rgdal)

NLCD <- raster("NLCD2016_2021.tif")

#NLCD <- raster("Caparo_18_09_2018_S2.tif")


plot(NLCD)
A.O.I <- sf::st_read("Primary_Zone.shp")

A.O.I <- sf::as_Spatial(st_geometry(A.O.I), 
                        IDs = as.character(1:nrow(A.O.I)))


AOI <- spTransform(A.O.I,
                   CRS("+proj=longlat 
                       +datum=WGS84 
                       +no_defs"))


cropped_extent <- crop(NLCD, AOI)
ext <- extent(AOI)
r <- crop(NLCD, ext)
capa <- mask(r, AOI)

class(capa)

legend<-pal_nlcd()
legend

paletap <- legend$color

Water <- legend$color[1]
Dev_urb <- legend$color[6]
Agriculture <- legend$color[18]
Grassland <- legend$color[13]
Upland_f <- legend$color[10]
Wetland_f <- legend$color[8]
E_W_Veg <- legend$color[20]

paleta3 <- c(Water, Dev_urb,Agriculture,
             Grassland, Upland_f,Wetland_f,
             E_W_Veg)


a <- tm_shape(capa) + 
  tm_raster(style = "cont", title = " ",
            palette = paletap, legend.show = F)+
  tm_legend(outside = T) +
  tm_graticules(col = "grey90")+
  tm_scale_bar(position = c("left", "bottom"))+
  tm_layout(main.title = "FLORIDA STUDY AREA CROPPED EXTENT", 
            title.size=3,
            #title.position = c('right', 'top')
            main.title.position = "CENTER"
  ) +
  tm_facets(free.scales=T) +
  tm_add_legend('symbol', 
                col = paleta3,
                border.col = "grey40",
                size = 2,
                labels = c('Water',
                           'Developed/Urban',
                           "Agriculture",
                           "Grassland/Shrib",
                           "Upland Forest",
                           "Wetland Forest",
                           "Emergent Wetland Vegetation"
                ),
                title=" ") 


a

tmap_leaflet(a)


