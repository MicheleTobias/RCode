#PURPOSE: Scrape the links and link descriptions from the old Map & GIS LibGuide
# http://guides.lib.ucdavis.edu/Maps_GIS

# Reference: http://dsi.ucdavis.edu/ClimateRefuge/
# Reference: http://datascience.ucdavis.edu/NSFWorkshops/WebScraping/ScheduleOutline.html 
# Regex Builder: http://regexr.com/ 

#Load Libraries
library(XML)
library(RCurl)

#Where to save the CSV of links and what to call it
#SaveFileAs <- "C:\\Users\\mmtobias\\Documents\\Website\\Links.csv"
SaveFileAs <- "C:\\Users\\mmtobias\\Documents\\Website\\MapsOnline.csv"

#The target website
#LibGuide = "http://guides.lib.ucdavis.edu/Maps_GIS"
LibGuide = "http://guides.lib.ucdavis.edu/Maps_Online"

#Download website to a file
#getHTMLLinks(LibGuide)

raw.html<-htmlTreeParse(LibGuide, useInternalNodes=T)

#Parse HTML

#Stuff that didn't work:
#link.text<-xpathSApply(raw.html, "//a", xmlValue)
#uls<-xpathSApply(raw.html, "//li", xmlValue)
#uls<-getNodeSet(raw.html, "//li|//a/@href")

#Get the nodes that are unordered list items <li>
#lis<-getNodeSet(raw.html, "//li")
lis<-getNodeSet(raw.html, "//div[@class='linkdesc']//..")

#Get Links
#as<-getNodeSet(lis[[1]], "//a")

as<-getNodeSet(raw.html, "//div[@class='linkdesc']//..//a")
#as<-sapply(lis, getNodeSet, "//a")
link.raw<-sapply(as, xmlGetAttr, "href")
link<-unlist(link.raw)



#Get Link Text
link.text.raw<-sapply(as, xmlValue, "//a")
link.text<-unlist(link.text.raw)



#Get Link Description
#link.desc<-getNodeSet(raw.html, "//div[@class='linkdesc']")
link.desc<-getNodeSet(raw.html, "//div[@class='linkdesc']")
link.desc.text<-sapply(link.desc, xmlValue)
link.desc.text<-unlist(link.desc.text)


dftest<-data.frame(link[-19], link.text[-19], link.desc.text, stringsAsFactors = FALSE)

write.csv(dftest, file=SaveFileAs)
