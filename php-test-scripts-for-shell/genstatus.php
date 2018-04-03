<?php
	ini_set('error_reporting', E_ALL);
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	
	$code=0;
	if (empty($_GET))
	{
		echo "Use ?code=http_status_code";		
	}
	else
	{
		if (!isset($_GET['code']))
		{
			echo "Use ?code=http_status_code";
		}
		else
		{
			$code=$_GET['code'];
			if (($code<100)||($code>599))
			{
				echo "Wrong code (min 100, max 599)";
			}
			else
			{
				echo $code;
				http_response_code($code);
			}
		}
	}	
?>