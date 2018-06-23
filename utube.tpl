<!DOCTYPE html>
<html>
<head>
<title>Youplay</title>
    <meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">

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
		   ws = new WebSocket('ws://localhost:8080/ws_utube');	//Setting up a web socket on the mentioned url
            ws.onopen = function(evt) {//Defining what happens when socket connection opens
                $('#messages').append('<li><b>Connected to server</b></li>');
           }
           ws.onmessage = function(evt) {	//Defining what happens when message is received
		   console.log(evt.data);
		   var b=0
		    if(evt.data.substr(0,13)=='Playlist_name'){
			$('#playlist_name').append('<span>'+evt.data.substr(13,evt.data.length-13)+'</span>');
			}
			else if(evt.data.substr(0,14)=='Playlist_count'){
			b=parseInt(evt.data.substr(14,evt.data.length-14));
			console.log('b is'+b);
			if(b>0)
			$('#container').remove();
			}
		    else if(evt.data.substr(0,9)=='Last_song'){
			$('#main').append('<div class="col-xl-4 pl-5"><iframe id="sortable" width="300" height="200" src="'+evt.data.substr(9,evt.data.length-9)+'" frameborder="0" allowfullscreen></iframe><br/><button id="remove" class="btn" type="button">Remove</button><br/><br/></div>');
	        $('#main').append('<div class="col-xl-4 pl-5" id="container"><button type="button" style="background-color:#F0F0F0;width:300px;height:200px;color:tomato;" class="btn pb-3 pr-4"><span id="create">+ ADD</span><br/><input id="input1" type="text" name="vid" placeholder="Enter video URL"> </button></div>');}
	        else if(evt.data.substr(0,8)=='Add_song'){
			$('#main').append('<div class="col-xl-4 pl-5"><iframe id="sortable" width="300" height="200" src="'+evt.data.substr(8,evt.data.length-8)+'" frameborder="0" allowfullscreen></iframe><br/><button id="remove" class="btn" type="button">Remove</button><br/><br/></div>');
			}
			else{
			$('#messages').append('<li>' + evt.data + '</li>');}	//Appending the message to the module
           }
			
           ws.onclose = function()	//Defining what happens when web socket connection is closed
            {
				$('#messages').append('<li><b>' + "Connection is closed..." + '</b></li>'); 
            }
			$('#btn3').click(function(){
			
				//Sending a unique string to determine if Signout is pressed
				ws.send("Offline1234abc5678def90ghij");	
            });
	$('#create').live('click',function(){
	var a=$('#input1').val();
	if(a=='')
	return
	var s='';
	var i=0;
	var c=0;
	for(i=0;i<a.length;i++){
	if(a.charAt(i)=='&')
	break;
	if(a.charAt(i-1)=='='||c==1){
	s=s+a.charAt(i);
	c=1;}
	}
	var b='https://www.youtube.com/embed/';
	a=b+s;
	ws.send('Add_song_in_playlist'+a);
	$('#container').remove();
	$('#input').val('');
	$('#main').append('<div class="col-xl-4 pl-5"><iframe id="sortable" width="300" height="200" src="'+a+'" frameborder="0" allowfullscreen></iframe><br/><button id="remove" class="btn" type="button">Remove</button><br/><br/></div>');
	$('#main').append('<div class="col-xl-4 pl-5" id="container"><button type="button" style="background-color:#F0F0F0;width:300px;height:200px;color:tomato;" class="btn pb-3 pr-4"><span id="create">+ ADD</span><br/><input id="input1" type="text" name="vid" placeholder="Enter video URL"> </button></div>');
	});
	$('#remove').live('click',function(e){
	var e1=$(this).parent();
	var e2=$(this).prev();
	var n=e1.prevAll().length;
	console.log('n is'+n);
	n=n+1;
	ws.send('Remove'+(n.toString()));
	e1.remove();
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
				<a class="nav-link" href="http://localhost:8080/adm">Stats</a>
			</li>
		</ul>
		</div>
	</nav>
	<br/><br/>
	&nbsp;<div contenteditable="true" id='playlist_name'></div>
	<br/><br/>
	&nbsp;<span contenteditable="true" class="badge badge-secondary">New</span>
	<span contenteditable="true" class="badge badge-secondary">New1</span>
	<span contenteditable="true" class="badge badge-secondary">New2</span>
	<span contenteditable="true" class="badge badge-secondary">New3</span>
	<span contenteditable="true" class="badge badge-secondary">New4</span>
	<span contenteditable="true" class="badge badge-secondary">New5</span>
	<br/><br/>
  <div class="row" id="main">
  <div class="col-xl-4 pl-5" id="container"><button type="button" style="background-color:#F0F0F0;width:300px;height:200px;color:tomato;" class="btn pb-3 pr-4"><span id="create">+ ADD</span><br/><input id="input1" type="text" name="vid" placeholder="Enter video URL"> </button></div>
  </div>
  <br/><br/>
  &nbsp;<button type="button" class="btn" id="btn3">Signout</button>		<!-- For logging out --><br/><br/>
  <div id="messages"></div>
</body>
</html>