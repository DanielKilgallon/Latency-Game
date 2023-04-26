extends Node2D

var ports

func _ready():
	ports = $Ports.get_children()
