################################################################################
## dashboard layout
################################################################################

source("requirements.R")
source("data_components.R")


# ______________________________________________________________________________
#                                       header
# ______________________________________________________________________________
#                                            ___________________________________
#  _____________________________            |                                   |
# |        card1                |           |                                   |
# |_____________________________|           |                                   |
#                                           |                                   |  
#  _____________________________            |   top and botttom earners         |
# |       card2                 |           |    (figure                        |
# |_____________________________|           |                                   |
#                                           |                                   |
#  _____________________________            |                                   |
# |     card3                   |           |                                   |
# |_____________________________|           |___________________________________
#                                           
#
#                                           ____________________________________
#                                           |                                   |
#                                           |                                   |
#                                           |            table                  |
#                                           |                                   |
#                                           |                                   |
#                                           |___________________________________
#
#_______________________________________________________________________________


# 1. create an app and link it to a stylesheet
app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

# 2. create the layout
app$layout(
  
  dbcContainer(
    div(
      list(
        
        dbcRow(header),
        
        dbcRow(
          list(
            dbcCol(list(card1, card2, card3), width = "4"),
            dbcCol(list(
              dbcRow( list(dbcCol(list( dccGraph(fig=ggplotFigCombinedTopBottom ) )) )) ,
              #dbcRow(dbcCol(list(p("Top 5 most compensated"), dccGraph(fig=plotlyTableTopIndividuals) ) ) )
              dbcRow(dbcCol(topIndividualsDashTable))
            )#list
            ) #col
          )#list
        ))
    ))
)# layout

app$run_server(showcase = TRUE)
