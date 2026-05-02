<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<div class="payment-list">
	<c:forEach var="p" items="${detail}">
		<c:choose>
			<%-- 납입이 된 경우 --%>
			<c:when test="${p.IS_PAID == 'Y'}">
				<div class="payment-row is-paid">
					<span class="payment-month">${p.PAYMONTH}</span>
					<div class="payment-right">
						<span class="paid-date">${p.PAYDATE}</span>
                        <span class="badge-paid">완료</span>
                        <button class="btn-check" onclick="checkPayment('${p.HISTORYID}', '${p.SAVINGSID}')">취소</button>
					</div>
				</div>
			</c:when>
			<c:when test="${p.IS_CURRENT == 'Y'}">
				<div class="payment-row is-current">
					<span class="payment-month">${p.PAYMONTH}</span>
                   	<div class="payment-right">
                     	<span class="badge-unpaid">미납입</span>
                     	<button class="btn-check" onclick="checkPayment('${p.HISTORYID}', '${p.SAVINGSID}')">납입 체크</button>
                   	</div>
				</div>
			</c:when>
			<c:otherwise>
            	<div class="payment-row">
                	<span class="payment-month">${p.PAYMONTH}</span>
                    <div class="payment-right">
                    	<span class="badge-plan">예정</span>
                    </div>
                </div>
            </c:otherwise>
		</c:choose>
	</c:forEach>
</div>
<script>
	var checkPayment = (p_hid, p_sid) => {
		if(!confirm('납입 완료로 처리하시겠습니까?')) return;
		
		$.ajax({
			url: "/svg/checkPayment.do",
			type: "POST",
			data: { HISTORYID: p_hid, SAVINGSID: p_sid},
			success: (res) => {
				
				if (res === 'success') {
					alert("처리되었습니다.");
					loadContent('/svg/svg03m00.do', { SAVINGSID: p_sid });
	            } else {
	                alert('처리 중 오류가 발생했습니다.');
	            }
			}
		});
	}
</script>