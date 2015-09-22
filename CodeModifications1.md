# New Annotations #

  1. ORM, JPA
    * added annotations
```
   @Entity
   
   @Id
   @GeneratedValue(strategy = GenerationType.IDENTITY) for primary keys

   @Column

   @MapsId
   @OneToOne(fetch = FetchType.LAZY, cascade = { CascadeType.PERSIST, CascadeType.MERGE })
   @JoinColumn(updatable = false, name = "id")
   
   @ManyToOne(fetch = FetchType.LAZY, targetEntity = Master.class)
```

# Abstract DAO #
  * created interface AbstractDao with class AbstractDaoImpl
```
public interface AbstractDao<ID, Entity> {
	Entity getById(ID id);
	List<Entity> getAll();
	void delete(ID key);
	void deleteAll();
	void delete(List<ID> ids);
	Entity insert(Entity entity);
	Entity update(Entity entity);
}
```
```
public abstract class AbstractDaoImpl<ID, Entity> implements
		AbstractDao<ID, Entity> {

	private EntityManager em;
	private final Class<Entity> entityClass;

	protected AbstractDaoImpl(final Class<Entity> entityClass) {
		Validate.notNull(entityClass, "entityClass could not be a null");
		this.entityClass = entityClass;
	}

	@Override
	public Entity getById(ID id) {
		return em.find(getEntityClass(), id);
	}

	@Override
	public Entity insert(final Entity entity) {
		em.persist(entity);
		return entity;
	}

	@Override
	public Entity update(Entity entity) {
		entity = em.merge(entity);
		em.flush();
		return entity;
	}

	@Override
	public void delete(final ID key) {
		em.remove(em.find(getEntityClass(), key));
	}

	@Override
	public void delete(List<ID> ids) {
		em.createQuery(
				String.format("delete from %s e where e.id in (:ids)",
						entityClass.getSimpleName())).setParameter("ids", ids)
				.executeUpdate();
	}

	@Override
	public void deleteAll() {
		final Query q1 = em.createQuery("delete from "
				+ getEntityClass().getSimpleName());
		q1.executeUpdate();
		em.flush();
	}

	@Override
	public List<Entity> getAll() {
		final CriteriaQuery<Entity> query = em.getCriteriaBuilder()
				.createQuery(getEntityClass());
		query.from(getEntityClass());
		final List<Entity> lst = em.createQuery(query).getResultList();
		return lst;
	}

	@PersistenceContext
	private void setEntityManager(EntityManager em) {
		this.em = em;
	}

	private Class<Entity> getEntityClass() {
		return entityClass;
	}

}
```

# Using for tables #
## for Master table ##
  * ORM
```
@Entity
public class UserProfile {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Column
	private String firstName;
	@Column
	private String lastName;
	@Column
	private String telNum;
	@Column
	private Date dCreate;
}
```
  * DAO
```
public interface UserProfileDao extends AbstractDao<Long, UserProfile> {
}
```
```
@Repository
public class UserProfileDaoImpl extends AbstractDaoImpl<Long, UserProfile> implements UserProfileDao {
	protected UserProfileDaoImpl() {
		super(UserProfile.class);
	}
}
```
  * Services
```
public interface UserProfileService {

	UserProfile get(Long id);

	@Transactional
	void saveOrUpdate(UserProfile userProfile);

	@Transactional
	void delete(UserProfile userProfile);

	@Transactional
	void deleteAll();
}
```
```
@Service
public class UserProfileServiceImpl implements UserProfileService {
	private static final Logger LOGGER = LoggerFactory.getLogger(UserProfileServiceImpl.class);

	@Inject
	private UserProfileDao dao;

	@PostConstruct
	private void init() {
		// this method will be called by Spring after bean instantiation. Can be
		// used for any initialization process.
		LOGGER.info("Instance of UserProfileService is created. Class is: {}", getClass().getName());
	}

	@Override
	public UserProfile get(Long id) {
		UserProfile entity = dao.getById(id);
		return entity;
	}

	@Override
	public void saveOrUpdate(UserProfile userProfile) {
		if (userProfile.getId() == null) {
			LOGGER.debug("Save new: {}", userProfile);
			dao.insert(userProfile);
		} else {
			LOGGER.debug("Update: {}", userProfile);
			dao.update(userProfile);
		}
	}

	@Override
	public void delete(UserProfile userProfile) {
		LOGGER.debug("Remove: {}", userProfile);
		dao.delete(userProfile.getId());
	}

	@Override
	public void deleteAll() {
		LOGGER.debug("Remove all user profiles");
		dao.deleteAll();
	}

}
```
  * Tests
