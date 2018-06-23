<!doctype html>
<head>
    <meta charset="utf-8" />
    <title>WebSocket Connection Testing</title>
    
    <style>
        li { list-style: none; }
    </style>
	
	<!-- Importing google chart creator api -->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>	
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
	
	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css"
		integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
		crossorigin=""/>
		
	<script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js"
		integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="
		crossorigin=""></script>
     
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>	
    <script>
		$(document).ready(function() {
            if (!window.WebSocket) {
                if (window.MozWebSocket) {//Checking if the system supports web sockets
                    window.WebSocket = window.MozWebSocket;
                } else {
                    $('#messages').append("<li><b>Your browser doesn't support WebSockets.</b></li>");		//If web socket not supported, message is displayed
                }
            }
			
            ws = new WebSocket('ws://localhost:8080/ws_adm');	//Setting up a web socket on the mentioned url
			$('#btn').hide()//Hiding the refresh button
            ws.onopen = function(evt) {		//Function to define what happens when web socket is opened
                $('#messages').append('<li><b>Connected to server</b></li>');	//Message is appended to the given section on web socket opening
                
            }
			
            var c1=0;var n1=0;var n2=0;var str="";var i=0;
            ws.onmessage = function(evt) {	//Defines what happens on receiving a message
				str=evt.data;	//Taking the data out of the object send by server
				for(i=0;i<str.length;i++){
					if(str.charAt(i)==':'){
						c1=i;break;
					}	
				}
				n1=parseInt(str.substring(3,c1));	//Total users
				n2=parseInt(str.substring(c1+1,str.length));	//Online users
				$('#count1').text(n1.toString());
				$('#count2').text(n2.toString());
				$('#count3').text((n1-n2).toString());	//Appending offline users to the mentioned sectioned
				google.charts.load('current', {'packages':['corechart']});	//Loading charts packages
				google.charts.setOnLoadCallback(drawChart);	//Calling charts api
				
				function drawChart() {	//Function to draw chart
					var data = google.visualization.arrayToDataTable([//Passing data to the api
					['Users', 'Status'],
					['Total', n1],
					['Online', n2],
					['Offline', n1-n2]
					]);
				
					var options = {'title':'User Status', 'width':550, 'height':400, is3D:true};	//Defining the size of piechart
					var chart = new google.visualization.PieChart(document.getElementById('piechart'));	//Placing th pie chart
					chart.draw(data, options);
				}			
            }
			
            $('#btn').click(function(){		//Defines what happens when Refresh is clicked
				ws.send("Send");	//Sending a message to server using websocket
            });
			
            setInterval(function(){$('#btn').trigger("click")},5000);	//Setting a interval after a button is clicked which refreshes the data
            ws.onclose = function()		//It defines what happens when the web socket connection is closed
            {
				$('#messages').append('<li><b>' + "Connection is closed..." + '</b></li>'); 
            }
        });
</script>
</head>

<body>
    
	&nbsp;<h2>Real Time User Statistics</h2>
	<br/><br/>
	<button id="btn">Refresh</button>
	&nbsp;<p>Total Users : <span id="count1"></span></p><br/>
	&nbsp;<p>Online Users : <span id="count2"></span></p><br/>
	&nbsp;<p>Offline Users : <span id="count3"></span></p><br/><br/>	<!-- Module for loading Pie chart -->
	<div id="piechart"></div><br/><br/>
	&nbsp;<div id="messages"></div>
	
</body>
</html>