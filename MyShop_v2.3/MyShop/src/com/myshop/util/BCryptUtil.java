package com.myshop.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * SHA-256 + salt password hashing utility.
 * Replaces BCrypt for zero-dependency operation.
 */
public class BCryptUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    /** Generate a 16-byte random salt (Base64 encoded, 24 chars). */
    public static String generateSalt() {
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    /** Hash password with salt using SHA-256. Returns "salt:hash". */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt.getBytes("UTF-8"));
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            return salt + ":" + Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException("Password hashing failed", e);
        }
    }

    /** Verify password against stored "salt:hash". */
    public static boolean checkPassword(String password, String stored) {
        if (stored == null || !stored.contains(":")) return false;
        String salt = stored.split(":")[0];
        String expected = hashPassword(password, salt);
        return expected.equals(stored);
    }
}
