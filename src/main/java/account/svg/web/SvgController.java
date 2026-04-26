package account.svg.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import account.svg.service.SvgService;

@Controller
@RequestMapping("/svg")
public class SvgController {

	@Resource(name = "svgService")
	private SvgService svgService;
	
	/**
	 * 사용처 관리 목록 페이지
	 * @return
	 */
	@RequestMapping(value = "/svg00m00.do", method = RequestMethod.POST)
    public String selectSvg00M00List(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		List<Map<String, Object>> cList = svgService.selectCategoryList(inputMap);
		
		model.addAttribute("cList", cList);
		
        return "account/svg/svg00m00";
    }
	
	/**
	 * 사용처 관리 저장
	 * @param inputList
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCategory.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveCategory(@RequestBody Map<String, Object> inputMap) throws Exception {
		
		svgService.saveCategory(inputMap);
		
		return "success";
	}
	
	/**
	 * 사용처 관리 삭제
	 * @param inputList
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteCategory.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteCategory(@RequestBody List<String> inputList) throws Exception {
		
		svgService.deleteCategory(inputList);

		return "success";
	}
	
	/**
	 * 사용자 관리 목록 갱신
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCategoryList.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> selectCategoryList(@RequestParam Map<String, Object> paramMap) throws Exception {

		return svgService.selectCategoryList(paramMap);
	}
	
	/**
	 * 계좌 관리 목록 페이지
	 * @return
	 */
	@RequestMapping(value = "/svg01m00.do", method = RequestMethod.POST)
    public String selectSvg01M00List(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
        return "account/svg/svg01m00";
    }
	
	
	@RequestMapping(value = "/saveAccount.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveAccount(@RequestBody Map<String, Object> inputMap) throws Exception {

		svgService.saveAccount(inputMap);
		
		return "success";
	}
	
	@RequestMapping(value = "/selectAccountListPaging.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> selectAccountListPaging(@RequestParam Map<String, Object> inputMap) throws Exception {

		Map<String, Object> resultMap = new HashMap<>();

	    List<Map<String, Object>> list = svgService.selectAccountListPaging(inputMap);
	    int totalCount = svgService.selectAccountCnt(inputMap);
	    System.out.println("list="+list);
	    resultMap.put("list", list);
	    resultMap.put("totalCount", totalCount);

	    return resultMap;
	}
	
	@RequestMapping(value = "/deleteAccount.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteAccount(@RequestBody List<String> inputList) throws Exception {
		
		svgService.deleteAccount(inputList);

		return "success";
	}
	
	@RequestMapping(value = "/selectAccountList.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> selectAccountList(@RequestParam Map<String, Object> paramMap) throws Exception {

		return svgService.selectAccountList(paramMap);
	}
	
}
