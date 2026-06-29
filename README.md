# Port Trade Analysis — IST432 Assignment

**Trade Volume Trends in Ports Across Different Geographies During the COVID-19 Pandemic and the Russia-Ukraine War (2018–2024)**

## Overview

This project analyzes how two major global crises — the COVID-19 pandemic and the Russia-Ukraine War — affected container throughput (TEU) across strategically selected ports between 2018 and 2024. Ports were chosen to represent diverse geographies: major production/export hubs in Asia, logistics centers in Europe, transit nodes in the Eastern Mediterranean, and Pacific-facing ports in North America.

### Ports Analyzed

| Country | Port |
|---------|------|
| China | Shanghai |
| Netherlands | Rotterdam |
| Germany | Hamburg |
| Turkey | Mersin |
| Egypt | Alexandria |
| Lebanon | Beirut |
| Poland | Gdańsk |
| Russia | Novorossiysk (NUTEP) |
| Ukraine | Odessa |
| United States | Los Angeles |

## Methodology

Because ports operate at vastly different volume scales (Shanghai handles tens of millions of TEUs while Odessa and Beirut handle far fewer), raw comparisons would be misleading. Z-score normalization was applied to each port's annual data — centering values around each port's own mean and standard deviation — so that relative fluctuations across time become directly comparable.

## Visualizations

| File | Description |
|------|-------------|
| `Kernel Density Plot.png` | Standardized trade density distributions per port (Z-score normalized), 2018–2024 |
| `Treemap.png` | Global trade volume share of each port as a percentage of the combined total, 2018–2024 |
| `Choropleth Map - 2018-2024 Arası Büyüme Oranı(%).png` | Geographic choropleth showing growth rates by port/country, 2018–2024 |

## Key Findings

- **Shanghai** alone accounts for ~53.7% of total combined trade volume across all analyzed ports, reflecting China's dominance in global maritime trade.
- **Rotterdam and Los Angeles** show higher year-to-year variability, suggesting greater sensitivity to global supply chain disruptions.
- **Odessa** exhibits a narrow, symmetric distribution — limited growth or decline — consistent with the port's restricted activity following the onset of the Russia-Ukraine War.
- **Beirut** shows a right-skewed pattern with sharp peaks, reflecting the port's irregular performance tied to Lebanon's compounding economic and infrastructural crises.
- **Mersin (Turkey)** demonstrates widening variance over the period, positioning it as an increasingly active Eastern Mediterranean transit hub.

## Repository Contents

| File | Description |
|------|-------------|
| `R kodları.R` | Main R analysis script (kernel density, treemap, statistical summaries) |
| `Choropleth.R` | R script for choropleth map generation |
| `treemap - toplam ticaret hacmi.R` | R script for treemap visualization |
| `deneme1.Rmd` | RMarkdown notebook combining analysis and narrative |
| `WtoData_20250422234040.xlsx` | Raw WTO trade data |
| `dış ticaret hacmi verisi.xlsx` | Turkish foreign trade volume dataset |
| `Rapor_1.docx` | Full project report (Turkish) |
| `Rapor_1_EN.docx` | Full project report (English) |

## Course

IST432 — Graphical Data Analysis  
