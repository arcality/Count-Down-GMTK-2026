class_name Bird extends Node2D

const SPEED: float = 100

@onready var window_width = get_viewport().get_visible_rect().size.x
@onready var window_height = get_viewport().get_visible_rect().size.y

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = starting_location
	print("hello!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if state == States.LANDING:
		landing(delta)
	elif state == States.GROUNDED:
		grounded(delta)
	elif state == States.FLYING_AWAY:
		flying_away(delta)
	pass


func landing(delta: float) -> void:
	# move toward destination
	position = position.move_toward(landing_destination, SPEED*delta)
	print(position)

	# switch to GROUNDED when destination is reached
	if position.is_equal_approx(landing_destination):
		state = States.GROUNDED

	

	

func grounded(_delta: float) -> void:
	pass
	

func flying_away(delta: float) -> void:
	print(position)
	if retreat_vector == null:
		retreat_vector = Vector2(SPEED*cos(-PI/4),SPEED*sin(-PI/4))
	position+=retreat_vector*delta
	if not $Area2D.overlaps_area(bounds):
		queue_free()
	pass
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if state == States.GROUNDED and body is Player:
		state = States.FLYING_AWAY
		#queue_free()
		
