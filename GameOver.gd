extends Control

func _ready():
	var total = Global.total()
	$PacketsSaved.text = str(total)
	$PacketsG.text = str(Global.green_packs)
	$PacketsR.text = str(Global.red_packs)

func _on_PlayButton1_pressed():
	get_tree().change_scene("res://Menu.tscn")
