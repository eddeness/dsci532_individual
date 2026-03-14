library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(readr)
library(DT)

df <- read_csv("data/financial_statement.csv", locale = locale(encoding = "UTF-8")) |>
  rename_with(trimws) |>
  mutate(
    Company  = trimws(Company),
    Category = trimws(Category),
    
    Category = case_when(
      tolower(Category) == "bank"          ~ "BANK",
      tolower(Category) == "fintech"       ~ "FINTECH",
      tolower(Category) == "finance"       ~ "FINANCE",
      tolower(Category) == "manufacturing" ~ "MANUFACTURING",
      TRUE                                  ~ Category
    )
  )

sectors <- c("All", sort(unique(df$Category)))

ui <- page_sidebar(
  title = "US Corporate Profitability Analytics",
  theme = bs_theme(bootswatch = "flatly", base_font = font_google("Inter")),
  
  sidebar = sidebar(
    title = "Filters",
    selectInput(
      "sector", "Sector",
      choices  = sectors,
      selected = "All"
    ),
    hr(),
    helpText("Data: 12 companies, 2009–2023")
  ),
  layout_columns(
    fill = FALSE,
    value_box(
      title    = "Avg Net Profit Margin",
      value    = textOutput("avg_npm"),
      showcase = bsicons::bs_icon("graph-up-arrow"),
      theme    = "primary"
    ),
    value_box(
      title    = "Top Company (NPM)",
      value    = textOutput("top_company"),
      showcase = bsicons::bs_icon("trophy"),
      theme    = "success"
    ),
    value_box(
      title    = "# Companies",
      value    = textOutput("n_companies"),
      showcase = bsicons::bs_icon("building"),
      theme    = "info"
    )
  ),
  
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Avg Net Profit Margin by Sector"),
      plotOutput("bar_chart", height = "300px")
    ),
    card(
      card_header("Net Profit Margin Trend"),
      plotOutput("line_chart", height = "300px")
    )
  ),
  
  card(
    card_header("Company Details"),
    DTOutput("data_table")
  )
)

server <- function(input, output, session) {
  filtered_df <- reactive({
    if (input$sector == "All") df
    else filter(df, Category == input$sector)
  })
  
  output$avg_npm <- renderText({
    val <- mean(filtered_df()$`Net Profit Margin`, na.rm = TRUE)
    paste0(round(val, 1), "%")
  })
  
  output$top_company <- renderText({
    filtered_df() |>
      group_by(Company) |>
      summarise(avg = mean(`Net Profit Margin`, na.rm = TRUE)) |>
      slice_max(avg, n = 1) |>
      pull(Company)
  })
  
  output$n_companies <- renderText({
    n_distinct(filtered_df()$Company)
  })
  
  output$bar_chart <- renderPlot({
    filtered_df() |>
      group_by(Category) |>
      summarise(avg_npm = mean(`Net Profit Margin`, na.rm = TRUE)) |>
      ggplot(aes(x = reorder(Category, avg_npm), y = avg_npm, fill = Category)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      labs(x = NULL, y = "Avg Net Profit Margin (%)") +
      theme_minimal(base_size = 13)
  })
  
  output$line_chart <- renderPlot({
    filtered_df() |>
      group_by(Year, Company) |>
      summarise(avg_npm = mean(`Net Profit Margin`, na.rm = TRUE), .groups = "drop") |>
      ggplot(aes(x = Year, y = avg_npm, color = Company)) +
      geom_line(linewidth = 0.8) +
      geom_point(size = 1.5) +
      labs(x = "Year", y = "Net Profit Margin (%)", color = NULL) +
      theme_minimal(base_size = 13) +
      theme(legend.position = "bottom")
  })
  
  output$data_table <- renderDT({
    filtered_df() |>
      select(Company, Category, Year, Revenue, `Net Income`, `Net Profit Margin`) |>
      arrange(Company, desc(Year)) |>
      datatable(
        options = list(pageLength = 10, scrollX = TRUE),
        rownames = FALSE
      ) |>
      formatRound("Net Profit Margin", digits = 2) |>
      formatCurrency(c("Revenue", "Net Income"), currency = "", digits = 0)
  })
}

shinyApp(ui, server)
