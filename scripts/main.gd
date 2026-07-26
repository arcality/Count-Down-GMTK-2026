extends Node

#var birds: Array

@onready var window_width = get_viewport().get_visible_rect().size.x
@onready var window_height = get_viewport().get_visible_rect().size.y

@onready var time_display = $HUD/TimeDisplay
@onready var timer = $Timer

var bird_scene = preload("res://scenes/bird.tscn")
var upgrade_scene = preload("res://scenes/upgrade.tscn")
var random = RandomNumberGenerator.new()
var is_playing_level: bool = false

var scared_bird_ct: int = 0

# time alotted to get beneath the flame diverters
var warning_window_length = 10

enum GameState {
	PLAYING_LEVEL,
	TITLE_SCREEN
}

var game_state = GameState.TITLE_SCREEN

var total_casualties = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#start_level()
	#var upgrade: Upgrade = upgrade_scene.instantiate()
	#add_child(upgrade)
	#print(window_width)
	#print(window_height)
	#print(get_window().size)
	
	
	#get_tree().root.content_scale_size = Vector2i(480*4,270*4)
	#get_tree().root.content_scale_factor = 4
	
	#DisplayServer.window_set_size(Vector2i(480*4,270*4))
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if game_state == GameState.PLAYING_LEVEL:
		if Input.is_action_just_pressed("debug_button"):
			spawn_bird()
		if random.randi_range(0,100) == 0:
			spawn_bird()
			
	
	time_display.text = str(int(ceil(timer.time_left)))


func start_level() -> void:
	game_state = GameState.PLAYING_LEVEL
	print("start level")
	
	%Player.can_move = true
	%Player.respawn()

	timer.start()
	scared_bird_ct = 0
	for bird in get_tree().get_nodes_in_group("birds"):
		bird.queue_free()
	
	for n in 7:
		spawn_ground_bird()
	

func end_level() -> void:
	
	display_stats_screen()
	%Player.can_move = false
	
	
func display_stats_screen() -> void:
	# update stats
	var bird_tally := 0
	for bird in get_tree().get_nodes_in_group("birds"):
		bird_tally += 1
	total_casualties += bird_tally
	if %Player.state==%Player.States.PROTECTED:
		total_casualties += 1
	
	$StatsScreen.set_marmot_casualties(%Player.state==%Player.States.PROTECTED)
	$StatsScreen.set_bird_casualties(bird_tally)
	$StatsScreen.set_total_casualties(total_casualties)
	
	$StatsScreen.clear_upgrades()
	
	var possible_upgrades := Upgrade.Upgrades.values()
	possible_upgrades.shuffle()
	
	if %Player.airhorn_cooldown_upgrade_ct >= 3:
		possible_upgrades.remove_at(possible_upgrades.find(Upgrade.Upgrades.AIRHORN_COOLDOWN))
	if %Player.airhorn_radius_upgrade_ct >= 3:
		possible_upgrades.remove_at(possible_upgrades.find(Upgrade.Upgrades.AIRHORN_RADIUS))
	if %Player.flail_radius_upgrade_ct >= 3:
		possible_upgrades.remove_at(possible_upgrades.find(Upgrade.Upgrades.BATON_SIZE))
	#if %Player.net_range_upgrade_ct >= 3:
		#possible_upgrades.remove_at(possible_upgrades.find(Upgrade.Upgrades.NET_DISTANCE))
	if %Player.speed_upgrade_ct >= 3:
		possible_upgrades.remove_at(possible_upgrades.find(Upgrade.Upgrades.SPEED))
	
	possible_upgrades = possible_upgrades.slice(0,3)
	#var possible_upgrades := possible_upgrades.slice(0,2)
	for u in possible_upgrades:
		$StatsScreen.add_upgrade_choice(u)
	#for n in 3:
		#$StatsScreen.add_upgrade_choice(Upgrade.Upgrades.values().pick_random())
	
	# stats screen bounce animation
	var temp_tween = get_tree().create_tween()
	temp_tween.set_ease(Tween.EASE_OUT)
	temp_tween.set_trans(Tween.TRANS_BOUNCE)
	temp_tween.tween_property($StatsScreen, "offset", Vector2(0,0), 2.0)
	

