package account.lgn.service;

import java.util.Map;

public interface LgnService {
	Map<String, Object> login(Map<String, Object> inputMap) throws Exception;
	int dupCheckId(Map<String, Object> inputMap) throws Exception;
	int insertUser(Map<String, Object> inputMap) throws Exception;
}
