# Gerekli kütüphaneler
library(dplyr)
library(tidyr)
library(plotly)

# Liman koordinatlarý ve ülke eþlemesi
port_coords <- tibble::tribble(
  ~Country, ~`Port Name`, ~Latitude, ~Longitude,
  "China", "Shanghai", 31.2304, 121.4737,
  "Netherlands", "Rotterdam", 51.8850, 4.2867,
  "Germany", "Hamburg", 53.5511, 9.9937,
  "Turkey", "Mersin", 36.8004, 34.6391,
  "Egypt", "Alexandria", 31.2046, 29.8801,
  "Lebanon", "Beirut", 33.9028, 35.5250,
  "Poland", "Gdansk", 54.3933, 18.6700,
  "Russia", "Novorossiysk (NUTEP)", 44.7330, 37.7830,
  "Ukraine", "Odessa", 46.5036, 30.7444,
  "United States", "Los Angeles", 33.7300, -118.2625
)

# 2018 ve 2024 verilerini filtrele ve büyüme oranýný hesapla
growth_data <- data_long %>%
  filter(Year %in% c(2018, 2024)) %>%
  group_by(Country, `Port Name`, Year) %>%
  summarise(Value = sum(Value, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = Year, values_from = Value) %>%
  mutate(
    growth_pct = (`2024` - `2018`) / `2018` * 100
  )

# Koordinatlarý ekle
growth_data <- growth_data %>%
  left_join(port_coords, by = c("Country", "Port Name"))

# Harita oluþtur
map <- plot_ly(
  data = growth_data,
  type = "scattergeo",
  mode = "markers",
  lat = ~Latitude,
  lon = ~Longitude,
  text = ~paste(`Port Name`, "<br>Büyüme (%):", round(growth_pct, 2)),
  marker = list(
    size = 10,
    color = ~growth_pct,
    colorscale = "YlOrRd",
    colorbar = list(title = "Büyüme (%)"),
    line = list(width = 0.5, color = 'black')
  )
) %>%
  layout(
    title = list(
      text = "2018–2024 Arasý Liman Ticaret Hacmi Büyüme Oranlarý",
      x = 0.5,
      y = 0.95,
      font = list(size = 18)
    ),
    geo = list(
      scope = 'world',
      projection = list(type = 'natural earth'),
      showland = TRUE,
      landcolor = 'rgb(217, 217, 217)',
      subunitwidth = 1,
      countrywidth = 1,
      subunitcolor = 'rgb(255, 255, 255)',
      countrycolor = 'rgb(255, 255, 255)'
    )
  )

map
