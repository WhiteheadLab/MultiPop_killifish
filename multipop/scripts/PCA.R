## PCA Plots of lineage main effect genes


library(ggplot2)

pop2 <- pop[pop_main$tree_row$order,]
exp2

#pop_pca <- as.data.frame(t(w$counts[pop2$Gene,]))
rownames(pop2) <- pop2$Gene
pop_pca <- as.data.frame(t(pop2[,-(2:4)]))
pop_pca$trt <- w$samples$trt

pop.pca <- prcomp(pop_pca[,1:7064])
summary(pop.pca)
pop.pca.proportionvariances <- ((pop.pca$sdev^2) / (sum(pop.pca$sdev^2)))*100
pop.PCi <- data.frame(pop.pca$x, group=w$samples$group, exposure=w$samples$exposure)





q <- ggplot(f1_group.PCi, aes(x=PC1, y=PC2, color=group, 
                              shape=gen,
                              fill=factor(ifelse(exposure=="56", group, "white")))) +
  scale_color_manual(name="Lineage", values=c("steelblue3", "red4")) + 
  scale_shape_manual(name="Generation", values=c(21,24)) + 
  scale_fill_manual(name="Exposure", values=c("steelblue3", "red4", "white")) + 
  theme_minimal() +
  xlab(paste("PC1, ", round(pca.proportionvariances[1], 2), "%")) + 
  ylab(paste("PC2, ", round(pca.proportionvariances[2], 2), "%")) +
  ggtitle("PCA of F1 Lineage Main Effect Genes in All Stage 35 Samples") 

q + geom_point(aes(size=exposure)) + 
  scale_size_manual(name="Embryo Exposure", values=c(3, 3.01)) +
  guides(fill="none", 
         size=guide_legend(override.aes=list(shape=c(1,16))))



pop_effect <- trtnorm$pop
dose_effect <- trtnorm$exposure
ixn_effect <- trt

#Subset expression dataset by main effect and interaction effect DEGs: 
pop_effect <- [rownames(f1_35_group),]
f2_35 <- late[rownames(f2_35_group),]

#Normalize each dataset by generation: 
f1.f1_norm <- f1_35$counts[,which(f1_35$samples$gen=="F1")] - rowMeans(f1_35$counts[,which(f1_35$samples$gen=="F1")])
f1.f2_norm <- f1_35$counts[,which(f1_35$samples$gen=="F2")] - rowMeans(f1_35$counts[,which(f1_35$samples$gen=="F2")])
f1_35$counts <- cbind(f1.f1_norm, f1.f2_norm)

f2.f1_norm <- f2_35$counts[,which(f2_35$samples$gen=="F1")] - rowMeans(f2_35$counts[,which(f2_35$samples$gen=="F1")])
f2.f2_norm <- f2_35$counts[,which(f2_35$samples$gen=="F2")] - rowMeans(f2_35$counts[,which(f2_35$samples$gen=="F2")])
f2_35$counts <- cbind(f2.f1_norm, f2.f2_norm)

# Set up F1 DEG dataframe for prcomp analysis: 
f1_group <- as.data.frame(t(f1_35$counts))
f1_group$gen <- f1_35$samples$gen
f1_group$exposure <- f1_35$samples$exposure
f1_group$group <- f1_35$samples$group

# Make PC dataframe and calculate proportion variances: 
f1_group.pca <- prcomp(f1_group[,1:154])
summary(f1_group.pca)
f1_group.pca.proportionvariances <- ((f1_group.pca$sdev^2) / (sum(f1_group.pca$sdev^2)))*100
f1_group.PCi <- data.frame(f1_group.pca$x, gen=f1_group$gen, group=f1_group$group, exposure=f1_group$exposure)


# Set up F2 DEG dataframe for prcomp analysis:
f2_group <- as.data.frame(t(f2_35$counts))
f2_group$gen <- f2_35$samples$gen
f2_group$exposure <- f2_35$samples$exposure
f2_group$group <- f2_35$samples$group


# Make PC dataframe and calculate proportion variances:  
PC<-prcomp(f2_group[,1:246])
summary(PC)
pca.proportionvariances <- ((PC$sdev^2) / (sum(PC$sdev^2)))*100
PCi<-data.frame(PC$x, gen=f2_group$gen, group = f2_group$group, exposure = f2_group$exposure)


# Make PCA plots for F1 DEGs: 
q <- ggplot(f1_group.PCi, aes(x=PC1, y=PC2, color=group, 
                              shape=gen,
                              fill=factor(ifelse(exposure=="56", group, "white")))) +
  scale_color_manual(name="Lineage", values=c("steelblue3", "red4")) + 
  scale_shape_manual(name="Generation", values=c(21,24)) + 
  scale_fill_manual(name="Exposure", values=c("steelblue3", "red4", "white")) + 
  theme_minimal() +
  xlab(paste("PC1, ", round(pca.proportionvariances[1], 2), "%")) + 
  ylab(paste("PC2, ", round(pca.proportionvariances[2], 2), "%")) +
  ggtitle("PCA of F1 Lineage Main Effect Genes in All Stage 35 Samples") 

q + geom_point(aes(size=exposure)) + 
  scale_size_manual(name="Embryo Exposure", values=c(3, 3.01)) +
  guides(fill="none", 
         size=guide_legend(override.aes=list(shape=c(1,16))))

