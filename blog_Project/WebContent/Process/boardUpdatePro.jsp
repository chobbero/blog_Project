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
	
    int idx = Integer.parseInt(request.getParameter("idx"));
    
    if (check==1) {
    	
    	boardDAO bdao = boardDAO.getInstance();
    	
    	boardBean bb = new boardBean();
    	
    	bb.setIdx(idx);
    	bb.setId(request.getParameter("id"));
    	bb.setPass(request.getParameter("pass"));
    	bb.setTitle(request.getParameter("title"));
    	bb.setContents(request.getParameter("contents"));
    	
    	int result = bdao.update(bb);
    	
    	if(result==1) {
    		%><script>
    			alert("글수정 완료");
    			location.href='../View/content.jsp?idx=<%=idx%>';
    		</script><%
    	} else if (result==0) {
    		%><script>
    		alert("DB오류");
    		history.back();
    	</script><%
    	} else {
    		%><script>
    		alert("글수정 실패");
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