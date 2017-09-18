## Read geometries of Australian postal areas and Greater Sydney districts,
## calculate intersections of the two and generate a mapping of postal areas to districts

library(rgdal)
library(geojsonio)
library(maptools)
library(raster)
library(data.table)
library(dplyr)

# Read postal areas and districts
poa       <- geojson_read('data/australia_postal_areas.geojson', what = 'sp')
districts <- geojson_read('data/sydney_districts.geojson',      what = 'sp')

# Intersect postal areas with districts
pdi <- intersect(poa, districts)

# Add polygon area to data frames
add.area <- function (spdf) {
    areas <- data.frame(Area = sapply(spdf@polygons, function(x) { slot(x, 'area') }))
    row.names(areas) <- sapply(spdf@polygons, function(x) { slot(x, 'ID') })
    spdf$Area <- NULL
    spCbind(spdf, areas)
}

poa <- add.area(poa)
pdi <- add.area(pdi)

# Export postal area to district mappings (may have multiple districts per postcode)
pdm <- pdi@data %>%
    left_join(poa@data, by = 'Postcode') %>%
    mutate(DistrictAreaPercentage = round(Area.x / Area.y, 2)) %>%
    filter(DistrictAreaPercentage >= 0.1) %>%
    dplyr::select(Postcode, District, DistrictAreaPercentage)

# Export unique postal area to district mappings (only keep mapping with largest overlap)
pdmu <- pdm %>%
    group_by(Postcode) %>%
    top_n(1, DistrictAreaPercentage)

fwrite(pdm,  'data/poa_district.csv')
fwrite(pdmu, 'data/poa_district_unique.csv')


# -----------------------------------------------------------------------------

# Define colors for districts
district_colors <- list(
    `Central`      = '#f1ce63',  # yellow
    `North`        = '#e15759',  # red
    `South`        = '#a0cbe8',  # blue
    `South West`   = '#f28e2b',  # orange
    `West`         = '#8cd17d',  # green
    `West Central` = '#b07aa1'   # purple
)

# Subset postal areas to relevant ones
poa2 <- subset(poa, Postcode %in% pdm$Postcode)
poa2@data <- merge(poa2@data, pdmu, by = 'Postcode', all.x = T, all.y = F, sort = F)

# Add color
districts@data$Color <- sapply(districts@data$District, function (x) { district_colors[[x]] })
poa2@data$Color      <- sapply(poa2@data$District,      function (x) { district_colors[[x]] })

# Calculate label positions (centroid of polygon) for large enough postal areas
poa3 <- subset(poa2, Area >= 0.0001)
poa_label <- as.data.table(coordinates(poa3))
names(poa_label) <- c('Longitude', 'Latitude')
poa_label$Postcode <- poa3@data$Postcode
poa_label <- SpatialPointsDataFrame(poa_label[, list(Longitude, Latitude)], poa_label)

# Plot map to SVG file
dir.create('plot', showWarnings = FALSE)
svg(filename = 'plot/sydney_poa_district_map.svg', width = 30, height = 30, pointsize = 10)
plot(poa2, col = adjustcolor(poa2@data$Color, alpha.f = 0.5), lwd = 0.5, border = '#666666')
plot(districts, col = adjustcolor(districts@data$Color, alpha.f = 0.5), border = '#ffffff', add = T)
text(poa_label, poa_label@data$Postcode, cex = 0.6, col = '#666666')
dev.off()
