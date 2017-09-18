# geography-australia

This repository currently contains the following data assets.

* **[data/australia_postal_areas.geojson](https://github.com/itssimon/geography-australia/blob/master/data/australia_postal_areas.geojson)**<br>
  Approximations of Australian postcode boundaries by Australian Bureau of Statistics (ABS). GeoJSON file provided here is simply a conversion of the shape file published by the ABS. See [here](http://www.abs.gov.au/ausstats/abs@.nsf/Lookup/by%20Subject/1270.0.55.003~July%202016~Main%20Features~Postal%20Areas%20(POA)~8) for details about the source data.
* **[data/sydney_districts.geojson](https://github.com/itssimon/geography-australia/blob/master/data/sydney_districts.geojson)**<br>
  Boundaries of the six Greater Sydney Districts. Sourced from [this](https://www.greater.sydney/my-district) official website.
* **[data/poa_district.csv](https://github.com/itssimon/geography-australia/blob/master/data/poa_district.csv)**<br>
  A mapping of postal areas / postcodes to the six Greater Sydney Districts. One postcode may span multiple districts which is reflected in the data set. The column `DistrictAreaPercentage` informs on the percentage of area overlap. Postcodes that have an overlap with districts of less than 10% have not been mapped at all. There is also a [unique mapping file](https://github.com/itssimon/geography-australia/blob/master/data/poa_district_unique.csv) with postcodes assigned to the district with the largest intersection. [This map](https://github.com/itssimon/geography-australia/blob/master/plot/sydney_poa_district_map.svg) shows the unique mapping.
