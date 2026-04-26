<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>

<div class="summary-cards">
    <div class="s-card income">
        <div class="s-label">연간 수입계</div>
        <div class="s-value"><fmt:formatNumber value="${totalIncome}" pattern="#,###"/></div>
        <div class="s-sub">원</div>
    </div>
    <div class="s-card expense">
        <div class="s-label">연간 지출계</div>
        <div class="s-value"><fmt:formatNumber value="${totalExpense}" pattern="#,###"/></div>
        <div class="s-sub">원</div>
    </div>
    <div class="s-card balance">
        <div class="s-label">연간 잔액</div>
        <div class="s-value"><fmt:formatNumber value="${totalBalance}" pattern="#,###"/></div>
        <div class="s-sub">원</div>
    </div>
</div>

<!-- 테이블 -->
<div class="table-card">
    <div class="table-scroll">
        <table>
            <thead>
                <tr>
                    <th>구분</th>
                    <th>1월</th><th>2월</th><th>3월</th><th>4월</th>
                    <th>5월</th><th>6월</th><th>7월</th><th>8월</th>
                    <th>9월</th><th>10월</th><th>11월</th><th>12월</th>
                    <th class="annual">연계</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="row" items="${rows}">
                    <c:choose>

                        <c:when test="${row.type == 'section'}">
                            <tr class="section-header">
                                <td colspan="14">▸ ${row.label}</td>
                            </tr>
                        </c:when>

                        <c:when test="${row.type == 'spacer'}">
                            <tr class="spacer"><td colspan="14"></td></tr>
                        </c:when>

                        <c:otherwise>
                            <tr class="${row.trClass}">
                                <td>${row.label}</td>
                                <c:forEach var="m" items="${months}">
                                    <td>
                                        <c:set var="amt" value="${row.months[m]}"/>
                                        <c:choose>
                                            <c:when test="${row.trClass == 'carry-row' or row.trClass == 'balance-row'}">
                                                <c:if test="${amt != null}">
                                                    <fmt:formatNumber value="${amt}" pattern="#,###"/>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <c:if test="${amt != null and amt != 0}">
                                                    <fmt:formatNumber value="${amt}" pattern="#,###"/>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:forEach>
                                <td class="annual">
                                    <c:choose>
                                        <c:when test="${row.annual == null}">-</c:when>
                                        <c:when test="${row.annual == 0}">0</c:when>
                                        <c:otherwise><fmt:formatNumber value="${row.annual}" pattern="#,###"/></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:otherwise>

                    </c:choose>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>