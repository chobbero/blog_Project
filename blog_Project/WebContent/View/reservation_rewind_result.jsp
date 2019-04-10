<%@page import="movie.movieBean"%>
<%@page import="movie.movieDAO"%>
<%@page import="movie.movie_reservationBean"%>
<%@page import="movie.movie_reservationDAO"%>
<%@page import="member.memberBean"%>
<%@page import="member.memberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
	
	
	int member_id = Integer.parseInt(request.getParameter("member_id"));
	int reservation_no = Integer.parseInt(request.getParameter("reservation_no"));
	
	movie_reservationDAO mrdao = movie_reservationDAO.getInstance();
	movie_reservationBean mrb = new movie_reservationBean();
	
	mrb = mrdao.rewind(member_id, reservation_no);
	
	out.println(mrb.getReservation_no());
	
	if (mrb.getMovie_time() == null || mrb.getSeat_no() == null) {
		%><script>
		alert("예매내역없음")
		self.close();
		</script><%
	}
	
	movieDAO mdao = movieDAO.getInstance();
	movieBean mb = new movieBean();
	mb = mdao.getMovieBoard(mrb.getMovie_id());
%>

	아이디 : <%=id %>님의 예매 내역<br>
	예매번호 : <%=mrb.getReservation_no()%><br>
	영화제목 : <%=mb.getMovie_title() %><br>
	영화영제목 : <%=mb.getMovie_eng_title() %><br>
	상영시간 : <%=mrb.getMovie_time() %><br>
	상영관 : <%=mrb.getTheater_no() %>관<br>
	자리 : <%=mrb.getSeat_no() %><br>
	
</body>
</html>