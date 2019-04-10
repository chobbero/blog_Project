<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자료실 글쓰기</title>
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
			window.open('../View/loginForm.jsp?action=dbw', '', 'width=530, height=750,top=0, resizable=no');
		</script><%	
	}
%>
<jsp:include page="../include/header.jsp" />
	
<article class="art">
	<section class="view">
		<section>
			<div class="boardTitle">
				<h2 id="boardTitleWord">자료실 글쓰기</h2>
			</div>
		</section>
		
		<section class="boardView">
			<div class="boardWriteForm">
				<form action="../Process/DownloadBoardWritePro.jsp" method="post" enctype="Multipart/form-data" id="contentsWriteForm">
					<div>
						<table>
							<tr>
								<td class="wTitle">아이디</td>
								<td id="WriteIdPass"><input type="text" name="id" value="<%=id%>" id="blockIdPass" readonly></td>
								<td class="wTitle">패스워드</td>
								<td id="WriteIdPass"><input type="password" name="pass" maxlength="30" id="blockIdPass" required></td>
							</tr>
							
							<tr>
								<td class="wTitle">제목</td>
								<td id="WriteTitle" colspan="3"><input type="text" name="title" maxlength="100"  id="blockTitle" required></td>
							</tr>
							
							<tr>
								<td class="wTitle">내용</td>
								<td id="WriteContents" colspan="3"><textarea name="contents" id="blockContents" maxlength="1000" required></textarea></td>
							</tr>
							
							<tr>
								<td class="wTitle">첨부파일</td>
								<td id="WriteFile" colspan="3"><input type="file" name="fileName" required> 파일용량은 10mb이하</td>
							</tr>
						</table>
					</div>
					
					<div class="boardMenu">
						<div class="boardInsDelWri">
							<ul>
								<li id="boardIcon"><a href="DownloadBoardList.jsp">글목록</a></li>
								<li id="boardIcon"><a href="#" onclick="submit()">글쓰기</a></li>
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