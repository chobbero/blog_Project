package movie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import member.memberBean;
import member.memberDAO;


public class movie_reservationDAO {
/////////////////////////////////////////////////////////////////////////////////////////////////////////

private movie_reservationDAO() {}

	private static class singleton {
		private static final movie_reservationDAO mrdao = new movie_reservationDAO();
	}

	public static movie_reservationDAO getInstance() {
		System.out.println("Create movie_reservation Instance");
		return singleton.mrdao;
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

	// 공용으로 쓰일 필드 선언 (private)

	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null; 
	private movie_reservationBean mrb = null;

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
	
	public int add_reservation(movie_reservationBean mrb) {
		
		int result=0;
		
		try {
			connect();
			
			String sql = "INSERT INTO reservation(member_idx, movie_id, theater_no, seat_no, time) VALUES(?,?,?,?,?)";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, mrb.getMember_idx());
			pstmt.setInt(2, mrb.getMovie_id());
			pstmt.setInt(3,mrb.getTheater_no());
			pstmt.setString(4, mrb.getSeat_no());
			pstmt.setString(5, mrb.getMovie_time());
			
			result = pstmt.executeUpdate();
			
			if(result > 0) {
				sql = "SELECT reservation_no FROM reservation WHERE member_idx = ? AND movie_id = ? AND theater_no = ? AND seat_no = ? AND time = ?";
				
				pstmt = con.prepareStatement(sql);
				
				pstmt.setInt(1, mrb.getMember_idx());
				pstmt.setInt(2, mrb.getMovie_id());
				pstmt.setInt(3,mrb.getTheater_no());
				pstmt.setString(4, mrb.getSeat_no());
				pstmt.setString(5, mrb.getMovie_time());
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					return rs.getInt("reservation_no");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result; 
	}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public movie_reservationBean rewind (int member_id, int reservation_no) {
		
		mrb = new movie_reservationBean();
		
		try {
			connect();
			
			String sql = "SELECT * FROM reservation WHERE member_idx = ? AND reservation_no = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, member_id);
			pstmt.setInt(2, reservation_no);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				mrb.setReservation_no(rs.getInt("reservation_no"));
				mrb.setMovie_id(rs.getInt("movie_id"));
				mrb.setTheater_no(rs.getInt("theater_no"));
				mrb.setSeat_no(rs.getString("seat_no"));
				mrb.setMovie_time(rs.getString("time"));
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return mrb;
	}
}
