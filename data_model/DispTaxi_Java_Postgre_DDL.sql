SET search_path TO 'public';
SET search_path TO 'test';

--
-- Drop all tables
--
DROP TABLE APP_ROLE CASCADE;
DROP TABLE AUTOS CASCADE;
DROP TABLE CAR CASCADE;
DROP TABLE CARS_TYPE CASCADE;
DROP TABLE CITY CASCADE;
DROP TABLE CUSTOMER CASCADE;
DROP TABLE DRIVER CASCADE;
DROP TABLE ORDERS CASCADE;
DROP TABLE ORDERS_RESULT CASCADE;
DROP TABLE ORDERS_STATE CASCADE;
DROP TABLE ORDERS_TIMETABLE CASCADE;
DROP TABLE POINT CASCADE;
DROP TABLE PRICE CASCADE;
DROP TABLE ROUTE CASCADE;
DROP TABLE STREET CASCADE;
DROP TABLE USER_ACCOUNT CASCADE;
DROP TABLE USER_PROFILE CASCADE;
DROP TABLE USER_ROLE CASCADE;

--
-- Create tables and constraints
--

CREATE TABLE AUTOS
  (
    ID SERIAL NOT NULL ,
    CAR_ID       INTEGER NOT NULL ,
    DRIVER_ID    INTEGER NOT NULL ,
    R_WAITING    SMALLINT ,
    R_ROUTE      SMALLINT ,
    POSITION_LAT CHARACTER VARYING (15) ,
    POSITION_LNG CHARACTER VARYING (15) ,
    SIGN_ACTIVE  INTEGER ,
    D_CREATE     TIMESTAMP WITHOUT TIME ZONE
  )
;
COMMENT ON TABLE AUTOS
IS
  'Список автомобилей готовых к выполнению заказов' ;
  COMMENT ON COLUMN AUTOS.ID
IS
  'PK' ;
  COMMENT ON COLUMN AUTOS.CAR_ID
IS
  'FK cars' ;
  COMMENT ON COLUMN AUTOS.DRIVER_ID
IS
  'FK drivers' ;
  COMMENT ON COLUMN AUTOS.R_WAITING
IS
  'Радиус ожидания, км' ;
  COMMENT ON COLUMN AUTOS.R_ROUTE
IS
  'Радиус выполнения заказа, км' ;
  COMMENT ON COLUMN AUTOS.POSITION_LAT
IS
  'Текущее положение авто (широта)' ;
  COMMENT ON COLUMN AUTOS.POSITION_LNG
IS
  'Текущее положение авто (долгота)' ;
  COMMENT ON COLUMN AUTOS.SIGN_ACTIVE
IS
  'Признак участия в исполнении заказа' ;
  COMMENT ON COLUMN AUTOS.D_CREATE
IS
  'Дата создания записи' ;
  ALTER TABLE AUTOS ADD CONSTRAINT AUTOS_PK PRIMARY KEY ( ID ) ;
  ALTER TABLE AUTOS ADD CONSTRAINT AUTOS_UK UNIQUE ( CAR_ID , DRIVER_ID ) ;

CREATE TABLE CAR
  (
    ID SERIAL NOT NULL ,
    REG_NUM          CHARACTER VARYING (10) ,
    SEATS_QUAN       INTEGER NOT NULL ,
    CHILD_SEATS_QUAN INTEGER ,
    SUITCASES_QUAN   INTEGER ,
    CAR_TYPE         INTEGER NOT NULL ,
    CAR_MODEL        CHARACTER VARYING (100) ,
    SIGN_ACTIVE      INTEGER ,
    D_CREATE         TIMESTAMP WITHOUT TIME ZONE
  )
;
COMMENT ON TABLE CAR
IS
  'Справочник транспортных средств' ;
  COMMENT ON COLUMN CAR.ID
IS
  'PK' ;
  COMMENT ON COLUMN CAR.REG_NUM
IS
  'Регистрационный номер' ;
  COMMENT ON COLUMN CAR.SEATS_QUAN
IS
  'Количество пассажирских мест' ;
  COMMENT ON COLUMN CAR.CHILD_SEATS_QUAN
IS
  'Кол-во детских сидений' ;
  COMMENT ON COLUMN CAR.SUITCASES_QUAN
IS
  'Количество сумок в багаже' ;
  COMMENT ON COLUMN CAR.CAR_TYPE
IS
  'Тип авто' ;
  COMMENT ON COLUMN CAR.CAR_MODEL
IS
  'Модель автомобиля' ;
  COMMENT ON COLUMN CAR.SIGN_ACTIVE
