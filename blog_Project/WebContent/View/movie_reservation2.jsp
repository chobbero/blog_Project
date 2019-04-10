<%@page import="java.util.GregorianCalendar"%>
<%@page import="member.memberBean"%>
<%@page import="member.memberDAO"%>
<%@page import="java.util.Calendar"%>
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
	
	int movie_id = Integer.parseInt(request.getParameter("movie_id"));
	
	movieDAO mdao = movieDAO.getInstance();
	
	movieBean mb = new movieBean();
	
	mb = mdao.getMovieBoard(movie_id);
	
	//나이
	memberDAO memdao = memberDAO.getInstance();
	memberBean memb = new memberBean();
	memb = memdao.memberInfo(id);
	
	//날짜 계산
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	Date date = new Date();
	
	String Today = sdf.format(date.getTime());
	
	Date todayDate = sdf.parse(Today);
	
	Calendar c = Calendar.getInstance();
	
	c.setTime(date);
	
%>
<jsp:include page="../include/header.jsp" />

<article class="art">
	<section class="content-area">
	
		<div class="movie_title"> 
			<h3><span>영화 : [ <%=request.getParameter("movie_title")%> ] 예매 (좌석 선택)</span></h3>
		</div>
		
		<div class="reservation_area">
			<div class="reservation_time_block">
				<form action="../View/movie_reservation_check.jsp" method="post">
					<input type="hidden" name="movie_id" value="<%=mb.getMovie_id() %>">
					<p id="rev_title">상영관 안내</p>
					<div class="theater_select">
						상영관 <%=mb.getTheater_no()%> 입니다.
						<input type="hidden" name="theater_no" value="<%=mb.getTheater_no()%>">
								
						<input type="hidden" name="movie_id" value="<%=mb.getMovie_id() %>">
					</div>
					
					<div>
					<p id="rev_title">상영 시간 선택</p>
						<table>
							<tr id="rev_date">
								<td id="rev_title1">상영일</td>
								
								<%for (int i = 0 ; i < 5; i++) {
									c.add(Calendar.DATE, i);%>
								<td id="rev_radio1">
									<%=sdf.format(c.getTime())%><input type="radio" name="date" value="<%=sdf.format(c.getTime())%>" id="radio_size" required>
								</td>
								<%}%>
							</tr>
							<br>
							<tr id="rev_time">
								<td id="rev_title1">상영시간</td>
								<td id="rev_radio2">06:00<br><input type="radio" name="time" value="06:00" id="radio_size" required></td>
								<td id="rev_radio2">10:00<br><input type="radio" name="time" value="10:00" id="radio_size" required></td>
								<td id="rev_radio2">14:00<br><input type="radio" name="time" value="14:00" id="radio_size" required></td>
								<td id="rev_radio2">18:00<br><input type="radio" name="time" value="18:00" id="radio_size" required></td>
								<td id="rev_radio2">22:00<br><input type="radio" name="time" value="22:00" id="radio_size" required></td>
							</tr>
						</table>
					</div>
					
					<p id="rev_title">좌석 선택</p>
					<div class="seat_select">
						<table>
							<%for (int i = 0; i <= 4; i++) { %>
								<tr>
								<%for (int j = 1; j <= 10; j++) { %>
									<td>
										<p><%=i * 10 + j%></p>
										<p><input type="checkbox" name="seat_no" value="<%=i * 10 + j%>" id="checkbox_size"></p>
									</td>
								<%}%>
								</tr>
							<%}%>
						</table>
					</div>
					<input type="submit" value="예매내역확인">
				</form>
			</div>
		</div>
	</section>
</article>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>