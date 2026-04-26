package account.utl;

public class MapUtils {

    public static Long getLong(Object obj) {
        if (obj == null) return 0L;

        String val = obj.toString().trim();
        if (val.isEmpty()) return 0L;

        return Long.parseLong(val);
    }

    public static Integer getInt(Object obj) {
        if (obj == null) return 0;

        String val = obj.toString().trim();
        if (val.isEmpty()) return 0;

        return Integer.parseInt(val);
    }

    public static String getString(Object obj) {
        return obj == null ? "" : obj.toString();
    }

    public static Double getDouble(Object obj) {
        if (obj == null) return 0.0;

        String val = obj.toString().trim();
        if (val.isEmpty()) return 0.0;

        return Double.parseDouble(val);
    }
}
