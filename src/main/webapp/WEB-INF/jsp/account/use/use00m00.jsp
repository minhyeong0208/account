<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>

<div class="page-header">
	<h1>월별 내역</h1>
	<div class="month-nav">
		<button type="button" onclick="prevMonth()">◀</button>
		<span id="monthLabel"></span>
		<button type="button" onclick="nextMonth()">▶</button>
	</div>
</div>
<div class="summary-cards">
  	<div class="s-card income">
    	<div class="s-label">총 수입</div>
    	<div class="s-value" id="income"></div>
    	<div class="s-sub">원</div>
  	</div>
  	<div class="s-card expense">
    	<div class="s-label">총 지출</div>
    	<div class="s-value" id="expense"></div>
    	<div class="s-sub">원</div>
  	</div>
  	<div class="s-card balance">
    	<div class="s-label">잔액</div>
    	<div class="s-value" id="balance"></div>
    	<div class="s-sub">원</div>
  	</div>
</div>
<form id="mthFrm" method="post">

	<div class="toolbar">
		<div class="toolbar-left">
			<select class="toolbar-select" name="searchKey" onchange="changeSearchUI()">
				<option value="bankNm">은행명</option>
				<option value="tranType">거래유형</option>
				<option value="description">내용</option>
				<option value="categoryId">항목</option>
			</select>
			<span id="searchArea"></span>
			<button type="button" class="toolbar-btn toolbar-btn-primary" onclick="search()">검색</button> 
		</div>
		<div>
			<button type="button" class="toolbar-btn toolbar-btn-outline" onclick="addRow()">내역 추가</button>
			<button type="button" class="toolbar-btn toolbar-btn-success" onclick="save()">저장</button>
			<button type="button" class="toolbar-btn toolbar-btn-danger" onclick="deleteRow()">삭제</button>
		</div>
	</div>

	<div class="table-card">
		<div class="table-scroll">
			<table id="mthTbl">
				<thead>
					<tr>
						<th style="width:36px; text-align:center;"></th>
						<th style="width:44px; text-align:center;">순번</th>
						<th style="width:260px; text-align:center;">은행명</th>
						<th style="width:120px; text-align:center;">거래일자</th>
						<th style="width:72px; text-align:center;">거래유형</th>
						<th style="text-align:center;">내용</th>
						<th style="width:90px; text-align:center;">항목</th>
						<th style="width:110px; text-align:center;">금액</th>
						<th style="width:110px; text-align:center;">잔액</th>
					</tr>
				</thead>
				<tbody id="mthTbody"></tbody>
			</table>
		</div>
	</div>
	
	<div id="pagination"></div>
	