# Make PCA plots for F2 DEGs: 
p <- ggplot(PCi, aes(x=PC1, y=PC2, color=group,
                     shape=gen, 
                     fill=factor(ifelse(exposure=="56", group, "white")))) +
  scale_color_manual(name="Lineage", values=c("steelblue3", "red4")) + 
  scale_shape_manual(name="Generation", values=c(21,24)) + 
  scale_fill_manual(name="Exposure", values=c("steelblue3", "red4", "white")) + 
  theme_minimal() +
  xlab(paste("PC1, ", round(pca.proportionvariances[1], 2), "%")) + 
  ylab(paste("PC2, ", round(pca.proportionvariances[2], 2), "%")) +
  ggtitle("PCA of F2 Lineage Main Effect Genes in All Stage 35 Samples") 

p + geom_point(aes(size=exposure)) + 
  scale_size_manual(name="Embryo Exposure", values=c(3, 3.01)) +
  guides(fill="none", 
         size=guide_legend(override.aes=list(shape=c(1,16))))

# Save plots as PDFs: 



#Plots scatter plot for PC 1 and 2
plot(project.pca$x, type="n", main="Principal components analysis bi-plot", xlab=paste("PC1, ", round(project.pca.proportionvariances[1], 2), "%"), ylab=paste("PC2, ", round(project.pca.proportionvariances[2], 2), "%"))
points(project.pca$x, col=col.exp, pch=16, cex=1)


# Make PCA plots for treatment generation-normalized treatment means: 
f1_gnorm <- gnorm$late$f1_late$group
f2_gnorm <- gnorm$late$f2_late$group

# Set up F1 DEG dataframe for prcomp analysis: 
f1_gnorm <- as.data.frame(t(f1_gnorm))
f1_gnorm$gen <- c("F1", "F1", "F2", "F2", "F1", "F1", "F2", "F2")
f1_gnorm$exposure <- c("00", "56", "00", "56", "00", "56", "00", "56")
f1_gnorm$group <- c("C", "C", "C", "C", "E", "E", "E", "E")

# Set up F2 DEG dataframe for prcomp analysis:
f2_gnorm <- as.data.frame(t(f2_gnorm))
f2_gnorm$gen <- c("F1", "F1", "F2", "F2", "F1", "F1", "F2", "F2")
f2_gnorm$exposure <- c("00", "56", "00", "56", "00", "56", "00", "56")
f2_gnorm$group <- c("C", "C", "C", "C", "E", "E", "E", "E")

# Make F1 DEG PCA dataframe and calculate proportion variances:  
f1_gnorm.PC <-prcomp(f1_gnorm[,1:154])
summary(f1_gnorm.PC)
f1_gnorm.pca.proportionvariances <- ((f1_gnorm.PC$sdev^2) / (sum(f1_gnorm.PC$sdev^2)))*100
f1_gnorm.PCi<-data.frame(f1_gnorm.PC$x, gen=f1_gnorm$gen, group = f1_gnorm$group, exposure = f1_gnorm$exposure)

# Make F2 DEG PCA dataframe and calculate proportion variances: 
f2_gnorm.PC <- prcomp(f2_gnorm[,1:246])
summary(f2_gnorm.PC)
f2_gnorm.pca.proportionvariances <- ((f2_gnorm.PC$sdev^2) / (sum(f2_gnorm.PC$sdev^2)))*100
f2_gnorm.PCi<-data.frame(f2_gnorm.PC$x, gen=f2_gnorm$gen, group = f2_gnorm$group, exposure = f2_gnorm$exposure)



# Make PCA plots for F1 DEGs: 
r <- ggplot(f1_gnorm.PCi, aes(x=PC1, y=PC2, color=group, 
                              shape=gen,
                              fill=factor(ifelse(exposure=="56", group, "white")))) +
  scale_color_manual(name="Lineage", values=c("steelblue3", "red4")) + 
  scale_shape_manual(name="Generation", values=c(21,24)) + 
  scale_fill_manual(name="Exposure", values=c("steelblue3", "red4", "white")) + 
  theme_minimal() +
  xlab(paste("PC1, ", round(f1_gnorm.pca.proportionvariances[1], 2), "%")) + 
  ylab(paste("PC2, ", round(f1_gnorm.pca.proportionvariances[2], 2), "%")) +
  ggtitle("PCA of F1 Lineage Main Effect Genes in All Stage 35 Treatments Means") 

r + geom_point(aes(size=exposure)) + 
  scale_size_manual(name="Embryo Exposure", values=c(3, 3.01)) +
  guides(fill="none", 
         size=guide_legend(override.aes=list(shape=c(1,16))))

# Make PCA plots for F2 DEGs: 
s <- ggplot(f2_gnorm.PCi, aes(x=PC1, y=PC2, color=group,
                              shape=gen, 
                              fill=factor(ifelse(exposure=="56", group, "white")))) +
  scale_color_manual(name="Lineage", values=c("steelblue3", "red4")) + 
  scale_shape_manual(name="Generation", values=c(21,24)) + 
  scale_fill_manual(name="Exposure", values=c("steelblue3", "red4", "white")) + 
  theme_minimal() +
  xlab(paste("PC1, ", round(f2_gnorm.pca.proportionvariances[1], 2), "%")) + 
  ylab(paste("PC2, ", round(f2_gnorm.pca.proportionvariances[2], 2), "%")) +
  ggtitle("PCA of F2 Lineage Main Effect Genes in All Stage 35 Treatment Means") 

s + geom_point(aes(size=exposure)) + 
  scale_size_manual(name="Embryo Exposure", values=c(3, 3.01)) +
  guides(fill="none", 
         size=guide_legend(override.aes=list(shape=c(1,16))))

