package account.use.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface UseService {

	List<Map<String, Object>> selectHistoryList(Map<String, Object> inputMap) throws Exception;
	void saveHistory(Map<String, Object> inputMap) throws Exception;
	void deleteHistory(List<String> inputList) throws Exception;
	List<Map<String, Object>> selectHistoryListPaging(Map<String, Object> inputMap) throws Exception;
	int selectHistoryCnt(Map<String, Object> inputMap) throws Exception;
	List<Map<String, Object>> selectTranCategoryList(Map<String, Object> inputMap) throws Exception;
	Map<String, Object> getMonthlySummary(Map<String, Object> inputMap) throws Exception; 
	Map<String, Object> getAnnualData(Map<String, Object> inputMap) throws Exception;
	Map<String, Object> uploadExcel(Map<String, Object> inputMap, MultipartFile file) throws Exception;
	void saveUnregAndUpload(Map<String, Object> inputMap) throws Exception;
}
