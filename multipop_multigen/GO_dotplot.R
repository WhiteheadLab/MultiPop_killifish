

library(readxl)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(gridExtra)

setwd("~/Documents/NIEHS_LSU_UCD/niehs/multipop_multigen/DAVID/")

# Read DAVID data into R
### Dose response contrasts:
embryoexp <- read_excel("191118_exp_go.xlsx")
lineage <- read_excel("191119_group_go.xlsx")
pop_exp <- read_excel("191119_popexp_go.xlsx")
pop_lineage <- read_excel("191119_popgroup_go.xlsx")
pop_exp_lineage <- read_excel("191119_peg_go.xlsx")


### Clean up Terms
go <- list("embryoexp" = embryoexp, 
           "lineage" = lineage, 
           "pop_exp" = pop_exp, 
           "pop_lineage" = pop_lineage, 
           "pop_exp_lineage" = pop_exp_lineage)

for (i in 1:length(go)) { 
  terms <- go[[i]]$Term
  terms <- gsub(".*~", "", terms)
  terms <- gsub(".*:", "", terms)
  go[[i]]$Term <- terms
  } 

# Make dot plot in GGplot2
### circle size = % of total genes, color = p-value
require(gridExtra)
library(gtable)    
library(grid)

#embryo exposure 
dr <- go$embryoexp[c("Term", "%", "PValue", "Cluster")]
dr$Cluster <- as.factor(dr$Cluster)
dr$Term <- factor(dr$Term, levels = unique(dr$Term[order(dr$Cluster)]))
dr <- dr[dr$PValue <= 0.2,]

