package org.example.casemd3.util;

public class UserAgentUtil {
    public static String getBrowserName(String userAgent) {
        if (userAgent == null) return "Không xác định";

        userAgent = userAgent.toLowerCase();

        if (userAgent.contains("coccoc") || userAgent.contains("coc_coc_browser")) {
            return "Cốc Cốc";
        }

        if (userAgent.contains("edg/")) {
            return "Microsoft Edge";
        }

        if (userAgent.contains("chrome/")) {
            // Có thể là Cốc Cốc cải trang
            if (userAgent.contains("135.0.0.0") || userAgent.contains("136.0.0.0")) {
                return "Có thể là Cốc Cốc";
            }
            return "Google Chrome";
        }

        if (userAgent.contains("firefox/")) {
            return "Mozilla Firefox";
        }

        if (userAgent.contains("safari/") && !userAgent.contains("chrome/")) {
            return "Safari";
        }

        return "Trình duyệt khác";
    }
}
