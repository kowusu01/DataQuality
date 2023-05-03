###############################################################################
#
# visualization
# requires load_data.R
#
###############################################################################


# install devtools
if(!require(devtools)){
  install.packages("devtools")
}
library(devtools)


# install Dash for R
if (!require(remotes)){
    install.packages("remotes")
    remotes::install_github("plotly/dashR", upgrade = "always")
}

#install Dash bootstrap
#install_github('facultyai/dash-bootstrap-components@r-release')
if (!require(DT))
  install.packages("DT")

library(plotly)
library(dash)
library(scales)
library(gt)
library(DT)



mostCompensated <- (data %>% arrange(desc(salary))) [1, ]
mostCompensated$formattedTitle <- mostCompensatedTitle <- paste0(mostCompensated$title, " (" , mostCompensated$dept, ") ")

leastCompensated <- (data %>% arrange(salary)) [1, ]
leastCompensated$formattedTitle <- leastCompensatedTitle <- paste0(leastCompensated$title, " (" , leastCompensated$dept, ") ")

basicStats <- mostCompensated %>% 
  rbind(leastCompensated) %>% 
  gt()  %>% 
  fmt_currency( columns = 4) %>%
  as.data.frame()


minNumberOfEmployees <- 10
topN <- 10

top10Earners <- (data %>% group_by(dept) %>%summarise(count=n(), avg=mean(salary), min=min(salary), max=max(salary))  %>%
                   filter(count>=minNumberOfEmployees) %>% 
                   arrange(desc(avg)))[1:topN, ] 

top10Earners$category <- "top"

bottom10Earners <-  (data %>% group_by(dept) %>% summarise(count=n(), avg=mean(salary), min=min(salary), max=max(salary)) %>% 
                       filter(count>=minNumberOfEmployees) %>% 
                       arrange(avg))[1:topN, ]
bottom10Earners$category <- "bottom"


# departs with more than 10 employees
topButtomEarners <- top10Earners %>% rbind(bottom10Earners)

topButtomEarners$category <- as.factor(topButtomEarners$category)
glimpse(topButtomEarners)

figTop10Earners <- plot_ly( top10Earners, x = ~dept, y=~avg, type = "bar")
figButtom10Earners <- plot_ly( bottom10Earners, x = ~dept, y=~avg, type = "bar")

figButtom10Earners
figTop10Earners


top10Earners %>%
  ggplot(aes(x=dept, y=avg, fill=category)) +  geom_col() +  ggtitle("Top 10 Departments by Avg Salary") + xlab("department") + ylab("avg salary") +  coord_flip() + 
  scale_fill_manual(values = my_colors_20) +
  coord_flip() + theme(legend.position = "none")


bottom10Earners %>%
  ggplot(aes(x=dept, y=avg, fill=category)) +  geom_col() +  ggtitle("Bottom 10 Departments by Avg Salary") + xlab("department") +  ylab("avg salary") +  coord_flip() + 
  scale_fill_manual(values = my_colors_20) +
  coord_flip() + theme(legend.position = "none")


# 1. create an app and link it to a stylesheet
app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

# 2. create the layout
app$layout(
  
  dbcContainer(
    div(
      list(
        dbcRow(
          list(dbcCol(h1("ETSU 2022 Active Employee Salaries"), style = list(align="center")))
        ),
        dbcRow(
          list(
                dbcCol(list(
                  
                      dbcRow( 
                        dbcCol(dbcCard(list(
                          dbcCardBody(
                            div(p("Most Compensated Employee"), h3(basicStats$salary[1], className = "card-title"), p(basicStats$formattedTitle[1])))),
                             style = list(width="18rem", margin="5px"),color = "warning", inverse = "true"
                             ))),
                      dbcRow(
                        dbcCol(dbcCard(list(
                          dbcCardBody(div(p("Least Compensated Employee"), h3(basicStats$salary[2], className = "card-title"), p(basicStats$formattedTitle[2])))),
                          style = list(width="18rem", margin="5px", text_aligh="center"),color = "danger", inverse = "true"
                          
                          ))),
        
                      dbcRow( 
                        dbcCol(dbcCard(list(
                          dbcCardBody(div( p("Total Number of Job Titles"), h3(unique(data$title) %>% length(), className = "card-title")))),
                          style = list(width="18rem", margin="5px"),color = "dark", inverse = "true"
                          ))),
        
                      dbcRow( 
                        dbcCol(dbcCard(list(
                          dbcCardBody( div(p("2022 Total Active Employees"),h3(nrow(data), className = "card-title")))),
                          style = list(width="18rem", margin="5px"),color = "dark", inverse = "true"
                          ))),
                        
                      dbcRow( 
                        dbcCol(dbcCard(list(
                          dbcCardBody( div(p("2022 Total Number of Departments"), h3(unique(data$dept)  %>% length() ,className = "card-title")))),
                          style = list(width="18rem", margin="5px"),color = "dark", inverse = "true"
                          )))
                      )), 
                 
               dbcCol(dccGraph(fig=figTopAndBottom10Earners))
          )
        )
        ))
  )
)
      
      

app$run_server(showcase = TRUE)

