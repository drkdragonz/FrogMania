extends KinematicBody2D

export var jump_force = 0.0
export var _speed = 0.0
export var _gravity = 0.0
export var can_jump_start = 0

var can_jump = 0
var counter = 0
var _velocity = Vector2()
var _floor = Vector2(0, -1)



enum {
	IDLE
	WALK
	AIR
}

var _state: int = IDLE

func flip_sprite() -> void:
	if _velocity.x < 0:
		$AnimatedSprite.flip_h = true
	if move_direction().x > 0:
		$AnimatedSprite.flip_h = false


func _ready():
	can_jump = can_jump_start
	print(can_jump)

func _physics_process(delta):
	counter += delta
	while counter >= 8:
		counter -= 8
		$AudioStreamPlayer.play()
	if is_on_floor() and _state == IDLE:
		$AnimatedSprite.play("Idle")
	flip_sprite()
	var my_move_direction = move_direction()
	_velocity.y += _gravity
	
	if is_on_floor():
		can_jump = can_jump_start
	
	match _state:
		IDLE:
			_velocity.x = 0
			if my_move_direction:
				change_state(WALK)
			elif Input.is_action_just_pressed("Jump") and can_jump > 0:
				$AudioStreamPlayer2.play()
				_velocity.y = -jump_force
				can_jump -= 1
				change_state(AIR)
		WALK:
			$AnimatedSprite.play("Walk")
			if not my_move_direction:
				change_state(IDLE)
			elif Input.is_action_just_pressed("Jump") and can_jump > 0:
				$AudioStreamPlayer2.play()
				_velocity.y = -jump_force
				can_jump -= 1
				change_state(AIR)
			else:
				_velocity.x = my_move_direction.x * _speed
		AIR:
			$AnimatedSprite.play("Jump")
			if my_move_direction:
				_velocity.x = my_move_direction.x * _speed
			else: 
				_velocity.x = 0
			
			if _velocity.y > 1:
				change_state(IDLE)
			
	_velocity = move_and_slide(_velocity, _floor)
	

func move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("Left") - Input.get_action_strength("Right"), 0
	)

func change_state(target_state: int):
	_state = target_state
