library(tidyverse)
mpg
?mpg
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class, shape = as.factor(cyl)))

?geom_point

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy), se = FALSE, method = "lm")

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = as.factor(cyl)))

ggplot(mpg) +
  geom_point(aes(displ,hwy), color = "blue", size = 3)

ggplot(mpg) +
  geom_boxplot(aes(drv, hwy))

ggplot(mpg) +
  geom_violin(aes(drv, hwy))

ggplot(mpg) +
  geom_histogram(aes(hwy), bins = 50)
ggplot(mpg) +
  geom_histogram(aes(hwy), binwidth = 3)

ggplot(mpg) +
  geom_freqpoly(aes(hwy, color = class), binwidth = 3)

ggplot(mpg) +
  geom_density(aes(hwy, color = class))

ggplot(mpg) +
  geom_density(aes(hwy, fill = class), alpha = .2)

?diamonds
diamonds
ggplot(data = diamonds) +
  geom_bar(aes(cut))
ggplot(data = diamonds) +
  stat_count(aes(x = cut))

ggplot(diamonds) +
  geom_col(aes(x = round(carat, 1), y = price))

?economics
ggplot(economics) +
  geom_line(aes(date, unemploy))

ggplot(economics) +
  geom_line(aes(date, y = unemploy / pop * 1000))

ggplot(economics) +
  geom_line(aes(date, y = uempmed))
 
library(lubridate)
ggplot(economics, aes(unemploy / pop * 100, uempmed)) +
  geom_path() +
  geom_point(aes(color = year(date)), size = 3)

ggplot(diamonds,aes(cut,color)) +
  geom_count()

ggplot(diamonds, aes(carat,price)) +
  geom_bin2d()

mpg
ggplot(mpg, aes(displ, hwy)) + 
  geom_point() +
  facet_wrap(~class)

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() +
  facet_wrap(cyl~drv)

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = clarity), position = "stack")

ggplot(diamonds) +
  geom_bar(
    aes(x = cut, color = clarity),
    position = "identity",
    fill = "transparent")

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = clarity), position = "dodge")

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = clarity), position = "fill")

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = clarity), position = "jitter")

ggplot(diamonds) +
  geom_point(aes(carat, price), position = "jitter")

ggplot(diamonds) +
  geom_jitter(aes(carat, price))

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot()

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot() +
  coord_flip()

library(maps)
nz <- map_data("nz")
ggplot(nz, aes(x=long, y=lat, group=group)) +
  geom_polygon(aes(fill = region)) +
  coord_quickmap()

ggplot(mpg ,aes(cty, hwy)) +
  geom_point() +
  coord_fixed()

ggplot(diamonds, aes(cut, fill = cut)) +
  geom_bar() +
  coord_polar()

library(mdsr)
View(CIACountries)

ggplot(CIACountries) +
  geom_point(aes(educ, gdp, color = net_users, size = oil_prod)) +
  geom_text(aes(educ,gdp,label=country)) +
  coord_trans(y="log10")

interes <- CIACountries[CIACountries$country %in% c("Mexico","Qatar","Cuba","United States"),]

ggplot(CIACountries, aes(educ, gdp)) +
  geom_point(aes(color=net_users, size=oil_prod)) +
  geom_label(data=interes, aes(label=country)) +
  coord_trans(y="log10")

library(ggrepel)
ggplot(CIACountries, aes(educ, gdp)) +
  geom_point(aes(color=net_users, size=oil_prod)) +
  geom_point(data=interes, aes(color=net_users, size=oil_prod), size=3, col) +
  geom_label_repel(data=interes, aes(label=country)) +
  coord_trans(y="log10")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  labs(
    title = "Economia de combustible VS Tamaño de motor",
    subtitle = "Parece que existe una relación inversa",
    caption = "Datos del EPA",
    x = "Tamaño del motor [l]",
    y = "Autonomia en carretera [millas por galon]",
    color = "Clase de vehiculo"
  )
