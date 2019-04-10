<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="../css/header.css" rel="stylesheet" type="text/css">
</head>
<body>
<%	
	request.setCharacterEncoding("utf-8");

	String id = (String)session.getAttribute("id");
	
	// id == null 일때 방문자로 변경
	if (id == null || id.equals("") || id.length()==0) {
		id = "방문자";
	}
%>	
<header>
	<section class="headerMain">
		<section class="user">
			<div class="welcome">
				<p class="userName"><%=id%>님 환영합니다.</p>
			</div>
			
			<div class="userMenu">
				<% if (id == "방문자" || id == null || id.length()==0 || id.equals("")) { %>
					<div id="login">
						<a href="#" onclick="window.open('../View/loginForm.jsp', '', 'width=530, height=750,top=0, resizable=no')">
							로그인
						</a>
					</div>
				
					<div id="join">
						<a href="../View/joinForm.jsp">
							회원가입
						</a>
					</div>
				<% } else { %> 
					<div id="logout">
						<a href="../Process/logout.jsp">
							로그아웃
						</a>
					</div> 				
				<% } %>
			</div>
		</section>
			
		<section class="mainTop">
			
		</section>
		
		<section>
			<div class="menuBar">
				<ul>
					<li>
						<a href="../main/main.jsp">메인</a>
					</li>
					
					<li>
						<a href="../View/movieList.jsp">
						영화</a>
					</li>
				  
			   <!-- <li>
						<a href="#" id="boardSelect">
							게시판</a>
						<ul>
							<li><a href="../View/categoryBoard.jsp?category=food">음식</a></li>
							
							<li><a href="../View/categoryBoard.jsp?category=game">게임</a></li>
							
							<li><a href="../View/categoryBoard.jsp?category=car">자동차</a></li>
						</ul>
					</li> -->
				
					<li>
						<a href="../View/boardList.jsp">
						자유게시판</a>
					</li>
				
					<li>
						<a href="../View/DownloadBoardList.jsp">
						자료실</a>
					</li>
					<%if (!(id == "방문자" || id == null || id.length()==0 || id.equals(""))) { %>
					<li>
						<a href="#">
							회원메뉴
						</a>
						<ul>
							<li>
								<a href="#" onclick="window.open('../View/info.jsp', '', 'width=600, height=940,top=0, resizable=no')">
								회원정보 보기</a>
							</li>
							
							<li>
								<a href="#" onclick="window.open('../View/passCheck.jsp?action=userUpdate', '', 'width=600, height=940,top=0, resizable=no')">
								회원정보 수정</a>
							</li>
							
							<li>
								<a href="#" onclick="window.open('../View/deleteForm.jsp', '', 'width=600, height=940,top=0, resizable=no')">
								회원정보 삭제</a>
							</li>
						</ul>
					</li>
					<%}%>
					<li>
						<a href="#" onclick="window.open('../View/reservation_rewind.jsp', '', 'width=400, height=300,top=0, resizable=no')">
						예매확인</a>
					</li>
				</ul>
			</div>
		</section>
	<hr size="10" width="998" color="#c6ffc6">
	</section>
</header>		
</body>
</html>