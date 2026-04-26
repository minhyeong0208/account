package account.utl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.web.multipart.MultipartFile;

public class ExcelParser {

	public static List<Map<String, Object>> parse(String bank, MultipartFile file) throws Exception {
        Workbook workbook = WorkbookFactory.create(file.getInputStream());
        Sheet sheet = workbook.getSheetAt(0);
        List<Map<String, Object>> list = new ArrayList<>();

        if ("SH".equals(bank)) {
            list = parseShinhan(sheet);
        } else if ("KM".equals(bank)) {
            list = parseKookmin(sheet);
        } else if ("WR".equals(bank)) {
            list = parseWoori(sheet);
        }

        workbook.close();
        return list;
    }

    private static List<Map<String, Object>> parseShinhan(Sheet sheet) {
        List<Map<String, Object>> list = new ArrayList<>();
        for (int i = 7; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;

            String tranDate = getCellValue(row.getCell(0)).replace(".", "-").trim();
            String outAmt   = getCellValue(row.getCell(1)).replaceAll(",", "").trim();
            String inAmt    = getCellValue(row.getCell(2)).replaceAll(",", "").trim();
            String desc     = getCellValue(row.getCell(3)).trim();

            boolean hasOut = !outAmt.isEmpty() && !"0".equals(outAmt);
            boolean hasIn  = !inAmt.isEmpty()  && !"0".equals(inAmt);
            
            if (desc.isEmpty()) continue;
            
            String type   = outAmt.isEmpty() ? "I" : "O";
            String amount = outAmt.isEmpty() ? inAmt : outAmt;
            if (amount.isEmpty()) continue;

            Map<String, Object> map = new HashMap<>();
            map.put("TRANDATE",    tranDate);
            map.put("TRANAMOUNT",  amount);
            map.put("DESCRIPTION", desc);
            map.put("TRANTYPE",    type);
            list.add(map);
        }
        return list;
    }

    // 국민, 우리는 나중에 추가
    private static List<Map<String, Object>> parseKookmin(Sheet sheet) {
        return new ArrayList<>();
    }

    private static List<Map<String, Object>> parseWoori(Sheet sheet) {
        return new ArrayList<>();
    }

    private static String getCellValue(Cell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING:  return cell.getStringCellValue();
            case NUMERIC: return String.valueOf((long) cell.getNumericCellValue());
            case BLANK:   return "";
            default:      return "";
        }
    }
}