IS
  'Признак используемости авто' ;
  COMMENT ON COLUMN CAR.D_CREATE
IS
  'Дата создания записи' ;
  ALTER TABLE CAR ADD CONSTRAINT CAR_PK PRIMARY KEY ( ID ) ;
  ALTER TABLE CAR ADD CONSTRAINT CAR_UK UNIQUE ( REG_NUM ) ;

CREATE TABLE CITY
  ( ID SERIAL NOT NULL , NAME CHARACTER VARYING (50)
  );
COMMENT ON TABLE CITY
IS
  'Справочник населённых пунктов' ;
  COMMENT ON COLUMN CITY.ID
IS
  'PK' ;
  COMMENT ON COLUMN CITY.NAME
IS
  'Название населённого пункта' ;
  ALTER TABLE CITY ADD CONSTRAINT CITIES_PK PRIMARY KEY ( ID ) ;
  ALTER TABLE CITY ADD CONSTRAINT CITY_UK UNIQUE ( NAME ) ;

CREATE TABLE CUSTOMER
  (
    ID SERIAL NOT NULL ,
    AVG_RATING  INTEGER ,
    SIGN_ACTIVE INTEGER ,
    D_CREATE    TIMESTAMP WITHOUT TIME ZONE
  )
;
COMMENT ON TABLE CUSTOMER
IS
  'Справочник заказчиков' ;
  COMMENT ON COLUMN CUSTOMER.ID
IS
  'PK' ;
  COMMENT ON COLUMN CUSTOMER.AVG_RATING
IS
  'Средняя оценка заказчику' ;
  COMMENT ON COLUMN CUSTOMER.SIGN_ACTIVE
IS
  'Признак активности водителя в системе' ;
  COMMENT ON COLUMN CUSTOMER.D_CREATE
IS
  'Дата создания записи' ;
  ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTOMER_PK PRIMARY KEY ( ID ) ;

CREATE TABLE DRIVER
  (
    ID SERIAL NOT NULL ,
    AVG_RATING  INTEGER ,
    SIGN_ACTIVE INTEGER ,
    D_CREATE    TIMESTAMP WITHOUT TIME ZONE
  )
;
COMMENT ON TABLE DRIVER
IS
  'Справочник водителей' ;
  COMMENT ON COLUMN DRIVER.ID
IS
  'PK' ;
  COMMENT ON COLUMN DRIVER.AVG_RATING
IS
  'Средняя оценка водителю' ;
  COMMENT ON COLUMN DRIVER.SIGN_ACTIVE
IS
  'Признак активности водителя в системе' ;
  COMMENT ON COLUMN DRIVER.D_CREATE
IS
  'Дата создания записи' ;
  ALTER TABLE DRIVER ADD CONSTRAINT DRIVER_PK PRIMARY KEY ( ID ) ;

CREATE TABLE ORDERS
  (
    ID SERIAL NOT NULL ,
    CUSTOMER_ID     INTEGER NOT NULL ,
    AUTOS_ID        INTEGER ,
    PRICE_ID        INTEGER NOT NULL ,
    ORDER_STATUS   INTEGER NOT NULL ,
    ORDER_RESULT    INTEGER NOT NULL ,
    ROUTE_LENGTH    INTEGER ,
    ORDER_PRICE     INTEGER ,
    CUSTOMER_RATING INTEGER ,
    DRIVER_RATING   INTEGER ,
    D_CREATE        TIMESTAMP WITHOUT TIME ZONE NOT NULL
  )
;
COMMENT ON TABLE ORDERS
IS
  'Заказы' ;
  COMMENT ON COLUMN ORDERS.ID
IS
  'PK' ;
  COMMENT ON COLUMN ORDERS.CUSTOMER_ID
IS
  'Заказчик' ;
  COMMENT ON COLUMN ORDERS.AUTOS_ID
IS
  'Исполнитель заказа' ;
  COMMENT ON COLUMN ORDERS.PRICE_ID
IS
  'Цены' ;
  COMMENT ON COLUMN ORDERS.ORDER_STATUS
IS
  'Состояние заказа: новый, принят, прибыл, в пути, закрыт' ;
  COMMENT ON COLUMN ORDERS.ORDER_RESULT
IS
  'Результат: заказ принят, заказ выполнен, заказ отменён' ;
  COMMENT ON COLUMN ORDERS.ROUTE_LENGTH
IS
  'Длина маршрута' ;
  COMMENT ON COLUMN ORDERS.ORDER_PRICE
