###Generate a list of mean and standard deviations for each treatment
MeanVar <- function(x) {
	genelist <- colnames(x[,1:(dim(x)[2]-1)])
	treat <- unique(x$trt)

	meandat <- matrix(nrow=length(treat), ncol=length(genelist))
	colnames(meandat) <- genelist
	rownames(meandat) <- treat 
	for (i in 1:length(treat)) {
		a <- which(x$trt == treat[i])
		n <- apply(x[a,1:(dim(x)[2]-1)], 2, mean)
		b <- which(rownames(meandat)==treat[i])
		meandat[b,] <- n 
		}
	
	vardat <- matrix(nrow=length(treat), ncol=length(genelist))
	colnames(vardat) <- genelist
	rownames(vardat) <- treat 
	for (i in 1:length(treat)) {
		if (length(which(x$trt==treat[i])) > 1) {
			a <- which(x$trt==treat[i])
			#print(a)
			n <- apply(x[a,1:(dim(x)[2]-1)], 2, sd, na.rm=TRUE)
			#print(n)
			b <- which(rownames(vardat)==treat[i])
			#print(b)
			vardat[b,] <- n 
			}
	}
	meanvar <- list(mean=meandat, stdev=vardat)
	return(meanvar)
}
