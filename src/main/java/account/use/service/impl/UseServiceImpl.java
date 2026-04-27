package account.use.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import account.com.service.SessionManager;
import account.svg.service.impl.SvgDAO;
import account.use.service.UseService;
import account.utl.ExcelParser;
import account.utl.MapUtils;
import account.utl.RowUtil;

@Service("useService")
public class UseServiceImpl extends EgovAbstractServiceImpl implements UseService {

	@Resource(name = "useDAO")
    private UseDAO useDAO;
	
	@Resource(name = "svgDAO")
	private SvgDAO svgDAO;
	
	@Override
	public List<Map<String, Object>> selectHistoryList(Map<String, Object> inputMap) throws Exception {

		return useDAO.selectHistoryList(inputMap);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveHistory(Map<String, Object> inputMap) throws Exception {

	    List<Map<String, Object>> insertList = (List<Map<String, Object>>) inputMap.get("insertList");
	    List<Map<String, Object>> updateList = (List<Map<String, Object>>) inputMap.get("updateList");


	    String userId = (String) SessionManager.getAttribute("USERID");

	    // INSERT
	    if (insertList != null) {
	        for (Map<String, Object> map : insertList) {

	            map.put("USERID", userId);
	            map.put("REGID", userId);

	            Long accountId = useDAO.selectAccountId(map);
	            map.put("ACCOUNTID", accountId);

	            useDAO.insertHistory(map);
	        }
	    }

	    // UPDATE
	    if (updateList != null) {
	        for (Map<String, Object> map : updateList) {

	            map.put("USERID", userId);
	            map.put("MODID", userId);

	            Long accountId = useDAO.selectAccountId(map);
	            map.put("ACCOUNTID", accountId);

	            useDAO.updateHistory(map);
	        }
	    }
	    
	    Map<String, Object> paramMap = new HashMap<String, Object>();
	    paramMap.put("USERID", userId);
	    
	    List<Map<String, Object>> hList = useDAO.selectHistoryList(paramMap);  // 잔액 계산을 위한 거래내역 조회
	    List<Map<String, Object>> sList = svgDAO.selectAccountList(paramMap);  // 계좌초기금액 조회

	    // 계좌별 초기금액
	    Map<Long, Long> initBalMap = new HashMap<Long, Long>();
	    
	    for(Map<String, Object> acc: sList) {
	    	 long accountId = ((Number) acc.get("ACCOUNTID")).longValue();
	    	 long initMoney = ((Number) acc.get("INITMONEY")).longValue();
	    	 
	    	 initBalMap.put(accountId, initMoney);
	    }
	    
	    // 계좌별 현재잔액
	    Map<Long, Long> balMap = new HashMap<>(initBalMap);
	    
	    for(Map<String, Object> row: hList) {
	    	long accountId = MapUtils.getLong(row.get("ACCOUNTID"));
	    	String type = MapUtils.getString(row.get("TRANTYPE"));
	    	long amount = MapUtils.getLong(row.get("TRANAMOUNT"));

    	    long balance = balMap.get(accountId);

    	    if ("I".equals(type)) {
    	        balance += amount;
    	    } else {
    	        balance -= amount;
    	    }
    	    
    	    row.put("TRANAFTAMOUNT", balance);

    	    balMap.put(accountId, balance);

    	    useDAO.updateAfterAmount(row);
	    }
	    
	    
	}
	
	@Override
	public List<Map<String, Object>> selectHistoryListPaging(Map<String, Object> inputMap) throws Exception {
		
		inputMap.put("USERID", SessionManager.getAttribute("USERID"));

	    int pageIndex = Integer.parseInt(inputMap.get("pageIndex").toString());
	    int pageSize = Integer.parseInt(inputMap.get("pageSize").toString());

	    int offset = (pageIndex - 1) * pageSize;

	    inputMap.put("offset", offset);
	    inputMap.put("limit", pageSize);

	    return useDAO.selectHistoryListPaging(inputMap);
	}
	
	@Override
	public int selectHistoryCnt(Map<String, Object> inputMap) throws Exception {

		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		return useDAO.selectHistoryCnt(inputMap);
	}
	
	@Override
	public void deleteHistory(List<String> inputList) throws Exception {
		
		for(String id: inputList) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
			paramMap.put("USERID", SessionManager.getAttribute("USERID"));
			paramMap.put("TRANID", id);
			useDAO.deleteHistory(paramMap);
		}
		
		// 삭제 후 잔액 재계산
	    Map<String, Object> paramMap = new HashMap<String, Object>();
	    paramMap.put("USERID", SessionManager.getAttribute("USERID"));

	    List<Map<String, Object>> hList = useDAO.selectHistoryList(paramMap);
	    List<Map<String, Object>> sList = svgDAO.selectAccountList(paramMap);

	    Map<Long, Long> balMap = new HashMap<Long, Long>();
	    for(Map<String, Object> acc: sList) {
	        long accountId = ((Number) acc.get("ACCOUNTID")).longValue();
	        long initMoney = ((Number) acc.get("INITMONEY")).longValue();
	        balMap.put(accountId, initMoney);
	    }

	    for(Map<String, Object> row: hList) {
	        long accountId = MapUtils.getLong(row.get("ACCOUNTID"));
	        String type = MapUtils.getString(row.get("TRANTYPE"));
	        long amount = MapUtils.getLong(row.get("TRANAMOUNT"));

	        long balance = balMap.get(accountId);
	        if ("I".equals(type)) balance += amount;
	        else balance -= amount;

	        row.put("TRANAFTAMOUNT", balance);
	        balMap.put(accountId, balance);
	        useDAO.updateAfterAmount(row);
	    }
	}
	
