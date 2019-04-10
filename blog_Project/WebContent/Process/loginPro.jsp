<%@page import="member.memberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 실행</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	
	String action = request.getParameter("action");
	
	memberDAO dao = memberDAO.getInstance();
	
	int result = dao.login(id, pass); // 로그인 메서드 실행
	
	if ( result == 1 ) {
		
		session.setAttribute("id", id);  // 세션 생성
		
		if (action.equals("bw")) {
			%><script type="text/javascript">
			opener.document.location.href="../View/bWForm.jsp";
			self.close();
			</script><%
		} else if (action.equals("dbw")) {
			%><script type="text/javascript">
			opener.document.location.href="../View/DownloadBoardWriteForm.jsp";
			self.close();
			</script><%
		} else if (action.equals("cbw")) {
			%><script type="text/javascript">
			opener.document.location.href="../View/categoryBoardWriteForm.jsp";
			self.close();
			</script><%
		}
		
		%><script type="text/javascript">
		opener.document.location.href="../main/main.jsp";
		self.close();
		</script><%
	} else if (result == 0){
		%><script>
		alert("비밀번호틀림");
		history.back();
		</script><%
	} else if (result == -1 ){
		%><script>
		alert("아이디없음");
		history.back();
		</script><%
	} else {
		%><script>
		alert("알수없는 오류");
		history.back();
		</script><%
	}%>
</body>
</html>