j<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 화면</title>
<link href="../css/small.css" rel="stylesheet" type="text/css">
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	String action = request.getParameter("action"); // 받아온 값에 따라 분기
%>
	<section>
		<div class="smallImg">
		
		</div>
		<h2 class="loginName">로그인</h2>
		<hr size="10" width="500" color="#c6ffc6">
		
		<div class="loginForm">
			<form action="../Process/loginPro.jsp?action=<%=action%>" method="post" name="fr" class="fr01">
				<div class="inputForm">
					<h3 id="inputFormN">
					<label for ="id">아이디</label></h3>
					<input type="text" name="id" maxlength="30" class="irt" placeholder="아이디 입력" 
					pattern="^[a-zA-Z]{1}[a-zA-Z0-9_]{4,11}$" required autofocus="autofocus"> <br>
			
					<h3 id="inputFormN">
					<label for ="pass">비밀번호</label></h3>			
					<input type="password" name="pass" maxlength="30" class="irt" placeholder="비밀번호 입력" 
					pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$" required><br>
				</div>
		
				<div class="lastBtn">
					<input type="submit" value="로그인">
					<input type="button" value="회원가입" onclick="opener.document.location.href='../View/joinForm.jsp'; self.close();">
				</div>
				<div class="mainBtn">
					<input type="button" value="메인화면" onclick="location.href='../main/main.jsp'">
				</div>
			</form>
		</div>
	</section>
</body>
</html>