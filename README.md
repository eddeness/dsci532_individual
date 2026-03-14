# fin-health: US Corporate Profitability Analytics (Shiny for R)

Individual assignment — reimplementation of the group project dashboard using **Shiny for R**.

## Live App

> [](https://connect.posit.cloud/edeness/content/019cee40-3c62-b88b-1ed6-cb4e4133bbd6)

## Features

- **Sector dropdown** — filter all outputs by industry sector
- **3 Value Boxes** — Avg Net Profit Margin / Top Company / # Companies
- **Bar chart** — Average Net Profit Margin by sector
- **Line chart** — Net Profit Margin trend over time (per company)
- **Data table** — Company-level details with pagination

## Install & Run

### 1. Install R packages

```r
install.packages(c("shiny", "bslib", "bsicons", "dplyr", "ggplot2", "readr", "DT"))
```

### 2. Run the app

```r
shiny::runApp("app.R")
```

> Make sure `data/financial_statement.csv` is in the **same folder** as `app.R`.
