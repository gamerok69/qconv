# <font color='#3366FF'>Whats new</font> #

## <font color='3399FF'>New Tables</font> ##
  1. Customer
    * changed FK in Orders (Customers instead of Persons)
  1. Order timetable (for execution time control)
  1. Prices
  1. Car types (for different price)
  1. User accounts (for logging form)
  1. Application roles (for dividing layouts by Role) with foreign key to the Person table (one person can be as a driver and as a customer)

## <font color='3399FF'>New Columns</font> ##
  1. Table **Orders**
    1. route\_length (for summary)
    1. order\_price (for summary)
    1. customer\_rating (vote by driver)
    1. driver\_rating (vote by customer)
  1. Table **Routes**
    1. est\_length (estimated length for calculating preliminary price of order)
    1. fact\_length (used for calculating the total order price)
    1. est\_time (estimated time)
  1. Table **Cars**
    1. id\_car\_type (for price)

# <font color='#3366FF'>Results</font> #

  1. Generated DDL script file: [DispTaxi\_Oracle\_DDL-2.sql](https://code.google.com/p/qconv/source/browse/data_model/DispTaxi_Oracle_DDL-2.sql)

> 2) Generated PDF file for Relational Model: [DispTaxi\_Relational-2.pdf](https://code.google.com/p/qconv/source/browse/data_model/DispTaxi_Relational-2.pdf)

> 3) Generated PNG image for Relational Model
[DispTaxi\_Relational-2.png](https://qconv.googlecode.com/svn/data_model/DispTaxi_Relational-2.png)
![https://qconv.googlecode.com/svn/data_model/DispTaxi_Relational-2.png](https://qconv.googlecode.com/svn/data_model/DispTaxi_Relational-2.png)

# <font color='#3366FF'>ToDo</font> #
  1. Add Company table
  1. Add company column into Auto table