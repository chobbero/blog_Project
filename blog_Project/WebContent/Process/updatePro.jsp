<%@page import="java.util.Date"%>
<%@page import="member.memberBean"%>
<%@page import="member.memberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	memberDAO mdao = memberDAO.getInstance();
	memberBean mb = new memberBean();
	
	// 작성 정보 가져오기
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
	
	// 수정 실행
	int result = mdao.update(mb);
	
	switch (result) {
		case 1:
			%><script type="text/javascript">
				alert("회원정보수정완료");
				location.href="../View/info.jsp";
			</script><%
			break;
		case 0:	
			%><script>
			alert("회원정보수정실패");
			history.back();
			</script><%
			break;
		case -1:
			%><script>
			alert("알수없는오류");
			history.back();
			close();
			</script><%
			break;
	}%>
</body>
</html>