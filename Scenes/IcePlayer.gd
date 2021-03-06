extends KinematicBody2D


export (int) var speed = 250
export (int) var jump_speed = -380
export (int) var gravity = 1600

var jumps = 0
var counter = 0
const max_jumps = 2
var velocity = Vector2.ZERO


export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

func get_input():
	var dir = 0
	if Input.is_action_pressed("Left"): 
		dir += 1
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Walk")
	if Input.is_action_pressed("Right"):
		dir -= 1
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Walk")
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		$AnimatedSprite.play("Idle")
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if jumps < max_jumps and Input.is_action_just_pressed("Jump"):
			$AudioStreamPlayer3.play()
			$AnimatedSprite.play("Jump")
			velocity.y = jump_speed
			jumps += 1
	elif is_on_floor():
		jumps = 0

	if not is_on_floor():
		$AudioStreamPlayer.play()
		$AnimatedSprite.play("Jump")
	
	counter += delta
	while counter >= 8:
		counter -= 8
		$AudioStreamPlayer2.play()
