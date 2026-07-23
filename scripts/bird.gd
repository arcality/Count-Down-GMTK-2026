class_name Bird extends Node2D

const SPEED = 20

enum States {
	LANDING,
	GROUNDED,
	FLYING_AWAY
}

@export var state = States.LANDING
var starting_location = Vector2(0,0)
var landing_destination = Vector2(0,0)
var retreat_vector = null #movement vector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == States.LANDING:
		landing(delta)
	elif state == States.GROUNDED:
		grounded(delta)
	elif state == States.FLYING_AWAY:
		flying_away(delta)
	pass


func landing(_delta: float) -> void:
	position.move_toward(landing_destination, SPEED)
	if position.is_equal_approx(landing_destination):
		state = States.GROUNDED

	

	

func grounded(_delta: float) -> void:
	pass
	

func flying_away(_delta: float) -> void:
	if retreat_vector == null:
		retreat_vector = Vector2(SPEED*cos(PI/4),SPEED*cos(PI/4))
	position+=retreat_vector
	pass
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if state == States.GROUNDED and body is Player:
		state = States.FLYING_AWAY
		
