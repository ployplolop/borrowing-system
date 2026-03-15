<?php
// การตั้งค่าสำหรับเชื่อมต่อานข้อมลใน Docker
$host = 'db'; // ใช้ 'db' ตามชื่อ service ของานข้อมลใน docker-compose.yml
$dbname = 'borrowings_db'; // ชื่อานข้อมลใหม่ที่คุกำหนด
$username = 'dev_user';
$password = 'dev_password';

try {
    // สร้างการเชื่อมต่อานข้อมลผ่าน PDO
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch(PDOException $e) {
    // หากเชื่อมต่อไม่สำเรจ ให้แสดงข้อความแจ้งเตือน
    die("Connection failed: " . $e->getMessage());
}
?>
