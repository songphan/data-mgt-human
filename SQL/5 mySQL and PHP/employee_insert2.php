<?php
if(empty($_POST["send"])) {     // ตรวจสอบว่าถ้ายังไม่คลิกปุ่ม Submit ให้แสดงฟอร์มด้านล่าง
?>
<form action="employee_insert2.php" method="POST">
<! tag form โดยกำหนดให้การส่งข้อมูลไปยังตัวเอง >
แบบฟอร์มการเพิ่มข้อมูล<p>
   	รหัสพนักงาน <input type="text" name="id"><p>
	ชื่อพนักงาน <input type="text" name="name"><p>
  	ตำแหน่งงาน <input type="text" name="job"><p>
	เงินเดือน <input type="text" name="salary"><p>
<?php
	// คำสั่งเชื่อมต่อฐานข้อมูล โดยต้องกำหนดชื่อโฮสต์ ชื่อผู้ใช้ รหัสผ่าน และฐานข้อมูล
	$link = mysqli_connect("localhost", "root", "", "employee");
	$query = "select * from department;";
	// ดึงทุกฟิลด์ ทุกเรคคอร์ดจากตาราง department
	$result = mysqli_query($link, $query);
	echo "แผนก <select name=departid>";
	//วนลูปเพื่อสร้าง drop down ของรายชื่อแผนก
	while ($dbarr = mysqli_fetch_array($result)) 
	{
		// ดึงชื่อแผนกมาใส่ใน drop down โดยกำหนดให้รหัสแผนกเป็น value
		echo "<option value=$dbarr[departmentID]>$dbarr[name]</option>";	
	}
	echo "</select><p>";
?>
     	<input type="submit" name="send" value="Submit">
     	<input type="reset" name="cancel" value="Reset">
</form>
<?php
}
else { // กรณีที่คลิกปุ่ม submit แล้วให้เก็บค่าที่ส่งมาจากแบบฟอร์มข้างบนไปใส่ในตัวแปรต่าง ๆ
	$id = $_POST["id"];
	$name = $_POST["name"];
	$job = $_POST["job"];
	$salary = $_POST["salary"];
	$departid = $_POST["departid"];
	$link = mysqli_connect("localhost", "root", "", "employee");
	// คำสั่ง SQL สำหรับการเพิ่มเรคคอร์ดลงในตาราง employee
	$sql = "INSERT INTO employee 
			VALUES($id, '$name', '$job', $salary, $departid);";
	$result = mysqli_query($link, $sql);
	if ($result)
	{	echo "การเพิ่มข้อมูลลงในฐานข้อมูลประสบความสำเร็จ<br>";
		mysqli_close($link);	}
	else	// กรณีที่ไม่สามารถเพิ่มเรคคอร์ดได้
	{	echo "ไม่สามารถเพิ่มข้อมูลใหม่ลงในฐานข้อมูลได้<br>";	}
}
?>
