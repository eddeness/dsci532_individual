# fin-health: US Corporate Profitability Analytics (Shiny for R)

Individual assignment — reimplementation of the group project dashboard using **Shiny for R**.

## Live App

> (Posit Connect Cloud 배포 후 링크 추가)

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

> Make sure `financial_statement.csv` is in the **same folder** as `app.R`.

## Project Structure

```
.
├── app.R
├── financial_statement.csv
└── README.md
```
