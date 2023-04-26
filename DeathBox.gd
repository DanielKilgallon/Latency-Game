extends Area2D

func _on_DeathBox_body_entered(body):
	body.queue_free()
