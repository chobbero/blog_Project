<%@page import="movie.movie_commentBean"%>
<%@page import="movie.movie_commentDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="movie.movieBean"%>
<%@page import="movie.movieDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<script type="text/javascript">
 	function commentDeleteSubmit() {
 		document.getElementById("commentDeleteForm").submit();
	}
 	function commentSubmit() {
 		document.getElementById("commentWriteForm").submit();
 	}
</script>

<title>영화 상세 페이지</title>
<link href="../css/movie.css" rel="stylesheet" type="text/css">
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	String id = (String)session.getAttribute("id");
	
	if (request.getParameter("movie_id") == null) {
		%><script>
			location.href = "../main/main.jsp";
		</script><%
	}
	
	int movie_id = Integer.parseInt(request.getParameter("movie_id"));

	movieDAO mdao = movieDAO.getInstance();
	
	movieBean mb = new movieBean();
	
	mb = mdao.getMovieBoard(movie_id);

	// 현재 날짜 구하기
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	Date date = new Date();
	
	String Today = sdf.format(date.getTime());
	
	Date todayDate = sdf.parse(Today);
	
	movie_commentDAO mcdao = movie_commentDAO.getInstance();
	
	int commentCount = mcdao.CommentCount(movie_id);
	
%>
<jsp:include page="../include/header.jsp" />

<article class="art">
	<section class="content-area">
	
		<div class="movie_title">
			<span><%=mb.getMovie_title()%></span>상세정보
		</div>
		
		<div class="movieRef">
			<div class="movieRef_block">
				<img src="../movie_files/<%=mb.getMovie_image_name()%>" id="movie_ref_img"> <br>
			</div>
			
			<div class="movie_ref_block">
			<!--  왼쪽 정렬  -->	
				<p id="movie_ref_title"><%=mb.getMovie_title()%></p>
				<p id="movie_ref_subtitle"><%=mb.getMovie_eng_title() %></p>
				<p id="movie_ref_ref">	
				감독 : <%=mb.getMovie_director()%> / 배우 : <%=mb.getMovie_cast()%> <br>
				장르 : <%=mb.getMovie_genre()%> / 기본 : <%=mb.getMovie_basic() %> <br>
				개봉 : <%=mb.getRelease_date() %><br>
				</p>
			<!-- 날짜기준으로 상영중 상영예정 상영종료 표시 -->
			<%if(%><%mb.getClose_date().compareTo(todayDate)%><% <= 0) {%>
				<h2>상영종료</h2>  
				<h3><a href="#">좋아요</a></h3>
			<%} else if (%><%mb.getRelease_date().compareTo(todayDate)%><% > 0) {%>
				<h2>개봉전</h2> 
				<h3><a href="#">좋아요</a></h3>
			<%} else if (%><%mb.getRelease_date().compareTo(todayDate)%><% <= 0) {%>
				<h2>상영중</h2> 
				<h3><a href="#">좋아요</a> / <a href="movie_reservation.jsp?movie_id=<%=mb.getMovie_id()%>">예매</a></h3>
			<%}%> 
			
			</div>
			
			<div class="movie_ref_explain_block">
				<p id="explain_title">[ <%=mb.getMovie_title()%> ] 영화 정보</p>
				<textarea id="explain_contents" readonly><%=mb.getMovie_explanation()%></textarea>
			</div>		
		</div>
		
	</section>
	<section class="oneline_comment_area">
		<div class="comment_block">
		
			<h3 class="commentCount">전체 한줄평  : <span>[<%=commentCount %>]</span>개 한줄평</h3>
			
			<div class="comment_view_block">
				<%if (commentCount > 0) { %>
					<p class="comment_view_title">한줄평 보기</p>
					<%List Movie_comments = mcdao.getMovie_comments(movie_id); %> 
					<%for (int i = 0; i < Movie_comments.size(); i++) {
						movie_commentBean mcb = (movie_commentBean)Movie_comments.get(i);%> 
					<table class="comment_view_table">
						<tr>
							<td class="comment_view_id"><img src="../img/arrow_orange.gif"><%=mcb.getId()%></td>
							
						    <td class="commment_view_content" style="word-break:break-all;"><%=mcb.getContent()%></td>
						    
						    <td class="comment_view_date"><%=mcb.getDate()%></td>
						    
						    <td class="comment_view_delBtn">
						    	<form action="../Process/movie_comment_pro.jsp" method="post" id="commentDeleteForm">
						   			<% if(id == null || id.equals("") || id.length()==0) { %>
							   			<a href="#" onclick="window.open('../View/loginForm.jsp', '', 'width=530, height=750,top=0, resizable=no')">댓글삭제
							   			</a>
									<% } else {%> 
										<input type="hidden" name="id" value="<%=id%>">
										<input type="hidden" name="idx" value="<%=mcb.getIdx()%>">
										<input type="hidden" name="movie_id" value="<%=mb.getMovie_id()%>">	
										<input type="hidden" name="movie_comment_content" value=" ">
										<input type="hidden" name="action" value="commentDelete">
										<p id="comment_icon"><a href="#" onclick="commentDeleteSubmit();">댓글삭제</a></p>
									<% } %>
					    		</form>
						    </td>
						</tr>
					</table>
					<%}%>
				<%}%>
			</div>
			<!-- 댓글 쓰는 폼 -->
			<div class="comment_write_block">
				<p class="comment_write_title">댓글 쓰기</p>
				<form action="../Process/movie_comment_pro.jsp" method="post" id="commentWriteForm">
					<table class="comment_write_table">
						<tr>
							<td class="comment_write_content">
							<% if(id == null || id.equals("") || id.length()==0) { %>
							    <textarea id="comment_box" placeholder="댓글을 달려면 로그인이 필요합니다" disabled="disabled"></textarea>
							<% } else {%> 
								<textarea id="comment_box" maxlength="100" name="movie_comment_content"></textarea>
							<% } %></td>
							
							<td class="comment_write_subBtn">
							<% if(id == null || id.equals("") || id.length()==0) { %>
							  	 <input type="button" value="댓글달기" 
								   onclick="window.open('../View/loginForm.jsp', '', 'width=530, height=750,top=0, resizable=no')">
							<% } else {%> 
								<p id="comment_icon"><a href="#" onclick="commentSubmit()">댓글달기</a></p>
							<% } %>
							</td>
						</tr>
					</table>
					<input type="hidden" name="id" value="<%=id%>">
					<input type="hidden" name="idx" value="0">
					<input type="hidden" name="movie_id" value="<%=mb.getMovie_id()%>">
					<input type="hidden" name="action" value="commentWrite">
				</form>
			</div>
		</div>	
	</section>
</article>

<jsp:include page="../include/footer.jsp" />
</body>
</html>