extends AnimatedSprite

var play_sound

func _ready():
	if play_sound:
		$AudioStreamPlayer.play()

func _on_Timer_timeout():
	queue_free()
