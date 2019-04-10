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


public class DownloadBoardDAO {
	
	private DownloadBoardDAO() {}
	
	private static class singleton {
		private static final DownloadBoardDAO dbdao = new DownloadBoardDAO();
	}
	
	public static DownloadBoardDAO getInstance() {
		System.out.println("Create DownloadBoard Instance");
		return singleton.dbdao;
	}
	


/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 공용으로 쓰일 필드 선언 (private)
	
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null; 
	private DownloadBoardBean dbb = null;
		
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
	
	public int insert(DownloadBoardBean dbb) { // 글쓰기
		
		int result = 0;

		try {
			connect();
			
			String sql = "INSERT INTO DownloadBoard(id,pass,title,contents,viewCount,wTime,originalFileName,fileName,downloadCount) VALUES(?,?,?,?,?,now(),?,?,?)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, dbb.getId());
			pstmt.setString(2, dbb.getPass());
			pstmt.setString(3, dbb.getTitle());
			pstmt.setString(4, dbb.getContents());
			pstmt.setInt(5, dbb.getViewCount());
			pstmt.setString(6, dbb.getOriginalFileName());
			pstmt.setString(7, dbb.getFileName());
			pstmt.setInt(8, dbb.getDownloadCount());
			
			result = pstmt.executeUpdate();
			
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			result = 0;
		} finally {
			close();
		}
		return result = -1;
	} // 글쓰기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int getDownloadBoardCount() { // 전체 자료실 글 갯수 조회
		
		int count = 0;
		
		try {
			connect();
			
			String sql = "SELECT count(*) FROM DownloadBoard";
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
	} // 전체 자료실 글 갯수 조회 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public List getDownloadBoardList(int startRow,int pageSize) { // 자료실 글 목록 불러오기
		
		List DownloadBoardList = new ArrayList();
		
