extends Node2D

var random = RandomNumberGenerator.new()

const speed = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = get_tree().create_timer(0.5)
	timer.timeout.connect(_on_timeout)
	

func _on_timeout() -> void:
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var angle = random.randf_range(PI/4,3*PI/4)
	var angle_vec = Vector2.LEFT.rotated(angle)
	position += angle_vec * speed * delta
