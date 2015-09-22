# Created Data Model #

Created Data model for the new Application with Oracle SQL Developer Data Modeler.
Source files located in **data\_model** folder.

1) Generated layout file: [DispTaxi\_Relational.pdf](https://code.google.com/p/qconv/source/browse/data_model/DispTaxi_Relational.pdf)

2) Generated script file: [DispTaxi\_Oracle\_DDL.sql](https://code.google.com/p/qconv/source/browse/data_model/DispTaxi_Oracle_DDL.sql)

3) Generated PDF Relational Model
![https://qconv.googlecode.com/svn/data_model/DispTaxi_Relational.png](https://qconv.googlecode.com/svn/data_model/DispTaxi_Relational.png)

## What To Do ##

### Table Orders ###
  1. Information about Route length in KM
  1. Information about the amout of payment

### Table for login information ###
  1. UserName and Password
  1. Relation with the Person table

### Table or view for the 'New'/'On Way' orders ###
  * This table have only
    1. 'New' orders from which Driver can choose some.
    1. 'On Way' orders for control

### Table Orders ###
  * Add Rating for Customer and Driver
    1. customer\_rating
    1. driver\_rating

### Table Drivers, Customers ###
  * Add average
    1. avg\_customer\_rating
    1. avg\_driver\_rating