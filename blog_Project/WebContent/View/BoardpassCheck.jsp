<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<link href="../css/small.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	function moveMain() {
		opener.document.location.href="../main/main.jsp";
		self.close();
	}
</script>
</head>
<body>
<%	
	request.setCharacterEncoding("utf-8");

	String id = (String)session.getAttribute("id");
	
	String action = request.getParameter("action"); // 받아온 값에 따라 행동 분기
	
	String idx = request.getParameter("idx");
	
	String category = request.getParameter("category");
	
	if (id == null || id.equals("") || id.length()==0) {
		%><script>
			location.href="loginForm.jsp";
		</script><%
	}

%>
	<section>
		<div class="smallImg">
		
		</div>
		<h2 class="loginName">비밀번호 확인</h2>
		<hr size="10" width="500" color="#c6ffc6">
		
		<div class="loginForm">
			<form action="../Process/BoardpassCheckPro.jsp?action=<%=action%>&idx=<%=idx%>&category=<%=category %>" 
			method="post" name="fr" class="fr01">
				<div class="inputForm">
					<h3 id="inputFormN">
					<label for ="id">아이디</label></h3>
					<input type="text" name="id" maxlength="30" class="irt" value="<%=id%>" placeholder="아이디 입력" 
					pattern="^[a-zA-Z]{1}[a-zA-Z0-9_]{4,11}$" required autofocus="autofocus" readonly><br>
				
					<h3 id="inputFormN">
					<label for ="pass">비밀번호</label></h3>			
					<input type="password" name="pass" maxlength="30" class="irt" placeholder="비밀번호 입력" 
					pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$" required><br>
				</div>
			
				<div class="lastBtn">
					<input type="submit" value="확인" onclick="location.href='../main/main.jsp'">
					<input type="reset" value="취소">
				</div>
				
				<div class="mainBtn">
					<input type="button" value="메인화면" onclick="moveMain()">
				</div>
			</form>
		</div>
	</section>
</body>
</html>