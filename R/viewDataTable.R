####################################
# add data table options
# Authors: Komal Rathi
# Organization: DBHi, CHOP
####################################

viewDataTable <- function(dat, pageLength){
  DT::datatable(dat,
                extensions = c('Buttons'),
                selection = "single",
                filter = "bottom",
                options = list(dom = 'Bfrtip',
                               buttons = list('colvis','pageLength',
                                              list(extend = "collection", 
                                                   buttons = c('csv', 'excel'), 
                                                   text = 'Download')),
                               pageLength = pageLength,
                               searchHighlight = TRUE,
                               initComplete = JS("function(settings, json) {",
                                                 "$(this.api().table().header()).css({'background-color': '#005ab3', 'color': '#fff'});",
                                                 "}"),
                               scrollX = TRUE)
                )
}