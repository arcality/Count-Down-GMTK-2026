extends Node

#var birds: Array
var bird_scene = preload("res://scenes/bird.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#get_tree().root.content_scale_size = Vector2i(480*4,270*4)
	#get_tree().root.content_scale_factor = 4
	
	#DisplayServer.window_set_size(Vector2i(480*4,270*4))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_button"):
		spawn_bird()



func spawn_bird() -> void:
	var new_bird: Bird = bird_scene.instantiate()
	new_bird.starting_location = Vector2(0,0)
	new_bird.landing_destination = Vector2(240,135)
	print(new_bird.landing_destination)
	add_child(new_bird)
