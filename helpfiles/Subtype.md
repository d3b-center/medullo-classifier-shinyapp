### Existing Subtype Information (Optional)

#### Details:

```
* Upload observed/existing MB subtype classifications for your data
* Use this input if you need to do any accuracy testing or validate existing classifications
* Please download example data for reference
```

#### File Format:

```
* A vector of length M (corresponding to M columns in the input expression matrix) containing Medulloblastoma subtypes corresponding to each sample identifier. 
* Allowed values are: Group3, Group4, SHH, WNT and U (for Unknown).
* Allowed formats: TSV, RData and RDS files.
* TSV should contain one subtype per line and no headers.
* RData and RDS formats should be character vector.
```