extends Control


func _ready():
	pass

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_PlayButton2_pressed():
	get_tree().change_scene("res://levels/HDWorld2.tscn")

func _on_PlayButton1_pressed():
	get_tree().change_scene("res://levels/HDWorld1.tscn")
