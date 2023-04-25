extends Node2D

func _ready():
	var ports = $Ports.get_children()
	for port in ports:
		 port.connect("packet_received", self, "on_packet_received")

func on_packet_received(type):
	print(type)
