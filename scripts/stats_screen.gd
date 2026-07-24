extends CanvasLayer

signal retry_button_down
signal main_menu_button_down

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_birds_saved(bird_ct: int) -> void:
	$BirdsSavedLabel.text = "Birds Saved: " + str(bird_ct)


func _on_retry_button_button_down() -> void:
	emit_signal("retry_button_down")



func _on_main_menu_button_button_down() -> void:
	emit_signal("main_menu_button_down")
