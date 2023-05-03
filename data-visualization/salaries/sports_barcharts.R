

sports_depts <- c("Mens Golf", "Womens Golf"
                  ,"Mens Tennis", "Womens Tennis",
                   "Mens Soccer","Womens Soccer")

(data %>% filter(dept == "Mens Basketball" & title=="Head Coach") %>% arrange(desc(salary)))[1,] %>%
rbind((data %>% filter(dept == "Womens Basketball" & title=="Head Coach") %>% arrange(desc(salary)))[1,]) %>% 
rbind(
(data %>% filter(dept %in% sports_depts)) %>% filter(title=="Head Coach")) %>%
  mutate(
    gender = if_else(dept %like% "Womens", "Womens", "Mens"),
    sport = if_else(dept %like% "Golf", "Golf", 
                    if_else(dept %like% "Basketball", "Basketball", 
                            if_else(dept %like% "Tennis", "Tennis", "Soccer")))
  )  %>% 
  mutate(gender=factor(gender)) %>% 

  ggplot(aes(x=gender, y=salary, fill=gender)) +
  geom_col() +
  ggtitle("Coaches Salary Across Different Sports and Gender") +
  xlab("Head Coach Salary") + ylab("Amount") +
  scale_x_discrete(limits = c("Mens", "Womens")) +
  scale_y_continuous(
    limits = c(0, 350000), 
    labels = c("0", "50K", "100K", "150K", "200K", "250K", "300K", "350K"),
    breaks = c(0, 50000, 100000, 150000, 200000, 250000, 300000, 350000)
    ) +
  theme(, axis.text.x = element_blank(), legend.title = element_blank()) +
  facet_grid(~sport)

