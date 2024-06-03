# MAPS FOR MULTIPOP PAPER
################

# set up workspace
##################
# set wd
# packages
library(sf)
library(dplyr)
library(ggrepel)
library(ggspatial)
library(leaflet)
library(ggplot2)
library(maps) 
library(tools)
library(rnaturalearth)
library(forcats)
library(lubridate)
##################

# read in our site data
#######################
# read in lat/longs
sites <- read.csv("GPS_multipopsites.csv")
View(sites)
#######################

# create maps
#############
# prelim visualization of sites of interest in google maps
m <- leaflet()
m <- addTiles(m)
m <- addCircleMarkers(m, long=long, lat=lat, radius =2, opacity = 1, 
                      label = sites$name, labelOptions = labelOptions(noHide = T))
m 

# set object
world <- ne_countries(scale = "medium", returnclass = "sf")
sf_use_s2(FALSE)
world_crop <- st_crop(world, c(xmin =-117.2 , xmax = 110, ymin = -60, ymax = 60))
class(world)
class(world_crop)

# add state borders for the sake of clarity
states <- st_as_sf(map("state", plot = FALSE, fill = TRUE))
head(states)
states <- cbind(states, st_coordinates(st_centroid(states)))
states$ID <- toTitleCase(states$ID)
head(states)

# plot map, coloring by site/reference vs polluted
fig1 <- 
  ggplot(data = world) +
  theme_bw() + 
  geom_sf(data = world_crop, fill = 'antiquewhite1') +
  geom_sf(data = states, fill = 'antiquewhite1') +
  geom_point(data = sites, aes(x=Long, y=Lat, color=ID, size=5)) +
  geom_text_repel(data = sites, aes(x = Long, y = Lat, label = ID),
                  size = 5, nudge_x = c(-1.25,1.25),fontface = "bold")+
  coord_sf(xlim = c(-88, -97), ylim = c(28, 32), expand = FALSE) + ##FIT TO REGION OF INTEREST
  scale_color_manual(values = c("LA-Reference"= "navyblue", "TX-Reference"= "gold", "LA-Polluted"="skyblue" ,"TX-Polluted" = "olivedrab3"))+
  theme(plot.title = element_text(size = 24), panel.grid.major = element_line(color = gray(0.5), linetype = "dashed", size = 0.5),
        panel.background = element_rect(fill = "aliceblue"), legend.position = 'right')

ggsave("map_fig1.png",fig1, width=10, height=5, units = "in")

#map of US
usa <- map_data("usa")
states <- map_data("state")
usabase <- ggplot(data = states, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color = "black", fill = "gray")

usmap<-usabase + theme_classic() + 
  geom_polygon(data = states, fill = "grey", color = "black")

ggsave("USmap.png",usmap, height=30.16, width=15.67, units = "cm") 

 
