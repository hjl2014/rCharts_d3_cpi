#here are the two data source, but really don't need to do this in R
#could easily supply the locations as data instead
#and use d3.tsv
#but might generate the filters in R just to show combo


#put items in data frame
items.df <- read.delim(
  "http://download.bls.gov/pub/time.series/ap/ap.item"
  , allowEscapes=TRUE
  , header=TRUE
  , stringsAsFactors=FALSE
  , strip.white=TRUE
)[,-2,drop=F]
items.df[,1] <- gsub(x=items.df[,1],pattern='\\"',replacement="")
items.df$item_name <- items.df$item_code
items.df$item_code <- rownames(items.df)

#get series data
series.df <- read.delim(
  "http://download.bls.gov/pub/time.series/ap/ap.series"
  , allowEscapes=TRUE
  , header=TRUE
  , stringsAsFactors=FALSE
  , strip.white=TRUE
)

#join items and series
require(dplyr)
items.joined <- items.df %.%
  left_join(series.df, by = "item_code")

#actually changed this to a saved tsv so r would not have to pass large data set
#load the average price file which is large
#prices.df <- read.delim(
#  "http://download.bls.gov/pub/time.series/ap/ap.data.0.Current"
#  , allowEscapes=TRUE
#  , header=TRUE
#  , stringsAsFactors=FALSE
#  , strip.white=TRUE
#)

require(rCharts)
options(viewer=NULL)

cpi1 <- rCharts$new()
cpi1$setLib(".")
cpi1$lib <- "d3_cpi"
#cpi1$addAssets(
  #possible bug in rCharts here since getting added to both css and js when css defined
  #in config.yml
  #css = "http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"
#  jshead = "http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.1/angular.min.js"
#)
cpi1$setTemplate(
  chartDiv = '<div></div>',
  afterScript = '<script></script>'
)
#just a couple of parameters that we might like to see
cpi1$set(
  bodyattrs = "ng-app",
  height = 500,
  width = 900,
  margins = list(bottom = 30, top = 50, left = 40, right = 400)
)
cpi1$params$filters = items.joined
cpi1$save("index.html",cdn=T)

