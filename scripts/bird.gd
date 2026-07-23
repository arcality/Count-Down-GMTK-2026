class_name Bird extends Node2D

enum States {
	LANDING,
	GROUNDED,
	FLYING_AWAY
}

@export var state = States.LANDING
var starting_location = Vector2i(0,0)
var landing_destination = Vector2i(0,0)
var retreat_direction = null

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


func landing(delta: float) -> void:
	pass
	

func grounded(delta: float) -> void:
	pass
	

func flying_away(delta: float) -> void:
	if retreat_direction == null:
		retreat_direction = Vector2()
	pass
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if state == States.GROUNDED and body is Player:
		state = States.FLYING_AWAY
		
