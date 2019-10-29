.. |date| date::

****************************
Medullo Classifier Shiny App
****************************

:authors: Komal Rathi
:contact: rathik@email.chop.edu
:organization: D3B, CHOP
:status: This is "work in progress"
:date: |date|

.. meta::
   :keywords: web, portal, rshiny, 2016
   :description: D3B Rshiny Web Portal.

Introduction
============

R Shiny application built on the Medulloblastoma subtypes classifier R package: https://github.com/d3b-center/medullo-classifier-package

Input files
===========

The application requires two inputs: 

	1. Expression Matrix with HUGO symbols as rows and Sample identifiers as columns. 
	   
	   * A dataframe of NxM dimension containing expression values. 
	   * Rownames are HUGO/HGNC gene symbols and column names are Sample identifiers. 
	   * Allowed input types: **(1) FPKM (2) TPM (3) Quantile normalized data (4) microarray data (RMA).**
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

	2. Metadata with subtype information. 
	   
	   * A vector of length M containing Medulloblastoma subtypes corresponding to each sample identifier. 
	   * Tab delimited format should contain one subtype per line and no headers.
	   * RData and RDS formats should be character vector of subtypes.
	   * Allowed values are **Group3, Group4, SHH, WNT and U (for Unknown)**
	   * Allowed formats: Tab delimited text, RData and RDS files. 

**NOTE: Both expression and meta files should have the same extension type**

Output
======

Output consists of four tables: 

	1. Predicted subtypes and P-values for each sample.
	2. Confusion Matrix
	3. Overall Accuracy statistics
	4. Class based statistics
	   
For more details, please refer to: https://github.com/d3b-center/medullo-classifier-package