func spawn_ground_bird() -> void:
	var new_bird: Bird = bird_scene.instantiate()
	new_bird.spawn_side = -1
	new_bird.bounds = $LaunchPad.bounds
	new_bird.scared.connect(_on_bird_scared)
		
	add_child(new_bird)

func spawn_bird() -> void:
	if timer.time_left <= warning_window_length:
		return
	var new_bird: Bird = bird_scene.instantiate()
	
	#if random.randi_range(0,1) == 0:
		#new_bird.starting_location = Vector2(0,randi_range(50, window_height-50))
		#new_bird.landing_destination = Vector2(randi_range(20,window_width/2),randi_range(50, window_height-50))
		#while Geometry2D.is_point_in_circle(new_bird.landing_destination, Vector2(240,148),76):
			#new_bird.landing_destination = Vector2(randi_range(20,window_width/2),randi_range(50, window_height-50))
		#new_bird.facing = 1
	#else:
		#new_bird.starting_location = Vector2(window_width,randi_range(50, window_height-50))
		#new_bird.landing_destination = Vector2(randi_range(window_width/2,window_width-20),randi_range(50, window_height-50))
		#while Geometry2D.is_point_in_circle(new_bird.landing_destination, Vector2(240,148),76):
			#new_bird.landing_destination = Vector2(randi_range(window_width/2,window_width-20),randi_range(50, window_height-50))
		#new_bird.facing = 1
	
	#new_bird.starting_location = Vector2(0,150)
	#new_bird.landing_destination = Vector2(240,135)
	new_bird.spawn_side = random.randi_range(0,1)
	new_bird.bounds = $LaunchPad.bounds
	new_bird.scared.connect(_on_bird_scared)
		
	#print(new_bird.landing_destination)
	add_child(new_bird)
	#new_bird.set_params(random.randi_range(0,1))
	

func _on_bird_scared() -> void:
	scared_bird_ct += 1
	print(scared_bird_ct)
	

func _on_timer_timeout() -> void:
	end_level()


func _on_stats_screen_retry_button_down() -> void:
	start_level()
	var temp_tween = get_tree().create_tween()
	temp_tween.tween_property($StatsScreen, "offset", Vector2(0,-window_height), 1.0)
	


func _on_stats_screen_main_menu_button_down() -> void:
	$"Title Screen".show()
	game_state = GameState.TITLE_SCREEN
	$"Title Screen/Button".disabled = false
	$StatsScreen.offset = Vector2(0,-window_height)
	pass # Replace with function body.


func _on_title_screen_play_button_down() -> void:
	$"Title Screen".hide()
	$"Title Screen/Button".disabled = true
	start_level()


func _on_stats_screen_upgrade_selected(upgrade: Upgrade.Upgrades) -> void:
	print(upgrade)
	match upgrade:
		Upgrade.Upgrades.AIRHORN_COOLDOWN:
			%Player.upgrade_airhorn_cooldown()
		Upgrade.Upgrades.AIRHORN_RADIUS:
			%Player.upgrade_airhorn_radius()
		Upgrade.Upgrades.BATON_SIZE:
			%Player.upgrade_flail_radius()
		#Upgrade.Upgrades.NET_DISTANCE:
			#%Player.upgrade_net_range()
		Upgrade.Upgrades.SPEED:
			%Player.upgrade_speed()
	#%Player.upgrade_net_range()
	print("Upgrade Selected: "+Upgrade.upgrade_data[upgrade]["text"])


func _on_launch_pad_on_door_entrance_body_entered(body: Node2D) -> void:
	if $Timer.time_left < warning_window_length and body is Player:
		%Player.protect()
		
