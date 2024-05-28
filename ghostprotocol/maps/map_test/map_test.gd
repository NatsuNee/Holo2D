extends Node2D

@onready var pl1_spawn = $pl1_spawn

func _ready():
	if pl1_spawn:
		var player1 = preload("res://ghostprotocol/models/player/player1.tscn")
		var player_instance = player1.instantiate()
		player_instance.position = pl1_spawn.get_global_position()
		add_child(player_instance)
	else:
		push_error("'pl1 spawn' not found")
