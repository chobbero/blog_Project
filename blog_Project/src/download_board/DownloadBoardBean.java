package download_board;

import java.util.Date;

public class DownloadBoardBean {
	private int idx; // 글번호
	private String id; // 글쓴이
	private String pass; // 비밀번호
	private String title; // 제목
	private String contents; // 내용
	private int viewCount; // 조회 수
	private Date wTime; // 쓴시간 (글 수정시간)
	private String originalFileName; // 원본 자료명
	private String fileName;// 중복 처리된 자료명
	private int DownloadCount; // 다운로드 수
	
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
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
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	public Date getwTime() {
		return wTime;
	}
	public void setwTime(Date wTime) {
		this.wTime = wTime;
	}
	public String getOriginalFileName() {
		return originalFileName;
	}
	public void setOriginalFileName(String originalFileName) {
		this.originalFileName = originalFileName;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public int getDownloadCount() {
		return DownloadCount;
	}
	public void setDownloadCount(int downloadCount) {
		DownloadCount = downloadCount;
	}
}
