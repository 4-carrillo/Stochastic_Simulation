library(ggplot2) 
library(dplyr) 

library(rstan)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

datos <- read.csv("sunspots.csv",sep = ";")
head(datos)

summary(datos$SNvalue)

datos %>% filter(decimal.year >=1900) %>%
  ggplot(aes(x=decimal.year, y=SNvalue))+
  geom_line()

NsunSpots <- datos %>% filter(decimal.year >=1900)
Example <- list(T=nrow(NsunSpots),y=NsunSpots$SNvalue)

model1 <- stan("proyecto.stan",data=Example)

fit1 <- rstan::extract(model1)

plot(fit1$mu,type="l")
print(model1)

index=seq(from=1, to=length(NsunSpots$SNvalue))
lo=loess(NsunSpots$SNvalue~index,span=0.5)
num.low <- ts(loess(NsunSpots$SNvalue~index,span=0.5)$fitted,frequency=128)
num.hi <- ts(NsunSpots$SNvalue-loess(NsunSpots$SNvalue~index,span=0.05)$fitted,frequency=128)
num.cycles <- NsunSpots$SNvalue - num.hi - num.low
plot(ts.union(NsunSpots$SNvalue, num.low,num.hi,num.cycles),
     main="Decomposition of sunspots amount as trend + noise + cycles")
