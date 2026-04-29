package account.usr.service;

import java.util.Map;

public interface UsrService {

	Map<String, Object> selectUser(Map<String, Object> inputMap) throws Exception;
	int updateUser(Map<String, Object> inputMap) throws Exception;
}
