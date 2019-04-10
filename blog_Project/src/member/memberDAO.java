package member;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class memberDAO {
	
	private memberDAO() {}
	private static class singleton {
		private static final memberDAO mdao = new memberDAO();
	}
	
	public static memberDAO getInstance() {
		System.out.println("Create Member Instance");
		return singleton.mdao;
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 공용으로 쓰일 필드 선언 (private)
	
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null; 
	
	// 공용으로 쓰일 필드 선언 (private) 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private void connect () { // DB접속 메서드 (private)
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			
			String dbUrl="jdbc:mysql://localhost:3306/blog";
			String dbUser="root";
			String dbPass="1234";
			con = DriverManager.getConnection(dbUrl,dbUser,dbPass);
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	} // DB접속 메서드 (private) 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private void close() { // 접속해제 메서드
		
			if(rs!=null) try {rs.close();}catch(SQLException ex) {}
			if(pstmt!=null) try {pstmt.close();}catch(SQLException ex) {}
			if(con!=null) try {con.close();}catch(SQLException ex) {}
		
	} // 접속해제 메서드 끝

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int insert(memberBean mb) { // 회원 가입 메서드
		
		int result = -1;
		
		int check = idCheck(mb);
		
		if (check == -1) {

			connect();
		
			try {
			
				String sql = "INSERT INTO member(id,pass,name,birth,gender,email,phone,reg_date,postNo,address,addressDe,addressRef) VALUES(?,?,?,?,?,?,?,now(),?,?,?,?)";
			
				pstmt = con.prepareStatement(sql);
			
				pstmt.setString(1, mb.getId());
				pstmt.setString(2, mb.getPass());
				pstmt.setString(3, mb.getName());
				pstmt.setString(4, mb.getBirth());
				pstmt.setString(5, mb.getGender());
				pstmt.setString(6, mb.getEmail());
				pstmt.setString(7, mb.getPhone());
				pstmt.setInt(8, mb.getPostNo());
				pstmt.setString(9, mb.getAddress());
				pstmt.setString(10, mb.getAddressDe());
				pstmt.setString(11, mb.getAddressRef());
			
				result = pstmt.executeUpdate();
			
			} catch (Exception e) {
				System.out.println("SQL 구문 오류! (" + e.getMessage() + ")");
			} finally {
				close();
			}
			return result;
		}
		return result;
	} // 회원 가입 메서드 끝

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	protected int idCheck(memberBean mb) { // 회원가입시 아이디 중복 체크 메서드
		
		int check = 0;
		
		connect();
		
		try {
			String sql = "SELECT * FROM member where id = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, mb.getId());
			
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				if (mb.getId().equals(rs.getString("id"))) { 
					
					check = 1;         
					return check;
							
				} 
			}

			check = -1;                 
			return check;
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();			
		}
		return check;
	} // 회원가입시 아이디 중복 체크 메서드 끝

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int login(String id, String pass) { // 로그인 메서드
		
		int result = -1;
		
		connect();
		
		try {
			String sql = "SELECT * FROM member where id = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, id);
			
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				
				if (pass.equals(rs.getString("pass"))) { // 입력한 비밀번호 값과 컬럼 pass에 있는 비밀번호 값 비교
					result = 1;
					return result;
							
				} else { //비밀번호 틀리면 "비밀번호틀림" 
					result = 0;
					return result;
				}
			} else {
				return result;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();			
		}
		return result;
	} // 로그인 메서드 끝

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public memberBean memberInfo(String id) { // 회원 정보 조회 메서드
		
		memberBean mb = new memberBean();
		
		try {
			
			connect();
			
			String sql = "select * from member where id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				
				mb.setIdx(rs.getInt("idx"));
				mb.setId(rs.getString("id"));
				mb.setName(rs.getString("name"));
				mb.setBirth(rs.getString("birth"));
				mb.setGender(rs.getString("gender"));
				mb.setEmail(rs.getString("email"));
				mb.setPhone(rs.getString("phone"));
				mb.setPostNo(rs.getInt("postNo"));
				mb.setAddress(rs.getString("address"));
				mb.setAddressDe(rs.getString("addressDe"));
				mb.setAddressRef(rs.getString("addressRef"));
				mb.setReg_date(rs.getTimestamp("Reg_date"));
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}

		return mb;
		
	} // 회원 정보 조회 메서드 끝

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int userCheck(String id, String pass) { // 아이디 검사 및 비밀번호 검사
		
		int check = -1;

		try {
			connect();
			
			String sql = "SELECT * FROM member WHERE id = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			
			rs = pstmt.executeQuery();

			if (rs.next()) { // 아이디 검사
				if (pass.equals(rs.getString("pass"))) { // 비밀번호 검사 맞으면 1 반환
					check = 1;
					return check;
				} else { // 비밀번호 틀릴 시 0 반환
					check = 0;
					return check;
				}
			} else { // 아이디 없을 시 -1 반환
				check = -1;
				return check;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return check; 
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int update (memberBean mb) { // 회원 정보 수정 메서드
		
		int result = 0;
		
		connect();
		
		try {
			if (mb.getPass().length() == 0 || mb.getPass() == null || mb.getPass().equals("")) { // 비밀번호 <미변경> 시 실행할 SQL구문
				String sql = "UPDATE member SET name = ?, birth = ?, gender = ?, email = ?, phone = ?, postNo = ?, address = ?, addressDe = ?, addressRef = ? WHERE id = ?";
			
				pstmt = con.prepareStatement(sql);
			
				pstmt.setString(1, mb.getName());
				pstmt.setString(2, mb.getBirth());
				pstmt.setString(3, mb.getGender());
				pstmt.setString(4, mb.getEmail());
				pstmt.setString(5, mb.getPhone());
				pstmt.setInt(6, mb.getPostNo());
				pstmt.setString(7, mb.getAddress());
				pstmt.setString(8, mb.getAddressDe());
				pstmt.setString(9, mb.getAddressRef());
				pstmt.setString(10, mb.getId());
		
				result = pstmt.executeUpdate();
			
				
			} else { // 비밀번호도 <변경> 시 실행할 SQL구문
				String sql = "UPDATE member SET pass = ?, name = ?, birth = ?, gender = ?, email = ?, phone = ?, postNo = ?, address = ?, addressDe = ?, addressRef = ? WHERE id = ?";
				
				pstmt = con.prepareStatement(sql);
			
				pstmt.setString(1, mb.getPass());
				pstmt.setString(2, mb.getName());
				pstmt.setString(3, mb.getBirth());
				pstmt.setString(4, mb.getGender());
				pstmt.setString(5, mb.getEmail());
				pstmt.setString(6, mb.getPhone());
				pstmt.setInt(7, mb.getPostNo());
				pstmt.setString(8, mb.getAddress());
				pstmt.setString(9, mb.getAddressDe());
				pstmt.setString(10, mb.getAddressRef());
				pstmt.setString(11, mb.getId());
		
				result = pstmt.executeUpdate();
			
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		
		return result;
	
	} // 회원 정보 수정 메서드 끝

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int delete(String id, String pass) {
		int result = 0;
		
		System.out.println("아이디 : " + id + ", 패스워드 : " + pass);
		try {
			connect();
			
			String sql = "DELETE FROM member WHERE id = ? AND pass = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, id);
			pstmt.setString(2, pass);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
}
		


	