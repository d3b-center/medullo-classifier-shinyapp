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

R Shiny application for Medullo Classifier.

Input files
===========

The application requires two inputs: Expression Matrix and Metadata

Expression Matrix with HUGO symbols as rows and Sample identifiers as columns
   
+--------------+----------+-----------+-----------+-----------+
|              | Sample_1 | Sample_2  | Sample_3  | Sample_n  |
+--------------+----------+-----------+-----------+-----------+
| HUGO_Gene_1  |          |           |           |           |
+--------------+----------+-----------+-----------+-----------+
| HUGO_Gene_2  |          |           |           |           |
+--------------+----------+-----------+-----------+-----------+
| HUGO_Gene_3  |          |           |           |           |
+--------------+----------+-----------+-----------+-----------+

Metadata with two columns: *sample_id* (which should match exactly with expression matrix column names) and *subtypes*. Allowed values for subtypes are: Group3, Group4, SSH, WNT and U (for Unknown)
   
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

Output
======

Output consists of three tables: 

	1. Confusion Matrix
	2. Overall Accuracy statistics
	3. Class based statistics
	   

