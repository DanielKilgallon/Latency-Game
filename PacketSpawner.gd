extends Node2D


const PACKET = preload("res://Packet.tscn")
export var num_ports = 1
export var timer_increase_ratio = .1

func _ready():
	randomize()

func _on_Timer_timeout():
	var packet_obj = PACKET.instance()
	var packet_type = randi() % num_ports
	packet_obj.packet_type = packet_type
	packet_obj.position = position
	get_parent().add_child(packet_obj)
	var timer_time = $Timer.get_wait_time()
	if timer_time > 1:
		$Timer.set_wait_time(timer_time - timer_increase_ratio)
