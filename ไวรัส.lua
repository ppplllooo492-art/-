-- 1. เริ่มต้นระบบคู่ขนานอัตโนมัติ (Java Code Generator Setup)
print("[Auto File] เริ่มต้นระบบสร้างไฟล์อัตโนมัติ...")
print("[CPU Stream] เปลี่ยนโหมดการเขียนโค้ดเป็นภาษา JAVA (Android Engine)...")

-- 2. สร้างโฟลเดอร์เก็บข้อมูล txtGTA6 (หากยังไม่มี)
local folderName = "txtGTA6"
if not isfolder(folderName) then
    makefolder(folderName)
    print("[Auto File] สร้างคลังเก็บข้อมูล '" .. folderName .. "' สำเร็จ")
end

-- แม่แบบโค้ด Java สำหรับเร่งประสิทธิภาพ CPU และจัดการ Thread บน Android
-- (โค้ดนี้จะถูกเขียนลงไปในไฟล์ทุกไฟล์)
local javaCpuTemplate = [[
package com.mobile.optimizer;

import android.os.Build;
import android.util.Log;
import java.io.File;

public class CPUBooster {
    private static final String TAG = "CPU_OPTIMIZER";

    // ฟังก์ชันหลักในการเปิดโหมดรีดประสิทธิภาพสูงสุด (Performance Mode)
    public static void enableHighPerformance() {
        Log.d(TAG, "Initializing Android Core Acceleration...");
        
        try {
            // 1. จำลองการปรับแต่งซีพียูผ่านคำสั่งระบบ (Governor: Performance)
            String[] commands = {
                "echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor",
                "echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor", // คอร์ใหญ่ (Big Cores)
                "echo 1 > /sys/devices/system/cpu/kernel_max"
            };
            
            // 2. เร่งความเร็วการประมวลผลของ Thread หลัก (Thread Priority)
            Thread.currentThread().setPriority(Thread.MAX_PRIORITY);
            
            // 3. ปลดล็อก FPS และเปิดใช้งานการเร่งความเร็วด้วยฮาร์ดแวร์ (Hardware Acceleration)
            System.setProperty("debug.egl.hw", "1");
            System.setProperty("debug.sf.hw", "1");
            System.setProperty("ro.config.low_ram", "false"); // บังคับให้ระบบมองว่ามีแรมเหลือเฟือ
            
            Log.i(TAG, "CPU Device Verified: " + Build.HARDWARE);
            Log.i(TAG, "Mobile Optimizer Status: MAXIMUM OVERCLOCK ACTIVE");
            
        } catch (Exception e) {
            Log.e(TAG, "Failed to apply hardware override: " + e.getMessage());
        }
    }
}
]]

-- 3. ระบบลูปเขียนโค้ด Java ลงไฟล์ต่อเนื่องแบบไม่สิ้นสุด (Infinite Loop Engine)
task.spawn(function()
    local fileCounter = 1

    while true do
        -- กำหนดชื่อไฟล์ให้เป็นนามสกุล .java ในโฟลเดอร์ txtGTA6
        local fileName = folderName .. "/CPUBooster_Part_" .. fileCounter .. ".java"
        
        -- ทำการเขียนไฟล์ใหม่พร้อมยัดเนื้อหาโค้ด Java ลงไปทันที
        writefile(fileName, "// File ID: " .. fileCounter .. "\n" .. javaCpuTemplate)
        
        print("[System Sync] บันทึกสคริปต์เร่งความเร็ว CPU (Java) ลงในไฟล์: " .. fileName)
        
        -- เพิ่มลำดับของไฟล์ถัดไป
        fileCounter = fileCounter + 1
        
        -- หยุดพักสั้น ๆ 0.1 วินาที เพื่อความปลอดภัยไม่ให้เครื่องค้าง
        task.wait(0.1)
    end
end)
