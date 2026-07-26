class_name Bird extends Node2D

const SPEED: float = 100
const RETREAT_SPEED = 200

@onready var window_width = get_viewport().get_visible_rect().size.x
@onready var window_height = get_viewport().get_visible_rect().size.y

signal scared

# screen bounds where the birds despawn
var bounds: Area2D

enum States {
	LANDING,
	GROUNDED,
	FLYING_AWAY
}

@export var state = States.LANDING
@export var starting_location: Vector2 = Vector2(0,0)
@export var landing_destination: Vector2 = Vector2(0,0)
var retreat_vector = null #movement vector

var flap_speed: float = 0.25

var hopping

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = starting_location
	print("hello!")
	add_to_group("birds")
	
	$FlappingSound.play()
	var flap_timer := get_tree().create_timer(flap_speed)
	flap_timer.timeout.connect(_on_flap_end)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if state == States.LANDING:
		landing(delta)
		
		#if Time.get_ticks_msec() % 1000 == 0:
			#$FlappingSound.play()
	elif state == States.GROUNDED:
		grounded(delta)
	elif state == States.FLYING_AWAY:
		flying_away(delta)

func _on_flap_end() -> void:
	if state != States.GROUNDED:
		$FlappingSound.play()
	var flap_timer := get_tree().create_timer(flap_speed)
	flap_timer.timeout.connect(_on_flap_end)



func landing(delta: float) -> void:
	# move toward destination
	position = position.move_toward(landing_destination, SPEED*delta)
	#print(position)

	# switch to GROUNDED when destination is reached
	if position.is_equal_approx(landing_destination):
		
		state = States.GROUNDED





func grounded(_delta: float) -> void:
	
	pass
	

func flying_away(delta: float) -> void:
	#print(position)
	if retreat_vector == null:
		retreat_vector = Vector2(RETREAT_SPEED*cos(-PI/4),RETREAT_SPEED*sin(-PI/4))
	position+=retreat_vector*delta
	if not $Area2D.overlaps_area(bounds):
		queue_free()
	pass
	

func scare() -> void:
	state = States.FLYING_AWAY
	flap_speed = 0.13
	scared.emit()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if state == States.GROUNDED and body is Player:
		scare()
		#queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if state != States.FLYING_AWAY and area.get_parent().get_parent() is Player:
		scare()


var caught = false
func _on_caught() -> void:
	if caught == true: return
	caught = true
	if state != States.FLYING_AWAY:
		scared.emit()
	$FlappingSound.volume_db = -80.0
	$Sprite2D.hide()
	#call_deferred("_disable_collision_shape")
	$Area2D.monitoring = false
	$CatchSound.play()
	await $CatchSound.finished
	queue_free()

func _disable_collision_shape() -> void:
	$Area2D/CollisionShape2D.disabled = true
