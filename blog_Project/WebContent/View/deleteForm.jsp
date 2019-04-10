<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<link href="../css/small.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	function userDel () {
		opener.document.location.href="../main/main.jsp";
		self.close();
	}
</script>
</head>
<body>
<%
	String id = (String)session.getAttribute("id");	

	if (id == null || id.equals("") || id.length()==0) {
	%><script>
		alert("로그인 해주세요!");
		location.href = "../main/main.jsp";
		window.open('../View/loginForm.jsp', '', 'width=530, height=750, resizable=no');
	</script><%	
}
%>
	<section>
		<div class="smallImg">
		
		</div>
		<h2 class="delName">회원 탈퇴</h2>
		<hr size="10" width="800" color="#c6ffc6">
		
		<div class="loginForm">
			<form>
				<h3 class="delConfirm">정말로 탈퇴하시겠습니까?</h3>
				<div class="delBtn">
					<input type="button" value="yes" onclick="location.href='../View/passCheck.jsp?action=userDel'">
					<input type="button" value="no" onclick="userDel()">
				</div>
			</form>	
		</div>
	</section>
</body>
</html>