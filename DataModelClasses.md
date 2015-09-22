# <font color='#3366FF'>Classes</font> #

## <font color='3399FF'>Created new classes</font> ##
  1. field as table's column
```
public class AppRole {
	private Long id;
	private String name;
	private String descr;
        ...
}
```
  1. field as master table (type of master table Class)
```
public class Driver {
	...
	private Person person;
        ...
}
```
  1. field as details table (List of detail's table Class). Only for table PERSON as sample.
```
public class Person {
	...
	private List<Driver> drivers;
	private List<Customer> customers;
	private List<UsersAccount> usersAccounts;
        ...
}
```