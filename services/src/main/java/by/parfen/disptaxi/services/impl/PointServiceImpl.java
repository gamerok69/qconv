package by.parfen.disptaxi.services.impl;

import java.util.List;

import javax.annotation.PostConstruct;
import javax.inject.Inject;

import org.apache.commons.lang3.Validate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import by.parfen.disptaxi.dataaccess.PointDao;
import by.parfen.disptaxi.datamodel.Point;
import by.parfen.disptaxi.datamodel.Street;
import by.parfen.disptaxi.services.PointService;

@Service
public class PointServiceImpl implements PointService {
	private static final Logger LOGGER = LoggerFactory.getLogger(PointServiceImpl.class);

	@Inject
	private PointDao dao;

	@PostConstruct
	private void init() {
		// this method will be called by Spring after bean instantiation. Can be
		// used for any initialization process.
		LOGGER.info("Instance of PointService is created. Class is: {}", getClass().getName());
	}

	@Override
	public Point get(Long id) {
		Point entity = dao.getById(id);
		return entity;
	}

	@Override
	public void create(Point point, Street street) {
		Validate.notNull(point, "Point object is null!");
		Validate.notNull(point.getName(), "Points name is null!");
		Validate.isTrue(point.getId() == null, "Use update for existing point!");
		if (street != null) {
			LOGGER.debug("Set street for the point: {}", point);
			point.setStreet(street);
		}
		LOGGER.debug("Save new: {}", point);
		dao.insert(point);
	}

	@Override
	public void update(Point point) {
		LOGGER.debug("Update: {}", point);
		dao.update(point);
	}

	@Override
	public void delete(Point point) {
		LOGGER.debug("Update: {}", point);
		dao.delete(point.getId());
	}

	@Override
	public void deleteAll() {
		LOGGER.debug("Remove all points");
		dao.deleteAll();
	}

	@Override
	public Long getCount() {
		return dao.getCount();
	}

	@Override
	public List<Point> getAll() {
		return dao.getAll();
	}

	@Override
	public List<Point> getAllByName(String name) {
		return dao.getAllByName(name);
	}

	@Override
	public List<Point> getAllByStreet(Street street) {
		return dao.getAllByStreet(street);
	}

	@Override
	public List<Point> getAllByStreetAndName(Street street, String name) {
		return dao.getAllByStreetAndName(street, name);
	}

}
