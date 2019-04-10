<%@page import="board.commentBean"%>
<%@page import="board.commentDAO"%>
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

	commentDAO cdao = commentDAO.getInstance();
	
	commentBean cb = new commentBean();
	
	cb.setId(request.getParameter("id"));
	cb.setIdx(Integer.parseInt(request.getParameter("idx")));
	cb.setContents(request.getParameter("commentContent").replace("\r\n", "<br>")); // 엔터를 <br>로 변환해서 DB저장
	cb.setpBoardIdx(Integer.parseInt(request.getParameter("pBoardIdx")));
	
	int result = 0;
	
	if (action.equals("commentWrite")) {
		result = cdao.insert(cb);
		
		if (result == 0) {
			%><script>
			alert("댓글 쓰기 실패");
			history.back();
			</script><%
		}
		
		%><script>
		location.href="../View/content.jsp?idx=<%=cb.getpBoardIdx()%>"
		</script><%
	} else if (action.equals("commentUpdate")) {
		
	} else if (action.equals("commentDelete")) {
		result = cdao.delete(cb);
		
		if (result == 0) {
			%><script>
			alert("SQL 오류");
			history.back();
			</script><%
		} else if (result == -1) {
			%><script>
			alert("작성자만 삭제 가능!");
			history.back();
			</script><%
		}
		%><script>
			location.href="../View/content.jsp?idx=<%=cb.getpBoardIdx()%>"
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