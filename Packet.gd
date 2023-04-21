extends RigidBody2D

var packet_type: int
var packet_latency: float
var color_arr = [Color.red, Color.green, Color.yellow]

func _ready():
	randomize()
	modulate = color_arr[packet_type]

func _process(delta):
	$Label.text = str(packet_latency) #+ str(randi() % 9 + 1)

func _on_Timer_timeout():
	packet_latency = packet_latency + .01
