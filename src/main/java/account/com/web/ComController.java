package account.com.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/com")
public class ComController {

	@RequestMapping("/main.do")
    public String main() {

        return "account/com/layout";
    }

//    @RequestMapping("/mainContent.do")
//    public String mainContent() {
//        return "account/use/use00m00";
//    }
}
