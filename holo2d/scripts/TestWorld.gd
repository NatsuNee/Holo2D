extends Node2D

@onready var player1pos = $YSort/player1pos
var mutiplayer

func _ready():
		var player1 = preload("res://ghostprotocol/models/player/player1.tscn").instantiate()
		player1.global_transform = player1pos.global_transform
		$YSort.add_child(player1)
