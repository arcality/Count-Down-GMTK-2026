extends Node

#var birds: Array

@onready var window_width = get_viewport().get_visible_rect().size.x
@onready var window_height = get_viewport().get_visible_rect().size.y

@onready var time_display = $CanvasLayer/TimeDisplay
@onready var timer = $Timer

var bird_scene = preload("res://scenes/bird.tscn")
var random = RandomNumberGenerator.new()

var scared_bird_ct: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	#print(window_width)
	#print(window_height)
	#print(get_window().size)
	
	
	#get_tree().root.content_scale_size = Vector2i(480*4,270*4)
	#get_tree().root.content_scale_factor = 4
	
	#DisplayServer.window_set_size(Vector2i(480*4,270*4))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_button"):
		spawn_bird()
	time_display.text = str(int(timer.time_left))



func spawn_bird() -> void:
	var new_bird: Bird = bird_scene.instantiate()
	if random.randi_range(0,1) == 0:
		new_bird.starting_location = Vector2(0,randi_range(50, window_height-50))
		new_bird.landing_destination = Vector2(randi_range(20,window_width/2),randi_range(50, window_height-50))
	else:
		new_bird.starting_location = Vector2(window_width,randi_range(50, window_height-50))
		new_bird.landing_destination = Vector2(randi_range(window_width/2,window_width-20),randi_range(50, window_height-50))
	#new_bird.starting_location = Vector2(0,150)
	#new_bird.landing_destination = Vector2(240,135)
	
	new_bird.bounds = $LaunchPad.bounds
	new_bird.scared.connect(_on_bird_scared)
		
	print(new_bird.landing_destination)
	add_child(new_bird)

func _on_bird_scared() -> void:
	scared_bird_ct += 1
	print(scared_bird_ct)
	
