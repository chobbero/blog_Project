<%@page import="java.text.SimpleDateFormat"%>
<%@page import="member.memberBean"%>
<%@page import="member.memberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보</title>
<link href="../css/info.css" rel="stylesheet" type="text/css">
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	
	String id = (String)session.getAttribute("id");
		
	if (id == null || id.equals("") || id.length()==0) {  // 세션 만료시, 재로그인
		%><script>
		alert("로그인 해주세요!");
		location.href = "../main/main.jsp";
		window.open('../View/loginForm.jsp', '', 'width=530, height=750, resizable=no');
		</script><%
	} else {
		memberDAO mdao = memberDAO.getInstance();
		memberBean mb = mdao.memberInfo(id);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일"); // 날짜 표시 형식 지정
		%>
		
				
		<section class="sec1">
			<div class="infoForm">
				<h1>회원정보조회</h1>
				<hr size="5" width="488" color="pink">
	
				<div class="memberName">
					<h3><%=mb.getId() %>님의 회원정보</h3>
				</div>
			
				<div class="memberDe">
				<label for="name">이름</label><br>
				<input type="text" name="id" maxlength="20" value="<%=mb.getName()%>" class="irt" readonly><br>
				
  				<label for="birth">생년월일</label><br>
  				<input type="text" name="birth" maxlength="20" class="irt" readonly
  				value="<%=mb.getBirth().substring(0,4)+"년 "+mb.getBirth().substring(4,6)+"월 "+mb.getBirth().substring(6)+"일"%>" ><br>
  						
				<label for="gender">성별</label><br>
				<input type="text" name="gender" maxlength="20" class="irt" readonly
				value="<%if(mb.getGender().equals("male")){%>남성<%}else{%>여성<%}%>"><br>
				
				<label for="email">이메일</label><br>
				<input type="text" name="email" maxlength="50"  class="irt" readonly
				value="<%if(mb.getEmail()==null){%>등록된 이메일 없음 <%}else{%><%=mb.getEmail()%><%}%>"><br>
					
 				<label for="phone">핸드폰</label><br>
 				<input type="text" name="id" maxlength="20" value="<%=mb.getPhone()%>" class="irt" readonly><br>
 				
				<label for="address">주소</label><br>
				<input type="text" name="id" maxlength="100" value="<%=mb.getAddress()%>" class="irt" readonly><br>
				<label for="addressDe">상세주소</label><br>
				<input type="text" name="id" maxlength="100" value="<%=mb.getAddressDe()%>" class="irt" readonly><br>
				<label for="addressRef">참조주소</label><br>
				<input type="text" name="id" maxlength="20" value="<%=mb.getAddressRef()%>" class="irt" readonly><br>
					
				<label for="address">회원가입날짜</label><br>
				<input type="text" name="id" maxlength="20" value="<%=sdf.format(mb.getReg_date())%>" class="irt" readonly><br>
			</div>
	  <%}%>
			<div class="lastBtn">
				<input type="button" value="정보수정" onclick = "location.href ='../View/passCheck.jsp?action=userUpdate'">
				<input type="button" value="창닫기" onclick="window.close()">
			</div>
		</div>
	</section>
</body>
</html>