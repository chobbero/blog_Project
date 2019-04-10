<%@page import="member.memberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메일 보내기</title>
<link href="../css/small.css" rel="stylesheet" type="text/css">
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	
	String id = (String)session.getAttribute("id");
	
	if (id == null || id.equals("") || id.length()==0) {
		%><script>
			alert("로그인 해주세요!");
			self.close();
		</script><%	
	}
	
%>
	<div class="mail_form_block">
		<p class="mail_form_title">메일 보내기</p>
		<form action="../Process/send_mail_pro.jsp" method="post">
			<table class="mail_form_insert">
				<tr>
					<td id="form_table_title_td">
						<p id="send_form_title">이름</p>
					</td>
					<td id="form_align-left">
						<input type="text" name="name" id="send_form_insert_name" maxlength=10 required>
					</td>
				</tr>
				
				<tr>
					<td id="form_table_title_td">
						<p id="send_form_title">이메일</p>
					</td>
					<td id="form_align-left">
						<input type="email" name="email" id="send_form_insert_email" maxlength=50 required>
					</td>
				</tr>
				<tr>
					<td id="form_table_title_td">
						<p id="send_form_title">제목</p>
					</td>
					<td id="form_align-left">
						<input type="text" name="title" id="send_form_insert_title" maxlength=100 required>
					</td>
				</tr>
				<tr>
					<td id="form_table_title_td">
						<p id="send_form_title">내용</p>
					</td>
					<td id="form_align-left">
						<textarea name="content" id="send_form_insert_content" maxlength=1000 required></textarea>
					</td>
				</tr>
			</table>
			<input type="submit" value="메일보내기">
		</form>
	</div>
</body>
</html>