	@Override
	public List<Map<String, Object>> selectTranCategoryList(Map<String, Object> inputMap) throws Exception {

		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		return useDAO.selectTranCategoryList(inputMap);
	}
	
	@Override
	public Map<String, Object> getMonthlySummary(Map<String, Object> inputMap) throws Exception {
		 	
		String userId = (String) SessionManager.getAttribute("USERID");
	    String month = (String) inputMap.get("month");

	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("USERID", userId);
	    paramMap.put("month", month);

	    // 수입 / 지출
	    Map<String, Object> sumMap = useDAO.selectMonthlySummary(paramMap);

	    long income = MapUtils.getLong(sumMap.get("INCOME"));
	    long expense = MapUtils.getLong(sumMap.get("EXPENSE"));

	    // 마지막 잔액
	    Long lastBalance = useDAO.selectLastBalance(paramMap);

	    Map<String, Object> result = new HashMap<>();
	    result.put("income", income);
	    result.put("expense", expense);
	    result.put("lastBalance", lastBalance);

	    return result;
	}
	
	@Override
	public Map<String, Object> getAnnualData(Map<String, Object> inputMap) throws Exception {
		 
	    try {
	        String userId = (String) SessionManager.getAttribute("USERID");
	        inputMap.put("USERID", userId);
	 
	        // 1. 1월 전월이월 (초기 잔액)
	        long initMoney = useDAO.selectPrevYearLastBalance(inputMap);
	 
	        // 2. 월별 잔액
	        List<Map<String, Object>> balanceList = useDAO.selectMonthlyLastBalance(inputMap);
	        Map<String, Long> balanceMap = new HashMap<>();
	        for (Map<String, Object> row : balanceList) {
	            balanceMap.put((String) row.get("MONTH"), MapUtils.getLong(row.get("BALANCE")));
	        }
	        
	        // 3. 월별 카테고리별 금액
	        List<Map<String, Object>> amountList = useDAO.selectMonthlyAmountByCategory(inputMap);
	        Map<String, Long> amountMap = new HashMap<>();
	        for (Map<String, Object> row : amountList) {
	            String key = row.get("CATEGORYNM") + "_" + row.get("MONTH");
	            amountMap.put(key, MapUtils.getLong(row.get("AMOUNT")));
	        }

	        // 4. 카테고리 목록
	        List<Map<String, Object>> cList = useDAO.selectAnnualCategoryList(inputMap);
	        
	     // ── 행 구성 ──
	        List<Map<String, Object>> rows = new ArrayList<>();

	        // 수입 섹션
	        rows.add(RowUtil.sectionRow("수입"));
	        long totalIncome = 0L;
	        long[] incomeByMonth = new long[13];

	        for (Map<String, Object> cat : cList) {
	            if (!"I".equals(cat.get("CLASSIFICATION"))) continue;

	            Map<String, Object> row = new LinkedHashMap<>();
	            row.put("label", cat.get("CATEGORYNM"));
	            row.put("trClass", "sub-row");

	            Map<String, Long> months = new LinkedHashMap<>();
	            long annual = 0L;
	            for (int m = 1; m <= 12; m++) {
	                String mStr = String.format("%02d", m);
	                long amt = amountMap.getOrDefault(cat.get("CATEGORYNM") + "_" + mStr, 0L);
	                months.put(mStr, amt);
	                annual += amt;
	                incomeByMonth[m] += amt;
	            }
	            row.put("months", months);
	            row.put("annual", annual);
	            totalIncome += annual;
	            rows.add(row);
	        }

	        rows.add(RowUtil.totalRow("수입계", "total-income", incomeByMonth));
	        rows.add(RowUtil.spacerRow());

	        // 지출 섹션
	        rows.add(RowUtil.sectionRow("지출"));
	        long totalExpense = 0L;
	        long[] expenseByMonth = new long[13];

	        for (Map<String, Object> cat : cList) {
	            if (!"O".equals(cat.get("CLASSIFICATION"))) continue;

	            Map<String, Object> row = new LinkedHashMap<>();
	            row.put("label", cat.get("CATEGORYNM"));
	            row.put("trClass", "sub-row");

	            Map<String, Long> months = new LinkedHashMap<>();
	            long annual = 0L;
	            for (int m = 1; m <= 12; m++) {
	                String mStr = String.format("%02d", m);
	                long amt = amountMap.getOrDefault(cat.get("CATEGORYNM") + "_" + mStr, 0L);
	                months.put(mStr, amt);
	                annual += amt;
	                expenseByMonth[m] += amt;
	            }
	            row.put("months", months);
	            row.put("annual", annual);
	            totalExpense += annual;
	            rows.add(row);
	        }

	        rows.add(RowUtil.totalRow("지출계", "total-expense", expenseByMonth));
	        rows.add(RowUtil.spacerRow());

	        // 전월이월 / 잔액 행
	        long runningBalance = initMoney;
	        Map<String, Long> carryMonths = new LinkedHashMap<>();
	        Map<String, Long> balMonths   = new LinkedHashMap<>();

	        for (int m = 1; m <= 12; m++) {
	            String mStr = String.format("%02d", m);
	            carryMonths.put(mStr, runningBalance);
	            runningBalance = balanceMap.getOrDefault(mStr, runningBalance);
	            balMonths.put(mStr, runningBalance);
	        }

	        Map<String, Object> carryRow = new LinkedHashMap<>();
	        carryRow.put("label",   "전월이월");
	        carryRow.put("trClass", "carry-row");
	        carryRow.put("months",  carryMonths);
	        carryRow.put("annual",  null);
	        rows.add(carryRow);

	        Map<String, Object> balanceRow = new LinkedHashMap<>();
	        balanceRow.put("label",   "잔액");
	        balanceRow.put("trClass", "balance-row");
	        balanceRow.put("months",  balMonths);
	        balanceRow.put("annual",  runningBalance);
	        rows.add(balanceRow);

	        // 최종 결과
	        Map<String, Object> result = new HashMap<>();
	        result.put("rows",         rows);
	        result.put("totalIncome",  totalIncome);
	        result.put("totalExpense", totalExpense);
	        result.put("totalBalance", runningBalance);
	        result.put("incomeByMonth",  incomeByMonth);
	        result.put("expenseByMonth", expenseByMonth);

	        return result;
	 
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	 
	    return null;
	}
	
	@Override
	public Map<String, Object> uploadExcel(Map<String, Object> inputMap, MultipartFile file) throws Exception {
		
		String bank = (String) inputMap.get("bank");
		String accountNum = (String) inputMap.get("accountNum");
	    String userId = (String) SessionManager.getAttribute("USERID");
	    
//	    System.out.println("bank="+bank);
//	    System.out.println("month="+month);
//	    System.out.println("userId="+userId);
	    
	    List<Map<String, Object>> parsedList = ExcelParser.parse(bank, file);
	    
	    for (Map<String, Object> row : parsedList) {
	        row.put("ACCOUNTNUM", accountNum);
	    }
	    
	    List<String> unregList = new ArrayList<>();
	    for (Map<String, Object> row : parsedList) {
	        String description = (String) row.get("DESCRIPTION");
	        Map<String, Object> paramMap = new HashMap<>();
	        paramMap.put("USERID", userId);
	        paramMap.put("USAGENM", description);
	        // ACC_CATEGORY에서 USAGENM으로 조회
	        int cnt = useDAO.selectCategoryByUsageNm(paramMap);
	        if (cnt == 0 && !unregList.contains(description)) {
	            unregList.add(description);
	        }
	    }

	    Map<String, Object> result = new HashMap<>();
	    result.put("unregList", unregList);
	    result.put("parsedList", parsedList);
	    
	    System.out.println("parsedList=" + parsedList);
	    System.out.println("unregList=" + unregList);
	    return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveUnregAndUpload(Map<String, Object> inputMap) throws Exception {

		String userId = (String) SessionManager.getAttribute("USERID");

	    List<Map<String, Object>> unregList  = (List<Map<String, Object>>) inputMap.get("unregList");
	    List<Map<String, Object>> parsedList = (List<Map<String, Object>>) inputMap.get("parsedList");

	    // 1. 미등록 사용처 ACC_CATEGORY에 INSERT
	    if (unregList != null) {
	        for (Map<String, Object> item : unregList) {

	            // parsedList에서 해당 사용처의 TRANTYPE 찾아서 CLASSIFICATION 자동 결정
	            String classification = "O";
	            if (parsedList != null) {
	                for (Map<String, Object> p : parsedList) {
	                    if (item.get("usageNm").equals(p.get("DESCRIPTION"))) {
	                        classification = (String) p.get("TRANTYPE");
	                        break;
	                    }
	                }
	            }

	            Map<String, Object> paramMap = new HashMap<>();
	            paramMap.put("USERID",         userId);
	            paramMap.put("REGID",          userId);
	            paramMap.put("USAGENM",        item.get("usageNm"));
	            paramMap.put("CATEGORYNM",     item.get("categoryNm"));
	            paramMap.put("CLASSIFICATION", classification);
	            svgDAO.insertCategory(paramMap);
	        }
	    }

	    // 2. parsedList → ACC_HISTORY INSERT (엑셀용 - TRANTYPE 파싱값 사용)
	    if (parsedList != null) {
	        for (Map<String, Object> item : parsedList) {
	            item.put("USERID", userId);
	            item.put("REGID",  userId);
	            useDAO.insertHistoryFromExcel(item);
	        }
	    }

	    // 3. 잔액 재계산
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("USERID", userId);

	    List<Map<String, Object>> hList = useDAO.selectHistoryList(paramMap);
	    List<Map<String, Object>> sList = svgDAO.selectAccountList(paramMap);

	    Map<Long, Long> balMap = new HashMap<>();
	    for (Map<String, Object> acc : sList) {
	        long accountId = ((Number) acc.get("ACCOUNTID")).longValue();
	        long initMoney = ((Number) acc.get("INITMONEY")).longValue();
	        balMap.put(accountId, initMoney);
	    }

	    for (Map<String, Object> row : hList) {
	        long accountId = MapUtils.getLong(row.get("ACCOUNTID"));
	        String type    = MapUtils.getString(row.get("TRANTYPE"));
	        long amount    = MapUtils.getLong(row.get("TRANAMOUNT"));

	        long balance = balMap.get(accountId);
	        if ("I".equals(type)) balance += amount;
	        else balance -= amount;

	        row.put("TRANAFTAMOUNT", balance);
	        balMap.put(accountId, balance);
	        useDAO.updateAfterAmount(row);
	    }
	}
}
