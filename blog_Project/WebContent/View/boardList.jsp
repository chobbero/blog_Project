<%@page import="board.commentDAO"%>
<%@page import="board.boardBean"%>
<%@page import="java.util.List"%>
<%@page import="board.boardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글목록</title>
<link href="../css/board.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	function login () {
		window.open('../View/loginForm.jsp?action=bw', '', 'width=530, height=750, top=0, resizable=no');
	}
 	function searchSubmit() {
 		document.getElementById("boardSearch").submit();
 	}
</script>
</head>
<body>
<!-- 글내용 미리보기 구현 -->
<%
	request.setCharacterEncoding("utf-8");

	String id = (String)session.getAttribute("id");
	
	boardDAO bdao = boardDAO.getInstance();

	int count = bdao.getBoardCount(); // 글 갯수 저장

	int pageContentsNum=8; // 한페이지 보여줄 글 개수 설정

	String pageNum = request.getParameter("pageNum");
	
	if(pageNum==null){
		pageNum="1";
	}
	//시작하는 행 계산하기
	int currentPage = Integer.parseInt(pageNum);

	int startRow = (currentPage - 1) * pageContentsNum + 1; // 시작 행 구하기
	
	int endRow = pageContentsNum * currentPage; // 마지막 행 구하기
	
	List boardList = null; // 게시판 글 가져와서 저장할 변수
	
	if(count!=0){ 
		boardList = bdao.getBoardList(startRow, pageContentsNum); // 시작 열 부터 표시할 행만큼 찾기
	}
	
	commentDAO cdao = commentDAO.getInstance();
	 
%>
<jsp:include page="../include/header.jsp" />
	
<article class ="art">
	<section class="view">
		<section>
			<div class="boardTitle">
				<h2 id="boardTitleWord">자유게시판 글목록 [ 전체글개수 : <%=count %>개의 글 ]</h2>
			</div>
		</section>
		
		<section class="boardView">
			<div>
				<table>
					<tr>
						<td class="no">번호</td>
						<td class="title">제목</td>
						<td class="written">작성자</td>
						<td class="time">작성일</td>
						<td class="viewCount">조회</td>
					</tr>
					
					<%if(count != 0){
							for(int i = 0; i < boardList.size(); i++){
						
							boardBean bb = (boardBean)boardList.get(i);
							%>
					<tr>
						<td class="listNo"><%=bb.getIdx() %></td>
						
    					<td class="listTitle" rowspan="1">
    						<a href="content.jsp?idx=<%=bb.getIdx()%>"><%=bb.getTitle()%> [<%=cdao.CommentCount(bb.getIdx())%>]</a>
    					</td>
    					
   						<td class="listWritten"><%=bb.getId() %></td>
   						
   						<td class="listTime"><%=bb.getwTime() %></td>
   						
   						<td class="listViewCount"><%=bb.getViewCount() %></td>
   					</tr><%}}%>
				</table>
			</div>
			
			<div class="boardPage">	
				<!-- 글 페이지란 -->
				
				<%if (count != 0) {
					
					int pageCount= (count/pageContentsNum) + (count%pageContentsNum==0?0:1);
					int pageBlock=3;
					int startPage=((currentPage-1)/pageBlock)*pageBlock+1;
					int endPage=startPage+pageBlock-1;
				
    				if(endPage > pageCount) {
    					endPage = pageCount;
    				}
   				
   			 		if(startPage > pageBlock){%>
    					<a href="boardList.jsp?pageNum=<%=startPage-pageBlock%>">[이전]</a>
  			 	   <%}
   				
  			   	   for(int i=startPage; i <= endPage; i++) {%>
    					<a href="boardList.jsp?pageNum=<%=i%>">[<%=i %>]</a>
  			  	   <%}
  			    
  			  	   if(endPage < pageCount){%>
   			     		<a href="boardList.jsp?pageNum=<%=startPage+pageBlock%>">[다음]</a>
   			   	   <%}
				}%>
			</div>
		</section>
		
		<section class="boardBottom">
			<!-- 글메뉴창 & 글제목 검색 & 글쓴이 검색 -->
			<div class="boardMenu">
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
				
				<div class="boardInsDelWri">
					<ul>
						<%if (id == null || id.equals("") || id.length()==0) {%>
							<li id="boardIcon"><a href="#" onclick="login()">글쓰기</a></li>
						<%} else { %>
							<li id="boardIcon"><a href="bWForm.jsp">글쓰기</a></li>
						<%} %>
					</ul>
				</div>
			</div>
		</section>
	</section>
</article>
	
<aside></aside>
	
<jsp:include page="../include/footer.jsp" />

</body>
</html>