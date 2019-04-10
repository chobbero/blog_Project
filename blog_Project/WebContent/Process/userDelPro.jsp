<%@page import="member.memberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
</head>
<body>
<%
	int result = 0;

	memberDAO mdao = memberDAO.getInstance();
	
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	
	if(id==null||pass==null) {
		%><script>
			alert("잘못된 접근입니다.");
			self.close();
		</script><%
	}
	
	result = mdao.delete(id, pass);
	
	if (result != 0) {
		%><script>
		alert("회원탈퇴성공");
		opener.document.location.href="../main/main.jsp";
		self.close();
		</script><%
	} else {
		%><script>
		alert("회원탈퇴성공");
		history.back();
		</script><%
	}
%>
</body>
</html>