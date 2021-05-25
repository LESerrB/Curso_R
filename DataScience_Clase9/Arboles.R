library(readr)
library(dplyr)
library(stringr)
library(ggplot2)

Datos_titanic <- read_csv("titanic.csv")

glimpse(Datos_titanic)
summary(Datos_titanic)

unique(Datos_titanic$Sex)
unique(Datos_titanic$Pclass)
unique(Datos_titanic$Survived)

Datos_titanic$Name <- str_match(Datos_titanic$Name, pattern = "^[\\w\\s]+\\.")
unique(Datos_titanic$Name)

for (i in 1:ncol(Datos_titanic)) {
  if(i <= 4){
    Datos_titanic[, i] <- as.factor(Datos_titanic[[i]])
  }
}

summary(Datos_titanic)

Datos_titanic <- Datos_titanic %>%
  mutate(Family_Number = `Siblings/Spouses Aboard` + `Parents/Children Aboard`)

ggplot(Datos_titanic, aes(x = Pclass, fill = Survived)) +
  geom_bar(position = "dodge")

ggplot(Datos_titanic, aes(x = Name, fill = Survived)) +
  geom_bar(position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(Datos_titanic, aes(x = Sex, fill = Survived)) +
  geom_bar(position = "dodge")

##
ggplot(Datos_titanic, aes(x = Age, fill = Survived, color = Survived)) +
  geom_density(alpha = 0.4)

ggplot(Datos_titanic, aes(y = `Siblings/Spouses Aboard`, fill = Survived, color = Survived)) +
  geom_boxplot(alpha = 0.4)

ggplot(Datos_titanic, aes(y = `Parents/Children Aboard`, fill = Survived, color = Survived)) +
  geom_boxplot(alpha = 0.4)

ggplot(Datos_titanic, aes(y = Family_Number, fill = Survived, color = Survived)) +
  geom_boxplot(alpha = 0.4)

ggplot(Datos_titanic, aes(y = Fare, fill = Survived, color = Survived)) +
  geom_boxplot(alpha = 0.4)

##
Datos_titanic <- Datos_titanic %>%
  mutate(Family_Aboard = ifelse(Family_Number > 0, 1, 0),
         Family_Aboard = as.factor(Family_Aboard),
         Age_group = ifelse(Age <= 15, "Child", ifelse(Age <= 50, "Adult", "Elder")),
         Age_group = as.factor(Age_group))

##
ggplot(Datos_titanic, aes(x = Family_Aboard, fill = Survived)) +
  geom_bar(position = "dodge")

ggplot(Datos_titanic, aes(x = Age_group, fill = Survived)) +
  geom_bar(position = "dodge")

summary(Datos_titanic)
