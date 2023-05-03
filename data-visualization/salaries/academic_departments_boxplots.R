
source("data_load.R")

exclude_depts <- c("Quillen Chair of Geriat Geront", 
                   "Quillen Chair Education",
                   "Degree Programs",
                   "Dean College of Medicine",
                   "Dean College of Public Health Adm",
                   "Student Services COM")

academic_depts <- data %>% filter(title %in% c("Professor", "Associate Professor", "Assistant Professor")) %>% 
  subset(!(dept %in% exclude_depts))

depts_with_over_N_employees <- academic_depts %>% 
  group_by(dept) %>% summarise(count=n(), avg=mean(salary), min=min(salary), max=max(salary)) %>% 
  arrange(desc(avg)) %>% 
  filter(count >= minTenEmployees) %>% 
  select(dept)

topN_depts_with_over_N_employees <- depts_with_over_N_employees$dept[1:top5]

top_academic_depts_over_N_employees <- academic_depts %>% 
  subset(dept %in% topN_depts_with_over_N_employees) %>% 
  filter(title %in%c("Professor", "Associate Professor", "Assistant Professor"))

top_academic_depts_over_N_employees$dept <- as.factor(top_academic_depts_over_N_employees$dept)
top_academic_depts_over_N_employees %>% 
  ggplot(aes(x=fct_reorder(dept,salary), y=salary, fill=dept)) + 
  geom_boxplot(outlier.shape = NA) +
  scale_y_continuous(limits = c(0, 200000),
                     breaks = c(0,50000, 100000, 150000, 200000),
                     labels = c("0", "50K", "100K", "150K", "200K")) + 
  coord_flip() +
  theme(axis.ticks.x=element_blank()
        ,legend.position = "none"
        ,axis.title.y = element_blank()
        )

