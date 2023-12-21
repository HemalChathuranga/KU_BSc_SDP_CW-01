<?php

    //session_start();
    
    require_once 'db_conn.php';
    
    echo "Connected successfully <br>";

    //Assigning values passed from the form to the variables 
    $username = $_POST['username'];
	$password = $_POST['password'];

    //Hashing the passed password from the signin form
    $passwordHashed = password_hash($password, PASSWORD_DEFAULT);


    echo "API_Line-21 - User Variable Value is :".$username."<br>";
	echo "API_Line-22 - Pass Variable Value is :".$password."<br>";
    echo "API_Line-22 - Pass Variable Value is :".$passwordHashed."<br>";

    $sql = "SELECT * FROM users WHERE username = '$username'";
	
	$result = mysqli_query($con, $sql);
	$count = mysqli_num_rows($result);

    echo $count;
    echo "<br>";

    if($count > 0){

        $finResult['status'] = "3";
        $finResult['message'] = "User already Exist";

        $json_data = json_encode($finResult);
    
        echo $json_data;
        mysqli_close($con);

        echo $finResult['message'];

    }else{

        $insertSql = "INSERT INTO users (username, password) VALUES ('$username', '$passwordHashed')";

        $insertQuery = mysqli_query($con, $insertSql);

            if($insertQuery){

                $finResult['status'] = "4";
                $finResult['message'] = "User Added Successfully";
                $finResult['username'] = $username;

                $json_data = json_encode($finResult);
    
                echo $json_data;
                mysqli_close($con);

                echo $finResult['message'];

            }else{
                
                $finResult['status'] = "5";
                $finResult['message'] = "User not Added Successfully";
                
                $json_data = json_encode($finResult);
    
                echo $json_data;
                mysqli_close($con);

                echo $finResult['message'];
            }
        

    }

?>