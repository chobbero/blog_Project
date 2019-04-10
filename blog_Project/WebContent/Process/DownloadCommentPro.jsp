<%@page import="download_board.DownloadCommentBean"%>
<%@page import="download_board.DownloadCommentDAO"%>
<%@page import="download_board.DownloadBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	String action = request.getParameter("action");

	DownloadCommentDAO dcdao = DownloadCommentDAO.getInstance();
	
	DownloadCommentBean dcb = new DownloadCommentBean();
	
	dcb.setId(request.getParameter("id"));
	dcb.setIdx(Integer.parseInt(request.getParameter("idx")));
	dcb.setContents(request.getParameter("commentContent").replace("\r\n", "<br>")); // 엔터를 <br>로 변환해서 DB저장
	dcb.setpDownBoardIdx(Integer.parseInt(request.getParameter("pDownBoardIdx")));
	
	int result = 0;
	
	if (action.equals("commentWrite")) {
		result = dcdao.insert(dcb);
		
		if (result == 0) {
			%><script>
			alert("댓글 쓰기 실패");
			history.back();
			</script><%
		}
		
		%><script>
		location.href="../View/DownloadContent.jsp?idx=<%=dcb.getpDownBoardIdx()%>"
		</script><%
	} else if (action.equals("commentUpdate")) {
		
	} else if (action.equals("commentDelete")) {
		result = dcdao.delete(dcb);
		
		if (result == 0) {
			%><script>
			alert("오류");
			history.back();
			</script><%
		} else if (result == -1) {
			%><script>
			alert("작성자만 삭제 가능!");
			history.back();
			</script><%
		}
		%><script>
			location.href="../View/DownloadContent.jsp?idx=<%=dcb.getpDownBoardIdx()%>"
		</script><%
	} else {
		%><script>
			alert("잘못된 접근입니다!");
			history.back();
		</script>
		<%
	}
	
%>

</body>
</html>