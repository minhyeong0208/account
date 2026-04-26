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

import account.com.service.SessionManager;
import account.svg.service.impl.SvgDAO;
import account.use.service.UseService;
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

		// 카테고리 목록 조회
		List<Map<String, Object>> cList = svgDAO.selectCategoryList(inputMap);  
;
		// 월별 카테고리별 금액
		List<Map<String, Object>> amountList = useDAO.selectMonthlyAmountByCategory(inputMap);
		System.out.println("amountList="+amountList);
		Map<String, Long> amountMap = new HashMap<>();
        for (Map<String, Object> row : amountList) {
            String key = row.get("CATEGORYID") + "_" + row.get("MONTH");
            amountMap.put(key, MapUtils.getLong(row.get("AMOUNT")));
        }

        
        List<Map<String, Object>> balanceList = useDAO.selectMonthlyLastBalance(inputMap);
        Map<String, Long> balanceMap = new HashMap<>();
        for (Map<String, Object> row : balanceList) {
            balanceMap.put((String) row.get("MONTH"), MapUtils.getLong(row.get("BALANCE")));
        }

        // ── 행 구성 ──
        List<Map<String, Object>> rows = new ArrayList<>();
        
        rows.add(RowUtil.sectionRow("수입"));
        long totalIncome = 0L;
        long[] incomeByMonth = new long[13]; // 1~12월
        
        for (Map<String, Object> cat : cList) {
            if (!"I".equals(cat.get("CLASSIFICATION"))) continue;

            Map<String, Object> row = new LinkedHashMap<>();
            row.put("label", cat.get("CATEGORYNM"));
            row.put("trClass", "sub-row");

            Map<String, Long> months = new LinkedHashMap<>();
            long annual = 0L;
            for (int m = 1; m <= 12; m++) {
                String mStr = String.format("%02d", m);
                long amt = amountMap.getOrDefault(cat.get("CATEGORYID") + "_" + mStr, 0L);
                months.put(mStr, amt);
                annual += amt;
                incomeByMonth[m] += amt;
            }
            row.put("months", months);
            row.put("annual", annual);
            totalIncome += annual;
            rows.add(row);
        }
        
        // 수입계 행
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
                long amt = amountMap.getOrDefault(cat.get("CATEGORYID") + "_" + mStr, 0L);
                months.put(mStr, amt);
                annual += amt;
                expenseByMonth[m] += amt;
            }
            row.put("months", months);
            row.put("annual", annual);
            totalExpense += annual;
            rows.add(row);
        }
        
        // 지출계 행
        rows.add(RowUtil.totalRow("지출계", "total-expense", expenseByMonth));
        rows.add(RowUtil.spacerRow());
        
        // 전월이월 행
        Map<String, Object> carryRow = new LinkedHashMap<>();
        carryRow.put("label", "전월이월");
        carryRow.put("trClass", "carry-row");
        Map<String, Long> carryMonths = new LinkedHashMap<>();
        for (int m = 1; m <= 12; m++) {
            String mStr = String.format("%02d", m);
            if (m == 1) {
                carryMonths.put(mStr, 0L); // 1월 전월이월은 0 or 초기잔액
            } else {
                String prevMStr = String.format("%02d", m - 1);
                carryMonths.put(mStr, balanceMap.getOrDefault(prevMStr, 0L));
            }
        }
        carryRow.put("months", carryMonths);
        carryRow.put("annual", null);
        rows.add(carryRow);
        
        // 잔액 행
        Map<String, Object> balanceRow = new LinkedHashMap<>();
        balanceRow.put("label", "잔액");
        balanceRow.put("trClass", "balance-row");
        Map<String, Long> balMonths = new LinkedHashMap<>();
        long lastBalance = 0L;
        for (int m = 1; m <= 12; m++) {
            String mStr = String.format("%02d", m);
            long bal = balanceMap.getOrDefault(mStr, 0L);
            balMonths.put(mStr, bal);
            if (bal > 0) lastBalance = bal;
        }
        balanceRow.put("months", balMonths);
        balanceRow.put("annual", lastBalance);
        rows.add(balanceRow);
        
        // 최종결과
        Map<String, Object> result = new HashMap<>();
        result.put("rows", rows);
        result.put("totalIncome", totalIncome);
        result.put("totalExpense", totalExpense);
        result.put("totalBalance", lastBalance);
        
        return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
        
		return null;
	}
}
