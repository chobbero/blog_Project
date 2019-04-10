<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 게시판 글쓰기</title>
<link href="../css/movie.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	function submit() {
		document.getElementById("movie_write").submit();
	}
	function reset() {
		document.getElementById("movie_write").reset();
	}
</script>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	String id = (String)session.getAttribute("id");
	
	if (id == null || id.equals("") || id.length()==0) {
		%><script>
			alert("로그인 해주세요!");
			history.back();
			window.open('../View/loginForm.jsp', '', 'width=530, height=750, top=0, resizable=no');
		</script><%	
	}

	if (!(id != null && id.equals("test1"))) {
		%><script>
			alert("관리자 로그인 해주세요!");
			history.back();
			location.href = '../main/main.jsp';
		</script><%	
	}
%>
<jsp:include page="../include/header.jsp" />

<article class="art">
	<section class="content-area">
		<section>
			<div class="boardTitle">
				<h2 id="boardTitleWord">영화 등록</h2>
			</div>
		</section>
	
		<section class="categoryBoardWriteForm">
			<form action="../Process/movie_add_pro.jsp" method="post" enctype="Multipart/form-data" id="movie_write">
				<table>
				<tr class="wTitle">
					<td class="wTitle">카테고리</td>
					<td class="categoryValue">
					<select name="genre" id="categorySelectBox" required>
						<optgroup label="장르"></optgroup>
						<option value="action">액션</option>
						<option value="drama">드라마</option>
						<option value="comedy">코미디</option>
						<option value="mystery">미스테리</option>
						<option value="romance">로맨스</option>
						<option value="history">역사</option>
						<option value="SF">SF</option>
					</select>
					</td>
				</tr>
				
				<tr>
					<td class="wTitle">제목</td>
					<td class="categoryValue">
					<input type="text" name="movie_title" maxlength="100" id="blockTitle" required></td>
				</tr>
				
				<tr>
					<td class="wTitle">영제목</td>
					<td class="categoryValue">
					<input type="text" name="movie_eng_title" maxlength="100" id="blockTitle" required></td>
				</tr>
				
				<tr>
					<td class="wTitle">감독</td>
					<td class="categoryValue">
					<input type="text" name="movie_director" maxlength="30" id="blockTitle" required></td>
				</tr>
				
				<tr>
					<td class="wTitle">배우</td>
					<td class="categoryValue">
					<input type="text" name="movie_cast" maxlength="100" id="blockTitle" required></td>
				</tr>
				
				<tr>
					<td class="wTitle">기본설명</td>
					<td class="categoryValue">
					<input type="text" name="movie_basic" maxlength="100" id="blockTitle" required>
					 (나이제한, 상영시간)</td>
				</tr>
				
				<tr>
					<td class="wTitle">나이제한 선택</td>
					<td class="categoryValue">
					<select name="movie_age" required>
						<option value=""  disabled>시청가능</option>
						<option value="0">전체이용가</option>
						<option value="7">7세이상</option>
						<option value="12">12세이상</option>
						<option value="15">15세이상</option>
						<option value="18">18세이상</option>
					</select>
					 (전체, 7세, 12세, 15세, 18세)</td>
				</tr>
				
				<tr>
					<td class="wTitle">설명 및 줄거리</td>
					<td class="categoryValue">
					<textarea name="movie_explanation" maxlength="1000" id="blockContents" required></textarea></td>
				<tr>
				
				<tr>
					<td class="wTitle">개봉일</td>
					<td class="categoryValue">
						<div>
						<label for="release_date"></label>
						<select name="year" required>
							<option disabled>년도</option>
							<%
							for (int i = Calendar.getInstance().get(Calendar.YEAR); i <= Calendar.getInstance().get(Calendar.YEAR); i++) { %>
								<option value="<%=i %>"><%=i + "년" %></option>
							<%} %>
						</select>
				
						<select name="month" required>
							<option disabled>월</option>
							<%
							for (int i = Calendar.getInstance().get(Calendar.MONTH)+1; i <= 12; i++) { %>
								<% if (i < 10) { %>
									<option value="<%="0" + i %>"><%=i + "월" %></option>
								<% } else { %>
									<option value="<%=i %>"><%=i + "월" %></option>
								<% } 
							} %>
						</select>
					
						<select name="day" required>
							<option disabled>일</option>
							<%
							for (int i = 1; i <= 31; i++) { %>
								<% if (i < 10) { %>
									<option value="<%="0" + i %>"><%=i + "일" %></option>
								<% } else { %>
									<option value="<%=i %>"><%=i + "일" %></option>
								<% } 
							} %>
						</select>
					</div>
				</tr>
				
				<tr>
					<td class="wTitle">상영종료일</td>
					<td class="categoryValue">
				<div>
					<label for="close_date"></label>
					<select name="close_year" required>
						<option disabled>년도</option>
						<%
						for (int i = Calendar.getInstance().get(Calendar.YEAR); i <= Calendar.getInstance().get(Calendar.YEAR); i++) { %>
							<option value="<%=i %>"><%=i + "년" %></option>
						<%} %>
					</select>
				
					<select name="close_month" required>
						<option disabled>월</option>
						<%
						for (int i = Calendar.getInstance().get(Calendar.MONTH)+1; i <= 12; i++) { %>
							<% if (i < 10) { %>
								<option value="<%="0" + i %>"><%=i + "월" %></option>
							<% } else { %>
								<option value="<%=i %>"><%=i + "월" %></option>
							<% } 
						} %>
					</select>
				
					<select name="close_day" required>
						<option disabled>일</option>
						<%
						for (int i = 1; i <= 31; i++) { %>
							<% if (i < 10) { %>
								<option value="<%="0" + i %>"><%=i + "일" %></option>
							<% } else { %>
								<option value="<%=i %>"><%=i + "일" %></option>
							<% } 
						} %>
					</select>
				</div>
				</tr>
				
				<tr>
					<td class="wTitle">상영관선택</td>
					<td>
						상영관 1<input type="radio" name="theater_no" value="1" required>
						상영관 2<input type="radio" name="theater_no" value="2" required>
						상영관 3<input type="radio" name="theater_no" value="3" required>
					</td>
				</tr>
				
				<tr>
					<td class="wTitle">포스터파일</td>
					<td class="categoryValue">
					<input type="file" name="image" accept="image/gif, image/jpeg, image/png, image/jpg" required>
					<span> 이미지파일(gif, jpeg, png, jpg)만 가능!</span></td>
				</tr>
			</table>
			
			<div class="boardInsDelWri">
				<ul>
					<li id="boardIcon"><a href="moiveBoard.jsp">글목록</a></li>
					<li id="boardIcon"><a href="#" onclick="submit()">글쓰기</a></li>
					<li id="boardIcon"><a href="#" onclick="reset()">초기화</a></li>
				</ul>
			</div>
		</form>
	</section>
	
	</section>

</article>

<jsp:include page="../include/footer.jsp" />
</body>
</html>