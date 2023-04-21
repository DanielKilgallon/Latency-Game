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

func _input(event):
	interactWithObject()

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

	if can_jump && Input.is_action_just_pressed("jump"):
		can_jump = false
		velocity.y = -jumpvelocity
		$AnimatedSprite.play("Jump")

	var snap = Vector2.DOWN * 32 if !can_jump else Vector2.ZERO

	#returns a normalized velocity so the y value doesn't get ENORMOUS
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR)

func setInteractable(interactable):
	localInteractable = interactable

func interactWithObject():
	if localInteractable != null and localInteractable.has_method("interact") and Input.is_action_just_released("interact"):
		localInteractable.interact()

func _on_PickupArea_area_entered(area):
	if true:
		setInteractable(area)
