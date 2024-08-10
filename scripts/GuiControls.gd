extends Control

onready var gameplay := $".."

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

#nome antigo: atualizaGUI()
func refresh_ui():
	#print("Estado atual: " + str(gameplay.current_state))	
	if gameplay.current_state == gameplay.GameState.TITLE:
		toggle_title_sreen()
	elif gameplay.current_state == gameplay.GameState.INGAME:
		toggle_ingame_sreen()
	elif gameplay.current_state == gameplay.GameState.PAUSE:
		toggle_pause_screen()
	elif gameplay.current_state == gameplay.GameState.GAMEOVER:
		toggle_gameover_scren()

#antigos nomes: atualizaGUITitle, atualizaGUIIngame, atualizaGUIPause, atualizaGUIGameover
func toggle_title_sreen():
	$title.visible = true
	$ingame.visible = false
	$pause.visible = false
	$gameover.visible = false
	$commonButtons.visible = false

func toggle_ingame_sreen():
	$title.visible = false
	$ingame.visible = true
	$pause.visible = false
	$gameover.visible = false
	$commonButtons.visible = false 

func toggle_pause_screen():
	$title.visible = false 
	$ingame.visible = true
	$pause.visible = true
	$gameover.visible = false
	$commonButtons.visible = true

func toggle_gameover_scren():
	$title.visible = false
	$ingame.visible = false
	$pause.visible = false
	$gameover.visible = true
	$commonButtons.visible = true

func update_score_ui(score_value):
	$ingame/score.text = "" + str(score_value)
	$ingame/score.update()

func update_life_ui(live_value):
	$ingame/lives.text = "" + str(live_value)
	$ingame/lives.update()
