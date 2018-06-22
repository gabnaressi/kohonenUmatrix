# kohonenUmatrix
Plots a proper SOM U-matrix for a Kohonen object.

## Limitations
Currently supports symmetrical hexagonal grids only.

## Usage
```
data(iris)

som_grid <- (xdim=2, ydim=2, topo='hexagonal')
som_model <- kohonen::som(iris[,1:4], som_grid, rlen=100)

source(Umatrix.R)
umatrix <- getUmatrix(som_model)
plotUmatrix(umatrix)

```  
## Dependencies
Please install the following packages:
* plotrix

## Parameters
* palette: the default is `colorRampPalette(c('lightblue','black'))`.
* contrast: lower this parameter for more contrast on your plot. Default: 255.
* line: The hexagon's borders. Default is "transparent". Black and white may also look good.
