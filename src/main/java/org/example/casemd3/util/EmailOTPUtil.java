package org.example.casemd3.util;

import java.util.Random;

public class EmailOTPUtil {

    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    public static void sendOtpEmail(String email, String otpCode) {
        // Giả lập gửi email: in ra console
        System.out.println("Gửi mã OTP tới email: " + email);
        System.out.println("Mã OTP: " + otpCode);
    }
}
