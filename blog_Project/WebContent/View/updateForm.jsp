<%@page import="member.memberBean"%>
<%@page import="member.memberDAO"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
<link href="../css/update.css" rel="stylesheet" type="text/css">

<!-- 비밀번호 동일 여부 체크 -->
<script>
function checkValue(){
	if(document.userInfo.pass.value != document.userInfo.passCheck.value ){
    	alert("비밀번호를 동일하게 입력하세요.");
    	return false;
	}
}
</script>

<!-- 우편번호 검색 기능 API-->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script> 
<script>  
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("extraAddress").value = extraAddr;
                
                } else {
                    document.getElementById("extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("detailAddress").focus();
            }
        }).open();
    }
</script>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	String id = (String) session.getAttribute("id");
	
	if (id == null || id.equals("") || id.length()==0) {
		%><script>
			alert("로그인이 필요합니다");
		</script><%
	    response.sendRedirect("loginForm.jsp");
	}
	
	// 기존 회원정보 가져와서 폼에 입력
	memberDAO mdao = memberDAO.getInstance();
	memberBean mb = mdao.memberInfo(id); 
	
%>	
	<form action="../Process/updatePro.jsp" method="post" name="userInfo" class="fr01" onsubmit="return checkValue()">
		<section class="updateForm">
			<h1>회원정보수정</h1>
			<hr size="5" width="488" color="pink">
			<div class="joinIdPass">
				<div class="joinId">
					<h3 class="menu">
					<label for="id">아이디</label></h3><p class="ref"></p>
					<input type="text" name="id" maxlength="30" value="<%=mb.getId() %>" class="irt" readonly><br>
				</div>
			
				<div class="joinPass">
					<h3 class="menu"> 
					<label for="password">비밀번호</label></h3><p class="ref">(최소 8자리에 숫자, 문자, 특수문자 각각 1개 이상 포함한 비밀번호)</p>
					<input type="password" name="pass" maxlength="30" class="irt" placeholder="8~16글자 이상 비밀번호 입력 " 
					pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$"><br>
				</div>
			
				<div class="joinPassCK">
					<h3 class="menu">
					<label for="passCheck">비밀번호 확인</label></h3>
					<input type="password" name="passCheck" maxlength="30" class="irt" placeholder="비밀번호 입력창과 동일한 비밀번호 입력 (영어,숫자)" 
					pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$"><br>
				</div>
			</div>
		
			<div class="joinRef">
				<div class="joinName">
					<h3 class="menu">
					<label for="name">이름</label></h3><p class="ref">(한글만 입력가능)</p>
					<input type="text" name="name" value="<%=mb.getName() %>"class="irt" maxlength="10" placeholder="이름 입력 " 
					pattern="^[가-힣]{2,}$" required><br> 
				</div>
			
				<div class="joinBirth">
					<h3 class="menu">
					<label for="age">생년월일</label></h3>
					<select name="year" class="selBirth" required>
						<option disabled>년도</option>
						<%
						for (int i = Calendar.getInstance().get(Calendar.YEAR) ; i > 1900 ; i--) { %>
							<option value="<%=i %>" 
							<%if(mb.getBirth().substring(0,4).equals(String.valueOf(i))){%>selected<%}%>><%=i + "년" %></option>
						<%} %>
					</select>
				
					<select name="month" class="selBirth" required>
						<option disabled>월</option>
						<%
						for (int i = 1; i <= 12; i++) { %>
							<% if (i < 10) { %>
								<option value="<%="0" + i %>" 
								<%if(mb.getBirth().substring(4, 6).equals("0"+String.valueOf(i))){%>selected<%}%>><%=i + "월"%></option>
							<% } else { %>
								<option value="<%=i %>" 
								<%if(mb.getBirth().substring(4, 6).equals(String.valueOf(i))){%>selected<%}%>><%=i + "월"%></option>
							<% } 
						} %>
					</select>
				
					<select name="day" class="selBirth" required>
						<option disabled>일</option>
						<%
						for (int i = 1; i <= 31; i++) { %>
							<% if (i < 10) { %>
								<option value="<%="0" + i %>" 
								<%if(mb.getBirth().substring(6).equals("0"+String.valueOf(i))){%>selected<%}%>><%=i + "일"%></option>
							<% } else { %>
								<option value="<%=i %>" 
								<%if(mb.getBirth().substring(6).equals(String.valueOf(i))){%>selected<%}%>><%=i + "일"%></option>
							<% } 
						} %>
					</select>
				</div>
			
				<div class="joinGender">
					<h3 class="menu">
					<label for="gender">성별</label></h3>
					<select name="gender" class="selbox" required>
						<option disabled>성별</option>
						<option value="male" <%if(mb.getGender().equals("male")){%>selected<%}%>>남자</option>
						<option value="female" <%if(mb.getGender().equals("female")){%>selected<%}%>>여자</option>
					</select><br>
				</div>
			
				<div class="joinEmail">
					<h3 class="menu">
					<label for="email">이메일</label></h3>
					<input type="email" name="email" value="<%if(mb.getEmail()!=null){%><%=mb.getEmail()%><%}%>" class="irt" 
					maxlength="50" placeholder="선택사항"><br>
				</div>	
			
				<div class="joinPhone">
					<h3 class="menu">
					<label for="phone">핸드폰</label></h3>
					<select name="phoneA" class="phoneA" required>
						<option disabled>번호</option>
						<option value="010" <%if(mb.getPhone().substring(0,3).equals("010")){%>selected<%}%>>010</option>
						<option value="016" <%if(mb.getPhone().substring(0,3).equals("016")){%>selected<%}%>>016</option>
						<option value="019" <%if(mb.getPhone().substring(0,3).equals("019")){%>selected<%}%>>019</option>
					</select>
					<input type="text" name="phoneB" class="phoneB" value="<%=mb.getPhone().substring(3)%>" maxlength="8" 
					placeholder="7~8자리 숫자 입력" pattern="^[0-9]{7,8}$" required><br>
				</div>
			</div>
		
			<div class="joinPost">
				<div class="joinAdd">
					<h3 class="menu">
					<label for="postNo">우편번호</label></h3>
					<input type="text" name="postNo" id="postcode" value="<%=mb.getPostNo()%>" 
					placeholder="우편번호 자동입력" size = "4" class="irt2" required readonly>
					<input type="button" onclick="execDaumPostcode()" value="우편번호 찾기" class="btn"><br>
					
					<input type="text" name="address" id="address" 
					value="<%=mb.getAddress()%>" placeholder="주소 자동입력" size="35" class="irt" readonly><br>
				
					<input type="text" name="addressDe" id="detailAddress" 
					<%if(mb.getAddressDe()!=null){%>value="<%=mb.getAddressDe()%>"<%}%> placeholder="상세주소 입력" maxlength="100" class="irt"><br>
				
					<input type="text" name="addressRef" id="extraAddress" value="<%=mb.getAddressRef()%>" 
					placeholder="참고항목 자동입력" class="irt" readonly><br><br>
				</div>
			</div>
			<div class="lastBtn">
				<input type="submit" value="정보수정">
				<input type="reset" value="초기화">
			</div>
		</section>
	</form>	
</body>
</html>