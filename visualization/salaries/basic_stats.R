###############################################################################
#
# basic stats
# requires load_data.R
#
###############################################################################



# remove all rows with NAs
data <- data[complete.cases(data), ]

unique(data$dept)  %>% length()
unique(data$title) %>% length()
min(data$salary)
max(data$salary)
mean(data$salary)

# interested depts

data %>% filter(title %in% c("Professor", "Associate Professor", "Assistant Professor")) |> 
  select(dept) %>%  distinct %>% arrange(dept)


data %>% filter(dept=="Quillen Chair Education") %>% 

data %>% filter(dept=="Dean College of Medicine") |> arrange(desc(salary))
data |> filter(dept %like% c("Medicine")) |> select(dept) %>% distinct

data %>% filter(dept=="COM Research Department of Med Ed")


data %>% filter(dept=="Womens Baseball")
data %>% filter(dept=="Mens Baseball")

data %>% filter(dept=="Mens Soccer")
data %>% filter(dept=="Womens Soccer")

data %>% filter(dept=="Mens Tennis")
data %>% filter(dept=="Womens Tennis")

data %>% filter(dept %like% "Track")
data %>% filter(dept=="Womens Track And Field")

data %>% mutate(cents = salary - round(salary)) %>% filter(cents < 0) %>% arrange(cents)


data %>% filter(dept=="Pediatrics")


# interested titles
data %>% filter(title=="Dean")
data %>% filter(title=="Director")
data %>% filter(title=="Professor")

# rename the columns
#colnames(data) <- c("name", "dept", "title", "salary")

top10 <- data %>% group_by(dept) %>% summarise(count=n(), avg=mean(salary), min=min(salary), max=max(salary)) %>% 
  arrange(desc(avg))[1:10,] 

top10

fig <- plot_ly((data %>% group_by(dept) %>%
                 summarise(count=n(), avg=mean(salary), min=min(salary), max=max(salary)) %>% 
                 arrange(desc(avg)))[1:10,], 
               x = ~dept, y=~avg, 
               type = "bar")
fig

# plot box plot for professor
fig <- plot_ly(data %>% filter(dept=="Pediatrics" & title=="Professor"),  y=~salary, type = "box")
fig

fig <- plot_ly(data %>% filter(dept=="Pediatrics" & title=="Assistant Professor"),  y=~salary, type = "box")
fig


fig <- plot_ly(data %>% filter(dept=="Custodial Services" ),  y=~salary, type = "box")
fig

fig <- plot_ly(data %>% filter(dept=="University School" ),  y=~salary, type = "box")
fig

fig <- plot_ly(data %>% filter(dept=="Infor Technology Comp Svcs" ),  y=~salary, type = "box")
fig

fig <- plot_ly(data %>% filter(dept=="Mathematics and Statistics" ),  y=~salary, type = "box")
fig


data %>% group_by(dept) %>% summarise(count = n()) %>% arrange(desc(count)) %>% filter(count > 10)

