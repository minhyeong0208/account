package account.use.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import account.com.service.SessionManager;
import account.use.service.UseService;

@Controller
@RequestMapping("/use")
public class UseController {

	@Resource(name = "useService")
	private UseService useService;
	
	/**
	 * 월별 관리
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/use00m00.do", method = RequestMethod.POST)
	public String selectUse00M00(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		return "account/use/use00m00";
	}
	
	/**
	 * 거래내역 저장
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveHistory.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveHistory(@RequestBody Map<String, Object> inputMap) throws Exception {
		
		useService.saveHistory(inputMap);
		
		return "success";
	}
	
	@RequestMapping(value = "/selectHistoryListPaging.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> selectHistoryListPaging(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<>();
		
	    List<Map<String, Object>> list = useService.selectHistoryListPaging(inputMap);
	    int totalCount = useService.selectHistoryCnt(inputMap);
	    
	    resultMap.put("list", list);
	    resultMap.put("totalCount", totalCount);
	    
	    return resultMap;
	}
	
	
	/**
	 * 거래내역 삭제
	 * @param inputList
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteHistory.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteHistory(@RequestBody List<String> inputList) throws Exception {
		
		useService.deleteHistory(inputList);

		return "success";
	}
	
	@RequestMapping(value = "/selectTranCategoryList.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> selectTranCategoryList(@RequestParam Map<String, Object> inputList) throws Exception {
		return useService.selectTranCategoryList(inputList);
	}
	
	@RequestMapping(value = "/getMonthlySummary.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getMonthlySummary(@RequestParam Map<String, Object> inputMap) throws Exception {

	    return useService.getMonthlySummary(inputMap);
	}
	
	/**
	 * 엑셀 업로드
	 * @param bank
	 * @param file
	 * @param month
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/uploadExcel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> uploadExcel(@RequestParam Map<String, Object> inputMap
		    							 , @RequestParam("file") MultipartFile file) throws Exception {
	    
	    return useService.uploadExcel(inputMap, file);
	}
	
	/**
	 * 연간정리
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/use01m00.do", method = RequestMethod.POST)
    public String selectUse01M00(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
        return "account/use/use01m00";
    }
	
	/**
	 * 연간정리/전체내역
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/use01m01.do", method = RequestMethod.POST)
    public String selectUse01m01(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		Map<String, Object> data = useService.getAnnualData(inputMap);
		
		model.addAttribute("rows",         data.get("rows"));
	    model.addAttribute("totalIncome",  data.get("totalIncome"));
	    model.addAttribute("totalExpense", data.get("totalExpense"));
	    model.addAttribute("totalBalance", data.get("totalBalance"));
	    model.addAttribute("months", new String[]{"01","02","03","04","05","06","07","08","09","10","11","12"});
		
        return "account/use/use01m01";
    }
	
	/**
	 * 연간정리/차트
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/use01m02.do", method = RequestMethod.POST)
    public String selectUse01m02(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		Map<String, Object> data = useService.getAnnualData(inputMap);

		long[] income = (long[]) data.get("incomeByMonth");
		
	    model.addAttribute("totalIncome",  data.get("totalIncome"));
	    model.addAttribute("totalExpense", data.get("totalExpense"));
	    model.addAttribute("totalBalance", data.get("totalBalance"));
	    model.addAttribute("incomeByMonth",  data.get("incomeByMonth"));
	    model.addAttribute("expenseByMonth", data.get("expenseByMonth"));

	    return "account/use/use01m02";

    }
	
	/**
	 * 미등록 카테고리 저장
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveUnregAndUpload.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveUnregAndUpload(@RequestBody Map<String, Object> inputMap) throws Exception {
	    
		useService.saveUnregAndUpload(inputMap);
	    
		return "success";
	}
}