```
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:spring-context.xml" })
public class UserProfileServiceTest extends AbstractServiceTest {

	private static final Logger LOGGER = LoggerFactory.getLogger(UserProfileServiceTest.class);

	@Inject
	private UserProfileService userProfileService;

	@Before
	public void cleanUpData() {
		LOGGER.info("Instance of UserProfileService is injected. Class is: {}", userProfileService.getClass().getName());
		// userProfileService.deleteAll();
	}

	@Test
	public void test1() {
		LOGGER.warn("Test log message in test1().");
		Assert.assertNotNull(userProfileService);
	}

	@Test
	public void basicCRUDTest() {
		UserProfile userProfile = createUserProfile();
		userProfileService.saveOrUpdate(userProfile);

		UserProfile userProfileFromDb = userProfileService.get(userProfile.getId());
		Assert.assertNotNull(userProfileFromDb);
		Assert.assertEquals(userProfileFromDb.getFirstName(), userProfile.getFirstName());

		userProfileFromDb.setFirstName("newName");
		userProfileService.saveOrUpdate(userProfileFromDb);
		UserProfile userProfileFromDbUpdated = userProfileService.get(userProfile.getId());
		Assert.assertEquals(userProfileFromDbUpdated.getFirstName(), userProfileFromDb.getFirstName());
		Assert.assertNotEquals(userProfileFromDbUpdated.getFirstName(), userProfile.getFirstName());

		userProfileService.delete(userProfileFromDbUpdated);
		Assert.assertNull(userProfileService.get(userProfile.getId()));
	}

	private UserProfile createUserProfile() {
		UserProfile userProfile = new UserProfile();
		userProfile.setFirstName(randomString("UserFirstName-"));
		userProfile.setTelNum(randomString("+tel-num-"));
		return userProfile;
	}

}
```
## for Detail table with OneToOne relation ##
  * ORM
```
@Entity
public class Driver {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column
	private Long avgRating;
	@Column
	private Long signActive;
	@Column
	private Date dCreate;

	@MapsId
	@OneToOne(fetch = FetchType.LAZY, cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	@JoinColumn(updatable = false, name = "id")
	private UserProfile userProfile;
}
```
  * DAO
```
public interface DriverDao extends AbstractDao<Long, Driver> {
}
```
```
@Repository
public class DriverDaoImpl extends AbstractDaoImpl<Long, Driver> implements DriverDao {
	protected DriverDaoImpl() {
		super(Driver.class);
	}
}
```
  * Services
```
public interface DriverService {

	Driver get(Long id);

	@Transactional
	void create(Driver driver, UserProfile userProfile);

	@Transactional
	void update(Driver driver);

	@Transactional
	void delete(Driver driver);

	@Transactional
	void deleteAll();
}
```
```
@Service
public class DriverServiceImpl implements DriverService {
	private static final Logger LOGGER = LoggerFactory.getLogger(DriverServiceImpl.class);

	@Inject
	private DriverDao dao;

	@PostConstruct
	private void init() {
		// this method will be called by Spring after bean instantiation. Can be
		// used for any initialization process.
		LOGGER.info("Instance of DriverService is created. Class is: {}", getClass().getName());
	}

	@Override
	public Driver get(Long id) {
		Driver entity = dao.getById(id);
		return entity;
	}

	@Override
	public void create(Driver driver, UserProfile userProfile) {
		Validate.isTrue(driver.getId() == null,
				"This method should be called for 'not saved yet' profile only. Use UPDATE instead");
		driver.setPerson(userProfile);
		dao.insert(driver);
	}

	@Override
	public void update(Driver driver) {
		dao.update(driver);
	}

	@Override
	public void delete(Driver driver) {
		dao.delete(driver.getId());
	}

	@Override
	public void deleteAll() {
		dao.deleteAll();
	}

}
```
  * Tests