IS
  'Стоимость заказа' ;
  COMMENT ON COLUMN ORDERS.CUSTOMER_RATING
IS
  'Оценка заказчику' ;
  COMMENT ON COLUMN ORDERS.DRIVER_RATING
IS
  'Оценка водителю' ;
  COMMENT ON COLUMN ORDERS.D_CREATE
IS
  'Дата создания записи' ;
  ALTER TABLE ORDERS ADD CONSTRAINT ORDERS_PK PRIMARY KEY ( ID ) ;

CREATE TABLE ORDERS_TIMETABLE
  (
    ID SERIAL NOT NULL ,
    ORDERS_ID    INTEGER NOT NULL ,
    ORDER_STATUS INTEGER NOT NULL ,
    D_CREATE     TIMESTAMP WITHOUT TIME ZONE
  )
;
COMMENT ON TABLE ORDERS_TIMETABLE
IS
  'График выполнения заказа' ;
  COMMENT ON COLUMN ORDERS_TIMETABLE.ID
IS
  'PK' ;
  COMMENT ON COLUMN ORDERS_TIMETABLE.ORDERS_ID
IS
  'ID заказа' ;
  COMMENT ON COLUMN ORDERS_TIMETABLE.ORDER_STATUS
IS
  'Состояние заказа' ;
  COMMENT ON COLUMN ORDERS_TIMETABLE.D_CREATE
IS
  'Дата проставления состояния' ;
  ALTER TABLE ORDERS_TIMETABLE ADD CONSTRAINT ORADERS_TIMETABLE_PK PRIMARY KEY ( ID ) ;

CREATE TABLE POINT
  (
    ID SERIAL NOT NULL ,
    STREET_ID INTEGER NOT NULL ,
    NAME CHARACTER VARYING (10) ,
    POINT_LAT CHARACTER VARYING (15) ,
    POINT_LNG CHARACTER VARYING (15)
  )
;
COMMENT ON TABLE POINT
IS
  'Справочник пунктов назначений' ;
  COMMENT ON COLUMN POINT.ID
IS
  'PK' ;
  COMMENT ON COLUMN POINT.STREET_ID
IS
  'FK Улица' ;
  COMMENT ON COLUMN POINT.NAME
IS
  'Номер дома/корпуса' ;
  COMMENT ON COLUMN POINT.POINT_LAT
IS
  'Положение на карте: Широта [-90, 90]' ;
  COMMENT ON COLUMN POINT.POINT_LNG
IS
  'Положение на карте: Долгота [-180, 180]' ;
  ALTER TABLE POINT ADD CONSTRAINT POINTS_PK PRIMARY KEY ( ID ) ;
  ALTER TABLE POINT ADD CONSTRAINT POINT_UK UNIQUE ( STREET_ID , NAME ) ;

CREATE TABLE PRICE
  (
    ID SERIAL NOT NULL ,
    CAR_TYPE        INTEGER NOT NULL ,
    COST_BEFORE     INTEGER ,
    COST_KM         INTEGER ,
    COST_FOR_WAITING INTEGER ,
    D_BEGIN         TIMESTAMP WITHOUT TIME ZONE ,
    D_END           TIMESTAMP WITHOUT TIME ZONE ,
    D_CREATE        TIMESTAMP WITHOUT TIME ZONE
  )
;
COMMENT ON TABLE PRICE
IS
  'Цены на услуги' ;
  COMMENT ON COLUMN PRICE.ID
IS
  'PK' ;
  COMMENT ON COLUMN PRICE.CAR_TYPE
IS
  'Тип авто' ;
  COMMENT ON COLUMN PRICE.COST_BEFORE
IS
  'Цена посадки' ;
  COMMENT ON COLUMN PRICE.COST_KM
IS
  'Цена за 1 км' ;
  COMMENT ON COLUMN PRICE.COST_FOR_WAITING
IS
  'Цена ожидания за минуту' ;
  COMMENT ON COLUMN PRICE.D_BEGIN
IS
  'Действует с' ;
  COMMENT ON COLUMN PRICE.D_END
IS
  'Действует по' ;
  COMMENT ON COLUMN PRICE.D_CREATE
IS
  'Дата создания' ;
  ALTER TABLE PRICE ADD CONSTRAINT PRICE_PK PRIMARY KEY ( ID ) ;
  ALTER TABLE PRICE ADD CONSTRAINT PRICE_UNIQ UNIQUE ( CAR_TYPE , D_BEGIN ) ;

