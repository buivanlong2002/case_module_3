package org.example.casemd3.util;

public class DeviceUtil {

    public static String getDeviceTypeName(String rawDeviceType) {
        switch (rawDeviceType) {
            case "Computer":
                return "Máy tính";
            case "Mobile":
                return "Điện thoại";
            case "TABLET":
                return "Máy tính bảng";
            case "WEARABLE":
                return "Thiết bị đeo";
            case "GAME_CONSOLE":
                return "Máy chơi game";
            case "UNKNOWN":
                return "Không xác định";
            default:
                return rawDeviceType; // fallback tiếng Anh
        }
    }
}