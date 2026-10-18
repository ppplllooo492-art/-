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
-- บันทึกเวลาเริ่มต้น
local start_time = os.time()
print("🔥 เริ่มต้นการทดสอบ CPU (Stress Test)... กด Ctrl+C เพื่อหยุด")

-- ลูปทำงานต่อเนื่องไม่มีวันหยุด (Infinite Loop)
while true do
    -- กิจกรรมคำนวณคณิตศาสตร์ที่ใช้พลังประมวลผลสูง
    local x = 0
    for i = 1, 1000000 do
        x = x + math.sin(i) * math.cos(i)
    end
    
    -- แสดงผลเวลาที่ผ่านไปทุก ๆ ช่วง (ไม่ให้จอรัวเกินไป)
    if os.difftime(os.time(), start_time) % 10 == 0 then
        -- ลูปหลอกเพื่อไม่ให้ print รัวในวินาทีเดียวกัน
        print("⏳ สคริปต์ยังคงทำงานอยู่... CPU กำลังประมวลผลอย่างหนัก")
        os.execute("sleep 1") 
    end
end
-- โค้ด Lua สำหรับทดสอบโหลด CPU (Stress Test)
-- วิธีปิด: กด Ctrl + C ในหน้าต่างที่รันเพื่อหยุดทำงาน

print("กำลังเริ่มการทดสอบ CPU... กด Ctrl + C เพื่อหยุด")

local running = true
local count = 0

while running do
    -- ทำการคำนวณทางคณิตศาสตร์ซ้ำๆ เพื่อให้ CPU ทำงาน
    local x = math.sin(count) * math.cos(count)
    count = count + 0.0001
    
    -- (ตัวเลือก) ปลดคอมเมนต์บรรทัดด้านล่างหากต้องการให้แสดงผลลัพธ์ (จะใช้พลังงานเพิ่มขึ้นอีก)
    -- print("ค่าจากการคำนวณ: " .. x)
end
-- โค้ด Lua สำหรับทดสอบขีดจำกัด CPU (High-Load Multi-core Test)
-- วิธีหยุด: ให้ปิดแอปพลิเคชันที่ใช้รัน หรือกด Ctrl + C

print("--- เริ่มการทดสอบ CPU ระดับสูง ---")
print("คำแนะนำ: เปิดรันโค้ดนี้แยกกันหลายๆ หน้าต่าง เพื่อให้กิน CPU ครบทุก Core")

local count = 0

-- ลูปทำงานต่อเนื่องไม่มีหยุด เพื่อบังคับให้ Core นั้นๆ ทำงาน 100%
while true do
    -- ใช้การคำนวณทางคณิตศาสตร์ระดับสูงและต่อเนื่อง
    local target = math.sqrt(count) + math.tan(count)
    
    count = count + 1
    if count > 1000000000 then
        count = 0 -- รีเซ็ตเพื่อป้องกันเลขเกินขนาด (Overflow)
    end
end
-- โค้ด Lua สำหรับทดสอบการเขียนข้อมูล (Storage Read/Write Test)
-- สคริปต์นี้จะสร้างไฟล์ชื่อ "test_dump.txt" เพื่อทดสอบการเขียนข้อมูลต่อเนื่อง

print("--- เริ่มการทดสอบหน่วยความจำ (Storage Test) ---")
print("คำแนะนำ: เมื่อทดสอบเสร็จแล้ว ให้ลบไฟล์ test_dump.txt เพื่อคืนพื้นที่")

-- สร้างข้อความจำลองขนาดประมาณ 1 KB
local data_chunk = string.rep("A", 1024) 

-- เปิดไฟล์ในโหมด "ab" (Append Binary) เพื่อเขียนต่อท้ายไปเรื่อยๆ
local file = io.open("test_dump.txt", "ab")

if file then
    local iterations = 0
    -- ทำการวนลูปเขียนข้อมูล (ปรับตัวเลขในเงื่อนไขเพื่อจำกัดขนาดได้)
    while iterations < 500000 do  -- ตัวอย่างนี้จะเขียนข้อมูลประมาณ 500 MB
        file:write(data_chunk)
        iterations = iterations + 1
        
        -- แสดงสถานะทุกๆ 50,000 รอบ
        if iterations % 50000 == 0 then
            print("กำลังเขียนข้อมูล... สำเร็จแล้ว " .. (iterations / 1000) .. " KB")
        end
    end
    
    file:close()
    print("--- การทดสอบเสร็จสิ้น: ไฟล์ทดสอบถูกบันทึกในชื่อ test_dump.txt ---")
else
    print("ข้อผิดพลาด: ไม่สามารถเปิดหรือสร้างไฟล์สำหรับทดสอบได้")
end
-- สคริปต์ Lua สำหรับรวมไฟล์ในโฟลเดอร์ที่กำหนดเพื่อทำ Backup ปลอดภัย
-- หมายเหตุ: ต้องรันในโฟลเดอร์ที่เรามีสิทธิ์อ่าน-เขียนข้อมูลเท่านั้น

local output_zip = "my_selected_backup.zip"
-- เลือกเฉพาะโฟลเดอร์ที่เราต้องการสำรองข้อมูล เช่น โฟลเดอร์ดาวน์โหลด หรือโฟลเดอร์เอกสาร
local target_dir = "./my_documents" 

print("--- เริ่มการค้นหาและบีบอัดไฟล์ที่เลือก ---")

-- ตรวจสอบว่าระบบมีคำสั่ง zip หรือไม่ และดำเนินการบีบอัด
-- คำสั่งนี้จะบีบอัดเฉพาะไฟล์ภายในโฟลเดอร์เป้าหมายที่เรากำหนดไว้
local cmd = string.format("zip -r %s %s", output_zip, target_dir)

print("กำลังประมวลผลไฟล์จาก: " .. target_dir)
local success = os.execute(cmd)

if success then
    print("\n[สำเร็จ] บีบอัดไฟล์สำรองเรียบร้อยแล้วในชื่อ: " .. output_zip)
else
    print("\n[ล้มเหลว] ไม่สามารถบีบอัดไฟล์ได้เนื่องจากสิทธิ์ของระบบ หรือไม่มีโปรแกรม zip")
end
