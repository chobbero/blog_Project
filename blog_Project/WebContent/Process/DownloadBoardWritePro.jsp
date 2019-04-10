<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="member.memberDAO"%>
<%@page import="download_board.DownloadBoardBean"%>
<%@page import="download_board.DownloadBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자료실 글쓰기</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	String uploadPath = request.getSession().getServletContext().getRealPath("/uploadFiles"); // 파일 업로드시 서버에 저장할 경로
	out.println("절대경로 : " + uploadPath + "<br/>");

	int maxFileSize = 1024 * 1024 * 10; // 용량 제한 10MB로 설정
	
	String fileName = ""; 
	String originalFileName = ""; 
	String fileType = "";
	long fileSize = 0;
	
	// 파일저장경로, 최대 용량, 인코딩, 중복파일명 기본 정책
	MultipartRequest multi = new MultipartRequest(request,uploadPath,maxFileSize,"utf-8",new DefaultFileRenamePolicy());
	
	memberDAO mdao = memberDAO.getInstance();
	
	String id = multi.getParameter("id"); 
	String pass = multi.getParameter("pass");
	
    int check = mdao.userCheck(id, pass); // 사용자 확인
	
    if (check == 1) {
    	
    	try {
    	
    		Enumeration files = multi.getFileNames();
    	
    		while(files.hasMoreElements()){
           	    // form 태그에서 <input type="file" name="여기에 지정한 이름" />을 가져온다.
           		String file1 = (String)files.nextElement(); // 파일 input에 지정한 이름을 가져옴
           		// 그에 해당하는 실제 파일 이름을 가져옴
          		originalFileName = multi.getOriginalFileName(file1); // 중복처리되기전 파일명
          		 // 파일명이 중복될 경우 중복 정책에 의해 뒤에 1,2,3 처럼 붙어 unique하게 파일명을 생성하는데
                // 이때 생성된 이름을 filesystemName이라 하여 그 이름 정보를 가져온다.(중복에 대한 처리)
                fileName = multi.getFilesystemName(file1);
          		// 파일 타입 정보를 가져옴
           		fileType = multi.getContentType(file1); // 파일의 형식
            	// input file name에 해당하는 실제 파일을 가져옴
           		File uploadFile = multi.getFile(file1);
           		// 그 파일 객체의 크기를 알아냄
           		fileSize = uploadFile.length(); 
    		}
    	} catch(Exception e) {
            e.printStackTrace();
        }
    	 
    	DownloadBoardDAO dbdao = DownloadBoardDAO.getInstance();
    	
    	DownloadBoardBean dbb = new DownloadBoardBean();
    	
    	dbb.setId(multi.getParameter("id"));
    	dbb.setPass(multi.getParameter("pass"));
    	dbb.setTitle(multi.getParameter("title"));
    	dbb.setContents(multi.getParameter("contents"));
    	dbb.setOriginalFileName(originalFileName);
    	dbb.setFileName(fileName);
    	dbb.setViewCount(0); 
    	dbb.setDownloadCount(0);
    	
    	int result = dbdao.insert(dbb);

    	if(result==1) {
    		%><script>
    			alert("글쓰기 완료");
    			location.href='../View/DownloadBoardList.jsp';
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