extends KinematicBody2D

const jumpvelocity: int = 220
const gravityscale: int = 8
var walkspeed: int = 100
const FLOOR: Vector2 = Vector2(0, -1)

var velocity: Vector2 = Vector2()
var can_jump: bool = false
var coyoteCount: int = 0
var rotated: bool = false

var localInteractable
var heldPackets = []

func _input(_event):
	pickupObject()
	throwObject()

func _physics_process(_delta):
	velocity.x = 0
	velocity.y += gravityscale

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

	var animation_name = $AnimatedSprite.get_animation()
	if animation_name == "Jump" or animation_name == "Idle":
		$AudioStreamPlayer.stop()
	elif animation_name == "Walk":
		if !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()

	var snap = Vector2.DOWN * 32 if !can_jump else Vector2.ZERO

	#returns a normalized velocity so the y value doesn't get ENORMOUS
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR)

	if !heldPackets.empty():
		for packet in heldPackets:
			packet.linear_velocity = Vector2.ZERO
			packet.sleeping = true

func pickupObject():
	if localInteractable != null and Input.is_action_just_released("ui_accept"):
		localInteractable.interact(self)
		heldPackets.append(localInteractable)

func throwObject():
	if !heldPackets.empty() and Input.is_action_just_released("throw"):
		var packet = heldPackets.pop_front()
		self.remove_child(packet)
		get_parent().add_child(packet)
		packet.wake_up($PacketPoint.global_position)
		packet.apply_central_impulse(Vector2(200, -100))

func _on_PickupArea_body_entered(body):
	if body.is_in_group('Packets'):
		if localInteractable != null:
			localInteractable.unglow()
		body.glow()
		localInteractable = body

func _on_PickupArea_body_exited(body):
	if body == localInteractable and localInteractable != null:
		localInteractable.unglow()
	localInteractable = null
