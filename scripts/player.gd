class_name Player extends CharacterBody2D

@onready var net: Node2D = $Net

const SPEED: float = 300.0
const ACCELERATION: float = 16 * 60
const DECELERATION: float = 4 * 60

var can_move: bool = false

var net_duration: float = 0.5
var net_cooldown: float = 1.2
var net_ready: bool = true

var airhorn_duration: float = 1.1
var airhorn_cooldown: float = 5.5
var airhorn_ready: bool = true

var flail_duration: float = 0.7
var flail_cooldown: float = 0.2
var flail_ready: bool = true

var spawn_position := Vector2(240, 210)

# is never (0, 0)
var facing_direction := Vector2(0,-1)

func _physics_process(delta: float) -> void:
	
	# get movement direction from input
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# update the direction the player is facing
	if direction != Vector2(0, 0):
		facing_direction = direction
	
	# update where the net is facing
	net.rotation = facing_direction.angle()
	
	if Input.is_action_just_pressed("net") and net_ready:
		swing_net()
	
	if Input.is_action_just_pressed("airhorn") and airhorn_ready:
		use_airhorn()
	
	if Input.is_action_just_pressed("flail") and flail_ready:
		flail()
	
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


func respawn() -> void:
	position = spawn_position


func swing_net() -> void:
	$Net/Area2D/CollisionShape2D.disabled = false
	var net_swing_timer := get_tree().create_timer(net_duration)
	net_swing_timer.timeout.connect(_on_net_swing_end)
	
	net_ready = false
	var net_cooldown_timer := get_tree().create_timer(net_cooldown)
	net_cooldown_timer.timeout.connect(_on_net_cooldown_end)

func _on_net_swing_end() -> void:
	$Net/Area2D/CollisionShape2D.disabled = true

func _on_net_cooldown_end() -> void:
	net_ready = true


func use_airhorn() -> void:
	$Airhorn/Hitbox/CollisionShape2D.disabled = false
	var airhorn_use_timer := get_tree().create_timer(airhorn_duration)
	airhorn_use_timer.timeout.connect(_on_airhorn_use_end)
	
	airhorn_ready = false
	var airhorn_cooldown_timer := get_tree().create_timer(airhorn_cooldown)
	airhorn_cooldown_timer.timeout.connect(_on_airhorn_cooldown_end)

func _on_airhorn_use_end() -> void:
	$Airhorn/Hitbox/CollisionShape2D.disabled = true
	
func _on_airhorn_cooldown_end() -> void:
	airhorn_ready = true
	

func flail() -> void:
	$Flail/Hitbox/CollisionShape2D.disabled = false
	var flail_timer := get_tree().create_timer(flail_duration)
	flail_timer.timeout.connect(_on_flail_end)
	
	flail_ready = false
	var flail_cooldown_timer := get_tree().create_timer(flail_cooldown)
	flail_cooldown_timer.timeout.connect(_on_flail_cooldown_end)
	

func _on_flail_end() -> void:
	$Flail/Hitbox/CollisionShape2D.disabled = true

func _on_flail_cooldown_end() -> void:
	flail_ready = true


func _on_level_end() -> void:
	velocity=Vector2(0,0)

func _on_net_area_entered(area: Area2D) -> void:
	print("bazinga!")
	area.get_parent()._on_caught()
