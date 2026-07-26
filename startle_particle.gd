extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($Sprite2D, "position", Vector2(position.x,position.y-10), 0.1)
	await tween.finished
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass
