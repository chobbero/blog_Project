	package download_board;

import java.util.Date;

public class DownloadCommentBean {
	private int idx; // 댓글번호
	private String id; // 글쓴이
	private String contents; // 내용
	private Date wTime; // 쓴시간 (글 수정시간)
	private int pDownBoardIdx; // 게시판글번호
	
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public Date getwTime() {
		return wTime;
	}
	public void setwTime(Date wTime) {
		this.wTime = wTime;
	}
	public int getpDownBoardIdx() {
		return pDownBoardIdx;
	}
	public void setpDownBoardIdx(int pDownBoardIdx) {
		this.pDownBoardIdx = pDownBoardIdx;
	}
}
