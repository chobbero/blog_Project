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
<title>예매 확인</title>
<link href="../css/movie.css" rel="stylesheet" type="text/css">

</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	
	String id = (String)session.getAttribute("id");
	
	int movie_id = Integer.parseInt(request.getParameter("movie_id"));
	
	if (id == null || id.equals("") || id.length()==0) {
		%><script>
			alert("로그인 해주세요!");
			location.href = "../main/main.jsp";
			window.open('../View/loginForm.jsp', '', 'width=530, height=750,top=0, resizable=no');
		</script><%	
	}

	String seat_no="";
	
	movieDAO mdao = movieDAO.getInstance();
	
	movieBean mb = new movieBean();
	
	mb = mdao.getMovieBoard(movie_id);
	
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
			<h3><span>예매 확인</span></h3>
		</div>
		
		<div class="reservation_area">
			<div>
				<form action="../Process/movie_reservation_pro.jsp" method="post">
					<div class="theater_select">
						<p id="rev_title">상영관 번호</p>
						상영관 <%=mb.getTheater_no()%> 입니다.<br>
						<p id="rev_title">영화 제목</p>
						<%=mb.getMovie_title() %><br>
						<p id="rev_title">상영 날짜</p>
						<%= request.getParameter("date") %><br>
						<p id="rev_title">상영 시간</p>
						<%=	request.getParameter("time") %><br>
						<p id="rev_title">좌석 번호</p>
						<% String[] value = request.getParameterValues("seat_no");
							for (String val : value) {%>
								<%seat_no += val + " "; %>
							<%}%>
						<%=seat_no%>
						 
					</div>
					
					<input type="hidden" name="theater_no" value="<%=mb.getTheater_no()%>">	
					<input type="hidden" name="movie_id" value="<%=mb.getMovie_id() %>">
					<input type="hidden" name="date" value="<%=request.getParameter("date") %>">
					<input type="hidden" name="time" value="<%=request.getParameter("time") %>">
					<input type="hidden" name="seat_no" value="<%=seat_no%>">
					<br><br>
					<input type="submit" value="다음">
				</form>
			</div>
		</div>
	</section>
</article>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>