package movie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;


public class movie_commentDAO {
	
	private movie_commentDAO() {}
	
	private static class singleton {
		private static final movie_commentDAO mcdao = new movie_commentDAO();
	}
	
	public static movie_commentDAO getInstance() {
		System.out.println("Create movie_Comment Instance");
		return singleton.mcdao;
	}
	
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 공용으로 쓰일 필드 선언 (private)
	
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null; 
	private movie_commentBean mcb = null;
		
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
	
	public int CommentCount(int movie_id) { // 해당 글 댓글 갯수 조회
		
		int count = 0;
		
		try {
			connect();
			
			String sql="SELECT count(*) FROM movie_comment WHERE movie_id = ?";
			
			pstmt=con.prepareStatement(sql);
			pstmt.setInt(1, movie_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				count = rs.getInt("count(*)");
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return count;
	} // 해당 글 댓글 갯수 조회 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int insert(movie_commentBean mcb) { // 댓글쓰기
		
		int result = 0;

		try {
			
			connect();
			
			String sql = "INSERT INTO movie_comment(id,content,date,movie_id) VALUES(?,?,now(),?)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, mcb.getId());
			pstmt.setString(2, mcb.getContent());
			pstmt.setInt(3, mcb.getMovie_id());
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	} // 댓글쓰기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public List getMovie_comments(int movie_id) { // 댓글 불러오기
		
		List Movie_comments = new ArrayList();
		
		try {
			connect();
			
			String sql = "SELECT * FROM movie_comment WHERE movie_id = ? ORDER BY idx DESC";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, movie_id);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				mcb = new movie_commentBean();
				
				mcb.setIdx(rs.getInt("idx")); 
				mcb.setId(rs.getString("id"));
				mcb.setContent(rs.getString("content"));
				mcb.setDate(rs.getDate("date"));
				mcb.setMovie_id(rs.getInt("movie_id"));
				
				Movie_comments.add(mcb);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return Movie_comments;
	} // 댓글 불러오기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////

	public int delete(movie_commentBean mcb) { // 댓글 삭제
		
		int result = -1;
		
		int check = -1;
		
		check = idCheck(mcb);
		
		if (check == 1) {
			
			try {
				connect();
			
				String sql = "DELETE FROM movie_comment WHERE idx = ? AND id = ? AND movie_id = ?";
		
				pstmt = con.prepareStatement(sql);			
				pstmt.setInt(1, mcb.getIdx());
				pstmt.setString(2, mcb.getId());
				pstmt.setInt(3, mcb.getMovie_id());
			
				result = pstmt.executeUpdate();
			
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				close();
			}
			return result;
			
		} else if (check == -1) {
			return result = -1;
		} else {
			return result = 0;
		}
	} // 댓글 삭제 끝
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private int idCheck (movie_commentBean mcb) { // 글쓴이와 id 비교
		
		int check = 0;
		
		try {
			connect();
			
			String sql = "SELECT * FROM movie_comment WHERE idx = ? AND id = ? AND movie_id = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, mcb.getIdx());
			pstmt.setString(2, mcb.getId());
			pstmt.setInt(3, mcb.getMovie_id());

			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				return check = 1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return check;
		} finally {
			close();
		}
		return check;
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
}
