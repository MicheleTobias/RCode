#--- EXAMPLES of using LeafletR

# Adapted from example here:
# http://cran.r-project.org/web/packages/leafletR/leafletR.pdf

library(leafletR)

# load example data (Fiji Earthquakes)
data(quakes)

# Explore the data
head(quakes)

# store data in GeoJSON file (just a subset here)
q.dat <- toGeoJSON(data=quakes[1:99,], dest=tempdir(), name="quakes")

# Explore the new GeoJSON file
getProperties(q.dat)

# make style based on quake magnitude
q.style <- styleGrad(prop="mag", breaks=seq(4, 6.5, by=0.5),
style.val=rev(heat.colors(5)), leg="Richter Magnitude",
fill.alpha=0.7, rad=8)

# create map
savefile <- "C:\\Users\\Michele\\Documents\\Research\\Presentations & Talks\\2015 Davis RUG"
q.map <- leaflet(data=q.dat, dest=savefile, title="Fiji Earthquakes",
base.map="mqsat", style=q.style, popup="mag")

#q.map <- leaflet(data=q.dat, dest=tempdir(), title="Fiji Earthquakes",base.map="mqsat", style=q.style, popup="mag")

# view map in browser
q.map