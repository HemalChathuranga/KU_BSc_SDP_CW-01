<?php

    //DB Credential variables
    $svrname = "localhost";
    $uname = "root";
    $password = "";
    $db_name = "sdp_cw1_mob-db";

    // create MySQL database Connection
    $con = mysqli_connect($svrname, $uname, $password, $db_name);

    // Check if the connection is successful
    if (!$con) {
        die("Connection failed: " . mysqli_connect_error());
        //echo "Connection failed!";
    }