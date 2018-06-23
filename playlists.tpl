<!DOCTYPE html>
<html>
<head>
<title>Youplay</title>
    <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="keywords" content="footer, links, icons" />
	
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
	
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css">

	<!-- jQuery library -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

	<!-- Popper JS -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>

	<!-- Latest compiled JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
	
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
	<script>
	$(document).ready(function() {
            if (!window.WebSocket) {
                if (window.MozWebSocket) {	//Checking if websocket is supported
                    window.WebSocket = window.MozWebSocket;
                } else {
                    $('#messages').append("<li><b>Your browser doesn't support WebSockets.</b></li>");	<!-- If web socket not supported, message is displayed -->
                }
            }
		   ws = new WebSocket('ws://localhost:8080/ws_playlists');	//Setting up a web socket on the mentioned url
			$('#redirect').hide();
            ws.onopen = function(evt) {//Defining what happens when socket connection opens
                $('#messages').append('<li><b>Connected to server</b></li>');
           }
           ws.onmessage = function(evt) {	//Defining what happens when message is received
		   console.log(evt.data);
		    if(evt.data.charAt(0)=='%'){
			$('#playlist_name').append('<button id="btn" class="btn" type="button">'+evt.data.substr(5,evt.data.length-5)+'</button><br/><br/>');
			}
			else
			$('#messages').append('<li>' + evt.data + '</li>');	//Appending the message to the module
           }
			
           ws.onclose = function()	//Defining what happens when web socket connection is closed
            {
				$('#messages').append('<li><b>' + "Connection is closed..." + '</b></li>'); 
            }
	$('#btn3').click(function(){
			
				//Sending a unique string to determine if Signout is pressed
				ws.send("Offline1234abc5678def90ghij");	
            });
	$('#submit_playlist_name').click(function(){
	ws.send('List'+$('#input2').val());
	if($('#input2').val()=='')
	return
	$('#playlist_name').append('<button id="btn" class="btn" type="button">'+$('#input2').val()+'</button><br/><br/>');
	$('#input2').val('')
	});
	$('#btn').live('click',function(e){
	ws.send('Playlist_name'+$(this).text());
	$('#redirect').trigger('click');	//Triggering click of a button
	});
	});
	</script>
	<style>
	#input1{
	width:200px;
	}
	</style>
</head>
<body>
    <nav class="navbar navbar-expand-sm bg-secondary navbar-dark">
		<!-- Brand -->
  <a class="navbar-brand" href="#">Yourplay</a>
		<!-- Toggler/collapsibe Button -->
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="collapsibleNavbar">
		<ul class="navbar-nav ml-auto">
		<li>
		<form class="form-inline" action="/action_page.php">
    <input class="form-control mr-sm-2" type="text" placeholder="Search Playlists">
    <button class="btn btn-primary" type="submit">Search</button>
  </form></li>
			<li class="nav-item navbar-right active">
				<a class="nav-link" href="#">Playlists</a>
			</li>
		</ul>
		</div>
	</nav>
	<br/><br/>
	<div id='playlist_name'></div><br/><br/>
	&nbsp;<input id='input2' type="text" name="playlist" placeholder="Enter playlist Name">
	<button id="submit_playlist_name" type="button">Submit</button>
	<br/><br/>
  &nbsp;<button type="button" class="btn" id="btn3">Signout</button>		<!-- For logging out --><br/><br/>
  <div id="messages"></div>
  <br/>
  <input id="redirect" type="button" onclick="location.href='http://localhost:8080/utube';" value="Redirect" /> 	<!-- Redirecting to another url on clicking the button -->
  </body>
</html>