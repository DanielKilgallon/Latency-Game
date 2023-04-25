extends Node

func _ready():
	var scaling = get_viewport().size / $Box/Viewport.size
	#$Box.rect_scale = scaling
	print($Box.rect_scale)
