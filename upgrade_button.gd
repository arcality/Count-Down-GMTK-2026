class_name UpgradeButton extends Button

var upgrade: Upgrade.Upgrades

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_upgrade(upgrade: Upgrade.Upgrades) -> void:
	text = Upgrade.upgrade_data[upgrade]["text"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
