<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="movie.movieBean"%>
<%@page import="movie.movieDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 예매</title>
<link href="../css/movie.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
 	function searchSubmit() {
 		document.getElementById("boardSearch").submit();
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
			location.href = "../main/main.jsp";
			window.open('../View/loginForm.jsp', '', 'width=530, height=750,top=0, resizable=no');
		</script><%	
	}
	
	movieDAO mdao = movieDAO.getInstance();
	
	int count = mdao.getMovieCount();
	
	int pageSize = 5;
	
	String pageNum = request.getParameter("pageNum");
	
	if (pageNum == null) {
		pageNum="1";
	}
	
	int currentPage = Integer.parseInt(pageNum);
	
	int startRow = (currentPage - 1) * pageSize + 1; // 시작 행 구하기
	
	int endRow = pageSize * currentPage; // 마지막 행 구하기
	
	List movieList = null;
	
	if (count != 0) { 
		movieList = mdao.getMovieList(startRow, pageSize); // 시작 열 부터 표시할 행만큼 찾기
	}
	
	// 현재 날짜 구하기
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	Date date = new Date();
	
	String Today = sdf.format(date.getTime());
	
	Date todayDate = sdf.parse(Today);
	
%>
<jsp:include page="../include/header.jsp" />

<article class="art">
	<section class="content-area">
	
		<div class="movie_title">
			<h3><span>상영중인 영화목록</span></h3>
		</div>
		
		<div class="reservation_ShowArea">
		
			<%if (count != 0) {
				for ( int i = 0; i < movieList.size(); i++ ) {
						movieBean mb = (movieBean)movieList.get(i);
					if(%><%mb.getClose_date().compareTo(todayDate)%><% > 0 && %><%mb.getRelease_date().compareTo(todayDate)%><% <= 0) {%>
						<!-- 상영중인 영화만 포스터 표시 -->
						
					<img src="../movie_files/<%=mb.getMovie_image_name()%>" title="<%=mb.getMovie_title()%>" class="mySlides">
					
					
			<%}}}%>
			
			<a class="w3-btn-floating" style="position:absolute;top:45%;right:0" onclick="plusDivs(1)">❯</a>
			<a class="w3-btn-floating" style="position:absolute;top:45%;left:0" onclick="plusDivs(-1)">❮</a>
		</div>
		
		<script>
			// 수동 이미지 슬라이드
			var slideIndex = 1;
			showDivs(slideIndex);

			function plusDivs(n) {
			  showDivs(slideIndex += n);
			}

			function showDivs(n) {
				var i;
		 	 	var x = document.getElementsByClassName("mySlides");
			 	if (n > x.length) {slideIndex = 1}    
		 		if (n < 1) {slideIndex = x.length} ;
				for (i = 0; i < x.length; i++) {
			    	x[i].style.display = "none";  
				}
				x[slideIndex-1].style.display = "block";  
			}
			
			// 자동 이미지 슬라이드
			var myIndex = 0;
			carousel();

			function carousel() {
   				var i;
   				var x = document.getElementsByClassName("mySlides");
   				for (i = 0; i < x.length; i++) {
      			x[i].style.display = "none";  
    		}
   			myIndex++;
   			if (myIndex > x.length) {myIndex = 1}    
   				x[myIndex-1].style.display = "block";  
   				setTimeout(carousel, 3000);  // 3초마다 변경
			}
		</script>
		
		<div class="reservation_area">
			<div>
				<form action="../View/movie_reservation2.jsp" method="post">
					<div>
						<%if (count != 0) {
							for ( int i = 0; i < movieList.size(); i++ ) {
							movieBean mb = (movieBean)movieList.get(i);
								if (%><%mb.getClose_date().compareTo(todayDate)%><% > 0 && %><%mb.getRelease_date().compareTo(todayDate)%><% <= 0) {%>
							<table class="post">
								<tr>
									<td>
										<a href="movie_content.jsp?movie_id=<%=mb.getMovie_id()%>">
											<img src="../movie_files/<%=mb.getMovie_image_name()%>" title="<%=mb.getMovie_title()%>" >
										</a>
													
										<ul>
											<li><a href="movie_content.jsp?movie_id=<%=mb.getMovie_id()%>" id="reservation_title"><%=mb.getMovie_title()%></a></li>
											<li><a href="movie_content.jsp?movie_id=<%=mb.getMovie_id()%>" id="reservation_engtitle"><%=mb.getMovie_eng_title()%></a></li>
											<li id="reservation_movie_genre">
												장르 : <%=mb.getMovie_genre() %><br>
												개봉일 : <%=mb.getRelease_date()%>
											</li>
										</ul>	
											
										<input type="radio" name="movie_id" value="<%=mb.getMovie_id()%>" id="movie_radio" required>
										<input type="hidden" name="movie_title" value="<%=mb.getMovie_title() %>">
									</td>
								</tr>
							</table>
						<%}}}%>
					</div>
					
					<input type="submit" value="예매하러가기">
				</form>
			</div>
		</div>
	</section>
</article>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>