extends CanvasLayer

signal retry_button_down
signal main_menu_button_down
signal upgrade_selected(upgrade: Upgrade.Upgrades)

@onready var upgrade_scene = preload("res://scenes/upgrade.tscn")
@onready var upgrade_button_scene = preload("res://scenes/upgrade_button.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func clear_upgrades() -> void:
	var children := $UpgradeHBox.get_children()
	for child in children:
		child.queue_free()
	

func add_upgrade_choice(upgrade: Upgrade.Upgrades) -> void:
	#var new_upgrade = upgrade_scene.instantiate()
	#upgrade = Upgrade.Upgrades.values().pick_random()
	#var display_text = Upgrade.upgrade_data[upgrade]["text"]
	var upgrade_button := upgrade_button_scene.instantiate()
	upgrade_button.set_upgrade(upgrade)
	$UpgradeHBox.add_child(upgrade_button)
	upgrade_button.upgrade_button_down.connect(_on_upgrade_button_down)

func _on_upgrade_button_down(upgrade: Upgrade.Upgrades) -> void:
	print(upgrade)
	for button: UpgradeButton in $UpgradeHBox.get_children():
		button.disabled = true
	upgrade_selected.emit(upgrade)
	



func set_bird_casualties(bird_casualties: int) -> void:
	$BirdCasualtiesLabel.text = "Bird Casualties: " + str(bird_casualties)

func set_marmot_casualties(protected: bool) -> void:
	if protected:
		$MarmotCasualtiesLabel.text = ""
	else:
		$MarmotCasualtiesLabel.text = "Marmot Casualties: 1"

func set_total_casualties(total_casualties: int) -> void:
	$TotalCasualtiesLabel.text = "Total Casualties: " + str(total_casualties)
	

func game_over() -> void:
	$GameOverLabel.show()
	$UpgradeHBox.hide()
	$SelectAnUpgradeLabel.hide()
	$RetryButton.disabled = true

func _on_retry_button_button_down() -> void:
	emit_signal("retry_button_down")


func _on_main_menu_button_button_down() -> void:
	emit_signal("main_menu_button_down")
