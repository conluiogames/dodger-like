extends PowerUP

signal life_point_added 

var player_instance : Node

func _ready():
	var players = get_tree().get_nodes_in_group("ship")
	if players.size() > 0:
		player_instance = players[0]  # Seleciona o primeiro nó no grupo "ship"
		connect("life_point_added", player_instance, "restore_life")
	else:
		print("erro: powerup de cura sem alvo")
	pass

	connect("area_entered", self, "_on_area_entered")
	#connect("life_point_added", player_instance, "restore_life")  
	pass

func _on_area_entered(other):
	if other.is_in_group("ship"):
		#other.life += 1 #trocado por um sinal
		emit_signal("life_point_added")
		audio_player.play("powerup")
		queue_free()
	pass
