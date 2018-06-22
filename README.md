# kohonenUmatrix
Plots a proper SOM U-matrix for a Kohonen object.

## Limitations
Currently supports symmetrical hexagonal grids only.

## Usage
```R
library(kohonen)

data(iris)

som_grid <- somgrid(xdim=2, ydim=2, topo='hexagonal')
som_model <- kohonen::som(as.matrix(iris[,1:4]), som_grid, rlen=100)

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
