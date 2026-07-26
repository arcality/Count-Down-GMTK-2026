class_name Player extends CharacterBody2D

@onready var net: Node2D = $Net

const SPEED: float = 300.0
var ACCELERATION: float = 16 * 60
const DECELERATION: float = 4 * 60

var can_move: bool = false

var net_duration: float = 0.5
var net_cooldown: float = 1.2
var net_ready: bool = true
var net_range: float = 10

var airhorn_duration: float = 1.1
var airhorn_cooldown: float = 5.5
var airhorn_ready: bool = true

var flail_duration: float = 0.7
var flail_cooldown: float = 0.2
var flail_ready: bool = true

var spawn_position := Vector2(240, 210)

# is never (0, 0)
var facing_direction := Vector2(0,-1)
var direction := Vector2(0,0)

var speed_upgrade_ct = 0
var airhorn_cooldown_upgrade_ct = 0
var airhorn_radius_upgrade_ct = 0
var flail_radius_upgrade_ct = 0
var net_range_upgrade_ct = 0

enum States {
	NOTHING,
	NET,
	AIRHORN,
	FLAIL,
	PROTECTED
}

var state: States = States.NOTHING


func _process(delta: float) -> void:
	if position.y < 125:
		z_index = 2
	else:
		z_index = 4
	
	
	
	if state == States.NOTHING:
		$AnimatedSprite2D.flip_h = false
		if direction == Vector2(0,0):
			if facing_direction.y > 0:
				$AnimatedSprite2D.play("idle_front")
			elif facing_direction.y < 0:
				$AnimatedSprite2D.play("idle_back")
			elif facing_direction.x > 0:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("idle_side")
			elif facing_direction.x < 0:
				$AnimatedSprite2D.play("idle_side")
		else:
			if facing_direction.y > 0:
				$AnimatedSprite2D.play("run_front")
			elif facing_direction.y < 0:
				$AnimatedSprite2D.play("run_back")
			elif facing_direction.x > 0:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("run_side")
			elif facing_direction.x < 0:
				$AnimatedSprite2D.play("run_side")


func _physics_process(delta: float) -> void:
	
	# get movement direction from input
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# update the direction the player is facing
	if direction != Vector2(0, 0):
		facing_direction = direction
	
	
	
	if state != States.PROTECTED:
		if Input.is_action_just_pressed("net") and net_ready and state == States.NOTHING:
			swing_net()
		
		if Input.is_action_just_pressed("airhorn") and airhorn_ready and state == States.NOTHING:
			use_airhorn()
		
		if Input.is_action_just_pressed("flail") and flail_ready and state == States.NOTHING:
			flail()
	
	if state != States.AIRHORN and state != States.PROTECTED and state != States.FLAIL and state != States.NET:
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
		
		
		# update where the net is facing
		net.rotation = facing_direction.angle()
	else:
		velocity = Vector2(0,0)
		

	if can_move:
		move_and_slide()


func respawn() -> void:
	position = spawn_position
	state = States.NOTHING
	#$TempSprite2D.show()
	$AnimatedSprite2D.show()
	

func protect() -> void:
	#$TempSprite2D.hide()
	$AnimatedSprite2D.hide()
	state = States.PROTECTED

func upgrade_speed() -> void:
	if speed_upgrade_ct == 3:
		print("Already Max Speed")
		return
	var upgrade_factor: float = 1.3
	ACCELERATION *= upgrade_factor
	speed_upgrade_ct += 1
	
	print(ACCELERATION)

func upgrade_airhorn_cooldown() -> void:
	if airhorn_cooldown_upgrade_ct == 3:
		print("Already Min Airhorn Cooldown")
		return
	var upgrade_factor: float = 0.85
	airhorn_cooldown *= upgrade_factor
	airhorn_cooldown_upgrade_ct += 1
	
	print(airhorn_cooldown)
	

func upgrade_airhorn_radius() -> void:
	if airhorn_radius_upgrade_ct == 3:
		print("Already Max Airhorn Radius")
		return
	var upgrade_factor: float = 1.3
	$Airhorn/Hitbox/CollisionShape2D.shape.radius *= upgrade_factor
	#airhorn_cooldown *= upgrade_factor
	airhorn_radius_upgrade_ct += 1
	
	print($Airhorn/Hitbox/CollisionShape2D.shape.radius)
	

