library(readxl)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(gridExtra)

setwd("~/Documents/NIEHS_LSU_UCD/niehs/multipop/")

# Read DAVID data into R
### Dose response contrasts:
doseresponse <- read_excel("200421_dr_goterms.xlsx")

### Interaction contrasts: 
dr_ixn <- read_excel("200421_popexp_goterms.xlsx")

### Pop main effect:
popmain <- read_excel("200428_pop_goterms.xlsx")

### Clean up Terms
terms <- doseresponse$Term
terms <- gsub(".*~", "", terms)
terms <- gsub(".*:", "", terms)
doseresponse$Term <- terms

terms <- dr_ixn$Term
terms <- gsub(".*~", "", terms)
terms <- gsub(".*:", "", terms)
dr_ixn$Term <- terms

terms <- popmain$Term
terms <- gsub(".*~", "", terms)
terms <- gsub(".*:", "", terms)
popmain$Term <- terms

# Make dot plot in GGplot2
### circle size = % of total genes, color = p-value
require(gridExtra)
library(gtable)    
library(grid)

#embryo exposure 
dr <- doseresponse[c("Term", "%", "PValue", "Cluster")]
dr$Cluster <- as.factor(dr$Cluster)
dr$Term <- factor(dr$Term, levels = unique(dr$Term[order(dr$Cluster)]))
#dr <- dr[dr$PValue <= 0.2,]

dr_plot <- ggplot(dr, aes(x = Cluster, y = Term)) +
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_color_distiller(name="adj. p-value", palette="YlOrRd") +
  scale_size(name = "% genes from cluster", range = c(3,10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=10, colour = "black"), 
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  scale_fill_hue(c=100, l=40) + 
  ggtitle("Functional Enrichment Analysis for Embryonic Exposure Contrast")

#exposure x pop interactoin
interac <- dr_ixn[c("Term", "%", "PValue", "Cluster")]
interac$Cluster <- as.factor(interac$Cluster)
interac$Term <- factor(interac$Term, levels = unique(interac$Term[order(interac$Cluster)]))
#interac <- interac[interac$PValue <= 0.2,]

interac_plot <- ggplot(interac, aes(x = Cluster, y = Term)) +
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_color_distiller(name="adj. p-value", palette="YlOrRd") +
  scale_size(name = "% genes from cluster", range = c(3,10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=10, colour = "black"), 
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  scale_fill_hue(c=100, l=40) + 
  ggtitle("Functional Enrichment Analysis for \nEmbryonic Dose Response by Population Interaction")


# pop main effect
pm <- popmain[c("Term", "%", "PValue", "Cluster")]
pm$Cluster <- as.factor(pm$Cluster)
pm$Term <- factor(pm$Term, levels = unique(pm$Term[order(pm$Cluster)]))
#pm <- pm[pm$PValue <= 0.2,]

pm_plot <- ggplot(pm, aes(x = Cluster, y = Term)) +
  geom_point(aes(color = PValue, size = `%`), alpha = 0.5) +
  scale_color_distiller(name="adj. p-value", palette="YlOrRd") +
  scale_size(name = "% genes from cluster", range = c(3,10)) +
  theme(legend.position = "right", 
        axis.text.y=element_text(size=8, colour = "black"), 
        legend.text=element_text(size=12, colour = "black"),
        legend.title=element_text(size=12, colour = "black")) +
  scale_fill_hue(c=100, l=40) + 
  ggtitle("Functional Enrichment Analysis for Population Contrast")
