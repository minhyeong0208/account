package account.svg.service;

import java.util.List;
import java.util.Map;

public interface SvgService {

	List<Map<String, Object>> selectCategoryList(Map<String, Object> inputMap) throws Exception;
	void saveCategory(Map<String, Object> inputMap) throws Exception;
	void deleteCategory(List<String> inputList) throws Exception;
	
	List<Map<String, Object>> selectAccountListPaging(Map<String, Object> inputMap) throws Exception;
	void saveAccount(Map<String, Object> inputMap) throws Exception;
	void deleteAccount(List<String> inputList) throws Exception;
	int selectAccountCnt(Map<String, Object> inputMap) throws Exception;
	List<Map<String, Object>> selectAccountList(Map<String, Object> inputMap) throws Exception;
	
	int insertSavings(Map<String, Object> inputMap) throws Exception;
	List<Map<String, Object>> selectSavingsList(Map<String, Object> inputMap) throws Exception;
	Map<String, Object> selectSavingsSummary(Map<String, Object> inputMap) throws Exception;
	int deleteSavings(Map<String, Object> inputMap) throws Exception;
	
	Map<String, Object> selectSavingsOne(Map<String, Object> inputMap) throws Exception;
	List<Map<String, Object>> selectSavingsDetail(Map<String, Object> inputMap) throws Exception;
	
	int updateIsPaid(Map<String, Object> inputMap) throws Exception;
	int insertAddSavingsHistory(Map<String, Object> inputMap) throws Exception;
	int deleteAddSavings(Map<String, Object> inputMap) throws Exception;
	Map<String, Object> selectExtraDetail(Map<String, Object> inputMap) throws Exception;
}
