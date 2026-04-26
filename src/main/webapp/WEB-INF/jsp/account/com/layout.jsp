<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="<c:url value='/css/account/common.css'/>">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<title>가계부</title>
</head>
<body>
<div class="layout">

    <jsp:include page="/WEB-INF/jsp/account/com/sidebar.jsp"/>
    
    <div class="main">
	 	<jsp:include page="/WEB-INF/jsp/account/com/top.jsp"/>
		<div id="content" class="content"></div>
    </div>

</div>
<script>
$(document).ready(function() {
    loadContent('/use/use00m00.do');
});

function loadContent(url) {
    $.ajax({
        url: url,
        type: 'POST',
        success: function(res) {
            $('#content').html(res);
        },
        error: function(xhr) {
            console.log(xhr.status, xhr.responseText);
        }
    });
}
</script>
</body>
</html>