extends RigidBody2D

var packet_type: int
var packet_latency: float
var color_arr = [Color.red, Color.green]

var packetExplosion = preload("res://PacketExplosion.tscn")

func _ready():
	randomize()
	$Sprite.modulate = color_arr[packet_type]
	$Label.modulate = color_arr[packet_type]

func _process(_delta):
	$Label.text = str(packet_latency)

func destroy(sad_destroy = false):
	var explosion = packetExplosion.instance()
	explosion.modulate = $Sprite.modulate
	explosion.position = self.position
	explosion.play("default")
	explosion.play_sound = sad_destroy
	get_parent().add_child(explosion)
	queue_free()

func glow():
	$Glow.visible = true

func unglow():
	$Glow.visible = false

func interact(player):
	$CollisionShape2D.disabled = true
	get_parent().remove_child(self)
	player.add_child(self)
	self.linear_velocity = Vector2.ZERO
	self.sleeping = true
	self.position = player.get_node('PacketPoint').position

func wake_up(start_position):
	self.sleeping = false
	$CollisionShape2D.disabled = false
	self.position = start_position

func _on_Timer_timeout():
	packet_latency = packet_latency + .1
	if int(packet_latency) >= 30:
		destroy(true)
