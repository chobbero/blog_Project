package member;

import java.sql.Timestamp;

public class memberBean {
	
	private int idx;
	private String id;
	private String pass;
	private String name;
	private String birth;
	private String gender;
	private String email;
	private Timestamp reg_date;
	private int postNo;
	private String Address;
	private String AddressDe;
	private String AddressRef;
	private String phone;
	
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getBirth() {
		return birth;
	}
	public void setBirth(String birth) {
		this.birth = birth;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Timestamp getReg_date() {
		return reg_date;
	}
	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}
	public int getPostNo() {
		return postNo;
	}
	public void setPostNo(int postNo) {
		this.postNo = postNo;
	}
	public String getAddress() {
		return Address;
	}
	public void setAddress(String address) {
		Address = address;
	}
	public String getAddressDe() {
		return AddressDe;
	}
	public void setAddressDe(String addressDe) {
		AddressDe = addressDe;
	}
	public String getAddressRef() {
		return AddressRef;
	}
	public void setAddressRef(String addressRef) {
		AddressRef = addressRef;
	}
}
