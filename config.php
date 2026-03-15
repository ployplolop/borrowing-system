<?php
// การตั้งค่าสำหรับเชื่อมต่อฐานข้อมูลใน Docker
$host = 'db'; // ใช้ 'db' ตามชื่อ service ของฐานข้อมูลใน docker-compose.yml
$dbname = 'borrowings_db'; // ชื่อฐานข้อมูลใหม่ที่คุณกำหนด
$username = 'dev_user';
$password = 'dev_password';

try {
    // สร้างการเชื่อมต่อฐานข้อมูลผ่าน PDO
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch(PDOException $e) {
    // หากเชื่อมต่อไม่สำเร็จ ให้แสดงข้อความแจ้งเตือน
    die("Connection failed: " . $e->getMessage());
}
?>