package board;

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


public class commentDAO {
	
	private commentDAO() {}
	
	private static class singleton {
		private static final commentDAO cdao = new commentDAO();
	}
	
	public static commentDAO getInstance() {
		System.out.println("Create Comment Instance");
		return singleton.cdao;
	}
	
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 공용으로 쓰일 필드 선언 (private)
	
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null; 
	private commentBean cb = null;
		
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
	
	public int insert(commentBean cb) { // 댓글쓰기
		
		int result = 0;

		try {
			connect();
			
			String sql = "INSERT INTO comment(id,contents,wTime,pBoardIdx) VALUES(?,?,now(),?)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, cb.getId());
			pstmt.setString(2, cb.getContents());
			pstmt.setInt(3, cb.getpBoardIdx());
			
			result = pstmt.executeUpdate();
			
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	} // 댓글쓰기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int CommentCount(int idx) { // 해당 글 댓글 갯수 조회
		
		int count = 0;
		
		try {
			connect();
			
			String sql="SELECT count(*) FROM comment WHERE pBoardIdx = ?";
			pstmt=con.prepareStatement(sql);
			pstmt.setInt(1, idx);
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
	
	public List commentList(int idx) { // 댓글 불러오기
		
		List commentList = new ArrayList();
		
		try {
			connect();
			
			String sql = "SELECT * FROM comment WHERE pBoardIdx = ? ORDER BY idx DESC";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, idx);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) { // 한개의 행이 존재할시 실행
				
				cb = new commentBean();
				
				cb.setIdx(rs.getInt("idx")); 
				cb.setId(rs.getString("id"));
				cb.setContents(rs.getString("contents"));
				cb.setwTime(rs.getDate("wTime"));
				
				commentList.add(cb); // 배열 한개에 한개의 행 레코드 저장
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return commentList;
	} // 댓글 불러오기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////

	public int delete(commentBean cb) {
		
		int result = -1;
		
		int check = 0;
		
		check = idCheck(cb);
		
		if (check == 1) {
			try {
				connect();
			
				String sql = "DELETE FROM comment WHERE idx = ? AND id = ? AND pBoardIdx = ?";
			
				pstmt = con.prepareStatement(sql);
			
				pstmt.setInt(1, cb.getIdx());
				pstmt.setString(2, cb.getId());
				pstmt.setInt(3, cb.getpBoardIdx());
			
				result = pstmt.executeUpdate();
			
				return result;
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				close();
			}
			return result;
		}
		return result;
	}	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private int idCheck (commentBean cb) { // 글쓴이와 id 비교
		
		int check = -1;
		
		try {
			connect();
			
			String sql = "SELECT * FROM comment WHERE idx = ? AND id = ? AND pBoardIdx = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, cb.getIdx());
			pstmt.setString(2, cb.getId());
			pstmt.setInt(3, cb.getpBoardIdx());

			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				check = 1;
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
	
}
