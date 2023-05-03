###############################################################################
#
# visualization
# requires data_load.R, custom_theme.R
#
# resources:
# - https://viz-ggplot2.rsquaredacademy.com/ggplot2-modify-axis.html
#
###############################################################################


source("data_load.R")
source("custom_theme.R")

library(devtools)
library(plotly)
library(dash)
library(scales)
library(gt)
library(DT)


# data components

################################################################################
# style properties
################################################################################
cardWidth <- "22rem" 
cardMargin <- "5px"

minNumberOfEmployees <- 10
top10 <- 10
top5 <- 5

################################################################################
# most and least compensated individuals
mostCompensated <- (data %>% arrange(desc(salary))) [1, ]
mostCompensated$formattedTitle <- mostCompensatedTitle <- paste0(mostCompensated$title, " (" , mostCompensated$dept, ") ")

leastCompensated <- (data %>% arrange(salary)) [1, ]
leastCompensated$formattedTitle <- leastCompensatedTitle <- paste0(leastCompensated$title, " (" , leastCompensated$dept, ") ")

basicStats <- mostCompensated %>% 
  rbind(leastCompensated) %>% 
  gt()  %>% 
  fmt_currency( columns = 4) %>%
  as.data.frame()


################################################################################
# depart totals

highestSalary <- max(data$salary)

totalCutoff <- highestSalary

data %>% group_by(dept) %>% 
  summarise(total_salaries=sum(salary), num_employees=n()) %>% 
  filter(num_employees >= 10 & total_salaries <  totalCutoff) %>% 
  arrange(desc(total_salaries)) %>% 
  gt()
  


################################################################################
# top 10 and bottom 10

# top 10 most highly compensated
topIndividuals <- (data %>% arrange(desc(salary)))[1:top5, ]  %>% select(title, dept, salary)
colnames(topIndividuals) <- c("Title", "Department", "Salary")

topIndividuals <- topIndividuals %>% gt()  %>% 
  fmt_currency( columns = 3) %>%
  as.data.frame()


plotlyTableTopIndividuals <- plot_ly(
  type = 'table',
  header = list(
    values = names(topIndividuals),
    fill = list(color = 'black'),
    font = list(color = "white", size="14")),
  width = "10rem",
  cells=list(
    values = t(as.matrix(unname(topIndividuals))))
)
plotlyTableTopIndividuals

gtTable <- topIndividuals %>% gt()

# top earners by dept
top10Depts <- (data %>% group_by(dept) %>%summarise(count=n(), avg=mean(salary), min=min(salary), max=max(salary))  %>%
                   filter(count>=minNumberOfEmployees) %>% 
                   arrange(desc(avg)))[1:top10, ] 

top10Depts$dept <- as.factor(top10Depts$dept)
top10Depts$category <- "most compensated"

bottom10Depts <-  (data %>% group_by(dept) %>% summarise(count=n(), avg=mean(salary), min=min(salary), max=max(salary)) %>% 
                       filter(count>=minNumberOfEmployees) %>% 
                       arrange(avg))[1:top10, ]
bottom10Depts$category <- "least compensated"


plotlyFigTop10Depts <- plot_ly( top10Depts, x = ~dept, y=~avg, type = "bar")
plotlyFigButtom10Depts <- plot_ly( bottom10Depts, x = ~dept, y=~avg, type = "bar")


# combined
combinedTopBottom <- top10Depts %>% rbind(bottom10Depts)


#  using ggplot integration
#
 figTop10Depts <- top10Depts %>% 
   mutate(dept = fct_reorder(dept, avg)) %>% 
  ggplot(aes(x=dept, y=avg, fill=dept)) +  geom_col() + 
    ggtitle("Top 10 Departments by Avg Salary") + xlab("") + ylab("avg salary") +  coord_flip() + 
    scale_fill_manual(values = my_colors_20) +
    coord_flip() + theme(legend.position = "none")


figButtom10Depts <- bottom10Depts %>%
  ggplot(aes(x=dept, y=avg, fill=category)) +  geom_col() + 
  ggtitle("Bottom 10 Departments by Avg Salary") + xlab("")  + ylab("avg salary") +  coord_flip() + 
  scale_fill_manual(values = my_colors_20) +
  coord_flip() + theme(legend.position = "none")

figCombinedTopBottom <- combinedTopBottom %>%
  mutate(dept = fct_reorder(dept, avg)) %>% 
  ggplot(aes(x=dept, y=avg, fill=category)) +  geom_col() + 
  ggtitle("Top and Bottom 10 Departments by Avg Salary") + xlab("")  + ylab("average salary(USD)") +  coord_flip() + 
  scale_fill_hue(l=40)+
  scale_y_continuous(limits = c(0,150000),
                     breaks = c(0,25000, 50000, 75000, 100000, 125000, 150000),
                     labels = c("0", "25K", "50K", "75K", "100K", "125K", "150K")
                     )

figCombinedTopBottom

ggplotFigTop      <- ggplotly(figTop10Depts)
ggplotFigBottom10 <- ggplotly(figButtom10Depts)
ggplotFigCombinedTopBottom <- ggplotly(figCombinedTopBottom)


topIndividualsDashTable <- dashDataTable(
  id="table"
  ,data=df_to_list(topIndividuals)  
  ,style_table = list(maxHeight = "150px",overflowY = "scroll", maxWidth="650px")
  ,style_cell = list(textAlign="left", border="1px solid gray")
  
  #,style_data = list(textAlign="left")
  
)


################################################################################
# layout components
################################################################################

headerStyle <- list(align="center", fontWeight="bold", textAlign="center")
cardHeaderStyle <- list(fontWeight="bold")

header <- list(dbcCol(h1("ETSU 2022 Active Employee Salaries"), style = headerStyle))

card1 <- dbcRow( 
  dbcCol(dbcCard(list(
    dbcCardHeader(p("Most Compensated Employee"), style = cardHeaderStyle),
    dbcCardBody(
      div(h3(basicStats$salary[1], className = "card-title"), p(basicStats$formattedTitle[1])))),
    style = list(width=cardWidth, margin=cardMargin),color = "warning", inverse = "true"
  )))

card2 <- dbcRow(
  dbcCol(dbcCard(list(
    dbcCardHeader(p("Least Compensated Employee"), style = cardHeaderStyle),
    dbcCardBody(div(h3(basicStats$salary[2], className = "card-title"), p(basicStats$formattedTitle[2])))),
    style = list(width=cardWidth, margin=cardMargin, text_aligh="center"),color = "danger", inverse = "true"
  )))

card3 <- dbcRow( 
  dbcCol(dbcCard(list(
    dbcCardHeader(p("2022 Total Active Employees"), style = cardHeaderStyle),
    dbcCardBody(div(h3(nrow(data), className = "card-title")))),
    style = list(width=cardWidth, margin=cardMargin),color = "dark", inverse = "true"
  )))

