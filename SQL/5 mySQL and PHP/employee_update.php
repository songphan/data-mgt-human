<?php
	//รับค่าตัวแปรมาจากฟอร์มที่ส่งค่ามา
	$Ename = $_POST["Ename"];
	$Ejob = $_POST["Ejob"];
	$Esalary = $_POST["Esalary"];
	$Edepart = $_POST["Edepart"];
	$Empno = $_GET["Empno"];
	// สร้างการเชื่อมต่อไปยัง MySQL โดยระบุชื่อโฮสต์ ชื่อผู้ใช้ และรหัสผ่าน
	$link = mysqli_connect("localhost", "root", "", "employee");
	$sql = "UPDATE employee SET name='$Ename', job='$Ejob', salary='$Esalary', departmentID = $Edepart 
			WHERE employeeID ='$Empno' ";
      // คำสั่งแก้ไขเรคคอร์ดในตาราง employee โดยแก้ไขพนักงานที่มีรหัสพนักงานตรงกับที่ส่งค่ามา
	$result = mysqli_query($link, $sql);
	if ($result)
	{
		echo "การแก้ไขข้อมูลในฐานข้อมูลประสบความสำเร็จ<br>";
		mysqli_close($link);
	}
	else
	{
		echo "ไม่สามารถแก้ไขข้อมูลในฐานข้อมูลได้<br>";
	}
?>