		try {
			connect();
			
			String sql = "SELECT * FROM DownloadBoard ORDER BY idx desc limit ?,?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, startRow-1);
			pstmt.setInt(2, pageSize);
			rs = pstmt.executeQuery();
			
			while(rs.next()) { // 한개의 행이 존재할시 실행
				
				dbb = new DownloadBoardBean();
				
				dbb.setIdx(rs.getInt("idx")); 
				dbb.setId(rs.getString("id"));
				dbb.setPass(rs.getString("pass"));
				dbb.setTitle(rs.getString("title"));
				dbb.setContents(rs.getString("contents"));
				dbb.setwTime(rs.getDate("wTime"));
				dbb.setViewCount(rs.getInt("viewCount"));
				dbb.setOriginalFileName(rs.getString("originalFileName"));
				dbb.setFileName(rs.getString("fileName"));
				dbb.setDownloadCount(rs.getInt("downloadCount"));
				
				DownloadBoardList.add(dbb); // 배열 한개에 한개의 행 레코드 저장
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return DownloadBoardList;
	} // 자료실 글목록 불러오기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public void updateDownloadView(int idx) { // 자료실 글 조회수 증가
		
		try {
			connect();
			
			String sql = "UPDATE DownloadBoard SET viewCount = viewCount + 1 WHERE idx = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, idx);
			pstmt.executeUpdate();	
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
	} // 자료실 글 조회수 증가 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public DownloadBoardBean getDownloadBoard (int idx) { // 글 내용 가져오기
		
		try {
			connect();
			
			String sql = "SELECT * FROM DownloadBoard WHERE idx = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, idx);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				
				dbb = new DownloadBoardBean();
				
				dbb.setIdx(rs.getInt("idx"));
				dbb.setId(rs.getString("id"));
				dbb.setPass(rs.getString("pass"));
				dbb.setTitle(rs.getString("title"));
				dbb.setContents(rs.getString("contents"));
				dbb.setViewCount(rs.getInt("viewCount"));
				dbb.setwTime(rs.getDate("wTime"));
				dbb.setOriginalFileName(rs.getString("originalFileName"));
				dbb.setFileName(rs.getString("fileName"));
				dbb.setDownloadCount(rs.getInt("downloadCount"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return dbb;
	}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	public int getSearchDownloadBoardCount(String search) { // 검색 글 갯수 조회
		
		int count = 0;
		
		try {
			connect();
			
			String sql = "SELECT count(*) FROM DownloadBoard WHERE title LIKE ?";
			
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
	
	public List getSearchDownloadBoardList(int startRow,int pageSize,String search) { // 자료실 글 목록 불러오기

		List DownloadBoardList = new ArrayList();

		try {
			connect();

			String sql = "SELECT * FROM DownloadBoard WHERE title LIKE ? ORDER BY idx desc limit ?,?";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%" + search + "%");
			pstmt.setInt(2, startRow-1);
			pstmt.setInt(3, pageSize);
			rs=pstmt.executeQuery();

			while(rs.next()) { // 한개의 행이 존재할시 실행

				dbb = new DownloadBoardBean();

				dbb.setIdx(rs.getInt("idx")); 
				dbb.setId(rs.getString("id"));
				dbb.setPass(rs.getString("pass"));
				dbb.setTitle(rs.getString("title"));
				dbb.setContents(rs.getString("contents"));
				dbb.setwTime(rs.getDate("wTime"));
				dbb.setViewCount(rs.getInt("viewCount"));
				dbb.setFileName(rs.getString("fileName"));
				dbb.setOriginalFileName(rs.getString("originalFileName"));
				dbb.setDownloadCount(rs.getInt("downloadCount"));

				DownloadBoardList.add(dbb); // 배열 한개에 한개의 행 레코드 저장
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return DownloadBoardList;
	} // 자료실 글목록 불러오기 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public List searchBoard (String search) { // 자료실 글제목 검색
		
		List DownloadBoardList = new ArrayList();
		
		try {
			connect();
			
			String sql = "SELECT * FROM ORDER BY idx WHERE title like ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%" + search + "%");
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				
				dbb = new DownloadBoardBean();
				
				dbb.setIdx(rs.getInt("idx")); 
				dbb.setId(rs.getString("id"));
				dbb.setPass(rs.getString("pass"));
				dbb.setTitle(rs.getString("title"));
				dbb.setContents(rs.getString("contents"));
				dbb.setViewCount(rs.getInt("viewCount"));
				dbb.setwTime(rs.getDate("wTime"));
				dbb.setFileName(rs.getString("fileName"));
				dbb.setOriginalFileName(rs.getString("originalFileName"));
				dbb.setDownloadCount(rs.getInt("downloadCount"));
				
				DownloadBoardList.add(dbb);
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return DownloadBoardList;
	} // 자료실 글제목 검색 끝
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int delete(int idx, String id, String pass) { // 자료실 글 삭제
		
		int result = 0;
		
		try {
			connect();
			
			String sql = "DELETE FROM DownloadBoard WHERE idx = ? AND id = ? AND pass = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, idx);
			pstmt.setString(2, id);
			pstmt.setString(3, pass);
			
			result = pstmt.executeUpdate();
			
			DownloadCommentDAO dcdao = DownloadCommentDAO.getInstance();
			
			int count = dcdao.DownloadCommentCount(idx);
			
			if (result > 0 && count > 0) {	// 삭제 성공 및 댓글 존재시 실행
				dcdao.boardCommentdelete(idx);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int update(DownloadBoardBean dbb) { // 글수정

		int result = -1;

		try {
			connect();

			String sql = "UPDATE DownloadBoard SET title = ?, contents = ?, originalFileName = ?, fileName = ?, wTime = now() WHERE idx= ?";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, dbb.getTitle());
			pstmt.setString(2, dbb.getContents());
			pstmt.setString(3, dbb.getOriginalFileName());
			pstmt.setString(4, dbb.getFileName());
			pstmt.setInt(5, dbb.getIdx());
			
			result = pstmt.executeUpdate();

			return result;
		} catch (Exception e) {
			e.printStackTrace();
			result = 0;
		} finally {
			close();
		}
		return result = -1;
	} // 글수정 끝

}
