<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<link rel="stylesheet" href="<c:url value='/css/account/savings.css'/>">
<div class="page-header">
	<h1>적금 관리</h1>
	<button class="toolbar-btn toolbar-btn-primary" onclick="goList()">목록</button>
</div>
<div class="detail-layout">
	<div class="info-panel">
		<div class="info-panel-header">
			<h2>${savings.SAVINGNM}</h2>
			<c:choose>
              	<c:when test="${savings.STATUS == 'A'}"><span class="badge badge-active">진행 중</span></c:when>
              	<c:otherwise><span class="badge badge-done">완료</span></c:otherwise>
            </c:choose>
		</div>
		<div class="info-panel-body">
			<div class="info-row">
              	<span class="info-label">은행</span>
              	<span class="info-value">${savings.BANKNAME}</span>
           	</div>
           	<div class="info-row">
              	<span class="info-label">월 납입액</span>
              	<span class="info-value"><fmt:formatNumber value="${savings.PAYMENTAMOUNT}" pattern="#,###"/>원</span>
            </div>
            <div class="info-row">
              	<span class="info-label">금리</span>
              	<span class="info-value">${savings.INTERESTRATE}%</span>
            </div>
            <div class="info-row">
              	<span class="info-label">가입일</span>
              	<span class="info-value">${savings.JOINDATE}</span>
            </div>
            <div class="info-row">
              	<span class="info-label">만기일</span>
              	<span class="info-value">${savings.EXPIRATIONDATE}</span>
            </div>
            <c:if test="${not empty savings.MEMO}">
              	<div class="info-row">
                	<span class="info-label">메모</span>
                	<span class="info-value">${savings.MEMO}</span>
              	</div>
            </c:if>
            <div class="stat-grid">
              	<div class="stat-card accent">
                	<div class="stat-label">총 납입액</div>
                	<div class="stat-value"><fmt:formatNumber value="${savings.TOTAL_PAID_AMOUNT}" pattern="#,###"/>원</div>
              	</div>
              	<div class="stat-card success">
                	<div class="stat-label">예상 수령액</div>
                	<div class="stat-value"><fmt:formatNumber value="${savings.EXPECTED_AMOUNT}" pattern="#,###"/>원</div>
              	</div>
            </div>
            
            <div class="progress-wrap">
              	<div class="progress-label">
                	<span>납입 진행률</span>
                	<span>${savings.PAID_MONTHS} / ${savings.TOTAL_MONTHS}개월</span>
              	</div>
              	<div class="progress-bar">
                	<div class="progress-fill" style="width:${savings.PROGRESS_PCT}%"></div>
              	</div>
              	<div class="progress-sub">예상 이자 <fmt:formatNumber value="${savings.EXPECTED_INTEREST}" pattern="#,###"/>원</div>
            </div>
		</div>
	</div>
	<div class="payment-panel">
		<div class="tab-header">
        	<button class="tab-btn active" onclick="switchTab(this, '/svg/svg03m01.do', 'R')">정기 납입</button>
            <button class="tab-btn" onclick="switchTab(this, '/svg/svg03m02.do', 'A')">추가 납입</button>
        </div>
        
        <div id="tabContent"></div>
	</div>
</div>
<script>
	var savingsId = '${savings.SAVINGSID}';

	var switchTab = function(el, url, type) {
		$('.tab-btn').removeClass('active');
	    $(el).addClass('active');
	    
	    $.ajax({
	        url: url,
	        type: 'POST',
	        data: { SAVINGSID: savingsId, TYPE: type},
	        success: function(res) {
	            $('#tabContent').html(res);
	        }
	    });
	}
	
	var goList = function() {
		loadContent('/svg/svg02m00.do', { SAVINGSID: savingsId });
	}
	
	$(document).ready(function() {
	    switchTab($('.tab-btn').first(), '/svg/svg03m01.do', 'R');
	});
</script>
