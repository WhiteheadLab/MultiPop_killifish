###Generate a list of mean and standard deviations for each treatment
TreatMeans <- function(x) {
  genelist <- colnames(x[,1:(dim(x)[2]-5)])
  treat <- unique(x$trt)
  
  meandat <- matrix(nrow=length(treat), ncol=length(genelist))
  colnames(meandat) <- genelist
  rownames(meandat) <- treat 
  for (i in 1:length(treat)) {
    a <- which(x$trt == treat[i])
    n <- apply(x[a,1:(dim(x)[2]-5)], 2, mean)
    b <- which(rownames(meandat)==treat[i])
    meandat[b,] <- n 
  }
  
  trtmeans <- meandat
  return(trtmeans)
}