</form>
<script>
	var pageIndex = 1;
	var pageSize = 10;
	
	var optionHtml = "";
	
	var accountList = []; // 계좌조회
	
	
	var currentMonth = new Date().toISOString().slice(0,7);
	
	var addRow = () => {

		var html = "";

		html += "<tr>";
		html += "	<td style='text-align:center'>";
		html += "		<input type='checkbox' class='chk'>";
		html += "		<input type='hidden' class='TRANID' name='TRANID[]'>";
		html += "	</td>";
		html += "	<td></td>";
		html += "	<td>";
		html += "		<select class='ACCOUNTNUM' name='ACCOUNTNUM[]'>";
		html += 			optionHtml;
		html += "		</select>";
		html += "	</td>";
		html += "	<td><input type='date' class='TRANDATE' name='TRANDATE[]'></td>";
		html += "	<td></td>";
		html += "	<td><input type='text' class='DESCRIPTION' name='DESCRIPTION[]'></td>";
		html += "	<td></td>";
		html += "	<td><input type='text' class='TRANAMOUNT' name='TRANAMOUNT[]'></td>";
		html += "</tr>";

		$("#mthTbody").append(html);
	}
	
	// 계좌 조회
	var loadAccountOptions = () => {
		$.ajax({
			url: "/svg/selectAccountList.do",
			type: "POST",
			success: function(res) {
				
				accountList = res;
				optionHtml = ""

				res.forEach(item => {
					let bankName = "";

					if(item.BANKNM === "KM") bankName = "국민";
					if(item.BANKNM === "SH") bankName = "신한";
					if(item.BANKNM === "WR") bankName = "우리";
					
					bankName += "(" + item.ACCOUNTNUM + ")"

					optionHtml += "<option value=\"" + item.ACCOUNTNUM + "\">" + bankName + "</option>";
				});
				
				loadList({
				    month: currentMonth,
				    searchKey: $("select[name='searchKey']").val(),
				    searchValue: $("[name='searchValue']").val()
				});
			}
		});
	}
	
	var save = () => {
		let insertList = [];
		let updateList = [];
		let valid = true;
		
		$("#mthTbody tr").each(function() {
			let $row = $(this);
			
			let tranId = $row.find(".TRANID").val();
			let accountNum = $row.find(".ACCOUNTNUM").val();
			let tranDate = $row.find(".TRANDATE").val();
			let description = $row.find(".DESCRIPTION").val();
			let tranAmount = $row.find(".TRANAMOUNT").val();
			
			if (!accountNum && !tranDate && !description && !tranAmount) return;
			
			if(!accountNum.trim() || !tranDate.trim() || !description.trim() || !tranAmount.trim()) {
				alert("빈 행이 존재합니다. 모든 항목을 입력해주세요.");
				valid = false;
				return false;
			}
			
			let data = {
				TRANID: tranId,
				ACCOUNTNUM: accountNum,
				TRANDATE: tranDate,
				DESCRIPTION: description,
				TRANAMOUNT: tranAmount
			}
			
			if (tranId && tranId.trim() !== "") {
	            updateList.push(data);
	        } else {
	            insertList.push(data);
	        }
			
		});
		
		if (!valid) return;
		if (insertList.length === 0 && updateList.length === 0) return;
		
		$.ajax({
			url: "/use/saveHistory.do",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify({
	            insertList: insertList,
	            updateList: updateList
	        }),
			success: (res) => {
				alert("저장되었습니다.");
				
				let param = {
					searchKey: $("select[name='searchKey']").val(),
					searchValue: $("[name='searchValue']").val(),
					month: currentMonth
				};

				loadList(param);
				loadSummary();
			}
		})
	}
	
	var deleteRow = () => {
		let deleteList = [];
		let chkCnt = 0;
		
		$("#mthTbody tr").each(function () {
			let $row = $(this);

			let $chk = $row.find(".chk");

			if ($chk.is(":checked")) {
				chkCnt++;
				
				let tranId = $row.find(".TRANID").val();

				if (tranId) {
					deleteList.push(tranId);
				}
			}
		});
		
		if (chkCnt === 0) {
			alert("삭제할 항목을 선택하세요.");
			return;
		}
		
		$.ajax({
			url: "/use/deleteHistory.do",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify(deleteList),
			success: function (res) {
				alert("삭제되었습니다.");
				let param = {
					searchKey: $("select[name='searchKey']").val(),
					searchValue: $("[name='searchValue']").val(),
					month: currentMonth
				};

				loadList(param);
				loadSummary();
			},
			error: function () {
				alert("내역 삭제 중 오류가 발생했습니다.");
			}
		})
	}
	
	var search = () => {
		
		pageIndex = 1;
		
		let param = {
			searchKey: $("select[name='searchKey']").val(),
			searchValue: $("[name='searchValue']").val(),
			month: currentMonth
		};

		loadList(param);
		loadSummary();
		
	}
	
	var loadList = (param = {}) => {
		
		param.pageIndex = pageIndex;
		param.pageSize = pageSize;
		
		if (!param.month) {
		    param.month = currentMonth;
		}
		
		$.ajax({
		    url: "/use/selectHistoryListPaging.do",
		    type: "POST",
		    data: param,
		    success: function (res) {
		    	let list = res.list;
		        let totalCount = res.totalCount;
		        
		        drawTable(list);
		        drawPagination(totalCount);
		    }
		});
	}
	
	var loadSummary = () => {
		
	    $.ajax({
	        url: "/use/getMonthlySummary.do",
	        type: "POST",
	        data: { month: currentMonth },
	        success: function(res) {

	            $("#income").text(res.income);
	            $("#expense").text(res.expense);
	            $("#balance").text(res.lastBalance);
	        }
	    });
	};
	
	var drawTable = (list) => {
		let html = "";
		list.forEach((item, index) => {
			
			let rowNum = (pageIndex - 1) * pageSize + (index + 1);
			
			html += "<tr>";
			html += "  <td style='text-align:center'>";
            html += "    <input type=\"checkbox\" class=\"chk\">"
            html += "    <input type=\"hidden\" class=\"TRANID\" name=\"TRANID[]\" value=\"" + item.TRANID + "\">"
            html += "  </td>"
            html += "  <td style='text-align:center'>" + rowNum + "</td>";
            html += "  <td>";
            html += "    <select class='ACCOUNTNUM' name='ACCOUNTNUM[]'>";

            accountList.forEach(opt => {
                let selected = (opt.ACCOUNTNUM === item.ACCOUNTNUM) ? "selected" : "";

                let bankName = "";

                if(opt.BANKNM === "KM") bankName = "국민";
                if(opt.BANKNM === "SH") bankName = "신한";
                if(opt.BANKNM === "WR") bankName = "우리";

                bankName += "(" + opt.ACCOUNTNUM + ")";

                html += "<option value='" + opt.ACCOUNTNUM + "' " + selected + ">"
                     + bankName +
                     "</option>";
            });

            html += "    </select>";
            html += "  </td>";
            html += "  <td><input type='date' class='TRANDATE' value='" + (item.TRANDATE || "") + "'></td>";
            html += "  <td><span class='" +
           			 ((item.TRANTYPE === "O") ? "badge badge-expense" : "badge badge-income") +
            			"'>" +
            		 ((item.TRANTYPE === "O") ? "출금" : "입금") +
            			"</span></td>";html += "  <td><input type='text' class='DESCRIPTION' value='" + (item.DESCRIPTION || "") + "'></td>";
            html += "  <td>" + (item.CATEGORYNM || "") + "</td>";
            html += "  <td><input type='text' class='TRANAMOUNT' value='" + (item.TRANAMOUNT || "") + "'></td>";
            html += "  <td>" + item.TRANAFTAMOUNT + "</td>";
            html += "</tr>";
            
            
		});
		$("#mthTbody").html(html);
	}
	
	var drawPagination = (totalCount) => {

		let totalPage = Math.ceil(totalCount / pageSize);
		let html = "";

		for (let i = 1; i <= totalPage; i++) {
			if (i === pageIndex) {
				html += "<strong>" + i + "</strong> ";
			} else {
				html += "<a href='javascript:goPage(" + i + ")'>" + i + "</a> ";
			}
		}

		$("#pagination").html(html);
	};
	
	var goPage = (page) => {
		pageIndex = page;

		let param = {
			searchKey: $("select[name='searchKey']").val(),
			searchValue: $("[name='searchValue']").val(),
			month: currentMonth
		};

		loadList(param);
		loadSummary();
	};
	
	var changeSearchUI = () => {
		let key = $("select[name='searchKey']").val();
		let html = "";

		if (key === "bankNm") {
			html += `
				<select name="searchValue">
					<option value="">전체</option>
					<option value="KM">국민</option>
					<option value="SH">신한</option>
					<option value="WR">우리</option>
				</select>
			`;
		} else if(key === "tranType") {
			html += `
				<select name="searchValue">
					<option value="">전체</option>
					<option value="I">입금</option>
					<option value="O">출금</option>
				</select>
			`;
		} else if(key === "categoryId") {
			html += "<select name=\"searchValue\">";
			html += "<option value=\"\">전체</option>";
			html += "</select>";

			$("#searchArea").html(html);

			$.ajax({
				url: "/use/selectTranCategoryList.do",
				type: "POST",
				success: function(res) {
					let opt = "<option value=\"\">전체</option>";
					
					res.forEach(item => {
						opt += "<option value=\"" + item.CATEGORYID + "\">"
						opt += item.CATEGORYNM;
						opt += "</option>";
					});

					$("select[name='searchValue']").html(opt);
				}
			});
		} else {
			html += `<input type="text" name="searchValue">`;
		}

		$("#searchArea").html(html);
	};
	
	var renderMonth = () => {
	    $("#monthLabel").text(currentMonth);

	    loadList({
	        month: currentMonth,
	        searchKey: $("select[name='searchKey']").val(),
	        searchValue: $("[name='searchValue']").val()
	    });
	    
	    loadSummary();
	};

	// 이전 달로 이동하기
	var prevMonth = () => {
	    let d = new Date(currentMonth + "-01");
	    d.setMonth(d.getMonth() - 1);
	    currentMonth = d.toISOString().slice(0,7);

	    pageIndex = 1;
	    renderMonth();
	};

	// 다음 달로 이동하기
	var nextMonth = () => {
	    let d = new Date(currentMonth + "-01");
	    d.setMonth(d.getMonth() + 1);
	    currentMonth = d.toISOString().slice(0,7);

	    pageIndex = 1;
	    renderMonth();
	};
	
	$(document).ready(function() {
		changeSearchUI();
		$("#monthLabel").text(currentMonth);
		loadAccountOptions();
		loadSummary();
	});
</script>
</body>
</html>
