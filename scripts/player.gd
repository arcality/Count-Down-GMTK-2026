class_name Player extends CharacterBody2D

@onready var net: Node2D = $Net

const SPEED: float = 300.0
const ACCELERATION: float = 16 * 60
const DECELERATION: float = 4 * 60

var can_move: bool = false

var net_duration: float = 0.5
var net_cooldown:float = 1.2
var net_ready:bool = true

func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	net.rotation = direction.angle()
	
	if Input.is_action_just_pressed("net") and net_ready:
		swing_net()
	
	if direction:
		#velocity.x = direction.x * SPEED
		#velocity.y = direction.y * SPEED
		#velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION);
		#velocity.y = move_toward(velocity.y, direction.y * SPEED, ACCELERATION);
		velocity.x += direction.x * ACCELERATION * delta
		velocity.y += direction.y * ACCELERATION * delta
	#else:
	#velocity.x = move_toward(velocity.x, 0, DECELERATION)
	#velocity.y = move_toward(velocity.y, 0, DECELERATION)
	velocity.x = velocity.x/1.17
	velocity.y = velocity.y/1.17

	if can_move:
		move_and_slide()

func swing_net() -> void:
	$Net/Area2D/CollisionShape2D.disabled = false
	var net_swing_timer = get_tree().create_timer(net_duration)
	net_swing_timer.timeout.connect(_on_net_swing_end)
	
	net_ready = false
	var net_cooldown_timer = get_tree().create_timer(net_cooldown)
	net_cooldown_timer.timeout.connect(_on_net_cooldown_end)


func _on_net_swing_end() -> void:
	$Net/Area2D/CollisionShape2D.disabled = true

func _on_net_cooldown_end() -> void:
	net_ready = true


func _on_level_end() -> void:
	velocity=Vector2(0,0)

func _on_net_area_entered(area: Area2D) -> void:
	print("bazinga!")
	area.get_parent()._on_caught()
