library(tidyverse)
library(dbplyr)
library(DBI)
library(RPostgres)

db <-dbConnect(
  Postgres(),
  user = 'alumno',
  password = 'drlh6m4jrvwlo4bh',
  dbname = 'nycflights',
  host = 'db-512-r-prueba-do-user-7269609-0.a.db.ondigitalocean.com',
  port = 25060,
  sslmode = 'require'
)

dbListTables(db)
dbExistsTable(db, "airports")
dbListFields(db, "flights")

query <- 'select * from flights limit 10'
res <- dbSendQuery(db, query)
resReal <- dbFetch(res)
dbClearResult(res)

tbl(db, "flights") %>%
  group_by(carrier, tailnum) %>%
  summarise(avg_delay = mean(arr_delay)) %>%
  explain()

res <- tbl(db, "flights") %>%
  group_by(carrier, tailnum) %>%
  summarise(avg_delay = mean(arr_delay)) %>%
  collect()

ggplot(res) +
  geom_density(aes(avg_delay,fill=carrier)) +
  facet_wrap(~carrier) +
  xlim(c(-50,50))

tbl(db, "flights") %>%
  left_join(tbl(db, "planes"), by = c("tailnum" = "tailnum")) %>%
  collect()

res <- tbl(db, "flights") %>%
  full_join(tbl(db, "airlines"), "carrier") %>%
  select(month, carrier) %>%
  group_by(month, carrier) %>%
  summarise(count = n()) %>%
  collect()

a <- tibble(
  carrier = c("E9", "BO", "EC", "FF", "AA"),
  dato = runif(5)
)

b <- tibble(
  carrier = c("E9", "BO", "EC", "AA", "CC"),
  dato = runif(5)
)

inner_join(a,b,"carrier")

tbl (db, "airlines") %>%
  #sample_n(4) %>%
  filter(carrier %in% c("9E", "B6", "MQ", "AA")) %>%
  inner_join(tbl(db, "flights"), "carrier") %>%
  group_by(carrier) %>%
  summarise(count = n()) %>%
  collect()

semi_join(a,b,"carrier")
anti_join(a,b,"carrier")

tbl(db, "fligths") %>%
  semi_join(tbl(db, "fligths"), "carrier") %>%
  summarise(count = n()) %>%
  collect()

dbDisconnect(db)

library(httr)
library(jsonlite)

res <- GET(
  "https://reqres.in/",
  path = "/api/users",
  query = list(page = 2)
)

miDato <-content(res, as="text")
usuarios <- fromJSON(miDato)


