# The Common plan #

## Types of users (Roles) ##

  1. **Admin** which can add
    * the new user with granted role (Admin, Operator, Driver, Customer)
  1. **Operator** which can add/modify
    * any information into directories: Autos (Cars, Drivers), Customers, Orders
  1. **Driver** which can add/modify
    * information about execution of the Order (set orders _state_)
  1. **Customer** which can look at
    * information about him orders

## Layouts ##

  1. Create the **form for the Operator** (for the _Operator_ role).
    * Navigation menu
      * Orders
        * Create order
        * Show active orders
        * View all Orders
      * Autos
      * Customers
    * Main container
  1. Create **forms for directories** (for the _Admin_ and _Operator_ roles).
    * _Separate_ form
    * _Inline_ form in the main form for the operator role
    1. **Users accounts**
    1. **Autos** with calling the _Cars_ and the _Drivers_ forms
    1. **Cars**
    1. **Type of Cars**
    1. **Drivers**
    1. **Customers**
    1. **Prices**
  1. Create the **form for the Driver**
    * Navigation menu
      * **My Info**
        * My **Personal** info
        * My **Car** info
      * **Orders**
        * Create orders
        * Active order (with changing Order's State in Orders\_Timetable)
        * View my **Orders**
      * Show new orders
    * Main container
  1. Create the **form for the Customer**
    * Navigation menu
      * **My Info**
        * My **Personal** info
      * **Orders**
        * Create order
        * View my **Orders**
    * Main container

## Functional ##
  * Calculate Route length and price (using tables Routes, Prices)
  * Search Autos (using Route, Autos(r\_waiting, r\_route))