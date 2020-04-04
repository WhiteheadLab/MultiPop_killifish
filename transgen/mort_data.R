## Mortality Data
## 2019 08 12

library(readxl)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(gridExtra)


setwd("~/Documents/NIEHS_LSU_UCD/niehs/transgen/DAVID/")

## Subset data by 00% and 56% samples at day 15
rawdata <- read_excel("~/Documents/NIEHS_LSU_UCD/Exp1-2/Phenotype/EmbryoMorts/190812_ars_morts.xlsx")
morts <- rawdata[rawdata$`Embryo Treatment`=="0" | rawdata$`Embryo Treatment`=="56",]
morts$trt <- paste(morts$`Parent Treatment`, morts$`Embryo Treatment`)
mortsub <- morts[morts$Day=="15",]

# also transferred total start values from day 0 to the mortsub df 
# e.g.  
#     mortsub[mortsub$trt == "Exposed 56",]$`Total Start` <- morts[morts$trt=="Exposed 56" & morts$Day=="1",]$`Total Start`


## Can't use ANOVA on proportion or count data, need to use poisson regression (glm)
mortsub$`Embryo Treatment` <- factor(mortsub$`Embryo Treatment`)
mortsub$`Parent Treatment` <- factor(mortsub$`Parent Treatment`)
m.glm <- glm(`Percent_Dead` ~ `Parent Treatment` * `Embryo Treatment` + offset(log(`Total Start`)),  
    data=mortsub[mortsub$Gen=="1",])
#m.glm2 <- glm(`Percent_Dead` ~ `Parent Treatment` * `Embryo Treatment` + offset(log(`Total Start`)), family="binomial",
#             data=mortsub[mortsub$Gen=="1",])

summary(m.glm)
anova(m.glm, m.glm2)

m <- lm(`Percent_Dead` ~ `Parent Treatment` * `Embryo Treatment` * Gen, data=mortsub[mortsub$Gen=="1",])
ma <- anova(m)


# Run the functions length, mean, and sd on the value of "change" for each group, 
# broken down by parent and embryo treatments
library(plyr)
cdata <- ddply(mortsub, c("`Parent Treatment`", "`Embryo Treatment`", "Gen"), summarise,
               N    = length(`Percent_Dead`),
               mean = mean(`Percent_Dead`),
               sd   = sd(`Percent_Dead`),
               se   = sd / sqrt(N)
)
cdata


## Line graphs of mortality between 00% and 56% embryonic treatment, control and exposed parent treatments
cdata$`Embryo Treatment` <- factor(cdata$`Embryo Treatment`)
pd <- position_dodge(0.1)
labels <- c(`1` = "F1", `2` = "F2")
md <- ggplot(cdata, aes(x=factor(`Embryo Treatment`), y=mean, group=`Parent Treatment`, color=`Parent Treatment`)) + 
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.2, position=pd, size=1) +
  geom_line(position=pd, size=1) +
  geom_point(position=pd, size=3, shape=21, fill="white") +
  scale_colour_manual(values = c("#56B4E9", "#E69F00")) +
  scale_x_discrete(labels=c("0" = "0%", "56" = "56%")) +
  xlab("Embryo WAF Treatment (%)") + 
  ylab("Proportion Dead") +
  facet_grid(. ~ Gen, labeller=labeller(Gen = labels)) + 
  ggtitle("Cumulative Mortality of ARS Embryos by Experimental Day 15") +
  theme_light()



## Heart rate data

hearts <- read_excel("~/Documents/NIEHS_LSU_UCD/niehs/transgen/190814_ARS_hr.xlsx")
heart <- hearts[hearts$`WAF %`=="0" | hearts$`WAF %` == "0.56",]
hdata <- ddply(heart, c("`WAF %`", "Parent_Treatment", "Gen"), summarise,
               N    = length(BPM),
               mean = mean(BPM),
               sd   = sd(BPM),
               se   = sd / sqrt(N)
)
hdata

hdata$`WAF %` <- factor(hdata$`WAF %`)
hdata$Parent_Treatment <- factor(hdata$Parent_Treatment)

## Line graphs for heart rates
pd <- position_dodge(0.1)
labels <- c(`0.00` = "0%", `0.56` = "56%")
hr <- ggplot(hdata, aes(x=`WAF %`, y=mean, group=Parent_Treatment, color=Parent_Treatment)) + 
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.2, position=pd, size=1) +
  geom_line(position=pd, size=1) +
  geom_point(position=pd, size=3, shape=21, fill="white") +
  scale_colour_manual(values = c("#56B4E9", "#E69F00")) +
  scale_x_discrete(labels=c("0" = "0%", "0.56" = "56%")) +
  xlab("Embryo WAF Treatment (%)") + 
  ylab("Beats per minute (BPM)") +
  facet_grid(. ~ Gen) + 
  ggtitle("Heart rates of ARS embryos") +
  theme_light()

##glm and aov for heartrate data
l.f1 <- lm(formula=BPM ~ `WAF %` * `Parent_Treatment`, data=heart[heart$Gen == "F1",])
a.f1 <- anova(l.f1)

l.f2 <- lm(formula=BPM ~ `WAF %` * `Parent_Treatment`, data=heart[heart$Gen == "F2",])
a.f2 <- anova(l.f2)

l <- lm(formula=BPM ~ `WAF %` * `Parent_Treatment` * Gen, data=heart)
a <- anova(l)

glm(`Percent_Dead` ~ `Parent Treatment` * `Embryo Treatment` * Gen,
    family="binomial", 
    data=mortsub)

require(gridExtra)
phen <- grid.arrange(md, hr, ncol=1)

