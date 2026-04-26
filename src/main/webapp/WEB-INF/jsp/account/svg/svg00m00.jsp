<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>

<div class="page-header">
	<h1>사용처 관리</h1>
</div>

<form id="catFrm" method="post">

	<div class="toolbar">
		<div class="toolbar-left">
			<select class="toolbar-select" name="searchKey">
				<option value="usageNm">내용</option>
				<option value="categoryNm">항목</option>
				<option value="categoryDetailNm">세부항목</option>
			</select>
			<input type="text" name="searchValue">
		</div>
		<div>
			<button type="button" class="toolbar-btn toolbar-btn-primary" onclick="search()">검색</button> 
			<button type="button" class="toolbar-btn toolbar-btn-outline" onclick="addRow()">사용처 추가</button>
			<button type="button" class="toolbar-btn toolbar-btn-success" onclick="save()">저장</button>
			<button type="button" class="toolbar-btn toolbar-btn-danger" onclick="deleteRow()">삭제</button>
		</div>
	</div>

	<div class="table-card">
		<div class="table-scroll">
			<table id="catTbl">
				<thead>
					<tr>
						<th style="text-align:center"><input type="checkbox" class="chkAll"></th>
						<th style="text-align:center">내용</th>
						<th style="text-align:center">항목</th>
						<th style="text-align:center">세부항목</th>
						<th style="text-align:center">입출금구분</th>
					</tr>
				</thead>
				<tbody id="catTbody">
					<c:forEach var="item" items="${cList}" varStatus="status">
					<tr>
						<td style="text-align:center">
							<input type="checkbox" class="chk">
							<input type="hidden" class="CATEGORYID" name="CATEGORYID" value="${item.CATEGORYID}">
						</td>
						<td><input type="text" class="USAGENM" name="USAGENM" value="${item.USAGENM}"></td>
						<td><input type="text" class="CATEGORYNM" name="CATEGORYNM" value="${item.CATEGORYNM}"></td>
						<td><input type="text" class="CATEGORYDETAILNM" name="CATEGORYDETAILNM" value="${item.CATEGORYDETAILNM}"></td>
						<td>
							<select class="CLASSIFICATION" name="CLASSIFICATION">
								<option value="I" <c:if test="${item.CLASSIFICATION eq 'I'}">selected</c:if>>입금</option>
								<option value="O" <c:if test="${item.CLASSIFICATION eq 'O'}">selected</c:if>>출금</option>
							</select>
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</form>
<script>
	var addRow = () => {
		$("#catTbody").append(`
			<tr>
				<td style="text-align:center">
					<input type="checkbox" class="chk">
					<input type="hidden" class="CATEGORYID" name="CATEGORYID[]">
				</td>
				<td><input type="text" class="USAGENM" name="USAGENM[]"></td>
				<td><input type="text" class="CATEGORYNM" name="CATEGORYNM[]"></td>
				<td><input type="text" class="CATEGORYDETAILNM" name="CATEGORYDETAILNM[]"></td>
				<td>
					<select class="CLASSIFICATION" name="CLASSIFICATION[]">
						<option value="I">입금</option>
						<option value="O">출금</option>
					</select>
				</td>
			</tr>
		`);
	}
	
	var save = () => {
		let insertList = [];  // 사용처 추가 리스트
		let updateList = [];  // 사용처 수정 리스트
		let usageSet = new Set();   // 사용처 중복 체크용
		let valid = true;           // 유효성 체크
		
		$("#catTbody tr").each(function () {
			let $row = $(this);
			
			if ($row.find(".USAGENM").length === 0) return;
			
			let categoryId = $row.find(".CATEGORYID").val();
			let usageNm = $row.find(".USAGENM").val();
			let categoryNm = $row.find(".CATEGORYNM").val();
			
			if(!usageNm.trim() || !categoryNm.trim()) {
				alert("빈 행이 존재합니다. 모든 항목을 입력해주세요.");
				valid = false;
				return false;
			}
			
			if(usageSet.has(usageNm)) {
				alert("중복된 사용처가 존재합니다. [사용처명: " + usageNm + "]");
				valid = false;
				return false;
			}
			
			usageSet.add(usageNm);
			
			let data = {
				CATEGORYID: categoryId,
				USAGENM: $row.find(".USAGENM").val(),
				CATEGORYNM: $row.find(".CATEGORYNM").val(),
				CATEGORYDETAILNM: $row.find(".CATEGORYDETAILNM").val(),
				CLASSIFICATION: $row.find(".CLASSIFICATION").val()
			};
			
			if (categoryId && categoryId.trim() !== "") {
	            updateList.push(data);
	        } else {
	            insertList.push(data);
	        }

		});
		if (!valid) return;
		if (insertList.length === 0 && updateList.length === 0) return;
		
		$.ajax({
			url: "/svg/saveCategory.do",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify({
	            insertList: insertList,
	            updateList: updateList
	        }),
			success: (res) => {
				alert("저장되었습니다.");
				
				$("input[name='searchValue']").val("");
				loadList();
			}
		})
	}
	
	var deleteRow = () => {
		
		let deleteList = [];
		let chkCnt = 0;
		
		$("#catTbody tr").each(function () {
			let $row = $(this);

			let $chk = $row.find(".chk");

			if ($chk.is(":checked")) {
				chkCnt++;
				
				let categoryId = $row.find(".CATEGORYID").val();

				if (categoryId) {
					deleteList.push(categoryId);
				}
			}
		});
		
		if (chkCnt === 0) {
			alert("삭제할 항목을 선택하세요.");
			return;
		}
		
		$.ajax({
			url: "/svg/deleteCategory.do",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify(deleteList),
			success: function (res) {
				alert("삭제되었습니다.");
				loadList();
			},
			error: function () {
				alert("사용처 삭제 중 오류가 발생했습니다.");
			}
		})
	}
	
	var search = () => {
		
		let param = {
			searchKey: $("select[name='searchKey']").val(),
			searchValue: $("input[name='searchValue']").val()
		};

		loadList(param);
		
	}
	
	var loadList = (param = {}) => {

		$.ajax({
		    url: "/svg/selectCategoryList.do",
		    type: "POST",
		    data: param,
		    success: function (res) {
		        let html = "";
		        res.forEach(item => {

		            let selectedI = item.CLASSIFICATION === "I" ? "selected" : "";
		            let selectedO = item.CLASSIFICATION === "O" ? "selected" : "";
		            html += "<tr>"
		            html += "  <td style=\"text-align:center\">"
		            html += "    <input type=\"checkbox\" class=\"chk\">"
		            html += "    <input type=\"hidden\" class=\"CATEGORYID\" name=\"CATEGORYID\" value=\"" + item.CATEGORYID + "\">"
		            html += "  </td>"
		            html += "  <td><input type=\"text\" class=\"USAGENM\" name=\"USAGENM\" value=\"" + item.USAGENM + "\"></td>"
		            html += "  <td><input type=\"text\" class=\"CATEGORYNM\" name=\"CATEGORYNM\" value=\"" + item.CATEGORYNM + "\"></td>"
		            html += "  <td><input type=\"text\" class=\"CATEGORYDETAILNM\" name=\"CATEGORYDETAILNM\" value=\"" + item.CATEGORYDETAILNM+ "\"></td>"
		            html += "  <td>"
		            html += "    <select class=\"CLASSIFICATION\" name=\"CLASSIFICATION\">"
		            html += "      <option value=\"I\"" + selectedI+ ">입금</option>"
		            html += "      <option value=\"O\"" + selectedO + ">출금</option>"
		            html += "    </select>"
		            html += "  </td>"
		            html += "</tr>"
		        });

		        $("#catTbody").html(html);
		    }
		});
	}
</script>