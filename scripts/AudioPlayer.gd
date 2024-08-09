extends Node

func _ready():
	LoaderSamples.load_sample("explosion", "res://sounds/explosion.wav")
	LoaderSamples.load_sample("laser", "res://sounds/hit_enemy.wav")
	LoaderSamples.load_sample("music", "res://sounds/music.ogg")
	LoaderSamples.load_sample("powerup", "res://sounds/powerup.wav")
	yield(Utils.create_timer(4), "timeout")
	play("music")
	pass

func play(name):
	var player = AudioStreamPlayer.new()
	player.stream = LoaderSamples.get_resource(name)
	player.connect("finished", player, "queue_free")
	player.play()
	add_child(player)
	pass
