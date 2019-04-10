<%@page import="movie.movie_commentBean"%>
<%@page import="movie.movie_commentDAO"%>
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

	String action = request.getParameter("action");

	movie_commentDAO mdao = movie_commentDAO.getInstance();
	
	movie_commentBean mcb = new movie_commentBean();
	
	mcb.setIdx(Integer.parseInt(request.getParameter("idx")));
	mcb.setId(request.getParameter("id"));
	mcb.setContent(request.getParameter("movie_comment_content").replace("\r\n", "<br>")); // 엔터를 <br>로 변환해서 DB저장
	mcb.setMovie_id(Integer.parseInt(request.getParameter("movie_id")));
	
	int result = 0;
	
	if (action.equals("commentWrite")) {
		
		result = mdao.insert(mcb);
		
		if (result == 0) {
			%><script>
			alert("댓글 쓰기 실패");
			history.back();
			</script><%
		}
		
		%><script>
			location.href="../View/movie_content.jsp?movie_id=<%=mcb.getMovie_id()%>"
		</script><%
	} else if (action.equals("commentDelete")) {
		result = mdao.delete(mcb);
		
		if (result == 0) {
			%><script>
			alert("SQL 오류");
			history.back();
			</script><%
		} else if (result == -1) {
			%><script>
			alert("작성자만 삭제 가능!");
			history.back();
			</script><%
		}
		%><script>
			location.href="../View/movie_content.jsp?movie_id=<%=mcb.getMovie_id()%>"
		</script><%
	} else {
		%><script>
			alert("잘못된 접근입니다!");
			history.back();
		</script>
		<%
	}
	
%>

</body>
</html>