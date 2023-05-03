###############################################################################
## basic packages
##############################################################################

if (!require(pdftools))
  install.packages("pdftools", dependencies=TRUE)

if (!require(tidyverse))
  install.packages("tidyverse", dependencies=TRUE)

if (!require(DT))
  install.packages("DT", dependencies=TRUE)

if (!require(gt))
  install.packages("gt", dependency=TRUE)


###############################################################################
## visualization packages
##############################################################################

if (!require(plotly))
  install.packages("plotly", dependencies=TRUE)


# install Dash for R
if (!require(remotes)){
  install.packages("remotes", dependencies=TRUE)
  
  if (!require(dash))
    remotes::install_github("plotly/dashR", upgrade = "always")
}

#install Dash bootstrap
if (!require(dashBootstrapComponents))
  install_github('facultyai/dash-bootstrap-components@r-release')
