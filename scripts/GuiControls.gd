extends Control

onready var gameplay := $".."

func _ready():
	pass

func atualizaGUI():
	print("Estado atual: " + str(gameplay.current_state))

#	match gameplay.current_state:
#		gameplay.GameState.TITLE:
#			print("Atualizando GUI para TITLE")
#			atualizaGUITitle()
#		gameplay.GameState.INGAME:
#			print("Atualizando GUI para INGAME")
#			atualizaGUIIngame()
#		gameplay.GameState.PAUSE:
#			print("Atualizando GUI para PAUSE")
#			atualizaGUIPause()
#		gameplay.GameState.GAMEOVER:
#			print("Atualizando GUI para GAMEOVER")
#			atualizaGUIGameover()
			
	if gameplay.current_state == gameplay.GameState.TITLE:
		print("Atualizando GUI para TITLE")
		atualizaGUITitle()
	elif gameplay.current_state == gameplay.GameState.INGAME:
		print("Atualizando GUI para INGAME")
		atualizaGUIIngame()
	elif gameplay.current_state == gameplay.GameState.PAUSE:
		print("Atualizando GUI para PAUSE")
		atualizaGUIPause()
	elif gameplay.current_state == gameplay.GameState.GAMEOVER:
		print("Atualizando GUI para GAMEOVER")
		atualizaGUIGameover()
	else:
		print("Estado desconhecido: " + str(gameplay.current_state))
	pass


func atualizaGUITitle():
	$title.visible = true
	$ingame.visible = false
	$pause.visible = false
	$gameover.visible = false
	$commonButtons.visible = false
	pass

func atualizaGUIIngame():
	$title.visible = false
	$ingame.visible = true
	$pause.visible = false
	$gameover.visible = false
	$commonButtons.visible = false
	pass 

func atualizaGUIPause():
	$title.visible = false 
	$ingame.visible = true
	$pause.visible = true
	$gameover.visible = false
	$commonButtons.visible = true
	pass 

func atualizaGUIGameover():
	print("Atualizada tela do GameOver")
	$title.visible = false
	$ingame.visible = false
	$pause.visible = false
	$gameover.visible = true
	$commonButtons.visible = true
	pass
