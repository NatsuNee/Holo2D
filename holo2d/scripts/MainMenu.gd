extends Control

#unc _ready():
	#hideall()
	#$Main.show()
	
func hideall():
	$Main.hide()
	$Lobby.hide()
	$Singleplayer.hide()
	$Singleplayer/Contractor.hide()
	$Singleplayer/ContractorNull.hide()
	$Singleplayer/Label.hide()

func _on_Mutiplayer_pressed():
	hideall()
	$Lobby.show()

func _on_Quit_pressed():
	get_tree().quit()

func _player_connected(id):
	var game = preload("res://payman2/maps/Tutorial.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
	
func _on_Singleplayer_pressed():
	hideall()
	$Singleplayer.show()
	$Singleplayer/Label.show()
	$Singleplayer/Contractor.show()
	$Singleplayer/Label.text = "Contractor"

func _on_TestArea_pressed():
	hideall()
	$Singleplayer.show()
	$Singleplayer/MissionTest.show()

func _on_Null_pressed():
	hideall()
	$Singleplayer.show()
	$Singleplayer/Label.show()
	$Singleplayer/ContractorNull.show()
	$Singleplayer/Label.text = "Mission"

func _on_Play_pressed():
	var game = preload("res://payman2/maps/TestWorld.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
