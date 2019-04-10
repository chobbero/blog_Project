<%@page import="download_board.DownloadBoardDAO"%>
<%@page import="board.boardDAO"%>
<%@page import="member.memberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 재확인</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	
	memberDAO mdao = memberDAO.getInstance();
	
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	
	String category = request.getParameter("category");
	
	int result = mdao.userCheck(id, pass);
	
	String action = request.getParameter("action"); // 받아온 값에 따라 행동 분기
	
	int idx = Integer.parseInt(request.getParameter("idx"));
	
	if(!(action.equals("boardDel") || action.equals("DownloadBoardDel") || action.equals("categoryBoardDel"))) {
		%><script>
		alert("잘못된 접근입니다");
		opener.document.location.href="../main/main.jsp";
		self.close();
		</script><%
	}
	
	if (result == 1) {
		if (action.equals("boardDel")) {
			boardDAO bdao = boardDAO.getInstance();
			
			result = bdao.delete(idx,id,pass);
			
			if (result > 0) {
				%><script>
				alert("글 삭제 성공");
				opener.document.location.href="../View/boardList.jsp";
				self.close();
				</script><% 
			} else {
				%><script>
				alert("글 삭제 실패");
				history.back();
				</script><%
			} 
			
		} else if (action.equals("DownloadBoardDel")) {
			DownloadBoardDAO dbdao = DownloadBoardDAO.getInstance();
			
			result = dbdao.delete(idx,id,pass);
			
			if (result > 0) {
				%><script>
				alert("글 삭제 성공");
				opener.document.location.href="../View/DownloadBoardList.jsp";
				self.close();
				</script><% 
			} else {
				%><script>
				alert("글 삭제 실패");
				history.back();
				</script><%
			} 
		}
	} else {
		%><script>
		alert("비밀번호 틀림");
		history.back();
	</script><%
} %>
</body>
</html>