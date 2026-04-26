<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>

<!-- 요약 카드 -->
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

<!-- 차트 -->
<div class="table-card" style="padding:20px;">
    <canvas id="annualChart"></canvas>
</div>

<script>
    // JSTL → JS 배열 변환
    var incomeData  = [
        <c:forEach var="i" begin="1" end="12" varStatus="s">
            ${incomeByMonth[i]}<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];
    var expenseData = [
        <c:forEach var="i" begin="1" end="12" varStatus="s">
            ${expenseByMonth[i]}<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];

    var ctx = document.getElementById('annualChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
            datasets: [
                {
                    label: '수입',
                    data: incomeData,
                    backgroundColor: '#E6F1FB',
                    borderColor: '#185FA5',
                    borderWidth: 1.5,
                    borderRadius: 4
                },
                {
                    label: '지출',
                    data: expenseData,
                    backgroundColor: '#FCEBEB',
                    borderColor: '#A32D2D',
                    borderWidth: 1.5,
                    borderRadius: 4
                }
            ]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { font: { size: 12 } }
                },
                tooltip: {
                    callbacks: {
                        label: function(ctx) {
                            return ctx.dataset.label + ': ' + ctx.parsed.y.toLocaleString('ko-KR') + '원';
                        }
                    }
                }
            },
            scales: {
                y: {
                    ticks: {
                        callback: function(val) {
                            return val.toLocaleString('ko-KR') + '원';
                        }
                    }
                }
            }
        }
    });
</script>