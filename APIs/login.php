<?php

    //session_start();
    
    require_once 'db_conn.php';
    
    // echo "Connected successfully <br>";

    //Assigning values passed from the form to the variables 
    $username = $_POST['username'];
	$password = $_POST['password'];


    $sql = "SELECT * FROM users WHERE email = '$username'";
	
	$result = mysqli_query($con, $sql);
	$count = mysqli_num_rows($result);


    if($count == 1){

        $row = mysqli_fetch_assoc($result);

        $rowPassword = $row['password'];
        $checkPassword = password_verify($password, $rowPassword);

        if($checkPassword === false){

            $finResult['status'] = "2";
            $finResult['message'] = "Login Failed";

            $json_data = json_encode($finResult);

            echo $json_data;
            mysqli_close($con);

            //echo $finResult['message'];

        } else if($checkPassword === true){

            $finResult['status'] = "1";
            $finResult['message'] = "Login Success";
            $finResult['username'] = $row['username'];

            $json_data = json_encode($finResult);

            echo $json_data;
            mysqli_close($con);
        
            // echo "<br>";
            // echo $finResult['message'];

        }

    }else{
        $finResult['status'] = "2";
        $finResult['message'] = "Login Failed";

        $json_data = json_encode($finResult);

        echo $json_data;
        mysqli_close($con);


        // echo $finResult['message'];
    }
?>