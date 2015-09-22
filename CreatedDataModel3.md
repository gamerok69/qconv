# <font color='#3366FF'>Whats new</font> #

## <font color='3399FF'>Changed tables and columns names</font> ##
  1. Tables: not Cars but Car, but: Autos and Orders becasue Auto and Orders are regestered words!!!
  1. Columns
    * PK: not TABLE\_ID but ID
    * FK: not ID\_FIELD but TABLE\_WITH\_PK\_ID

## <font color='3399FF'>New Columns</font> ##
  1. Table **Auto**
    * CHILD\_SEATS\_QUAN - child seats quantity
  1. Table **Orders\_result**
    * DESCR - description
  1. Added columns PERSON\_ID into the table DRIVER and CUSTOMER instead of one to one relation.

# <font color='#3366FF'>Results</font> #

1) Generated Oracle DDL script file: [DispTaxi\_Java\_Oracle\_DDL.sql](https://code.google.com/p/qconv/source/browse/data_model/DispTaxi_Java_Oracle_DDL.sql)

2) Generated Postgre DDL script file: [DispTaxi\_Java\_Postgre\_DDL.sql](https://code.google.com/p/qconv/source/browse/data_model/DispTaxi_Java_Postgre_DDL.sql)

3) Generated PDF file for Relational Model: [DispTaxi\_Relational\_Java.pdf](https://code.google.com/p/qconv/source/browse/data_model/DispTaxi_Relational_Java.pdf)

4) Generated PNG image for Relational Model
[DispTaxi\_Relational\_Java.png](https://qconv.googlecode.com/svn/data_model/DispTaxi_Relational_Java.png)
![https://qconv.googlecode.com/svn/data_model/DispTaxi_Relational_Java.png](https://qconv.googlecode.com/svn/data_model/DispTaxi_Relational_Java.png)

# <font color='#3366FF'>ToDo</font> #
  1. Add Company table
  1. Add company column into Auto table