<%@page import="board.boardBean"%>
<%@page import="board.boardDAO"%>
<%@page import="member.memberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판 글쓰기</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	memberDAO mdao = memberDAO.getInstance();
	
    int check = mdao.userCheck(request.getParameter("id"), request.getParameter("pass"));
	
    if (check==1) {
    	
    	boardDAO bdao = boardDAO.getInstance();
    	
    	boardBean bb = new boardBean();
    	
    	bb.setId(request.getParameter("id"));
    	bb.setPass(request.getParameter("pass"));
    	bb.setTitle(request.getParameter("title"));
    	bb.setContents(request.getParameter("contents"));
    	bb.setViewCount(0);
    	
    	int result = bdao.insert(bb);
    	
    	if(result==1) {
    		%><script>
    			alert("글쓰기 완료");
    			location.href='../View/boardList.jsp';
    		</script><%
    	} else if (result==0) {
    		%><script>
    		alert("글쓰기 실패");
    		history.back();
    	</script><%
    	} else {
    		%><script>
    		alert("글쓰기 실패?");
    		history.back();
    	</script><%
    	}
    } else {
    	%><script>
    		alert("비밀번호 틀림");
    		history.back();
    	</script><%
    }
%>

</body>
</html>