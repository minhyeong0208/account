<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<nav class="sidebar">
	<div class="sidebar-logo">💰 가계부</div>
	<div class="sidebar-section">가계부</div>
	<ul class="sidebar-menu">
    <li>
      <a href="#" onclick="loadContent('/use/use00m00.do'); return false;">
        <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" style="vertical-align:middle;margin-right:6px;opacity:0.7">
          <rect x="1" y="1" width="6" height="6" rx="1"/>
          <rect x="9" y="1" width="6" height="6" rx="1"/>
          <rect x="1" y="9" width="6" height="6" rx="1"/>
          <rect x="9" y="9" width="6" height="6" rx="1"/>
        </svg>
        월별 내역
      </a>
    </li>
    <li>
      <a href="#" onclick="loadContent('/use/use01m00.do'); return false;">
        <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" style="vertical-align:middle;margin-right:6px;opacity:0.7">
          <path d="M2 4h12v1H2zm0 4h12v1H2zm0 4h8v1H2z"/>
        </svg>
        연간 정리
      </a>
    </li>
  </ul>
	
	<hr class="sidebar-divider">

  <div class="sidebar-section">관리</div>
  <ul class="sidebar-menu">
    <li>
      <a href="#" onclick="loadContent('/svg/svg00m00.do'); return false;">
        <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" style="vertical-align:middle;margin-right:6px;opacity:0.7">
          <circle cx="8" cy="8" r="6"/>
          <path d="M8 5v3l2 2"/>
        </svg>
        사용처 관리
      </a>
    </li>
    <li>
      <a href="#" onclick="loadContent('/svg/svg01m00.do'); return false;">
        <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" style="vertical-align:middle;margin-right:6px;opacity:0.7">
          <rect x="2" y="3" width="12" height="10" rx="1"/>
          <path d="M5 3V2M11 3V2M2 7h12"/>
        </svg>
        계좌 관리
      </a>
    </li>
    <li>
      <a href="#">
        <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" style="vertical-align:middle;margin-right:6px;opacity:0.7">
          <path d="M3 13V7l5-5 5 5v6H3z"/>
        </svg>
        적금 관리
      </a>
    </li>
  </ul>
  
   <hr class="sidebar-divider">

  <div class="sidebar-section">설정</div>
  <ul class="sidebar-menu">
    <li>
      <a href="#">
        <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" style="vertical-align:middle;margin-right:6px;opacity:0.7">
          <circle cx="8" cy="6" r="3"/>
          <path d="M2 14c0-3 2.7-5 6-5s6 2 6 5"/>
        </svg>
        내 정보
      </a>
    </li>
  </ul>
	
</nav>
<script>
$(document).ready(function() {
	$('.sidebar-menu li a').first().closest('li').addClass('active');
	
    $('.sidebar-menu li a').on('click', function() {
        $('.sidebar-menu li').removeClass('active');
        $(this).closest('li').addClass('active');
    });
});
</script>