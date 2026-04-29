<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="page-header">
  	<h1>내 정보</h1>
</div>

<div class="tab-header">
  	<button class="tab-btn active" onclick="switchTab(this, '/usr/usr00m01.do')">기본 정보</button>
  	<button class="tab-btn"       onclick="switchTab(this, '/usr/usr00m02.do')">비밀번호 변경</button>
  	<button class="tab-btn"       onclick="switchTab(this, '/usr/usr00m03.do')">회원 탈퇴</button>
</div>

<div id="tabContent"></div>

<script>
	var curUserId = '${sessionScope.USERID}';

	var switchTab = function(el, url) {
	    $('.tab-btn').removeClass('active');
	    $(el).addClass('active');
	    
	    $.ajax({
	        url: url,
	        type: 'POST',
	        data: { USERID: curUserId }, 
	        success: function(res) {
	            $('#tabContent').html(res);
	        }
	    });
	};
	
	$(document).ready(function() {
		$.ajax({
	        url: '/usr/usr00m01.do',
	        type: 'POST',
	        data: { USERID: curUserId },
	        success: function(res) {
	            $('#tabContent').html(res);
	        }
	    });
	});
</script>