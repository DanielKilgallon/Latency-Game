extends KinematicBody2D

const jumpvelocity: int = 220
var walkspeed: int = 150
const FLOOR: Vector2 = Vector2(0, -1)
var velocity: Vector2 = Vector2()
var can_jump: bool = false
var coyoteCount: int = 0
var rotated: bool = false

var localInteractables = []
var heldPackets = []

var packetExplosion = preload("res://entities/PacketExplosion.tscn")

func _input(_event):
	restart()
	backToMenu()
	pickupObject()
	throwObject()

func explode():
	var explosion = packetExplosion.instance()
	explosion.position = self.position
	explosion.play("default")
	explosion.play_sound = true
	get_parent().add_child(explosion)
	queue_free()

func _physics_process(_delta):
	velocity.x = 0
	velocity.y += float(ProjectSettings.get_setting("physics/2d/default_gravity") / 10)

	if Input.is_action_pressed("ui_right"):
		velocity.x = walkspeed
		$AnimatedSprite.play("Walk")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -walkspeed
		$AnimatedSprite.play("Walk")
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("Idle")

	if is_on_floor():
		can_jump = true
		coyoteCount = 0
	else:
		coyoteCount += 1
		if coyoteCount > 3:
			can_jump = false

	if can_jump && Input.is_action_just_pressed("ui_select"):
		can_jump = false
		velocity.y = -jumpvelocity
		$AnimatedSprite.play("Jump")
		$Jump.play()

	var animation_name = $AnimatedSprite.get_animation()
	if animation_name == "Jump" or animation_name == "Idle":
		$Walk.stop()
	elif animation_name == "Walk":
		if !$Walk.playing:
			$Walk.play()

	var snap = Vector2.DOWN * 32 if !can_jump else Vector2.ZERO

	#returns a normalized velocity so the y value doesn't get ENORMOUS
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR)

	if !heldPackets.empty():
		$ThrowGuide.visible = true
		if $ThrowGuide.rotation_degrees == 70:
			#$ThrowGuide.rotate($ThrowGuide.rotation + MATH.PI)
			pass
		for packet in heldPackets:
			if !is_instance_valid(packet):
				heldPackets.erase(packet)
			else:
				packet.linear_velocity = Vector2.ZERO
				packet.sleeping = true
	else:
		$ThrowGuide.visible = false

func restart():
	if Input.is_action_just_released("ui_home"):
		get_tree().reload_current_scene()

func backToMenu():
	if Input.is_action_just_released("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")

func pickupObject():
	if Input.is_action_just_released("ui_accept"):
		if !localInteractables.empty():
			$Interact.play()
			var closest_item = localInteractables.front()
			closest_item.interact(self)
			heldPackets.append(closest_item)

func throwObject():
	if !heldPackets.empty() and Input.is_action_just_released("throw"):
		var packet = heldPackets.pop_back()
		if self.is_a_parent_of(packet):
			self.remove_child(packet)
			get_parent().add_child(packet)
			packet.wake_up($PacketPoint.global_position)
			var force_vector = Vector2.ZERO
			if $AnimatedSprite.flip_h == false:
				force_vector = Vector2(150, -100)
			else:
				force_vector = Vector2(-150, -100)
			packet.apply_central_impulse(force_vector)

func _on_PickupArea_body_entered(body):
	if body.is_in_group('Packets'):
		if !localInteractables.empty() and localInteractables.front() != null:
			localInteractables.front().unglow()
		body.glow()
		localInteractables.push_front(body)

func _on_PickupArea_body_exited(body):
	if body.is_in_group('Packets'):
		body.unglow()
		localInteractables.remove(localInteractables.find(body))
		if !localInteractables.empty() and localInteractables.front() != null:
			localInteractables.front().glow()
