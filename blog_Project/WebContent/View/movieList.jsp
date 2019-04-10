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
<title>영화목록</title>
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
	
	movieDAO mdao = movieDAO.getInstance();
	
	int count = mdao.getMovieCount();
	
	int pageSize = 12;
	
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
			<h3><span>영화목록</span></h3>
		</div>
		
		<div class="slideShowArea">
		
			<%if (count != 0) {
				for ( int i = 0; i < movieList.size(); i++ ) {
				movieBean mb = (movieBean)movieList.get(i);%>
				<a href="movie_content.jsp?movie_id=<%=mb.getMovie_id()%>">
					<img src="../movie_files/<%=mb.getMovie_image_name()%>" title="<%=mb.getMovie_title()%>" class="mySlides">
				</a>
			<%}}%>
			
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
		
		<div class="post-area">
			<div>
				<%if (count != 0) {
						for ( int i = 0; i < movieList.size(); i++ ) {
						movieBean mb = (movieBean)movieList.get(i);%>
				<table class="post">
					<tr>
						<td>
							<a href="movie_content.jsp?movie_id=<%=mb.getMovie_id()%>">
								<img src="../movie_files/<%=mb.getMovie_image_name()%>" title="<%=mb.getMovie_title()%>" >
							</a>
										
							<ul>
								<li><h3><a href="movie_content.jsp?movie_id=<%=mb.getMovie_id()%>"><%=mb.getMovie_title()%></a></h3></li>
								<li id="list_movie_genre">장르 : <%=mb.getMovie_genre() %><br>
									<%=mb.getRelease_date()%>
									<%if(%><%mb.getClose_date().compareTo(todayDate)%><% <= 0) {%>
										<h3>상영종료</h3>
										<div><a href="#">좋아요</a></div>
									<%} else if (%><%mb.getRelease_date().compareTo(todayDate)%><% > 0) {%>
										<h3>개봉전</h3>
										<div><a href="#">좋아요</a></div>
									<%} else if (%><%mb.getRelease_date().compareTo(todayDate)%><% <= 0) {%>
										<h3>상영중</h3> 
										<div><a href="#">좋아요</a> / <a href="movie_reservation.jsp?movie_id=<%=mb.getMovie_id()%>">예매</a></div>
									<%}%> 
								</li>
							</ul>	
						</td>
					</tr>
				</table>
				<%}}%>
			</div>
		</div>
		
		<section class="boardPage">
			<div>	
				<!-- 글 페이지란 -->
				
				<%if (count != 0){
		
					int pageCount = (count / pageSize) + (count % pageSize == 0 ? 0 : 1);
					int pageBlock = 3;
					int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
					int endPage = startPage + pageBlock - 1;
					
    			if (endPage > pageCount) {
    				endPage = pageCount;
    			}
   				
   			 	if (startPage > pageBlock) {
    				%><a href="movieList.jsp?pageNum=<%=startPage-pageBlock%>">[이전]</a><%
  			    }
   				
  			    for (int i=startPage; i<=endPage; i++) {
    				%><a href="movieList.jsp?pageNum=<%=i%>">[<%=i %>]</a><%
  			    }
  			    
  			    if (endPage < pageCount) {
   			     	%><a href="movieList.jsp?pageNum=<%=startPage+pageBlock%>">[다음]</a><%
   			    }
			}%>
			</div>
		</section>
		
		<section class="boardListBottom">
			<!-- 글메뉴창 & 글제목 검색 & 글쓴이 검색 -->
			<div class="boardMenu">
				<div class="boardInsDelWri">
					<ul>
						<%if (id != null && id.equals("test1")) {%>
							<li id="boardIcon"><a href="movie_add_form.jsp">글쓰기</a></li>
						<%}%>
					</ul>
				</div>
			</div>
		</section>
	</section>
</article>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>