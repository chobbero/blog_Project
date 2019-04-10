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
	
	int result = mdao.userCheck(id, pass);
	
	String action = request.getParameter("action"); // 받아온 값에 따라 행동 분기
	
	if(!(action.equals("userUpdate") || action.equals("userDel"))) {
		%><script>
		alert("잘못된 접근입니다");
		opener.document.location.href="../main/main.jsp";
		self.close();
		</script><%
	}
	
	if (result == 1) {
		if (action.equals("userUpdate")) {
			%>
			<script>
				location.href="../View/updateForm.jsp";
			</script><%
		} else if (action.equals("userDel")) {
			
			result = mdao.delete(id, pass);
			
			if (result > 0) {
				%><script>
				alert("회원탈퇴성공");
				session.invalidate();
				opener.document.location.href="../main/main.jsp";
				self.close();
				</script><% 
			} else {
				%><script>
				alert("회원탈퇴실패");
				history.back();
				</script><%
			} 
		}
	} else {
		%><script>
			alert("비밀번호 틀림");
			history.back();
		</script><%
	}%>
</body>
</html>