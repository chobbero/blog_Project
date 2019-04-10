
<%@page import="board.boardBean"%>
<%@page import="board.boardDAO"%>
<%@page import="board.commentBean"%>
<%@page import="java.util.List"%>
<%@page import="board.commentDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글제목가져오기</title>
<link href="../css/board.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
	function login () {
		window.open('../View/loginForm.jsp', '', 'width=530, height=750, top=0, resizable=no');
	}
	function Writelogin () {
		window.open('../View/loginForm.jsp?action=bw', '', 'width=530, height=750, top=0, resizable=no');
	}
	
 	function commentDeleteSubmit() {
 		document.getElementById("commentDeleteForm").submit();
	}
 	function commentSubmit() {
 		document.getElementById("commentWriteForm").submit();
 	}
 	function searchSubmit() {
 		document.getElementById("boardSearch").submit();
 	}
</script>

</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	int check = 0;

	boardDAO bdao = boardDAO.getInstance();
	
	String id = (String)session.getAttribute("id");
	
	int idx = Integer.parseInt(request.getParameter("idx"));
	
	bdao.updateView(idx); // 해당 글번호의 조회수증가
	
	boardBean bb = bdao.getBoard(idx); // 해당 글번호의 내용 가져오기
	
	if (bb==null) {
		%><script type="text/javascript">
		alert("잘못된 접근");
		location.href="boardList.jsp";
		</script>
		<%
	}
	
	commentDAO cdao = commentDAO.getInstance(); // 댓글 인스턴스 생성
	
	int commentCount = cdao.CommentCount(idx); // 댓글갯수 계산
%>

<jsp:include page="../include/header.jsp" />
	
