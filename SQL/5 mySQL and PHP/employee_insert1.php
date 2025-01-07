<?php
if(empty($_POST["send"])) {     // ตรวจสอบว่าถ้ายังไม่คลิกปุ่ม Submit ให้แสดงฟอร์มด้านล่าง
?>
<form action="employee_insert1.php" method="POST">
<! tag form โดยกำหนดให้การส่งข้อมูลไปยังตัวเอง>
แบบฟอร์มการเพิ่มข้อมูล<p>
   	รหัสพนักงาน <input type="text" name="id"><p>
	ชื่อพนักงาน <input type="text" name="name"><p>
  	ตำแหน่งงาน <input type="text" name="job"><p>
	เงินเดือน <input type="text" name="salary"><p>
	รหัสแผนก <input type="text" name="departid"><p>
     	<input type="submit" name="send" value="Submit">
     	<input type="reset" name="cancel" value="Reset">
</form> 
<! input object แต่ละตัวตั้งชื่อว่า  id, name, job, salary และ departid ตามลำดับ>
<?php
}
else {  // กรณีที่คลิกปุ่ม submit แล้วให้เก็บค่าที่ส่งมาจากแบบฟอร์มข้างบนไปใส่ในตัวแปรต่าง ๆ
	$id = $_POST["id"];
	$name = $_POST["name"];
	$job = $_POST["job"];
	$salary = $_POST["salary"];
	$departid = $_POST["departid"];
	// คำสั่ง SQL สำหรับการเพิ่มเรคคอร์ดลงในตารางฐานข้อมูล	
	$link = mysqli_connect("localhost", "root", "", "employee");
	$sql = "INSERT INTO employee 
			VALUES($id, '$name', '$job', $salary, $departid);";
	$result = mysqli_query($link, $sql);
	if ($result)	// ถ้าการเพิ่มเรคคอร์ด ไม่มีปัญหา
	{	echo "การเพิ่มข้อมูลลงในฐานข้อมูลประสบความสำเร็จ<br>";
		mysqli_close($link);
	}
	Else  //ถ้าการเพิ่มเรคคอร์ด มีปัญหา ไม่สามารถเพิ่มได้
	{	echo "ไม่สามารถเพิ่มข้อมูลใหม่ลงในฐานข้อมูลได้<br>";
	}
}
?>