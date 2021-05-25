library(readr)

prueba <- read_delim("midwest-delim-spaces.txt", delim=" ")

prueba <- read_tsv("midwest-delim.txt")

prueba <- read_fwf("fwf-sample.txt", fwf_empty(
  "fwf-sample.txt", col_names = c("first", "last", "state", "ssn")
))

prueba <- read_csv("txhousing.csv", na=c(""," ","NA","NULL","???"))

library(rvest)
url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
selector <- "#constituents"

html <- read_html(url)
empresas <- html_table(html_node(html, css = selector))

library(tidyr)

class <- tibble(
  StudentName = c("Ana", "John", "Mari"),
  Math = c(78, 98, 56),
  English = c(67, 34, 86)
)

tidyData <- class %>%
  gather(key = Subject, value = Grade, Math:English)
