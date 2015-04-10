package by.parfen.disptaxi.services;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import by.parfen.disptaxi.datamodel.CarsType;

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

	Long getCount();

	List<CarsType> getAll();
}