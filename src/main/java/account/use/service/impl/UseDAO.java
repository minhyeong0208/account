package account.use.service.impl;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

@Repository("useDAO")
public class UseDAO extends EgovAbstractMapper {

	/**
	 * 입출금내역 조회
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectHistoryList(Map<String, Object> inputMap) throws Exception {
		return selectList("UseMapper.selectHistoryList", inputMap);
	}
	
	/**
	 * 입출금내역 추가
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	int insertHistory(Map<String, Object> inputMap) throws Exception {
		return insert("UseMapper.insertHistory", inputMap);
	}
	
	/**
	 * 입출금내역 수정
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	int updateHistory(Map<String, Object> inputMap) throws Exception {
		return update("UseMapper.updateHistory", inputMap);
	}
	
	/**
	 * 계좌ID 조회
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	Long selectAccountId(Map<String, Object> inputMap) throws Exception {
		return selectOne("UseMapper.selectAccountId", inputMap);
	}
	
	List<Map<String, Object>> selectHistoryListPaging(Map<String, Object> inputMap) throws Exception {
		return selectList("UseMapper.selectHistoryListPaging", inputMap);
	}
	
	int selectHistoryCnt(Map<String, Object> inputMap) throws Exception {
		return selectOne("UseMapper.selectHistoryCnt", inputMap);
	}
	
	int deleteHistory(Map<String, Object> inputMap) throws Exception {
		return delete("UseMapper.deleteHistory", inputMap);
	}
	
	/**
	 * 입출금내역 내 항목 조회
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectTranCategoryList(Map<String, Object> inputMap) throws Exception {
		return selectList("UseMapper.selectTranCategoryList", inputMap);
	}

	/**
	 * 거래별 계좌 잔액 갱신
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	int updateAfterAmount(Map<String, Object> inputMap) throws Exception {
		return update("UseMapper.updateAfterAmount", inputMap);
	}
	
	/**
	 * 월 수입, 지출 조회
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectMonthlySummary(Map<String, Object> inputMap) throws Exception {
		return selectOne("UseMapper.selectMonthlySummary", inputMap);
	}
	
	/**
	 * 월 마지막 잔액 조회
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	Long selectLastBalance(Map<String, Object> inputMap) throws Exception {
		return selectOne("UseMapper.selectLastBalance", inputMap);
	}
	
	/**
	 * 월별 카테고리별 금액
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectMonthlyAmountByCategory(Map<String, Object> inputMap) throws Exception {
		return selectList("UseMapper.selectMonthlyAmountByCategory", inputMap);
	}
	
	/**
	 * 월별 마지막 잔액
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectMonthlyLastBalance(Map<String, Object> inputMap) throws Exception {
		return selectList("UseMapper.selectMonthlyLastBalance", inputMap);
	}
} 
