package movie;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import download_board.DownloadBoardBean;

/////////////////////////////////////////////////////////////////////////////////////////////////////////

public class movieDAO {
	
	private movieDAO() {}
	
	private static class singleton {
		private static final movieDAO mdao = new movieDAO();
	}
	
	public static movieDAO getInstance() {
		System.out.println("Create Movie Instance");
		return singleton.mdao;
	}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 공용으로 쓰일 필드 선언 (private)
	
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null; 
	private movieBean mb = null;
		
	// 공용으로 쓰일 필드 선언 (private) 끝

/////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private void connect () { // DB접속
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
	
	public int movie_add(movieBean mb) {
		
		int result = -1; // 기본값 실패시 리턴 -1이면 실패 1이상시 성공
		
		try {
			connect();
			
			String sql = "INSERT INTO movie(movie_title, movie_eng_title, movie_genre, movie_like_count, movie_director, movie_cast, movie_basic, movie_age, movie_explanation, movie_add_date, release_date, close_date, movie_image_name, movie_image_path, movie_image_orgname, theater_no)"
					+ " VALUES(?,?,?,?,?,?,?,?,?,now(),?,?,?,?,?,?)";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, mb.getMovie_title());
			pstmt.setString(2, mb.getMovie_eng_title());
			pstmt.setString(3, mb.getMovie_genre());
			pstmt.setInt(4, mb.getMovie_like_count());
			pstmt.setString(5, mb.getMovie_director());
			pstmt.setString(6, mb.getMovie_cast());
			pstmt.setString(7, mb.getMovie_basic());
			pstmt.setInt(8, mb.getMovie_age());
			pstmt.setString(9, mb.getMovie_explanation());
			pstmt.setDate(10, mb.getRelease_date()); 
			pstmt.setDate(11, mb.getClose_date());
			pstmt.setString(12, mb.getMovie_image_name());
			pstmt.setString(13, mb.getMovie_image_path());
			pstmt.setString(14, mb.getMovie_image_orgname());
			pstmt.setInt(15, mb.getTheater_no());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
			result = 0; // sql오류
		} finally {
			close();
		}
		return result;
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int getMovieCount() { // 글 갯수 조회
		
		int count = 0;
		
		try {
			connect();
			
			String sql = "SELECT count(*) FROM Movie";
			pstmt=con.prepareStatement(sql);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				count=rs.getInt("count(*)");
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return count;
	} // 글 갯수 조회 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public List getMovieList(int startRow,int pageSize) { // 영화 목록 불러오기
		
		List MovieList = new ArrayList();
		
		try {
			connect();
			
			String sql = "SELECT * FROM movie ORDER BY movie_id DESC LIMIT ?,?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, startRow-1);
			pstmt.setInt(2, pageSize);
			rs = pstmt.executeQuery();
			
			while(rs.next()) { // 한개의 행이 존재할시 실행
				
				mb = new movieBean();
				
				mb.setMovie_id(rs.getInt("movie_id")); 
				mb.setMovie_genre(rs.getString("movie_genre"));
				mb.setMovie_title(rs.getString("movie_title"));
				mb.setMovie_eng_title(rs.getString("movie_eng_title"));
				mb.setMovie_like_count(rs.getInt("movie_like_count"));
				mb.setMovie_director(rs.getString("movie_director"));
				mb.setMovie_cast(rs.getString("movie_cast"));
				mb.setMovie_basic(rs.getString("movie_basic"));
				mb.setMovie_age(rs.getInt("movie_age"));
				mb.setMovie_explanation(rs.getString("movie_explanation"));
				mb.setMovie_add_date(rs.getDate("movie_add_date"));
				mb.setRelease_date(rs.getDate("release_date"));
				mb.setClose_date(rs.getDate("close_date"));
				mb.setMovie_image_name(rs.getString("movie_image_name"));
				mb.setMovie_image_path(rs.getString("movie_image_path"));
				mb.setTheater_no(rs.getInt("theater_no"));
				
				MovieList.add(mb); // 배열 한개에 한개의 행 레코드 저장
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return MovieList;
	} // 영화 목록 불러오기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public movieBean getMovieBoard (int movie_id) { // 글 내용 가져오기
		
		try {
			connect();
			
			String sql = "SELECT * FROM movie WHERE movie_id = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, movie_id);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				
				mb = new movieBean();
				
				mb.setMovie_id(rs.getInt("movie_id")); 
				mb.setMovie_genre(rs.getString("movie_genre"));
				mb.setMovie_title(rs.getString("movie_title"));
				mb.setMovie_eng_title(rs.getString("movie_eng_title"));
				mb.setMovie_like_count(rs.getInt("movie_like_count"));
				mb.setMovie_director(rs.getString("movie_director"));
				mb.setMovie_cast(rs.getString("movie_cast"));
				mb.setMovie_basic(rs.getString("movie_basic"));
				mb.setMovie_age(rs.getInt("movie_age"));
				mb.setMovie_explanation(rs.getString("movie_explanation"));
				mb.setMovie_add_date(rs.getDate("movie_add_date"));
				mb.setClose_date(rs.getDate("close_date"));
				mb.setRelease_date(rs.getDate("release_date"));
				mb.setMovie_image_name(rs.getString("movie_image_name"));
				mb.setMovie_image_path(rs.getString("movie_image_path"));
				mb.setTheater_no(rs.getInt("theater_no"));
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return mb;
	}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
		
	public List getOnScreenList(java.util.Date todayDate) { // 자료실 글 목록 불러오기
		
		List OnScreenList = new ArrayList();
		
		try {
			connect();
			
			String sql = "SELECT * FROM movie ORDER BY movie_id DESC";
			
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) { // 한개의 행이 존재할시 실행
				
				mb = new movieBean();
				
				mb.setMovie_id(rs.getInt("movie_id")); 
				mb.setMovie_genre(rs.getString("movie_genre"));
				mb.setMovie_title(rs.getString("movie_title"));
				mb.setMovie_eng_title(rs.getString("movie_eng_title"));
				mb.setMovie_like_count(rs.getInt("movie_like_count"));
				mb.setMovie_director(rs.getString("movie_director"));
				mb.setMovie_cast(rs.getString("movie_cast"));
				mb.setMovie_basic(rs.getString("movie_basic"));
				mb.setMovie_age(rs.getInt("movie_age"));
				mb.setMovie_explanation(rs.getString("movie_explanation"));
				mb.setMovie_add_date(rs.getDate("movie_add_date"));
				mb.setRelease_date(rs.getDate("release_date"));
				mb.setClose_date(rs.getDate("close_date"));
				mb.setMovie_image_name(rs.getString("movie_image_name"));
				mb.setMovie_image_path(rs.getString("movie_image_path"));
				mb.setTheater_no(rs.getInt("theater_no"));
				
				OnScreenList.add(mb); // 배열 한개에 한개의 행 레코드 저장
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return OnScreenList;
	} // 자료실 글목록 불러오기 끝
}
