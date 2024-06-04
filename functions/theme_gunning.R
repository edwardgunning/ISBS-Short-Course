theme_gunning <- function() {
  require(ggplot2)
  theme_set(theme_bw())
  theme_update(strip.text = element_text(size = 9),
               text = element_text(size = 9),
               panel.grid.minor = element_blank(),
               axis.title = element_text(size = 9),
               legend.text = element_text(size = 9, hjust = 0.5),
               plot.title = element_text(hjust = 0.5, size = 9.5, face = "bold"))
}