CREATE TABLE ROUTE
  (
    ID SERIAL NOT NULL ,
    ORDERS_ID    INTEGER NOT NULL ,
    ROUTE_ORDER  INTEGER ,
    SRC_POINT_ID INTEGER NOT NULL ,
    SRC_DESCR CHARACTER VARYING (100) ,
    DST_POINT_ID INTEGER NOT NULL ,
    EST_LENGTH   INTEGER ,
    FACT_LENGTH  INTEGER ,
    EST_TIME     INTEGER
  )
;
COMMENT ON TABLE ROUTE
IS
  'Маршрут следования' ;
  COMMENT ON COLUMN ROUTE.ID
IS
  'PK' ;
  COMMENT ON COLUMN ROUTE.ORDERS_ID
IS
  'FK на Заказ' ;
  COMMENT ON COLUMN ROUTE.ROUTE_ORDER
IS
  'Порядок следования пунктов' ;
  COMMENT ON COLUMN ROUTE.SRC_POINT_ID
IS
  'Начальный пункт' ;
  COMMENT ON COLUMN ROUTE.SRC_DESCR
IS
  'Примечания для пункта отправления' ;
  COMMENT ON COLUMN ROUTE.DST_POINT_ID
IS
  'Конечный пункт' ;
  COMMENT ON COLUMN ROUTE.EST_LENGTH
IS
  'Планируемая Длина пути' ;
  COMMENT ON COLUMN ROUTE.FACT_LENGTH
IS
  'Фактическая Длина пути' ;
  COMMENT ON COLUMN ROUTE.EST_TIME
IS
  'Планируемое время (минут)' ;
  ALTER TABLE ROUTE ADD CONSTRAINT ROUTES_PK PRIMARY KEY ( ID ) ;

CREATE TABLE STREET
  (
    ID SERIAL NOT NULL ,
    NAME    CHARACTER VARYING (50) ,
    CITY_ID INTEGER NOT NULL
  )
;
COMMENT ON TABLE STREET
IS
  'Справочник улиц' ;
  COMMENT ON COLUMN STREET.ID
IS
  'PK' ;
  COMMENT ON COLUMN STREET.NAME
IS
  'Название улицы' ;
  COMMENT ON COLUMN STREET.CITY_ID
IS
  'FK Населённый пункт' ;
  ALTER TABLE STREET ADD CONSTRAINT STREET_PK PRIMARY KEY ( ID ) ;
  ALTER TABLE STREET ADD CONSTRAINT STREET_UK UNIQUE ( CITY_ID , NAME ) ;

CREATE TABLE USER_ACCOUNT
 	  (
    ID SERIAL NOT NULL ,
    NAME     CHARACTER VARYING (30) NOT NULL ,
    PASSWORD CHARACTER VARYING (128) NOT NULL ,
    EMAIL    CHARACTER VARYING (255) NOT NULL ,
    D_CREATE   TIMESTAMP WITHOUT TIME ZONE
  )
;
COMMENT ON TABLE USER_ACCOUNT
IS
  'Справочник аккаунтов' ;
  COMMENT ON COLUMN USER_ACCOUNT.ID
IS
  'PK' ;
  COMMENT ON COLUMN USER_ACCOUNT.NAME
IS
  'Логин пользователя' ;
  COMMENT ON COLUMN USER_ACCOUNT.PASSWORD
IS
  'Пароль (HASH)' ;
  COMMENT ON COLUMN USER_ACCOUNT.EMAIL
IS
  'Контактный email' ;
  COMMENT ON COLUMN USER_ACCOUNT.D_CREATE
IS
  'Дата создания' ;
  ALTER TABLE USER_ACCOUNT ADD CONSTRAINT USER_ACCOUNT_PK PRIMARY KEY ( ID ) ;
  ALTER TABLE USER_ACCOUNT ADD CONSTRAINT USER_ACCOUNT_UK UNIQUE ( NAME , EMAIL ) ;

CREATE TABLE USER_PROFILE
  (
    ID SERIAL NOT NULL ,
    FIRST_NAME CHARACTER VARYING (30) NOT NULL ,
    LAST_NAME  CHARACTER VARYING (30) ,
    TEL_NUM    CHARACTER VARYING (30) NOT NULL ,
    D_CREATE   TIMESTAMP WITHOUT TIME ZONE
  )
;
COMMENT ON TABLE USER_PROFILE
IS
  'Справочник персон' ;
  COMMENT ON COLUMN USER_PROFILE.ID
IS
  'PK' ;
  COMMENT ON COLUMN USER_PROFILE.FIRST_NAME
IS
  'Имя' ;
  COMMENT ON COLUMN USER_PROFILE.LAST_NAME
