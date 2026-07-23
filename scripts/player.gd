extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 80
const DECELERATION = 20


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		#velocity.x = direction.x * SPEED
		#velocity.y = direction.y * SPEED
		#velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION);
		#velocity.y = move_toward(velocity.y, direction.y * SPEED, ACCELERATION);
		velocity.x += direction.x * ACCELERATION
		velocity.y += direction.y * ACCELERATION
	#else:
	#velocity.x = move_toward(velocity.x, 0, DECELERATION)
	#velocity.y = move_toward(velocity.y, 0, DECELERATION)
	velocity.x = velocity.x/1.17
	velocity.y = velocity.y/1.17

	move_and_slide()
