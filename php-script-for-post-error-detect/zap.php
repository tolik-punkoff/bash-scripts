<?php
	ini_set('error_reporting', E_ALL);
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);	
	if (empty($_POST))
	{
		echo "<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body>";
		echo "<form action='".$_SERVER['PHP_SELF']."' method='POST'>";
		echo "User: <input type='text' name='username'><br>";
		echo "Password: <input type='password' name='pass'><br>";
		echo "<input type='submit' name='button' value='Enter'>";
		echo "</form></body></html>";
	}
	else
	{
		if (isset($_POST['username'], $_POST['pass']))
		{
			if ($_POST['username']=='user')
			{
				if ($_POST['pass']=='666')
				{
					echo "OK";
					
				}
				else
				{
					//header('403 Forbidden', true, 403);
					http_response_code(403);
					
				}
			}
			else
			{
				//header('403 Forbidden', true, 403);
				http_response_code(403);
			}
		}
		else
		{
			//header('418 I am a teapot', true, 418);
			http_response_code(418);
		}
	}	
?>