### Input Expression File (Required)

#### Details:

```
* Upload a matrix of NxM dimension containing expression values.
* Please download example data for reference
```

#### File Format:

```
Expression Matrix with HUGO symbols as rows and Sample identifiers as columns. 

* A dataframe of NxM dimension containing expression values. 
* Rownames are HUGO/HGNC gene symbols and column names are Sample identifiers. 
* Allowed expression types: **(1) FPKM (2) TPM (3) Quantile normalized data (4) microarray data (RMA).**
* Allowed formats: Tab delimited text, RData and RDS files. 

+--------------+----------+-----------+-----------+-----------+
|              | Sample_1 | Sample_2  | Sample_3  | Sample_n  |
+--------------+----------+-----------+-----------+-----------+
| HUGO_Gene_1  |          |           |           |           |
+--------------+----------+-----------+-----------+-----------+
| HUGO_Gene_2  |          |           |           |           |
+--------------+----------+-----------+-----------+-----------+
| HUGO_Gene_3  |          |           |           |           |
+--------------+----------+-----------+-----------+-----------+
```