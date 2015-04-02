package by.parfen.disptaxi.services;

import org.springframework.transaction.annotation.Transactional;

import by.parfen.disptaxi.datamodel.AppRole;

public interface AppRoleService {

	AppRole get(Long id);

	@Transactional
	void saveOrUpdate(AppRole product);

	@Transactional
	void delete(AppRole product);

	@Transactional
	void deleteAll();
}
