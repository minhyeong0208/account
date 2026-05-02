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
	
	/**
	 * 계좌 저장
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveAccount.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveAccount(@RequestBody Map<String, Object> inputMap) throws Exception {

		svgService.saveAccount(inputMap);
		
		return "success";
	}
	
	/**
	 * 계좌 페이징
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAccountListPaging.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> selectAccountListPaging(@RequestParam Map<String, Object> inputMap) throws Exception {

		Map<String, Object> resultMap = new HashMap<>();

	    List<Map<String, Object>> list = svgService.selectAccountListPaging(inputMap);
	    int totalCount = svgService.selectAccountCnt(inputMap);

	    resultMap.put("list", list);
	    resultMap.put("totalCount", totalCount);

	    return resultMap;
	}
	
	/**
	 * 계좌 삭제
	 * @param inputList
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteAccount.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteAccount(@RequestBody List<String> inputList) throws Exception {
		
		svgService.deleteAccount(inputList);

		return "success";
	}
	
	/**
	 * 계좌 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAccountList.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> selectAccountList(@RequestParam Map<String, Object> paramMap) throws Exception {

		return svgService.selectAccountList(paramMap);
	}
	
	
	/**
	 * 적금관리 페이지
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/svg02m00.do", method = RequestMethod.POST)
    public String selectSvg02M00List(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		List<Map<String, Object>> savingsList = svgService.selectSavingsList(inputMap);
		Map<String, Object> savingsSummary = svgService.selectSavingsSummary(inputMap);

		model.addAttribute("savingsList", savingsList);
		model.addAttribute("savingsSummary", savingsSummary);

        return "account/svg/svg02m00";
    }
	
	/**
	 * 적금 등록
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveSavings.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveSavings(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		try {
	        int res = svgService.insertSavings(inputMap);
	        return res > 0 ? "success" : "fail";
	    } catch (Exception e) {
	    	e.printStackTrace();
	        return "error";
	    }
	}
	
	@RequestMapping(value = "/deleteSavings.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteSavings(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		try {
	        int res = svgService.deleteSavings(inputMap);
	        return res > 0 ? "success" : "fail";
	    } catch (Exception e) {
	    	e.printStackTrace();
	        return "error";
	    }
	}
	
	/**
	 * 적금상세 페이지
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/svg03m00.do", method = RequestMethod.POST)
    public String selectSvg03M00List(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		try {
		
			Map<String, Object> savings = svgService.selectSavingsOne(inputMap);
		
			model.addAttribute("savings", savings);

		} catch (Exception e) {
			e.printStackTrace();
		}
        return "account/svg/svg03m00";
    }
	
	/**
	 * 적금상세/정기
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/svg03m01.do", method = RequestMethod.POST)
    public String selectSvg03M01View(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		List<Map<String, Object>> detail = svgService.selectSavingsDetail(inputMap);
		
		model.addAttribute("detail", detail);
		
		return "account/svg/svg03m01";
	}
	
	/**
	 * 적금 납입 처리
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/checkPayment.do", method = RequestMethod.POST)
	@ResponseBody
    public String checkPayment(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		try {
			int res = svgService.updateIsPaid(inputMap);
	        return res > 0 ? "success" : "fail";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
	}
	
	/**
	 * 적금상세/추가
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/svg03m02.do", method = RequestMethod.POST)
    public String selectSvg03M02View(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {

		Map<String, Object> result = svgService.selectExtraDetail(inputMap);

		model.addAttribute("detail", result.get("detail"));
		model.addAttribute("extraTotalAmount", result.get("extraTotalAmount"));
		model.addAttribute("extraCount", result.get("extraCount"));
		
		return "account/svg/svg03m02";
	}
	
	/**
	 * 추가납입 저장
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveAddSavings.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveAddSavings(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		try {
			int res = svgService.insertAddSavingsHistory(inputMap);
			return res > 0 ? "success" : "fail";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
	}
	
	/**
	 * 추가납입 내역 삭제
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteAddSavings.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteAddSavings(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		try {
			int res = svgService.deleteAddSavings(inputMap);
			return res > 0 ? "success" : "fail";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
	}
}
