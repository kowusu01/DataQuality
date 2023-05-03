
#########################################################################
# my custom bar chart theme
#########################################################################

#plot.title
chart_main_title_theme <- theme(plot.title = element_text(size = 10))

#axis title and text
chart_axis_theme <-  theme(axis.title =  element_text(face = "bold"),
                           axis.text = element_text(size = 10) ) 

angled_30_x_axis_labels_theme <- theme(axis.text.x = element_text(angle = 30, vjust=.8, hjust=0.8))
angled_45_x_axis_labels_theme <- theme(axis.text.x = element_text(angle = 45, vjust=.8, hjust=0.8) )
angled_90_x_axis_labels_theme <- theme(axis.text.x = element_text(angle = 90) )

classic_chart_theme <- theme_classic() + chart_main_title_theme + chart_axis_theme

gray_chart_theme <- theme_gray() + chart_main_title_theme + chart_axis_theme 

minimal_chart_theme <- theme_minimal() + chart_main_title_theme + chart_axis_theme

gray_chart_theme_45 <- theme_gray() + chart_main_title_theme +
  chart_axis_theme + angled_45_x_axis_labels_theme


#################################################
##
## http://applied-r.com/rcolorbrewer-palettes/
## 
## set color palette:
##  - scale_fill_brewer(palette = "RdYlGn") 
##  - scale_fill_manual(values = my_colors_17) 
##
## display.brewer.pal(7,"BrBG")
## brewer.pal(7,"BrBG")
##
# create my own color pallete for long categorical list
# pick similar color blind friendly from different pallettes

my_colors_20 <- c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3", "#FDB462", "#B3DE69", 
                  "#FCCDE5", "#FEE0D2", "#D9D9D9", "#BC80BD", "#CCEBC5", "#FFED6F", "#31A354",
                  "#034E7B", "#006837","#D95F0E" ,"#993404", "#3690C0" ,"#0570B0")

my_colors_8<-c("#F4A582", "#92C5DE","#66C2A5", "#A6D854","#FFD92F", "#66BD63", "#1A9850", "#FDAE61", "#D9EF8B")

my_colors_8<-c( "#1A9850")