<article class="art">
	<section class="view">
	
		<section>
			<div class="boardTitle">
				<h3 id="boardTitleWord">자유게시판</h3>
				<h2 id="boardTitleWord">글제목 [<%=bb.getTitle() %>]</h2>
			</div>
		</section>
		
		<section>
			<div class="boardView">
				<table>
					<tr>
						<td class="wTitle">아이디</td>
						<td><input type="text" name="id" value="<%=bb.getId() %>" id="blockIdPass" readonly></td>
					
						<td class="wTitle">조회수</td>
						<td><input type="text" name="viewCount" id="blockIdPass" value="<%=bb.getViewCount() %>" readonly></td>
					
						<td class="wTitle">작성시간</td>
						<td><input type="text" name="viewCount" id="blockIdPass"	value="<%=bb.getwTime() %>" readonly></td>
					</tr>
					
					<tr><td class="wTitle">제목</td>
					<td colspan="5"><input type="text" name="title" id="blockTitle" value="<%=bb.getTitle() %>" readonly></td></tr>
					
					<tr><td class="wTitle">내용</td>
					<td colspan="5"><textarea id="blockContents" readonly><%=bb.getContents() %></textarea></td></tr>
				</table>
			</div>
		</section>
		
		<section class="boardBottom">
			<!-- 글메뉴창 & 글제목 검색 & 글쓴이 검색 -->
			<div class="boardMenu">
				<div class="boardInsDelWri">
					<ul>
						<%if (id == null || id.equals("") || id.length()==0) {%>
							<li id="boardIcon"><a href="#" onclick="login()">글수정</a></li>
							<li id="boardIcon"><a href="#" onclick="login()">글삭제</a></li>
							<li id="boardIcon"><a href="#" onclick="Writelogin()">글쓰기</a></li>
						<%} else { %>
							<li id="boardIcon"><a href="boardUpdate.jsp?idx=<%=idx%>">글수정</a></li>
							<li id="boardIcon"><a onclick="window.open('../View/BoardpassCheck.jsp?action=boardDel&idx=<%=idx%>', '', 'width=530, height=940, top=0, resizable=no')" >글삭제</a></li>
							<li id="boardIcon"><a href="bWForm.jsp">글쓰기</a></li>
						<%} %>
					</ul>
				</div>
				
				<div class="boardSearch">
					<form action="search.jsp" method="post" id="boardSearch">
						<input type="search" name="search" class="searchIrt" maxlength="10" placeholder="10자 이내">
						<div class="boardInsDelWri">
							<ul>
								<li id="boardIcon"><a href="#" onclick="searchSubmit()">검색</a></li>
							</ul>
						</div>
					</form>
				</div>
			</div>
		</section>
	</section>
		
		<hr size="7" width="790" color="#c6ffc6">
		
	<section class="view">
		<section>
		<!-- 댓글이 있을때만 표시 -->
		<h3 class="commentCount">전체 댓글 갯수 : [<%=commentCount %>]</h3>
		<div class="boardView">
			<%if (commentCount > 0) { // 댓글 가져오기
				List commentList = cdao.commentList(idx); %> 
				<table>
				<% for (int i = 0; i < commentList.size(); i++) {
					commentBean cb = (commentBean)commentList.get(i);%> 
					<tr>
						<td class="wTitle"><img src="../img/arrow_orange.gif"><%=cb.getId()%></td>
							
					    <td class="commentContents" style="word-break:break-all;"><%=cb.getContents()%></td>
						    
					    <td class="wTitle"><%=cb.getwTime()%></td>
						    
					    <td class="wTitle">
					    	<form action="../Process/commentPro.jsp" method="post" id="commentDeleteForm">
						   		<% if(id == null || id.equals("") || id.length()==0) { %>
						   			<a href="#" onclick="window.open('../View/loginForm.jsp', '', 'width=530, height=750,top=0, resizable=no')">댓글삭제
						   			</a>
								<% } else {%> 
									<input type="hidden" name="id" value="<%=id%>">
									<input type="hidden" name="idx" value="<%=cb.getIdx()%>">
									<input type="hidden" name="pBoardIdx" value="<%=bb.getIdx()%>">	
									<input type="hidden" name="commentContent" value=" ">
									<input type="hidden" name="action" value="commentDelete">
									<a href="#" onclick="commentDeleteSubmit();">댓글삭제</a>
								<% } %>
					    	</form>
					    </td>
					</tr>
				<%}%>
			</table>
			<%}%>
		</div>
			
			<!-- 댓글 쓰는 폼 -->
		<div class="boardView">
			<form action="../Process/commentPro.jsp" method="post" id="commentWriteForm">
				<table id="commentWrite">
					<tr>
						<td class="commentWriteBox">
							<% if(id == null || id.equals("") || id.length()==0) { %>
							    <textarea class="commentBox" placeholder="댓글을 달려면 로그인이 필요합니다" disabled="disabled"></textarea>
							<% } else {%> 
								<textarea class="commentBox" maxlength="200" name="commentContent"></textarea>
							<% } %></td>
							
							<td class="commentWriteSubmitBtn">
							<% if(id == null || id.equals("") || id.length()==0) { %>
							  	 <input type="button" value="댓글달기" 
								   onclick="window.open('../View/loginForm.jsp', '', 'width=530, height=750,top=0, resizable=no')">
							<% } else {%> 
								<div class="boardInsDelWri">
									<ul>
										<li id="boardIcon"><a href="#" onclick="commentSubmit()">댓글달기</a></li>
									</ul>
								</div>
							<% } %>
							</td>
						</tr>
					</table>
					<input type="hidden" name="id" value="<%=id%>">
					<input type="hidden" name="idx" value="0">
					<input type="hidden" name="pBoardIdx" value="<%=bb.getIdx()%>">
					<input type="hidden" name="action" value="commentWrite">
				</form>
			</div>
		</section>
	
		<section>
			<div class="boardInsDelWri">
				<ul>
					<li  id="boardIcon"><a href="boardList.jsp">글목록</a></li>
				</ul>
			</div>
		</section>
	</section>	
</article>

<aside></aside>

<jsp:include page="../include/footer.jsp" />
</body>
</html>