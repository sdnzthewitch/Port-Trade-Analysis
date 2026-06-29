library(tidyr)
library(dplyr)

data <- readxl::read_xlsx("C:/Users/DELL/Desktop/Grafiksel Veri Analizi/dýþ ticaret hacmi verisi.xlsx")
data_long <- data %>%
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "Year",
    values_to = "Value"
  ) %>%
  mutate(Year = as.integer(Year))


# 2. Z-score standardizasyonu
economic_z <- data_long %>%
  group_by(`Port Name`) %>%
  mutate(Value_z = scale(Value)) %>%
  ungroup()

library(ggplot2)
economic_z_clean <- economic_z %>%
  filter(!is.na(Value_z))

ggplot(economic_z_clean, aes(x = Value_z, fill = `Port Name`)) +
  geom_density(alpha = 0.7, color = "black") +
  facet_wrap(~ `Port Name`, scales = "free_y", ncol = 3) +
  labs(
    title = "2018–2024 Arasý Limanlarýn Standartlaþtýrýlmýþ Ticaret Yoðunluðu",
    subtitle = "Her limanýn kendi daðýlýmý Z-score ile normalize edilmiþtir",
    x = "Z-score",
    y = "Yoðunluk"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "none",
    strip.text = element_text(face = "bold", size = 12),
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12)
  ) +
  scale_fill_brewer(palette = "Set3")

total_trade <- data_long %>%
  group_by(`Port Name`) %>%
  summarise(total_value = sum(Value, na.rm = TRUE)) %>%
  mutate(share = round(total_value / sum(total_value) * 100, 1))

treemap(total_trade,
index = "Port Name",
vSize = "Total",
title = "2018–2024 Arasý Limanlarýn Küresel Ticaret Hacmi Payý (%)",
palette = "Set2",
fontcolor.labels = "black",
fontface.labels = 2,
fontsize.labels = 12,
align.labels = list(c("center", "center")),
border.col = "white",
fontsize.title = 14)



library(readxl)
library(dplyr)
install.packages("sf")
library(sf)
library(ggplot2)
install.packages("rnaturalearth")
library(rnaturalearth)
install.packages("rnaturalearthdata")
library(rnaturalearthdata)
library(tidyr)             

# 2018 ve 2024 yýllarýna göre filtre ayrý toplamlarý al
growth_df <- data_long %>%
  filter(Year %in% c(2018, 2024)) %>%
  group_by(Country, Year) %>%
  summarise(total = sum(Value, na.rm = TRUE)) %>%
  pivot_wider(names_from = Year, values_from = total) %>%
  mutate(growth = round(((`2024` - `2018`) / `2018`) * 100, 1))

world <- ne_countries(scale = "medium", returnclass = "sf")

# ISO_A3 kodu yerine doðrudan ülke ismi ile join
world_growth <- left_join(world, growth_df, by = c("name" = "Country"))


ggplot(world_growth) +
  geom_sf(aes(fill = growth), color = "black", size = 0.2) +
  scale_fill_gradient2(
    low = "darkred", mid = "orange", high = "lightyellow",
    midpoint = 20, na.value = "white",
    name = "2018–2024\nGrowth (%)"
  ) +
  labs(title = "2018–2024 Arasý Büyüme Oraný (%)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 8)
  )


# Her liman için yýllýk Z-score'lu deðerleri al

shapiro.test(economic_z$Value_z)  # Normal daðýlým testi (genel)


# Perform Kruskal-Wallis test
kruskal_result <- kruskal.test(Value ~ `Port Name`, data = data_long)

# Extract H statistic, sample size n, and number of groups k
H <- kruskal_result$statistic
n <- length(data_long$Value)
k <- length(unique(data_long$`Port Name`))

# Calculate eta-squared effect size
eta_squared <- (H - k + 1) / (n - k)
print(paste("Eta-squared effect size:", round(eta_squared, 4)))

library(car)  # if not installed, run install.packages("car")

leveneTest(Value ~ `Port Name`, data = data_long)

pairwise.wilcox.test(data_long$Value, data_long$`Port Name`, p.adjust.method = "bonferroni")

library(dplyr)  # if not installed, run install.packages("dplyr")

desc_stats <- data_long %>%
  group_by(`Port Name`) %>%
  summarise(
    n = n(),
    mean = mean(Value),
    median = median(Value),
    sd = sd(Value),
    IQR = IQR(Value)
  )

print(desc_stats)

library(boot)  # if not installed, run install.packages("boot")

# Function to compute median
median_fun <- function(data, indices) {
  return(median(data[indices]))
}

# Bootstrap CI for each Port Name
cis <- data_long %>%
  group_by(`Port Name`) %>%
  summarise(
    median = median(Value),
    lower_CI = {
      boot_obj <- boot(Value, median_fun, R = 1000)
      boot.ci(boot_obj, type = "perc")$percent[4]
    },
    upper_CI = {
      boot_obj <- boot(Value, median_fun, R = 1000)
      boot.ci(boot_obj, type = "perc")$percent[5]
    }
  )

print(cis)
