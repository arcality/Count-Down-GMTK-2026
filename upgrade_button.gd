class_name UpgradeButton extends Button

var upgrade: Upgrade.Upgrades

signal upgrade_button_down(upgrade: Upgrade.Upgrades)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_upgrade(upgrade_: Upgrade.Upgrades) -> void:
	upgrade = upgrade_
	text = Upgrade.upgrade_data[upgrade_]["text"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_down() -> void:
	upgrade_button_down.emit(upgrade)
