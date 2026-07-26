class_name Bird extends Node2D

const SPEED: float = 100
const RETREAT_SPEED = 200

@onready var window_width = get_viewport().get_visible_rect().size.x
@onready var window_height  = get_viewport().get_visible_rect().size.y
@onready var startle_particle_scene = preload("res://scenes/startle_particle.tscn")
@onready var sleep_particle_scene = preload("res://scenes/sleep_particle.tscn")


var random = RandomNumberGenerator.new()

signal scared

# screen bounds where the birds despawn
var bounds: Area2D

enum States {
	LANDING,
	GROUNDED,
	FLYING_AWAY,
	SLEEPING
}

var spawn_side = 0
@export var state = States.LANDING
@export var starting_location: Vector2 = Vector2(0,0)
@export var landing_destination: Vector2 = Vector2(0,0)
var retreat_vector = null #movement vector
var facing: int = 1

var flap_speed: float = 0.25

var hopping: bool = false

#func set_params(facing_: int) -> void:
	#if facing_ == 0:
		#starting_location = Vector2(0,randi_range(50, window_height-50))
		#print(starting_location)
		#landing_destination = Vector2(randi_range(20,window_width/2),randi_range(50, window_height-50))
		#while Geometry2D.is_point_in_circle(landing_destination, Vector2(240,148),76):
			#landing_destination = Vector2(randi_range(20,window_width/2),randi_range(50, window_height-50))
		#facing = 1
	#else:
		#starting_location = Vector2(window_width,randi_range(50, window_height-50))
		#print(starting_location)
		#landing_destination = Vector2(randi_range(window_width/2,window_width-20),randi_range(50, window_height-50))
		#while Geometry2D.is_point_in_circle(landing_destination, Vector2(240,148),76):
			#landing_destination = Vector2(randi_range(window_width/2,window_width-20),randi_range(50, window_height-50))
		#facing = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if spawn_side == -1:
		position = Vector2(randi_range(20,window_width-20),randi_range(50, window_height-50))
		while Geometry2D.is_point_in_circle(position, Vector2(240,148),76):
				position = Vector2(randi_range(20,window_width-20),randi_range(50, window_height-50))
		facing = [-1, 1].pick_random()
		if facing == -1:
			$AnimatedSprite2D.flip_h = true
		
		print("hello!")
		add_to_group("birds")
		state = States.GROUNDED
	else:
		if spawn_side == 0:
			starting_location = Vector2(0,randi_range(50, window_height-50))
			print(starting_location)
			landing_destination = Vector2(randi_range(20,window_width/2),randi_range(50, window_height-50))
			while Geometry2D.is_point_in_circle(landing_destination, Vector2(240,148),76):
				landing_destination = Vector2(randi_range(20,window_width/2),randi_range(50, window_height-50))
			facing = 1
			$AnimatedSprite2D.flip_h = false
		else:
			starting_location = Vector2(window_width,randi_range(50, window_height-50))
			print(starting_location)
			landing_destination = Vector2(randi_range(window_width/2,window_width-20),randi_range(50, window_height-50))
			while Geometry2D.is_point_in_circle(landing_destination, Vector2(240,148),76):
				landing_destination = Vector2(randi_range(window_width/2,window_width-20),randi_range(50, window_height-50))
			facing = -1
			$AnimatedSprite2D.flip_h = true
		
		
		
		position = starting_location
		print("hello!")
		add_to_group("birds")
		
		$FlappingSound.play()
		var flap_timer := get_tree().create_timer(flap_speed)
		flap_timer.timeout.connect(_on_flap_end)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	if state == States.LANDING:
		if position.y < 125:
			$AnimatedSprite2D.z_index = 2
		else:
			$AnimatedSprite2D.z_index = 5
		landing(delta)
		#if Time.get_ticks_msec() % 1000 == 0:
			#$FlappingSound.play()
	elif state == States.GROUNDED:
		if position.y < 125:
			$AnimatedSprite2D.z_index = 2
		else:
			$AnimatedSprite2D.z_index = 5
		grounded(delta)
	elif state == States.FLYING_AWAY:
		flying_away(delta)
	elif state == States.SLEEPING:
		sleeping(delta)

func _on_flap_end() -> void:
	if state == States.LANDING or state == States.FLYING_AWAY:
		$FlappingSound.play()
	var flap_timer := get_tree().create_timer(flap_speed)
	flap_timer.timeout.connect(_on_flap_end)



func landing(delta: float) -> void:
	# move toward destination
	position = position.move_toward(landing_destination, SPEED*delta)
	#print(landing_destination)
	#print(position)
	$AnimatedSprite2D.play("fly")
	# switch to GROUNDED when destination is reached
	if position.is_equal_approx(landing_destination):
		
		switch_to_grounded()




func switch_to_grounded() -> void:
	state = States.GROUNDED
	var sleepy_timer = get_tree().create_timer(8)
	sleepy_timer.timeout.connect(_on_sleepy_timer_timeout)

func grounded(_delta: float) -> void:
	$AnimatedSprite2D.play("idle")
	if not hopping and random.randi_range(0,100) < 10:
		hopping = true
		
		#var hop_tween = get_tree().create_tween()

func _on_sleepy_timer_timeout() -> void:
	if state == States.GROUNDED:
		switch_to_sleeping()

func switch_to_sleeping() -> void:
	state = States.SLEEPING
	var timer = get_tree().create_timer(1+random.randf_range(-0.5,0.5))
	timer.timeout.connect(_on_sleep_particle_timer_timeout)
	#print("switch to sleeping")

func sleeping(_delta: float) -> void:
	pass

func _on_sleep_particle_timer_timeout() -> void:
	#print("zzzzzzz")
	if state == States.SLEEPING:
		#print("sleeeeeeeping")
		var timer = get_tree().create_timer(1+random.randf_range(-0.5,0.5))
		timer.timeout.connect(_on_sleep_particle_timer_timeout)
		add_child(sleep_particle_scene.instantiate())


func _on_hop_end() -> void:
	hopping = false



func switch_to_flying_away() -> void:
	if position.y < 125:
		$AnimatedSprite2D.z_index = 2
	else:
		$AnimatedSprite2D.z_index = 5
	state = States.FLYING_AWAY

func flying_away(delta: float) -> void:
	#print(position)
	if retreat_vector == null:
		retreat_vector = Vector2(RETREAT_SPEED*cos(-PI/4),RETREAT_SPEED*sin(-PI/4))
	position+=retreat_vector*delta
	$AnimatedSprite2D.play("fly")
	$AnimatedSprite2D.speed_scale=2
	if not $Area2D.overlaps_area(bounds):
		queue_free()
	pass
	

func scare() -> void:
	switch_to_flying_away()
	flap_speed = 0.13
	scared.emit()

func startle() -> void:
	add_child(startle_particle_scene.instantiate())
	switch_to_grounded()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if state == States.GROUNDED and body is Player:
		scare()
		#queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if state == States.SLEEPING:
		startle()
		return
	if state != States.FLYING_AWAY and area.get_parent().get_parent() is Player:
		scare()


var caught = false
func _on_caught() -> void:
	if caught == true: return
	caught = true
	if state != States.FLYING_AWAY:
		scared.emit()
	state = States.GROUNDED
	$FlappingSound.volume_db = -80.0
	$AnimatedSprite2D.hide()
	#call_deferred("_disable_collision_shape")
	$Area2D.monitoring = false
	$CatchSound.play()
	await $CatchSound.finished
	queue_free()

func _disable_collision_shape() -> void:
	$Area2D/CollisionShape2D.disabled = true
