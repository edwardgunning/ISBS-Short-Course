# script to produce the fda logo on the README
library(fda)        # CRAN v5.5.1
library(data.table) # CRAN v1.14.2
library(ggplot2)    # CRAN v3.4.2
source("functions/theme_gunning.R")
theme_gunning()

handwritx <- data.table(time= handwritTime,  handwrit[,,1]) 
handwrity <- data.table(time= handwritTime,  handwrit[,,2]) 


handwritx_lng <- melt.data.table(handwritx, id.vars = "time")
handwrity_lng <- melt.data.table(handwrity, id.vars = "time")

handwrit_lng <- merge.data.table(x = handwritx_lng, y = handwrity_lng, c("time", "variable"))

ggplot(handwrit_lng) +
  aes(x = value.x, y = value.y, group = variable, colour = variable) +
  geom_path() +
  theme_classic() +
  theme(legend.position = "none",
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(), 
        axis.line = element_line(linewidth = 4))

ggsave(filename = "logo/fda-logo.png", device = "png")
