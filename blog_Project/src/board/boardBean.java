package board;

import java.util.Date;

public class boardBean {
	private int idx; // 글번호
	private String id; // 글쓴이
	private String title; // 제목
	private String contents; // 내용
	private int viewCount; // 조회수
	private Date wTime; // 쓴시간 (글 수정시간)
	private String pass; // 비밀번호
	
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
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	
}