func upgrade_flail_radius() -> void:
	if flail_radius_upgrade_ct == 3:
		print("Already Max Flail Radius")
		return
	var upgrade_factor: float = 1.3
	$Flail/Hitbox/CollisionShape2D.shape.radius *= upgrade_factor
	#airhorn_cooldown *= upgrade_factor
	flail_radius_upgrade_ct += 1
	
	print($Flail/Hitbox/CollisionShape2D.shape.radius)
	

func upgrade_net_range() -> void:
	if net_range_upgrade_ct == 3:
		print("Already Max Net Range")
		return
	var upgrade_factor: float = 1.1
	#$Net/Hitbox/CollisionPolygon2D.shape.points[0].x *= upgrade_factor
	#$Net/Hitbox/CollisionPolygon2D.shape.points[1].x *= upgrade_factor
	#airhorn_cooldown *= upgrade_factor
	net_range_upgrade_ct += 1
	
	print($Net/Hitbox/CollisionPolygon2D.shape.points[0].x)


func swing_net() -> void:
	if facing_direction.y > 0:
		$AnimatedSprite2D.play("net_front")
	elif facing_direction.y < 0:
		$AnimatedSprite2D.play("net_back")
	elif facing_direction.x > 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("net_side")
	elif facing_direction.x < 0:
		$AnimatedSprite2D.play("net_side")
	state = States.NET
	
	var net_swing_timer := get_tree().create_timer(net_duration)
	net_swing_timer.timeout.connect(_on_net_swing_end)
	
	var net_hitbox_timer := get_tree().create_timer(net_duration-0.2)
	net_hitbox_timer.timeout.connect(_on_net_hitbox_timer_timeout)
	
	net_ready = false
	var net_cooldown_timer := get_tree().create_timer(net_cooldown)
	net_cooldown_timer.timeout.connect(_on_net_cooldown_end)

func _on_net_swing_end() -> void:
	state = States.NOTHING
	$Net/Hitbox/CollisionPolygon2D.disabled = true

func _on_net_hitbox_timer_timeout() -> void:
	$Net/Hitbox/CollisionPolygon2D.disabled = false

func _on_net_cooldown_end() -> void:
	net_ready = true


func use_airhorn() -> void:
	$AnimatedSprite2D.play("airhorn")
	state = States.AIRHORN
	$Airhorn/Hitbox/CollisionShape2D.disabled = false
	var airhorn_use_timer := get_tree().create_timer(airhorn_duration)
	airhorn_use_timer.timeout.connect(_on_airhorn_use_end)
	
	airhorn_ready = false
	var airhorn_cooldown_timer := get_tree().create_timer(airhorn_cooldown)
	airhorn_cooldown_timer.timeout.connect(_on_airhorn_cooldown_end)

func _on_airhorn_use_end() -> void:
	state = States.NOTHING
	$Airhorn/Hitbox/CollisionShape2D.disabled = true
	
func _on_airhorn_cooldown_end() -> void:
	airhorn_ready = true
	

func flail() -> void:
	$AnimatedSprite2D.play("baton")
	state = States.FLAIL
	$Flail/Hitbox/CollisionShape2D.disabled = false
	var flail_timer := get_tree().create_timer(flail_duration)
	flail_timer.timeout.connect(_on_flail_end)
	
	flail_ready = false
	var flail_cooldown_timer := get_tree().create_timer(flail_cooldown)
	flail_cooldown_timer.timeout.connect(_on_flail_cooldown_end)
	

func _on_flail_end() -> void:
	state = States.NOTHING
	$Flail/Hitbox/CollisionShape2D.disabled = true

func _on_flail_cooldown_end() -> void:
	flail_ready = true


func _on_level_end() -> void:
	velocity=Vector2(0,0)

func _on_net_area_entered(area: Area2D) -> void:
	#print("bazinga!")
	area.get_parent()._on_caught()
