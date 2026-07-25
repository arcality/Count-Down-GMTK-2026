class_name Upgrade extends Node

enum Upgrades {
	AIRHORN_COOLDOWN,
	AIRHORN_RADIUS,
	BATON_SIZE,
	NET_DISTANCE,
	NET_COOLDOWN,
	SPEED
}

var upgrade_data: Array = [
	{"text":"Shorter Airhorn Cooldown", "property":"airhorn_cooldown"},
	{"text":"Louder Airhorn", "property":"airhorn_radius"},
	{"text":"More Menacing Baton", "property":"flail_radius"},
	{"text":"Longer Net", "property":"net_range"},
	{"text":"Shorter Net Cooldown", "property":"net_cooldown"},
	{"text":"Speed", "property":"acceleration"}
]



var upgrade: Upgrades

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade = Upgrades.values().pick_random()
	print(upgrade)
	#print(Upgrades.keys()[upgrade])
	print(upgrade_data[upgrade]["property"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
