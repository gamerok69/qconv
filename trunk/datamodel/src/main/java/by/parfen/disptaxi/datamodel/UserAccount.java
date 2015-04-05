package by.parfen.disptaxi.datamodel;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import by.parfen.disptaxi.util.Password;

@Entity
public class UserAccount {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Column
	private String name;
	@Column
	private String password;
	@Column
	private String email;
	@Column
	private Date dCreate;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassw() {
		return password;
	}

	public void setPassw(String password) {
		Password pasw = new Password();
		this.password = pasw.getHash(password);
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getdCreate() {
		return dCreate;
	}

	public void setdCreate(Date dCreate) {
		this.dCreate = dCreate;
	}

	@Override
	public String toString() {
		return "UserAccount [id=" + id + ", name=" + name + ", password=" + password + ", email=" + email + ", dCreate="
				+ dCreate + "]";
	}

}
