<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>

<div class="page-header">
	<h1>계좌 관리</h1>
</div>

<form id="accFrm" method="post">

	<div class="toolbar">
		<div class="toolbar-left">
			<select class="toolbar-select" name="searchKey" onchange="changeSearchUI()">
				<option value="bankNm">은행명</option>
				<option value="accountNum">계좌번호</option>
			</select>
			<span id="searchArea"></span>
			<button type="button" class="toolbar-btn toolbar-btn-primary" onclick="search()">검색</button> 
		</div>
		<div>
			
			<button type="button" class="toolbar-btn toolbar-btn-outline" onclick="addRow()">은행 추가</button>
			<button type="button" class="toolbar-btn toolbar-btn-success" onclick="save()">저장</button>
			<button type="button" class="toolbar-btn toolbar-btn-danger" onclick="deleteRow()">삭제</button>
		</div>
	</div>
	
	<div class="table-card">
		<div class="table-scroll">
			<table id="accTbl">
				<thead>
					<tr>
						<th style="text-align: center;"></th>
						<th style="text-align: center;">순번</th>
						<th style="text-align: center;">은행명</th>
						<th style="text-align: center;">계좌번호</th>
						<th style="text-align: center;">초기잔액</th>
					</tr>
				</thead>
				<tbody id="accTbody"></tbody>
			</table>
		</div>
	</div>
	<div id="pagination"></div>

</form>
<script>
	var pageIndex = 1;
	var pageSize = 10;

	var addRow = () => {
		$("#accTbody").append(`
			<tr>
				<td style="text-align:center">
					<input type="checkbox" class="chk">
					<input type="hidden" class="ACCOUNTID" name="ACCOUNTID[]">
				</td>
				<td class="rowNum"></td>
				<td>
					<select class="BANKNM" name="BANKNM[]">
						<option value="KM">국민</option>
						<option value="SH">신한</option>
						<option value="WR">우리</option>
					</select>
				</td>
				<td><input type="text" class="ACCOUNTNUM" name="ACCOUNTNUM[]"></td>
				<td><input type="number" class="INITMONEY" name="INITMONEY[]"></td>
			</tr>
		`);
	}
	
	var save = () => {
		let insertList = [];
		let updateList = [];
		let accountNumSet = new Set();   // 계좌번호 중복 체크용
		let valid = true;
		
		$("#accTbody tr").each(function () {
			let $row = $(this);
			
			if($row.find(".ACCOUNTNUM").length === 0) return;
			
			let accountId = $row.find(".ACCOUNTID").val();
			let accountNum = $row.find(".ACCOUNTNUM").val();
			let bankNm = $row.find(".BANKNM").val();
			let initMoney = $row.find(".INITMONEY").val();
			
			if(!accountNum.trim() || !initMoney.trim()) {
				alert("빈 행이 존재합니다. 모든 항목을 입력해주세요.");
				valid = false;
				return false;
			}
			
			if(accountNumSet.has(accountNum)) {
				alert("중복된 계좌가 존재합니다. [계좌번호: " + accountNum + "]");
				valid = false;
				return false;
			}
			
			if(isNaN(initMoney)) {
				alert("초기잔액은 숫자만 입력하세요.");
				valid = false;
				return false;
			}
			
			accountNumSet.add(accountNum);
			
			let data = {
				ACCOUNTID: accountId,
				ACCOUNTNUM: accountNum,
				BANKNM: bankNm,
				INITMONEY: initMoney
			}
			
			if (accountId && accountId.trim() !== "") {
	            updateList.push(data);
	        } else {
	            insertList.push(data);
	        }
			
		});
		
		if (!valid) return;
		if (insertList.length === 0 && updateList.length === 0) return;
		
		$.ajax({
			url: "/svg/saveAccount.do",
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
					searchValue: $("[name='searchValue']").val()
				};

				loadList(param);
			}
		})
	}
	
	var deleteRow = () => {
		let deleteList = [];
		let chkCnt = 0;
		
		$("#accTbody tr").each(function () {
			let $row = $(this);

			let $chk = $row.find(".chk");

			if ($chk.is(":checked")) {
				chkCnt++;
				
				let accountId = $row.find(".ACCOUNTID").val();

				if (accountId) {
					deleteList.push(accountId);
				}
			}
		});
		
		if (chkCnt === 0) {
			alert("삭제할 항목을 선택하세요.");
			return;
		}
		
		$.ajax({
			url: "/svg/deleteAccount.do",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify(deleteList),
			success: function (res) {
				alert("삭제되었습니다.");
				let param = {
					searchKey: $("select[name='searchKey']").val(),
					searchValue: $("[name='searchValue']").val()
				};

				loadList(param);
			},
			error: function () {
				alert("계좌 삭제 중 오류가 발생했습니다.");
			}
		})
	}
	
	var search = () => {
		
		pageIndex = 1;
		
		let param = {
			searchKey: $("select[name='searchKey']").val(),
			searchValue: $("[name='searchValue']").val()
		};

		loadList(param);
		
	}
	
	var loadList = (param = {}) => {

		param.pageIndex = pageIndex;
		param.pageSize = pageSize;
		
		$.ajax({
		    url: "/svg/selectAccountListPaging.do",
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
	
	var drawTable = (list) => {
		let html = "";
        list.forEach((item, index) => {
        	
        	let rowNum = (pageIndex - 1) * pageSize + (index + 1);

            let selectedKM = item.BANKNM === "KM" ? "selected" : "";
            let selectedSH = item.BANKNM === "SH" ? "selected" : "";
            let selectedWR = item.BANKNM === "WR" ? "selected" : "";
            
            html += "<tr>"
            html += "  <td style='text-align:center;'>"
            html += "    <input type=\"checkbox\" class=\"chk\">"
            html += "    <input type=\"hidden\" class=\"ACCOUNTID\" name=\"ACCOUNTID[]\" value=\"" + item.ACCOUNTID + "\">"
            html += "  </td>"
            html += "  <td style='text-align:center;'>" + rowNum + "</td>";
            html += "  <td>"
            html += "    <select class=\"BANKNM\" name=\"BANKNM[]\">"
            html += "      <option value=\"KM\" " + selectedKM + ">국민</option>"
            html += "      <option value=\"SH\" " + selectedSH + ">신한</option>"
            html += "      <option value=\"WR\" " + selectedWR + ">우리</option>"
            html += "    </select>"
            html += "  </td>"
            html += "  <td><input type=\"text\" class=\"ACCOUNTNUM\" name=\"ACCOUNTNUM[]\" value=\"" + item.ACCOUNTNUM + "\"></td>"
            html += "  <td><input type=\"number\" class=\"INITMONEY\" name=\"INITMONEY[]\" value=\"" 
                + (item.INITMONEY || 0) + "\" readonly></td>";
            html += "</tr>"

        });

        $("#accTbody").html(html);
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
			searchValue: $("[name='searchValue']").val()
		};

		loadList(param);
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
		} else {
			html += `<input type="text" name="searchValue">`;
		}

		$("#searchArea").html(html);
	};
	
	$(document).ready(function() {
		changeSearchUI();
		loadList();
	})
</script>
