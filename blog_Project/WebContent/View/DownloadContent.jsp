<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="download_board.DownloadCommentBean"%>
<%@page import="download_board.DownloadCommentDAO"%>
<%@page import="download_board.DownloadBoardBean"%>
<%@page import="download_board.DownloadBoardDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글제목가져오기</title>
<link href="../css/board.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
	function Writelogin () {
		window.open('../View/loginForm.jsp?action=dbw', '', 'width=530, height=750, top=0, resizable=no');
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

	DownloadBoardDAO dbdao = DownloadBoardDAO.getInstance();
	
	String id = (String)session.getAttribute("id");
	
	int idx = Integer.parseInt(request.getParameter("idx"));
	
	dbdao.updateDownloadView(idx); // 해당 글번호의 조회수증가
	
	DownloadBoardBean dbb = dbdao.getDownloadBoard(idx); // 해당 글번호의 내용 가져오기
	
	if (dbb==null) {
		%><script type="text/javascript">
		alert("잘못된 접근");
		location.href="DownloadBoardList.jsp";
		</script><%	
	}
	
	DownloadCommentDAO dcdao = DownloadCommentDAO.getInstance(); // 댓글 인스턴스 생성
			
	int DownloadCommentCount = dcdao.DownloadCommentCount(idx); // 댓글갯수 계산
	
	%>

<jsp:include page="../include/header.jsp" />
	
<article class="art">
	<section class="view">
		<section>
			<div class="boardTitle">
				<h3 id="boardTitleWord">자료게시판</h3>
				<h2 id="boardTitleWord">글제목 : [<%=dbb.getTitle() %>]</h2>
			</div>
		</section>
		
		<section>
			<div class="boardView">
				<table>
					<tr>
						<td class="wTitle">아이디</td>
						<td><input type="text" name="id" value="<%=dbb.getId() %>" id="blockIdPass" readonly></td>
						
						<td class="wTitle">조회수</td>
						<td><input type="text" name="viewCount" id="blockIdPass" value="<%=dbb.getViewCount() %>" readonly></td>
						
						<td class="wTitle">작성시간</td>
						<td><input type="text" name="viewCount" id="blockIdPass" value="<%=dbb.getwTime() %>" readonly></td>
					</tr>
					
					<tr><td class="wTitle">제목</td>
					<td  colspan="5"><input type="text" name="title" id="blockTitle" value="<%=dbb.getTitle() %>" readonly></td></tr>
					
					<tr><td class="wTitle">내용</td>
					<td colspan="5"><textarea id="blockContents" readonly><%=dbb.getContents() %></textarea></td></tr>
					
					<tr>
						<td class="wTitle">첨부파일</td>
						<td colspan="5"><a href="#" id="Download"><%=dbb.getOriginalFileName() %></a> 
						<script type="text/javascript">
        				    document.getElementById("Download").addEventListener("click", function(event) {
           					event.preventDefault();  // a 태그의 기본 동작을 막음
           					event.stopPropagation(); // 이벤트의 전파를 막음
           					var fName = encodeURIComponent("<%=dbb.getFileName()%>"); // fileName을 utf-8로 인코딩한다.
            				// 인코딩된 파일이름을 쿼리문자열에 포함시켜 다운로드 페이지로 이동
           					window.location.href = "../Process/DownloadPro.jsp?fileName="+fName; 
       						});
   						</script>
						</td>
					</tr>
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
							<li id="boardIcon"><a href="DownloadBoardUpdateForm.jsp?idx=<%=idx%>">글수정</a></li>
							<li id="boardIcon"><a onclick="window.open('../View/BoardpassCheck.jsp?action=DownloadBoardDel&idx=<%=idx%>', '', 'width=530, height=940, top=0, resizable=no')" >글삭제</a></li>
							<li id="boardIcon"><a href="DownloadBoardWriteForm.jsp">글쓰기</a></li>
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
				<h3 class="commentCount">전체 댓글 갯수 : [<%=DownloadCommentCount %>]</h3>
				<div class="boardView">
				<%if (DownloadCommentCount > 0) { // 댓글 가져오기
					List DownloadCommentList = dcdao.DownloadCommentList(idx); %> 
					<table>
					<% for (int i = 0; i < DownloadCommentList.size(); i++) {
						DownloadCommentBean dcb = (DownloadCommentBean)DownloadCommentList.get(i);%> 
						<tr>
							<td class="wTitle"><%=dcb.getId()%><img src="../img/arrow_orange.gif"></td>
							
						    <td class="commentContents" style="word-break:break-all;"><%=dcb.getContents()%></td>
						    
						    <td class="wTitle"><%=dcb.getwTime()%></td>
						    
						    <td class="wTitle">
						    	<form action="../Process/DownloadCommentPro.jsp" method="post" id="commentDeleteForm">
						    		<% if(id == null || id.equals("") || id.length()==0) { %>
								  	    <input type="button" value="댓글삭제" 
									    onclick="window.open('../View/loginForm.jsp', '', 'width=530, height=750,top=0, resizable=no')">
									<% } else {%> 
										<input type="hidden" name="id" value="<%=id%>">
										<input type="hidden" name="idx" value="<%=dcb.getIdx()%>">
										<input type="hidden" name="pDownBoardIdx" value="<%=dbb.getIdx()%>">	
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
			<form action="../Process/DownloadCommentPro.jsp" method="post" id="commentWriteForm">
				<table id="commentWrite">
					<tr>
						<td class="commentWriteBox">
							<% if(id == null || id.equals("") || id.length()==0) { %>
								   <textarea class="commentBox" placeholder="댓글을 달려면 로그인이 필요합니다" disabled="disabled"></textarea>
							<% } else {%> 
							       <textarea class="commentBox" maxlength="200" name="commentContent" required></textarea>
							<% } %></td>
							
							<td class="commentWriteSubmitBtn">
							<% if(id == null || id.equals("") || id.length()==0) { %>
								   <input type="button" value="댓글달기" 
								   onclick="window.open('../View/loginForm.jsp', '', 'width=530, height=750,top=0 resizable=no')">
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
					<input type="hidden" name="pDownBoardIdx" value="<%=idx%>">
					<input type="hidden" name="action" value="commentWrite">
				</form>
			</div>
		</section>
		
		<section>
			<div class="boardInsDelWri">
				<ul>
					<li id="boardIcon"><a href="DownloadBoardList.jsp">글목록</a></li>
				</ul>
			</div>
		</section>
	</section>
</article>
<aside></aside>
	
<jsp:include page="../include/footer.jsp" />
</body>
</html>