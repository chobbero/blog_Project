<%@page import="board.boardDAO"%>
<%@page import="board.boardBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판 글쓰기</title>
<link href="../css/board.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	function submit() {
		document.getElementById("contentsWriteForm").submit();
	}
 	function reset() {
		document.getElementById("contentsWriteForm").reset();
	}
 	function searchSubmit() {
 		document.getElementById("boardSearch").submit();
 	}
</script>
</head>
<body>
<%
 	request.setCharacterEncoding("utf-8");

	String id = (String) session.getAttribute("id");
	
	if (id == null || id.equals("") || id.length()==0) {
		%><script>
			alert("로그인 해주세요!");
			history.back();
			window.open('../View/loginForm.jsp', '', 'width=530, height=750, top=0, resizable=no');
		</script><%	
	}
	
	int idx = Integer.parseInt(request.getParameter("idx")) ;

	boardDAO bdao = boardDAO.getInstance();
	
	boardBean bb = bdao.getBoard(idx);
	
	if (!id.equals( bb.getId())) {
		%><script>
			alert("글작성자만 수정가능!");
			history.back();
		</script><%	
	}
	
	
	
%>

<jsp:include page="../include/header.jsp" />

<article class="art">
	<section class="view">
		<section>
			<div class="boardTitle">
				<h2 id="boardTitleWord">자유게시판 글수정</h2>
			</div>
		</section>
		
		<section class="boardView">
			<div class="boardWriteForm">
				<form action="../Process/boardUpdatePro.jsp" method="post" id="contentsWriteForm">
					<div>
						<table>
							<tr>
								<td class="wTitle">아이디</td>
								<td id="WriteIdPass"><input type="text" name="id" value="<%=bb.getId() %>" id="blockIdPass" readonly></td>
								<td class="wTitle">패스워드</td>
								<td id="WriteIdPass"><input type="password" name="pass" maxlength="30" id="blockIdPass" required></td>
							</tr>
							
							<tr>
								<td class="wTitle">제목</td>
								<td id="WriteTitle" colspan="3"><input type="text" name="title" maxlength="100" value=<%=bb.getTitle() %> id="blockTitle" required></td>
							</tr>
							
							<tr>
								<td class="wTitle">내용</td>
								<td id="WriteContents" colspan="3"><textarea name="contents" id="blockContents" maxlength="1000"  required><%=bb.getContents() %></textarea></td>
							</tr>
						</table>
					</div>
					<input type="hidden" name=idx value="<%=idx %>">
					<div class="boardMenu">
						<div class="boardInsDelWri">
							<ul>
								<li id="boardIcon"><a href="boardList.jsp">글목록</a></li>
								<li id="boardIcon"><a href="#" onclick="submit()">글수정</a></li>
								<li id="boardIcon"><a href="#" onclick="reset()">초기화</a></li>
							</ul>
						</div>
					</div>
				</form>
			</div>
		</section>
		
		<section class="boardBottom">
		<!-- 글메뉴창 & 글제목 검색 & 글쓴이 검색 -->
			<div class="boardMenu">
				<div class="boardSearch">
					<form action="search.jsp" method="post" name="boardSearch">
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
</article>
	
<aside></aside>
	
<jsp:include page="../include/footer.jsp" />

</body>
</html>