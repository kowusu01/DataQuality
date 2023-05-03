
plotlyTableTopIndividuals <- plot_ly(
  type = 'table',
  header = list(
    values = names(top10Individuals)),
  cells=list(
    values = t(as.matrix(unname(top10Individuals))))
)

plotlyTableTopIndividuals


