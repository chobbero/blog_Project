<%@page import="member.memberDAO"%>
<%@page import="member.memberBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
		
		memberBean mb = new memberBean();
		
		if (request.getParameter("postNo").equals("")) {
			%><script>
				alert("우편번호를 입력하세요");
				history.back();
			</script><%
		} else {
		
		mb.setId(request.getParameter("id"));
		mb.setPass(request.getParameter("pass"));
		mb.setName(request.getParameter("name"));
		mb.setGender(request.getParameter("gender"));
		mb.setBirth(request.getParameter("year") + request.getParameter("month") + request.getParameter("day"));
		mb.setPostNo(Integer.parseInt(request.getParameter("postNo")));
		mb.setAddress(request.getParameter("address"));
		mb.setAddressDe(request.getParameter("addressDe"));
		mb.setAddressRef(request.getParameter("addressRef"));
		mb.setPhone(request.getParameter("phoneA") + request.getParameter("phoneB"));
		mb.setEmail(request.getParameter("email"));
		
		memberDAO mdao = memberDAO.getInstance();
		
		int result = mdao.insert(mb); // mdao의 insert 메서드 실행
		
		switch (result) {
		case 1:
			%>
			<script>
				alert("회원가입성공");
				location.href = "../main/main.jsp";
			</script>
			<%
			break;
		case 0:	
			%>
			<script>
			alert("SQL오류");
			history.back();
			</script>
			<%
			break;
		case -1:
			%>
			<script>
			alert("아이디있음");
			history.back();
			</script>
			<%
			break;
			}
		}	
	%>

</body>
</html>