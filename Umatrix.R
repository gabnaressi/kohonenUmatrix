getUmatrix <- function(som_model){

###UMATRIX!!!

#properUMatrix <- function(som_model){

positions <- som_model$grid$pts
codes <- som_model$codes[[1]]

xstep <- unique(positions[,1][order(positions[,1])])
xstep <- xstep[2] - xstep[1]

ystep <- unique(positions[,2][order(positions[,2])])
ystep <- ystep[2] - ystep[1]

minx<- positions[1,1]; miny<- positions[1,2]

distmat <- as.matrix(dist(codes))

##
#preenchimento dos neuronios
##


prototypes <- cbind(positions, data.frame(dist=0))
size <- nrow(prototypes)
#dim <- sqrt(size)
xdim<- som_model$grid$xdim
ydim<- som_model$grid$ydim

distcells<-data.frame(x=as.double(), y=as.double(), dist=as.double())


##
editp<- split(prototypes, prototypes$y)
names(editp) <- 1:length(editp)
editp <- split(editp, as.numeric(names(editp)) %% 2 == 0 )

editp$`FALSE` <- lapply(editp$`FALSE`, FUN=function(df){df$x<- df$x + (0:(nrow(df)-1) * (xstep*4)); df})
editp$`TRUE` <- lapply(editp$`TRUE`, FUN=function(df){df$x<-(df$x + (0:(nrow(df)-1) * (xstep*4))) - xstep*2; df})
#editp$`TRUE` <- lapply(editp$`TRUE`, FUN=function(df){df$x<- df$x -(seq(from=(nrow(df)-1), to=0) * (xstep*4)); df})

editp$`FALSE` <- do.call("rbind", editp$`FALSE`)
editp$`TRUE` <- do.call("rbind", editp$`TRUE`)
editp <- do.call("rbind", editp)

editp$y <- editp$y + (editp$y / ystep - 1) * ystep



prototypes <- editp[order(editp$y, editp$x),]
##

xstep <- (prototypes[2,1] - prototypes[1,1]) / 4
ystep <- (unique(prototypes$y)[2] - unique(prototypes$y)[1]) /2
minx<- min(prototypes$x); miny<- min(prototypes$y)
maxx<- max(prototypes$x)

for(i in 1:nrow(prototypes)){
  iterador <- prototypes[i,]
  somaDist<-c()
  #calcular distancia da direita
  if(i<size &  prototypes[i,]$y == prototypes[i+1,]$y){
    newcell <- data.frame(x=prototypes[i,]$x+(xstep*2),
                          y=prototypes[i,]$y,
                          dist=distmat[i,i+1]
    )
    
    distcells <- rbind(distcells, newcell)
    
    somaDist<- c(somaDist,distmat[i,i+1])
    
    #update
    #prototypes[(prototypes$y==prototypes[i,]$y & prototypes$x > prototypes[i,]$x),]$x <- prototypes[(prototypes$y==prototypes[i,]$y & prototypes$x > prototypes[i,]$x),]$x + (xstep*2)
    
  }
  
  #calcular distancia diagonal direita
  if(i+xdim < size & prototypes[i,]$x < maxx){
    newcell <- data.frame(x=prototypes[i,]$x + xstep,
                          y=prototypes[i,]$y + ystep,
                          dist=distmat[i,i+xdim])
    
    distcells <- rbind(distcells, newcell)
    
    #update
    somaDist<- c(somaDist, distmat[i,i+xdim])
    
  }
  #calcular distancia diagonal esquerda
  if(i+xdim-1 < size & prototypes[i,]$x > minx){
    newcell <- data.frame(x=prototypes[i,]$x - xstep,
                          y=prototypes[i,]$y + ystep,
                          dist=distmat[i,i+xdim-1])
    
    distcells <- rbind(distcells, newcell)
    
    somaDist<- c(somaDist,distmat[i,i+xdim-1])
  }
  
  prototypes[i,]$dist <- mean(somaDist)
  
}

distcells <- distcells[order(distcells$y, distcells$x),]


#plot coordenadas 
# plot(editp$x,editp$y)
# points(distcells$x,distcells$y)

  
#plot
umat <- rbind(prototypes, distcells)
umat <- umat[order(umat$y,umat$x),]


}

plotUmatrixLegacy<- function(umat, palette=colorRampPalette(c('lightblue','black')), cex=3){
  umat$color <- palette(15)[as.numeric(cut(umat$dist,breaks = 15))]
  plot(umat$x,umat$y,cex=cex, col=umat$color, pch=19)
}

plotUmatrix<- function(umat,palette=colorRampPalette(c('lightblue','black')), contrast=255, line="transparent" ){
  library(plotrix)
  
  hexmap <- function(xcor,ycor,colval){
    plot(min(c(xcor,ycor)):(max(c(xcor,ycor))+1),min(c(xcor,ycor)):(max(c(xcor,ycor))+1), type="n", frame.plot=F, xaxt="n", yaxt="n", xlab="", ylab="")
    data <- data.frame(xcor,ycor,colval)
    
    for (i in 1:length(data$xcor)){
      hexagon(data$xcor[i],data$ycor[i],col=as.character(data$colval[i]), unitcell=0.95,border=line)
    }
  }
  
  #umat <- umat[-is.na(umat$dists),]
  
  umat$x <- umat$x/1.6
  
  umat$dists <- round( rescale(umat$dist, newrange=c(0,contrast)) )
  umat$dists[umat$dists==0] <- 1
  
  hexes <- palette(contrast)
  
  umat$hex <- hexes[umat$dists]
  
  # umat$dists <- round( rescale(umat$dist, newrange=c(0,255)) )
  #
  # umat$hex <- as.hexmode((umat$dists))
  # 
  # umat$hex[umat$hex==0] <- 00
  # 
  # umat$hex <- paste0('#',umat$hex,umat$hex, umat$hex)
  
  hexmap(umat$x,umat$y, umat$hex)
}

