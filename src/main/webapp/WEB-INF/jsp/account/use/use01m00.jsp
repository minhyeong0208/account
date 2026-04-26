<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<div class="page-header">
	<h1>연간 정리</h1>
	<div class="year-selector">
       	<select id="yearSelect" onchange="changeYear(this.value)">
       		<option value="2026" selected>2026년</option>
         	<option value="2025">2025년</option>
         	<option value="2024">2024년</option>
         	<option value="2023">2023년</option>
       	</select>
    </div>
</div>

<div class="tab-header">
    <button class="tab-btn active" onclick="switchTab(this, '/use/use01m01.do')">전체 내역</button>
    <button class="tab-btn" onclick="switchTab(this, '/use/use01m02.do')">차트</button>
</div>

<div id="tabContent"></div>
<script>
	var switchTab = function(el, url) {
	    $('.tab-btn').removeClass('active');
	    $(el).addClass('active');
	    
	    $.ajax({
	        url: url,
	        type: 'POST',
	        data: { YEAR: $('#yearSelect').val() },
	        success: function(res) {
	            $('#tabContent').html(res);
	        }
	    });
	};
	
	var changeYear = function(year) {
	    var activeBtn = $('.tab-btn.active');
	    var url = activeBtn.attr('onclick').replace("switchTab(this, '", "").replace("')", "");

	    $.ajax({
	        url: url,
	        type: 'POST',
	        data: { YEAR: year },
	        success: function(res) {
	            $('#tabContent').html(res);
	        }
	    });
	};
	
	$(document).ready(function() {
		$.ajax({
	        url: '/use/use01m01.do',
	        data: { YEAR: $('#yearSelect').val() },
	        type: 'POST',
	        success: function(res) {
	            $('#tabContent').html(res);
	        }
	    });
	});
</script>