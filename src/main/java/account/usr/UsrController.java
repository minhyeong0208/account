package account.usr;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/usr")
public class UsrController {
	
	/**
	 * 내 정보
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/usr00m00.do")
	public String selectUsr00M00(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		return "account/usr/usr00m00";
	}
}
