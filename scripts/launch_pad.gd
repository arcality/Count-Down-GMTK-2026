extends Node2D

@onready var bounds = $ScreenBounds
signal on_door_entrance_body_entered(body: Node2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$DoorEntrance.get_overlapping_bodies()

func run_hot_fire_test() -> void:
	$HotFireAnimation.play()
	$HotFireAnimation.show()

func reset() -> void:
	$HotFireAnimation.hide()


func _on_door_entrance_body_entered(body: Node2D) -> void:
	print('sjdgbsgkdsnkjs')
	on_door_entrance_body_entered.emit(body)
