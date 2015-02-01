#Processing for PRISM data in .bil format


###### Location of Data Inputs ######
# Location of the folder containing the files you want to process & shapefile for point sampling
# Replace the paths here with the path to your files using \\ between each folder name

RasterFolder<-"C:\\PRISM\\All_PRISM_Temp\\"
PointSHP<-"C:\\PRISM\\SampleLocations_NAD83.shp"
SaveDataAs<-"C:\\PRISM\\Temperature.txt"
SaveDataAs_Long<-"C:\\PRISM\\Temperature_Long.txt"


####################################






########## Load libraries ##########

library(rgdal)
library(raster)
library(maptools)
library(reshape)


########## Data Processing #########
setwd(RasterFolder)
RasterFiles<-dir(RasterFolder, ".bil$")
#RasterFiles<-dir("C:\\Users\\mmtobias\\Documents\\PRISM\\Test_PRISM\\", ".bil$")
points<-readShapePoints(PointSHP)

q<-raster()
qstack<-stack(q)

for (i in RasterFiles) {
	s<-raster(i)
	qstack<- addLayer(qstack, s)
	}

samples<-extract(qstack, points)

newnames<-c()

for (i in RasterFiles) {	
	x<-substr(i, 26, 31)
	newnames<-c(newnames, x)
	}

samplematrix<-cbind(points$PK, samples)
colnames(samplematrix)<-c("SiteKey", newnames)
write.table(samplematrix, file=SaveDataAs, sep=",", row.names=FALSE)

long_temp<-melt(samplematrix, varnames="SiteKey")
colnames(long_temp)<-c("SiteKey", "YearMonth", "Value")
YearMonth<-long_temp$YearMonth
year<-substr(YearMonth, 0, 4)
month<-substr(YearMonth, 5, 6)
long_temp2<-cbind(long_temp, year, month)
write.table(long_temp2, file=SaveDataAs_Long, sep=",", row.names=FALSE)



