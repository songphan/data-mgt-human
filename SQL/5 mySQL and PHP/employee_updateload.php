<?php
	if(empty($_POST["send"])) {     // ตรวจสอบว่าถ้ายังไม่คลิกปุ่ม Submit ให้แสดงฟอร์มด้านล่าง
?>
	<form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
	<! สร้างฟอร์มรับข้อมูลรหัสพนักงานที่ต้องการแก้ไข  โดยส่งข้อมูลไปยังไฟล์ตัวเอง>
		แบบฟอร์มการแก้ไขข้อมูล<p>
		กรุณากรอกรหัสพนักงานที่ต้องการแก้ไข<p>
		รหัสพนักงาน <input type="text" name="id"><p>
     		<input type="submit" name="send" value="Submit">
     		<input type="reset" name="cancel" value="Reset">
	</form>
<?php
}
else // กรณีที่ทำการคลิกปุ่ม Submit แล้ว
{
	$id = $_POST["id"];
	$link = mysqli_connect("localhost", "root", "", "employee");
	$query = "SELECT e.name, e.job, e.salary, d.name, d.departmentID 
			  FROM employee e, department d
			  WHERE e.departmentID = d.departmentID And e.employeeID = '$id';";
	// คำสั่ง SQL เพื่อดึงข้อมูลพนักงานคนที่ตรงกับรหัสพนักงานที่กรอกบนฟอร์ม
	$result = mysqli_query($link, $query);
	// สร้างฟอร์มแสดงข้อมูลพนักงาน โดยถ้าคลิกปุ่ม  Submit จะส่งไปยังไฟล์ update.php
    // โดยมีการส่งค่ารหัสพนักงานผ่านตัวแปร Empno ไปด้วย
	echo "<form action=employee_update.php?Empno=$id method=post>";
	$dbarr = mysqli_fetch_row($result);
?>
<!  ส่วนต่อไป คือการนำข้อมูลของพนักงานไปใส่ใน input object เพื่อให้สามารถแก้ไขได้> 
	รหัสพนักงาน: 	
	<?php echo "$id" ?> <br>
	ชื่อพนักงาน:
	<input type=text name=Ename value="<?=$dbarr[0]?>"> <br>
	ตำแหน่งงาน:
	<input type=text name=Ejob value="<?=$dbarr[1]?>"> <br>
	เงินเดือน:
	<input type=text name=Esalary value="<?=$dbarr[2]?>"> <br>
	แผนก:
	<select name=Edepart>"
<?php
	echo "<option value=$dbarr[4]>$dbarr[3]</option>";	
	// นำชื่อแผนกของพนักงานใส่ไว้เป็น default ของ drop down
	$sql = "select * from department;";
	// คำสั่ง SQL สำหรับการเรียกข้อมูลจากตาราง department
	$result = mysqli_query($link, $sql);
	while ($dbarr = mysqli_fetch_array($result))
{
	  echo "<option 
             value=$dbarr[departmentID]>$dbarr[name]</option>";	
	   // นำชื่อแผนกวนลูปใส่ใน drop down และรหัสแผนกใส่เป็น value
	}
	echo "</select><p>";
	echo "<input type=submit name=Submit value=Submit>";
	echo "<input type=reset name=reset value=Cancel>";
	echo "</form>";
	mysqli_close($link);
}
?>
