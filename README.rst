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

	1. Expression Matrix with HUGO symbols as rows and Sample identifiers as columns. Allowed formats: Tab delimited text, RData and RDS files. 
   
	+--------------+----------+-----------+-----------+-----------+
	|              | Sample_1 | Sample_2  | Sample_3  | Sample_n  |
	+--------------+----------+-----------+-----------+-----------+
	| HUGO_Gene_1  |          |           |           |           |
	+--------------+----------+-----------+-----------+-----------+
	| HUGO_Gene_2  |          |           |           |           |
	+--------------+----------+-----------+-----------+-----------+
	| HUGO_Gene_3  |          |           |           |           |
	+--------------+----------+-----------+-----------+-----------+

	2. Metadata with subtype information. Allowed formats: Tab delimited text, RData and RDS files. 

	The metadata file should have two columns: **sample_id** (which should match exactly with expression matrix column names) and **subtypes**. Allowed values for subtypes are: Group3, Group4, SSH, WNT and U (for Unknown).
   
	+-----------+-----------+-----------+
	|           | sample_id | subtype   |
	+-----------+-----------+-----------+
	| Sample_1  |           | Group3    |
	+-----------+-----------+-----------+
	| Sample_2  |           | Group4    |
	+-----------+-----------+-----------+
	| Sample_3  |           | SSH       |
	+-----------+-----------+-----------+
	| Sample_4  |           | WNT       |
	+-----------+-----------+-----------+
	| Sample_n  |           | U         |
	+-----------+-----------+-----------+

**NOTE: Both files should have the same input type.**

Output
======

Output consists of three tables: 

	1. Confusion Matrix
	2. Overall Accuracy statistics
	3. Class based statistics
	   

