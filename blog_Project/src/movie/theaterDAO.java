package movie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;


public class theaterDAO {
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////

	private theaterDAO() {}
	
	private static class singleton {
		private static final theaterDAO tdao = new theaterDAO();
	}
	
	public static theaterDAO getInstance() {
		System.out.println("Create theater Instance");
		return singleton.tdao;
	}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 공용으로 쓰일 필드 선언 (private)
	
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null; 
	private movieBean mb = null;
	
	// 공용으로 쓰일 필드 선언 (private) 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private void connect() { // DB접속
		try {
		
		Context init = new InitialContext();
		DataSource ds = (DataSource) init.lookup("java:comp/env/jdbc/blog");
		con = ds.getConnection();
		
		} catch (NamingException e) {
		e.printStackTrace();
		} catch (SQLException e) {
		e.printStackTrace();
		}
	} // DB접속 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private void close() { // 접속해제
	
		if(rs!=null) try {rs.close();}catch(SQLException ex) {}
		if(pstmt!=null) try {pstmt.close();}catch(SQLException ex) {}
		if(con!=null) try {con.close();}catch(SQLException ex) {}
	
	} // 접속해제 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
}
