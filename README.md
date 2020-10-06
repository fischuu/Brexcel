# Brexcel
An R-package to create Public Health England data handling

# Usage
To install, run 

```
library("devtools")
install_github("fischuu/Brexcel", ref="main")
```

and then, just type

```
library("Brexcel")
brexcelfy()
```

and all data frames and matrices in your current environment will be adjusted to
emulate Public Health England (PHE) data handling with Excel (i.e. truncate them
to 65,536 rows and 255 columns (`version="Excel2003"`)). 

You can also choose different presets to emulate other Excel versions, e.g.
with 

```
brexcelfy(version="Excel2007")
```

your objects will be truncated to 1,048,576 rows by 16,384 columns.

In case you do not want to follow any preset, you can also define the number
of rows and columns by hand

```
brexcelfy(nrow=100, ncol=10)
```
