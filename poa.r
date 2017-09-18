## Download geometries of Australian postal areas from Australian Bureau of Statistics (ABS)
## and convert them to GeoJSON format.
##
## See http://www.abs.gov.au/AUSSTATS/abs@.nsf/Lookup/1270.0.55.003Main+Features1July%202016?OpenDocument

library(rgdal)
library(geojsonio)

# Create directories
dir.create('data_src', showWarnings = FALSE)
dir.create('data', showWarnings = FALSE)

# Download file from ABS website
url <- 'http://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&1270055003_poa_2016_aust_shape.zip&1270.0.55.003&Data%20Cubes&4FB811FA48EECA7ACA25802C001432D0&0&July%202016&13.09.2016&Latest'
src_file <- 'data_src/1270055003_poa_2016_aust_shape.zip'
download.file(url, destfile = src_file, mode='wb')

# Unzip and delete downloaded file
unzip(src_file, exdir = 'data_src')
unlink(src_file)

# Read shape file
poa <- readOGR("data_src/POA_2016_AUST.shp")
poa <- spTransform(poa, CRS("+proj=longlat +datum=WGS84"))
poa@data$POA_NAME16 <- NULL
names(poa@data) <- c('Postcode', 'AreaSqKm')

# Write GeoJSON file
geojson_write(poa, file = 'data/australia_postal_areas.geojson')
