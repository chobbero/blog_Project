<%@page import="movie.movie_reservationDAO"%>
<%@page import="member.memberBean"%>
<%@page import="member.memberDAO"%>
<%@page import="movie.movie_reservationBean"%>
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
	
	memberDAO mdao = memberDAO.getInstance();
	memberBean mb = new memberBean();
	mb = mdao.memberInfo(id);
	
	movie_reservationBean mrb = new movie_reservationBean();
	
	mrb.setMember_idx(mb.getIdx());
	mrb.setMovie_id(Integer.parseInt(request.getParameter("movie_id")));
	mrb.setTheater_no(Integer.parseInt(request.getParameter("theater_no")));
	mrb.setMovie_time(request.getParameter("date") + " " + request.getParameter("time"));
	mrb.setSeat_no(request.getParameter("seat_no"));
	
	movie_reservationDAO mrdao = movie_reservationDAO.getInstance();
	
	int result = mrdao.add_reservation(mrb);
	
	if (result == 0) {
		%><script>
		alert("예매실패");
		history.back();
		</script><%
	} else {
		%><script>
		alert("예매성공! 예매번호 : <%=result%>");
		location.href = "../View/movieList.jsp";
		</script><%
	}
	
	
	
%>
</body>
</html>