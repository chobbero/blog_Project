package download_board;

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


public class DownloadCommentDAO {
	
	private DownloadCommentDAO() {}
	
	private static class singleton {
		private static final DownloadCommentDAO dcdao = new DownloadCommentDAO();
	}
	
	public static DownloadCommentDAO getInstance() {
		System.out.println("Create DownloadComment Instance");
		return singleton.dcdao;
	}
	
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 공용으로 쓰일 필드 선언 (private)
	
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null; 
	private DownloadCommentBean dcb = null;
		
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
	
	public int insert(DownloadCommentBean dcb) { // 댓글쓰기
		
		int result = 0;

		try {
			connect();
			
			String sql = "INSERT INTO DownloadComment(id,contents,wTime,pDownBoardIdx) VALUES(?,?,now(),?)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, dcb.getId());
			pstmt.setString(2, dcb.getContents());
			pstmt.setInt(3, dcb.getpDownBoardIdx());
			
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
	
	public int DownloadCommentCount(int idx) { // 해당 글 댓글 갯수 조회
		
		int count = 0;
		
		try {
			connect();
			
			String sql="SELECT count(*) FROM DownloadComment WHERE pDownBoardIdx = ?";
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
	
	public List DownloadCommentList(int idx) { // 댓글 불러오기
		
		List DownloadCommentList = new ArrayList();
		
		try {
			connect();
			
			String sql = "SELECT * FROM DownloadComment WHERE pDownBoardIdx = ? ORDER BY idx DESC";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, idx);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) { // 한개의 행이 존재할시 실행
				
				dcb = new DownloadCommentBean();
				
				dcb.setIdx(rs.getInt("idx")); 
				dcb.setId(rs.getString("id"));
				dcb.setContents(rs.getString("contents"));
				dcb.setwTime(rs.getDate("wTime"));
				
				DownloadCommentList.add(dcb); // 배열 한개에 한개의 행 레코드 저장
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return DownloadCommentList;
	} // 댓글 불러오기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////

	public int delete(DownloadCommentBean dcb) {
		
		int result = -1;
		
		int check = 0;
		
		check = idCheck(dcb);
		
		if (check == 1) {
			try {
				connect();
			
				String sql = "DELETE FROM DownloadComment WHERE idx = ? AND id = ?";
			
				pstmt = con.prepareStatement(sql); 
			
				pstmt.setInt(1, dcb.getIdx());
				pstmt.setString(2, dcb.getId());
			
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
	
	private int idCheck (DownloadCommentBean dcb) { // 글쓴이와 id 비교
		
		int check = -1;

		System.out.println(check);
		try {
			connect();
			
			String sql = "SELECT * FROM DownloadComment WHERE idx = ? AND id = ? AND pDownBoardIdx = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, dcb.getIdx());
			pstmt.setString(2, dcb.getId());
			pstmt.setInt(3, dcb.getpDownBoardIdx());

			rs = pstmt.executeQuery();

			if (rs.next()) {
				check = 1;
				System.out.println(check);
				return check;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return check;
	} // 글쓴이와 id 비교 끝

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int boardCommentdelete(int idx) { // 원글 삭제시 원글에 달린 댓글도 삭제
		
		int result = -1;
		
		try {
			connect();
			
			String sql = "DELETE FROM DownloadComment WHERE pDownBoardIdx = ?";
			
			pstmt = con.prepareStatement(sql); 
			
			pstmt.setInt(1, idx);
			
			result = pstmt.executeUpdate();
				
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}	// 원글 삭제시 원글에 달린 댓글도 삭제 끝

/////////////////////////////////////////////////////////////////////////////////////////////////////////
}