doseresponse <- ggplot(dr, aes(x = Cluster, y = Term)) +
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_color_distiller(name="adj. p-value", palette="YlOrRd") +
  scale_size(name = "% genes from cluster", range = c(3,10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=10, colour = "black"), 
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  scale_fill_hue(c=100, l=40) + 
  ggtitle("Functional Enrichment Analysis for Embryonic Exposure Contrast")


#group 
li <- go$lineage[c("Term", "%", "PValue", "Cluster")]
li$Cluster <- as.factor(li$Cluster)
li$Term <- factor(li$Term, levels = unique(li$Term[order(li$Cluster)]))
li <- li[li$PValue <= 0.5,]

p.lin <- ggplot(li, aes(x = Cluster, y = Term)) +
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_color_distiller(name="adj. p-value", palette="YlOrRd") +
  scale_size(name = "% genes from cluster", range = c(3,10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=10, colour = "black"), 
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  scale_fill_hue(c=100, l=40) + 
  ggtitle("Functional Enrichment Analysis for Lineage Contrast")


# group x exposure interaction
ge <- go$group_exp[c("Term", "%", "PValue", "Cluster")]
ge$Cluster <- as.factor(ge$Cluster)
ge$Term <- factor(ge$Term, levels = unique(ge$Term[order(ge$Cluster)]))
#ge <- ge[ge$PValue <= 0.5,]

p.ge <- ggplot(ge, aes(x = Cluster, y = Term)) +
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_color_distiller(name="adj. p-value", palette="YlOrRd") +
  scale_size(name = "% genes from cluster", range = c(3,10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=10, colour = "black"), 
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  scale_fill_hue(c=100, l=40) + 
  ggtitle("Functional Enrichment Analysis for Lineage x Embryonice Dose Response Interaction")

#pop x exposure interaction
pe <- go$pop_exp[c("Term", "%", "PValue", "Cluster")]
pe$Cluster <- as.factor(pe$Cluster)
pe$Term <- factor(pe$Term, levels = unique(pe$Term[order(pe$Cluster)]))
#pe <- pe[pe$PValue <= 0.5,]

p.pe <- ggplot(pe, aes(x = Cluster, y = Term)) +
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_color_distiller(name="adj. p-value", palette="YlOrRd") +
  scale_size(name = "% genes from cluster", range = c(3,10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=10, colour = "black"), 
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  scale_fill_hue(c=100, l=40) + 
  ggtitle("Functional Enrichment Analysis for Pop x Embryo Exposure Interaction")

# pop x group interaction
pg <- go$pop_lineage[c("Term", "%", "PValue", "Cluster")]
pg$Cluster <- as.factor(pg$Cluster)
pg$Term <- factor(pg$Term, levels = unique(pg$Term[order(pg$Cluster)]))
#pg <- pg[pg$PValue <= 0.5,]

p.pg <- ggplot(pg, aes(x = Cluster, y = Term)) +
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_color_distiller(name="adj. p-value", palette="YlOrRd") +
  scale_size(name = "% genes from cluster", range = c(3,10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=10, colour = "black"), 
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  scale_fill_hue(c=100, l=40) + 
  ggtitle("Functional Enrichment Analysis for Pop x Parent Exposure Interaction")

# pop x exp x group ineteraction

peg <- go$pop_exp_lineage[c("Term", "%", "PValue", "Cluster")]
peg$Cluster <- as.factor(peg$Cluster)
peg$Term <- factor(peg$Term, levels = unique(peg$Term[order(peg$Cluster)]))
#peg <- peg[peg$PValue <= 0.5,]

p.peg <- ggplot(peg, aes(x = Cluster, y = Term)) +
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_color_distiller(name="adj. p-value", palette="YlOrRd") +
  scale_size(name = "% genes from cluster", range = c(3,10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=10, colour = "black"), 
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  scale_fill_hue(c=100, l=40) + 
  ggtitle("Functional Enrichment Analysis for Pop x Embryo Exposure x Parent Exposure Interaction")


# Make sure all GO terms are present in both generations
f1 <- doseresponse[doseresponse$Gen == "f1", c("Term", "%", "PValue", "Gen", "Cluster", "GenClus")]
f2 <- doseresponse[doseresponse$Gen == "f2", c("Term", "%", "PValue", "Gen", "Cluster", "GenClus")]
difs1 <- setdiff(f2$Term, f1$Term)
difs1 <- data.frame(difs1)
difs1[,2:6] <- NA
names(difs1) <- names(f1)
f1 <- rbind(f1, difs1)
f1[25:30,]$Cluster<- "c1"
f1[25:30,]$`%` <- "0"
f1[25:30,]$PValue <- "1"
f1 <- f1[order(f1$Term),]
f1$PValue <- as.numeric(f1$PValue)
f1$`%` <- as.numeric(f1$`%`)

df2 <- setdiff(f1$Term, f2$Term)
df2 <- data.frame(df2)
df2[,2:6] <- NA
names(df2) <- names(f2)
f2 <- rbind(f2, df2)
f2[22:30,]$Cluster<- "c1"
f2[22:30,]$`%` <- 0
f2[22:30,]$PValue <- 1
f2 <- f2[order(f2$Term),]

#group plots together
g1 <- ggplotGrob(p.c1)
g2 <- ggplotGrob(p.c2)
g2$widths <- g1$widths
grid.arrange(g1, g2, nrow=2)

l.c1 <- lineage[lineage$Cluster == "c1", c("Term", "%", "PValue", "Gen", "Cluster", "GenClus")]
l.c1$Term <- factor(l.c1$Term, levels = l.c1$Term[order(l.c1$Gen)])
l.c1 <- l.c1[l.c1$PValue <= 0.2,]
p.c1 <- ggplot(l.c1[order(l.c1$Gen),], aes(x = Gen, y = Term)) +
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_color_distiller(name="adj. p-value", palette="YlOrRd") +
  scale_size(name= "% of genes from cluster", range = c(3,10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=17, colour = "black"), 
        axis.text.x=element_blank(),
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  ylab("") +
  xlab("")


l.c2 <- lineage[lineage$Cluster == "c2", c("Term", "%", "PValue", "Gen", "Cluster", "GenClus")]
l.c2$Term <- factor(l.c2$Term, levels = l.c2$Term[order(l.c2$Gen)])
l.c2 <- l.c2[l.c2$PValue <= 0.5,]
p.c2 <- ggplot(l.c2, aes(x = Gen, y = Term)) + 
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_colour_gradient(name = "adj. p-value",low="black", high="blue") +
  scale_size(name = "% genes from cluster", range = c(3, 10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=17, colour = "black"), 
        axis.text.x=element_text(size=17, colour = "black"), 
        axis.title.x=element_text(size=20, colour = "black"),
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  scale_x_discrete(labels=c("F1", "F2")) +
  ylab("") +
  xlab("Generation")

l1 <- ggplotGrob(p.c1)
l2 <- ggplotGrob(p.c2)
l2$widths <- l1$widths
grid.arrange(l1, l2, nrow=2)

