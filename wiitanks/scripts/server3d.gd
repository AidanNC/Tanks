extends Node

# The port we will listen to.
const PORT = 9080
var tcp_server := TCPServer.new()
# var socket := WebSocketPeer.new()
var clients = []



func log_message(message):
	var time = Time.get_time_string_from_system()
	print( time +" "+ message + "\n")
	#$Node2D/Polygon2D.color = Color(randf(), randf(), randf())



func _ready():
	print("Starting server!")
	if tcp_server.listen(PORT) != OK:
		log_message("Unable to start server.")
		set_process(false)
	else:
		print("started server")



func _process(_delta):

	while tcp_server.is_connection_available():
		var conn: StreamPeerTCP = tcp_server.take_connection()
		assert(conn != null)
		var ws_peer := WebSocketPeer.new()
		ws_peer.accept_stream(conn)
		clients.append(ws_peer)
		print("new client added")


	var index = -1
	for client in clients:
		index += 1
		# if client.get_ready_state() == WebSocketPeer.STATE_OPEN:
		# 	var tank = get_node("Tank"+str(index))
		# 	if tank && tank.respawning:
		# 		print("buzzing")
		# 		client.send_text("hahahaha");
				

		
		client.poll()
		if client.get_ready_state() == WebSocketPeer.STATE_OPEN:
			while client.get_available_packet_count():
				var packet = client.get_packet().get_string_from_ascii()
				# log_message(packet)
				var result = JSON.parse_string(packet)
				moveGuy(result, index) 
		elif client.get_ready_state() == WebSocketPeer.STATE_CLOSED:
			client.close()
			clients.erase(client)
			print("client removed")



func _exit_tree():
	print("exiting tree")
	for client in clients:
		client.close()
	tcp_server.stop()
	
func moveGuy(input, id):
	var direction = input["direction"]
	var joystick = input["joystick"]
	var tank = get_node("Tank3d_"+str(id))
	if joystick == 0: #movement stick
		
		if tank.has_method("setPlayerDirection"):
			tank.setPlayerDirection(direction)
		else: 
			print("doesn't have method")
	if joystick == 1: #shoot stick
		
		if tank.has_method("shoot"):
			tank.shoot(direction)
		else: 
			print("doesn't have method")

	return
