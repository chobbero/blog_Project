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


public class boardDAO {
	
	private boardDAO() {}
	
	private static class singleton {
		private static final boardDAO bdao = new boardDAO();
	}
	
	public static boardDAO getInstance() {
		System.out.println("Create Board Instance");
		return singleton.bdao;
	}
	


/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 공용으로 쓰일 필드 선언 (private)
	
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null; 
	private boardBean bb = null;
		
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
	
	public int insert(boardBean bb) { // 글쓰기
		
		int result = 0;

		try {
			connect();
			
			String sql = "INSERT INTO board(id,pass,title,contents,viewCount,wTime) VALUES(?,?,?,?,?,now())";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bb.getId());
			pstmt.setString(2, bb.getPass());
			pstmt.setString(3, bb.getTitle());
			pstmt.setString(4, bb.getContents());
			pstmt.setInt(5, bb.getViewCount());
			
			result = pstmt.executeUpdate();
			
			return result;
		} catch (Exception e) {
			System.out.println("SQL 구문 오류! (" + e.getMessage() + ")");
			result = 0;
		} finally {
			close();
		}
		return result = -1;
	} // 글쓰기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int getBoardCount() { // 전체 글 갯수 조회
		
		int count = 0;
		
		try {
			connect();
			
			String sql="select count(*) from board";
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
	} // 전체 글 갯수 조회 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public List getBoardList(int startRow,int pageSize) { // 글 목록 불러오기
		
		List boardList = new ArrayList();
		
		try {
			connect();
			
			String sql="SELECT * FROM board ORDER BY idx desc limit ?,?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, startRow-1);
			pstmt.setInt(2, pageSize);
			rs = pstmt.executeQuery();
			
			while(rs.next()) { // 한개의 행이 존재할시 실행
				
				bb = new boardBean();
				
				bb.setIdx(rs.getInt("idx")); 
				bb.setId(rs.getString("id"));
				bb.setPass(rs.getString("pass"));
				bb.setTitle(rs.getString("title"));
				bb.setContents(rs.getString("contents"));
				bb.setwTime(rs.getDate("wTime"));
				bb.setViewCount(rs.getInt("viewCount"));
				
				boardList.add(bb); // 배열 한개에 한개의 행 레코드 저장
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return boardList;
	} // 글목록 불러오기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public void updateView(int idx) { // 조회수증가
		
		try {
			connect();
			
			String sql = "UPDATE board SET viewCount = viewCount + 1 WHERE idx = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, idx);
			pstmt.executeUpdate();	
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
	} // 조회수증가 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public boardBean getBoard (int idx) { // 글 내용 가져오기
		
		try {
			connect();
			
			String sql = "SELECT * FROM board WHERE idx = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, idx);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				
				bb = new boardBean();
				
				bb.setIdx(rs.getInt("idx"));
				bb.setId(rs.getString("id"));
				bb.setPass(rs.getString("pass"));
				bb.setTitle(rs.getString("title"));
				bb.setContents(rs.getString("contents"));
				bb.setViewCount(rs.getInt("viewCount"));
				bb.setwTime(rs.getDate("wTime"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return bb;
	}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	public int getSearchBoardCount(String search) { // 검색 글 갯수 조회
		
		int count = 0;
		
		try {
			connect();
			
			String sql = "SELECT count(*) FROM board WHERE title LIKE ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%" + search + "%");
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
	} // 검색 글 갯수 조회 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public List getSearchBoardList(int startRow,int pageSize,String search) { // 글 목록 불러오기

		List boardList = new ArrayList();

		try {
			connect();

			String sql = "SELECT * FROM board WHERE title LIKE ? ORDER BY idx desc limit ?,?";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%" + search + "%");
			pstmt.setInt(2, startRow-1);
			pstmt.setInt(3, pageSize);
			rs=pstmt.executeQuery();

			while(rs.next()) { // 한개의 행이 존재할시 실행

				bb = new boardBean();

				bb.setIdx(rs.getInt("idx")); 
				bb.setId(rs.getString("id"));
				bb.setPass(rs.getString("pass"));
				bb.setTitle(rs.getString("title"));
				bb.setContents(rs.getString("contents"));
				bb.setwTime(rs.getDate("wTime"));
				bb.setViewCount(rs.getInt("viewCount"));

				boardList.add(bb); // 배열 한개에 한개의 행 레코드 저장
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return boardList;
	} // 글목록 불러오기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public List searchBoard (String search) { // 글제목 검색
		
		List boardList = new ArrayList();
		
		try {
			connect();
			
			String sql = "SELECT * FROM ORDER BY idx WHERE title like ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%" + search + "%");
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				
				bb = new boardBean();
				
				bb.setIdx(rs.getInt("idx")); 
				bb.setId(rs.getString("id"));
				bb.setPass(rs.getString("pass"));
				bb.setTitle(rs.getString("title"));
				bb.setContents(rs.getString("contents"));
				bb.setViewCount(rs.getInt("viewCount"));
				bb.setwTime(rs.getDate("wTime"));
				
				boardList.add(bb);
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return boardList;
	} // 글제목 검색 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int delete(int idx, String id, String pass) {
		int result = 0;
		
		try {
			connect();
			
			String sql = "DELETE FROM board WHERE idx = ? AND id = ? AND pass = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, idx);
			pstmt.setString(2, id);
			pstmt.setString(3, pass);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int update(boardBean bb) { // 글쓰기
		
		int result = -1;

		try {
			connect();
			
			String sql = "UPDATE board SET title = ?, contents = ?, wTime = now() WHERE idx = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bb.getTitle());
			pstmt.setString(2, bb.getContents());
			pstmt.setInt(3, bb.getIdx());
			
			result = pstmt.executeUpdate();
			
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			result = 0;
		} finally {
			close();
		}
		return result;
	} // 글쓰기 끝
}
