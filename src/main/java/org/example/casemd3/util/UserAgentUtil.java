package org.example.casemd3.util;


public class UserAgentUtil {
    public static String getBrowserName(String userAgent) {
        if (userAgent == null) return "Không xác định";

        if (userAgent.contains("CocCoc")) return "Cốc Cốc";
        if (userAgent.contains("Edg/")) return "Microsoft Edge";
        if (userAgent.contains("Chrome/")) return "Google Chrome";
        if (userAgent.contains("Firefox/")) return "Mozilla Firefox";
        if (userAgent.contains("Safari/") && !userAgent.contains("Chrome/")) return "Safari";

        return "Trình duyệt khác";
    }
}
