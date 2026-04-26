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
}