```
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:spring-context.xml" })
public class DriverServiceTest extends AbstractServiceTest {

	@Inject
	private DriverService driverService;
	@Inject
	private UserProfileService userProfileService;

	@Test
	public void createUserAndDriver() {

		final UserProfile profile = createUserProfile();
		final Driver driver = createDriver();
		driverService.create(driver, profile);

		final Driver createdDriver = driverService.get(driver.getId());
		Assert.assertNotNull(createdDriver);
		// TODO check equals

		driverService.delete(driver);
		Assert.assertNull(driverService.get(driver.getId()));

		userProfileService.delete(profile);
		Assert.assertNull(userProfileService.get(profile.getId()));
	}

	private Driver createDriver() {
		final Driver driver = new Driver();
		driver.setSignActive(0L);
		return driver;
	}

	private UserProfile createUserProfile() {
		final UserProfile userProfile = new UserProfile();
		userProfile.setFirstName(randomString("firstName-"));
		userProfile.setLastName(randomString("lastName-"));
		userProfile.setTelNum(randomString("+tel-num-"));
		userProfile.setdCreate(randomDate());
		return userProfile;
	}
}
```

## for Detail table with ManyToOne relation ##
  * ORM
```
@Entity
public class CarsType {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Column
	private String name;
}
```
```
@Entity
public class Car {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Column
	private String regNum;
	@Column
	private Long seatsQuan;
	@Column
	private Long childSeatsQuan;
	@ManyToOne(fetch = FetchType.LAZY, targetEntity = CarsType.class)
	private CarsType carsType;
	@Column
	private Long signActive;
	@Column
	private Date dCreate;
}
```
  * DAO
```
public interface CarsTypeDao extends AbstractDao<Long, CarsType> {
}
```
```
@Repository
public class CarsTypeDaoImpl extends AbstractDaoImpl<Long, CarsType> implements CarsTypeDao {
	protected CarsTypeDaoImpl() {
		super(CarsType.class);
	}
}
```
```
public interface CarDao extends AbstractDao<Long, Car> {
}
```
```
@Repository
public class CarDaoImpl extends AbstractDaoImpl<Long, Car> implements CarDao {
	protected CarDaoImpl() {
		super(Car.class);
	}
}
```
  * Service
```
public interface CarsTypeService {
	CarsType get(Long id);

	@Transactional
	void create(CarsType carsType);

	@Transactional
	void update(CarsType carsType);

	@Transactional
	void delete(CarsType carsType);

	@Transactional
	void deleteAll();
}
```
```
@Service
public class CarsTypeServiceImpl implements CarsTypeService {
	private static final Logger LOGGER = LoggerFactory.getLogger(CarServiceImpl.class);

	@Inject
	private CarsTypeDao dao;

	@PostConstruct
	private void init() {
		// this method will be called by Spring after bean instantiation. Can be
		// used for any initialization process.
		LOGGER.info("Instance of CarsTypeService is created. Class is: {}", getClass().getName());
	}

	@Override
	public CarsType get(Long id) {
		CarsType entity = dao.getById(id);
		return entity;
	}

	@Override
	public void create(CarsType carsType) {
		Validate.isTrue(carsType.getId() == null,
				"This method should be called for 'not saved yet' profile only. Use UPDATE instead");
		LOGGER.debug("Insert: {}", carsType);
		dao.insert(carsType);
	}

	@Override
	public void update(CarsType carsType) {
		LOGGER.debug("Update: {}", carsType);
		dao.update(carsType);
	}

	@Override
	public void delete(CarsType carsType) {
		LOGGER.debug("Remove: {}", carsType);
		dao.delete(carsType.getId());
	}

	@Override
	public void deleteAll() {
		LOGGER.debug("Remove all cars types");
		dao.deleteAll();
		;
	}

}
```
```
public interface CarService {

	Car get(Long id);

	@Transactional
	void create(Car car, CarsType carsType);

	@Transactional
	void update(Car car);

	@Transactional
	void delete(Car car);

	@Transactional
	void deleteAll();
}
```
```
@Service
public class CarServiceImpl implements CarService {
	private static final Logger LOGGER = LoggerFactory.getLogger(CarServiceImpl.class);

	@Inject
	private CarDao dao;

	@PostConstruct
	private void init() {
		// this method will be called by Spring after bean instantiation. Can be
		// used for any initialization process.
		LOGGER.info("Instance of CarService is created. Class is: {}", getClass().getName());
	}

	@Override
	public Car get(Long id) {
		Car entity = dao.getById(id);
		return entity;
	}

	@Override
	public void create(Car car, CarsType carsType) {
		Validate.isTrue(car.getId() == null,
				"This method should be called for 'not saved yet' profile only. Use UPDATE instead");
		car.setCarsType(carsType);
		LOGGER.debug("Insert: {}", car);
		dao.insert(car);
	}

	@Override
	public void update(Car car) {
		LOGGER.debug("Update: {}", car);
		dao.update(car);
	}

	@Override
	public void delete(Car car) {
		LOGGER.debug("Remove: {}", car);
		dao.delete(car.getId());
	}

	@Override
	public void deleteAll() {
		LOGGER.debug("Remove all cars");
		dao.deleteAll();

	}

}
```
  * Tests
