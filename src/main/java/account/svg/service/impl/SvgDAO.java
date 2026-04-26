package account.svg.service.impl;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

@Repository("svgDAO")
public class SvgDAO extends EgovAbstractMapper {

	public List<Map<String, Object>> selectCategoryList(Map<String, Object> inputMap) throws Exception {
		return selectList("SvgMapper.selectCategoryList", inputMap);
	}
	
	int insertCategory(Map<String, Object> inputMap) throws Exception {
		return insert("SvgMapper.insertCategory", inputMap);
	}
	
	int updateCategory(Map<String, Object> inputMap) throws Exception {
		return update("SvgMapper.updateCategory", inputMap);
	}
	
	int deleteCategoryAll(Map<String, Object> inputMap) throws Exception {
		return delete("SvgMapper.deleteCategoryAll", inputMap);
	}
	
	int deleteCategory(Map<String, Object> inputMap) throws Exception {
		return delete("SvgMapper.deleteCategory", inputMap);
	}
	
	
	List<Map<String, Object>> selectAccountListPaging(Map<String, Object> inputMap) throws Exception {
		return selectList("SvgMapper.selectAccountListPaging", inputMap);
	}
	
	int insertAccount(Map<String, Object> inputMap) throws Exception {
		return insert("SvgMapper.insertAccount", inputMap);
	}
	
	int updateAccount(Map<String, Object> inputMap) throws Exception {
		return update("SvgMapper.updateAccount", inputMap);
	}
	
	int deleteAccount(Map<String, Object> inputMap) throws Exception {
		return delete("SvgMapper.deleteAccount", inputMap);
	}
	
	int selectAccountCnt(Map<String, Object> inputMap) throws Exception {
		return selectOne("SvgMapper.selectAccountCnt", inputMap);
	}
	
	public List<Map<String, Object>> selectAccountList(Map<String, Object> inputMap) throws Exception {
		return selectList("SvgMapper.selectAccountList", inputMap);
	}
}
