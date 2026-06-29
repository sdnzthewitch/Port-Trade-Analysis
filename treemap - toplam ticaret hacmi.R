library(plotly)
library(dplyr)
library(tidyr)

# Toplam ticaret hacmini liman bazýnda hesapla
total_trade <- data_long %>%
  group_by(`Port Name`) %>%
  summarise(total_value = sum(Value, na.rm = TRUE)) %>%
  ungroup()

# Treemap oluþtur (liman bazlý)
treemap <- plot_ly(
  data = total_trade,
  type = "treemap",
  labels = ~`Port Name`,
  parents = NA,
  values = ~total_value,
  textinfo = "label+value",
  marker = list(
    colors = ~total_value,
    colorscale = "Blues",
    colorbar = list(title = "Total TEU")
  ),
  text = ~paste(`Port Name`, "<br>Toplam TEU:", round(total_value))
)

treemap

