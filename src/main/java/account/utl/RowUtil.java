package account.utl;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class RowUtil {
	
	public static Map<String, Object> sectionRow(String label) {
        
		Map<String, Object> row = new HashMap<>();
		
        row.put("type", "section");
        row.put("label", label);
        
        return row;
    }

    public static Map<String, Object> spacerRow() {
        
    	Map<String, Object> row = new HashMap<>();
    	
        row.put("type", "spacer");
        
        return row;
    }

    public static Map<String, Object> totalRow(String label, String trClass, long[] byMonth) {
       
    	Map<String, Object> row = new LinkedHashMap<>();
    	
        row.put("label", label);
        row.put("trClass", trClass);
        
        Map<String, Long> months = new LinkedHashMap<>();
        long annual = 0L;
        
        for (int m = 1; m <= 12; m++) {
            String mStr = String.format("%02d", m);
            months.put(mStr, byMonth[m]);
            annual += byMonth[m];
        }
        
        row.put("months", months);
        row.put("annual", annual);
        
        return row;
    }
}