```
@Component
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:spring-context.xml" })
public class CarsTypeServiceTest extends AbstractServiceTest {

	private static final Logger LOGGER = LoggerFactory.getLogger(CarsTypeServiceTest.class);

	@Inject
	private CarsTypeService carsTypeService;

	@Before
	public void cleanUpData() {
		LOGGER.info("Instance of CarsTypeService is injected. Class is: {}", carsTypeService.getClass().getName());
		carsTypeService.deleteAll();
	}

	@Test
	public void test1() {
		LOGGER.warn("Test log message in test1().");
		Assert.assertNotNull(carsTypeService);
	}

	@Test
	public void basicCRUDTest() {
		CarsType carsType = createCarsType();
		carsTypeService.create(carsType);

		CarsType carsTypeFromDb = carsTypeService.get(carsType.getId());
		Assert.assertNotNull(carsTypeFromDb);
		Assert.assertEquals(carsTypeFromDb.getName(), carsType.getName());
		// TODO check other fields

		carsTypeFromDb.setName(randomString("NEW-TYPE-"));
		carsTypeService.update(carsTypeFromDb);
		CarsType carsTypeFromDbUpdated = carsTypeService.get(carsType.getId());
		Assert.assertEquals(carsTypeFromDbUpdated.getName(), carsTypeFromDb.getName());
		Assert.assertNotEquals(carsTypeFromDbUpdated.getName(), carsType.getName());

		carsTypeService.delete(carsTypeFromDbUpdated);
		Assert.assertNull(carsTypeService.get(carsType.getId()));
	}

	public CarsType createCarsType() {
		CarsType carsType = new CarsType();
		carsType.setName(randomString("TYPE-"));
		return carsType;
	}

}
```
```
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:spring-context.xml" })
public class CarServiceTest extends AbstractServiceTest {

	private static final Logger LOGGER = LoggerFactory.getLogger(CarServiceTest.class);

	@Inject
	private CarService carService;
	@Inject
	private CarsTypeService carsTypeService;
	@Inject
	private CarsTypeServiceTest carsTypeServiceTest;

	@Before
	public void cleanUpData() {
		LOGGER.info("Instance of CarService is injected. Class is: {}", carService.getClass().getName());
		carService.deleteAll();
	}

	@Test
	public void test1() {
		LOGGER.warn("Test log message in test1().");
		Assert.assertNotNull(carService);
	}

	@Test
	public void basicCRUDTest() {
		Car car = createCar();
		CarsType carsType = carsTypeServiceTest.createCarsType();
		carsTypeService.create(carsType);
		carService.create(car, carsType);

		Car carFromDb = carService.get(car.getId());
		Assert.assertNotNull(carFromDb);
		Assert.assertEquals(carFromDb.getRegNum(), car.getRegNum());
		// TODO check other fields

		carFromDb.setRegNum(getRandomRegNum());
		carService.update(carFromDb);
		Car carFromDbUpdated = carService.get(car.getId());
		Assert.assertEquals(carFromDbUpdated.getRegNum(), carFromDb.getRegNum());
		Assert.assertNotEquals(carFromDbUpdated.getRegNum(), car.getRegNum());

		carService.delete(carFromDbUpdated);
		Assert.assertNull(carService.get(car.getId()));
	}

	private String getRandomRegNum() {
		return randomInteger(1111, 9999) + " " + randomString().substring(1, 2) + "-" + randomInteger(1, 7);
	}

	private Car createCar() {
		Car car = new Car();
		car.setRegNum(getRandomRegNum());
		car.setSeatsQuan(randomLong(1L, 12L));
		return car;
	}

}
```