extends CanvasLayer

var port1Score = 0
var port2Score = 0

var packetsR = 0
var packetsG = 0

func _ready():
	var ports = get_parent().get_node("Box/Viewport").get_child(0).ports
	for port in ports:
		 port.connect("packet_received", self, "on_packet_received")

func on_packet_received(type, time):
	if type == 0:
		packetsR += 1
		port1Score = port1Score - (30 / int(time))
	elif type == 1:
		packetsG += 1
		port2Score = port2Score - (30 / int(time))
	if port1Score < 0:
		port1Score = 0
	if port2Score < 0:
		port2Score = 0
	$Container/LatencyText2.text = str(port1Score)
	$Container/LatencyText3.text = str(port2Score)

func _on_Timer_timeout():
	port1Score += 1
	port2Score += 1
	$Container/LatencyText2.text = str(port1Score)
	$Container/LatencyText3.text = str(port2Score)
	if (port1Score + port2Score) >= 100:
		get_parent().get_node("Box/Viewport").get_child(0).get_node('Player').explode()
		$GameOverTimer.start()
		$Timer.stop()

func _on_GameOverTimer_timeout():
	Global.calculate_score(packetsR, packetsG)
	get_tree().change_scene("res://GameOver.tscn")
