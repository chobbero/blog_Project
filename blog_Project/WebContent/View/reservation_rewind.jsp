<%@page import="member.memberBean"%>
<%@page import="member.memberDAO"%>
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
	
	String id = (String)session.getAttribute("id");
	
	if (id == null || id.equals("") || id.length()==0) {
		%><script>
			alert("로그인 해주세요!");
			self.close();
		</script><%	
	}
	
	memberDAO memdao = memberDAO.getInstance();
	memberBean memb = new memberBean();
	memb = memdao.memberInfo(id);
		
%>
	<form action="../View/reservation_rewind_result.jsp" method="post">
		<input type="hidden" name="member_id" value="<%=memb.getIdx()%>">
		<input type="text" name="member_name" value="<%=id %>" readonly>
		<input type="text" name="reservation_no" placeholder="예매번호 입력">
		<input type="submit" value="예매확인">
	</form>
</body>
</html>