IS
  'Фамилия' ;
  COMMENT ON COLUMN USER_PROFILE.TEL_NUM
IS
  'Контактный телефон' ;
  COMMENT ON COLUMN USER_PROFILE.D_CREATE
IS
  'Дата создания записи' ;
  ALTER TABLE USER_PROFILE ADD CONSTRAINT PERSON_PK PRIMARY KEY ( ID ) ;
  ALTER TABLE USER_PROFILE ADD CONSTRAINT USER_PROFILE_UK UNIQUE ( TEL_NUM ) ;

CREATE TABLE USER_ROLE
  (
    ID SERIAL NOT NULL,
    USER_PROFILE_ID INTEGER NOT NULL ,
    APP_ROLE        INTEGER NOT NULL
  )
;
COMMENT ON TABLE USER_ROLE
IS
  'Роли пользователя' ;
  COMMENT ON COLUMN USER_ROLE.ID
IS
  'Аккаунт' ;
  COMMENT ON COLUMN USER_ROLE.USER_PROFILE_ID
IS
  'Пользователь' ;
  COMMENT ON COLUMN USER_ROLE.APP_ROLE
IS
  'Роль' ;
  ALTER TABLE USER_ROLE ADD CONSTRAINT USER_ROLE_PK PRIMARY KEY ( ID ) ;
  ALTER TABLE USER_ROLE ADD CONSTRAINT USER_ROLE_UNIQ UNIQUE ( USER_PROFILE_ID , APP_ROLE ) ;

ALTER TABLE AUTOS ADD CONSTRAINT AUTOS_CAR_FK FOREIGN KEY ( CAR_ID ) REFERENCES CAR ( ID ) ;

ALTER TABLE AUTOS ADD CONSTRAINT AUTOS_DRIVER_FK FOREIGN KEY ( DRIVER_ID ) REFERENCES DRIVER ( ID ) ;

ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTOMER_USER_PROFILE_FK FOREIGN KEY ( ID ) REFERENCES USER_PROFILE ( ID ) ;

ALTER TABLE DRIVER ADD CONSTRAINT DRIVER_USER_PROFILE_FK FOREIGN KEY ( ID ) REFERENCES USER_PROFILE ( ID ) ;

ALTER TABLE ORDERS_TIMETABLE ADD CONSTRAINT ORADERS_TIMETABLE_ORDER_FK FOREIGN KEY ( ORDERS_ID ) REFERENCES ORDERS ( ID ) ;

ALTER TABLE ORDERS ADD CONSTRAINT ORDERS_AUTOS_FK FOREIGN KEY ( AUTOS_ID ) REFERENCES AUTOS ( ID ) ;

ALTER TABLE ORDERS ADD CONSTRAINT ORDERS_CUSTOMER_FK FOREIGN KEY ( CUSTOMER_ID ) REFERENCES CUSTOMER ( ID ) ;

ALTER TABLE ORDERS ADD CONSTRAINT ORDERS_PRICE_FK FOREIGN KEY ( PRICE_ID ) REFERENCES PRICE ( ID ) ;

ALTER TABLE POINT ADD CONSTRAINT POINTS_STREETS_FK FOREIGN KEY ( STREET_ID ) REFERENCES STREET ( ID ) ;

ALTER TABLE ROUTE ADD CONSTRAINT ROUTE_ORDERS_FK FOREIGN KEY ( ORDERS_ID ) REFERENCES ORDERS ( ID ) ;

ALTER TABLE ROUTE ADD CONSTRAINT ROUTE_POINT_DST_FK FOREIGN KEY ( DST_POINT_ID ) REFERENCES POINT ( ID ) ;

ALTER TABLE ROUTE ADD CONSTRAINT ROUTE_POINT_SRC_FK FOREIGN KEY ( SRC_POINT_ID ) REFERENCES POINT ( ID ) ;

ALTER TABLE STREET ADD CONSTRAINT STREET_CITY_FK FOREIGN KEY ( CITY_ID ) REFERENCES CITY ( ID ) ;

ALTER TABLE USER_ACCOUNT ADD CONSTRAINT USER_ACCOUNT_USER_ROLE_FK FOREIGN KEY ( ID ) REFERENCES USER_ROLE ( ID ) ;

ALTER TABLE USER_ROLE ADD CONSTRAINT USER_ROLE_USER_PROFILE_FK FOREIGN KEY ( USER_PROFILE_ID ) REFERENCES USER_PROFILE ( ID ) ;


-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            14
-- ALTER TABLE                             38
