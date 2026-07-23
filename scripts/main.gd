extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#get_tree().root.content_scale_size = Vector2i(480*4,270*4)
	#get_tree().root.content_scale_factor = 4
	DisplayServer.window_set_size(Vector2i(480*4,270*4))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
