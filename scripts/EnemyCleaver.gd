extends Enemy

const scn_laser = preload("res://scenes/LaserEnemy.tscn")
var projectiles_node

func _ready():
	life = 2
	scorePoints = 15
	velocity.x = 20
	projectiles_node = get_tree().current_scene.get_node("Projectiles")
	yield(Utils.create_timer(1), "timeout")
	if(is_instance_valid(self)): 
		shoot()

func safe_free():
	if shoot().is_valid():
		shoot().resume()
	queue_free()

func _process(delta):
	# bouncing from screen
	if self.position.x <= 0+16:
		velocity.x = abs(velocity.x)
	if self.position.x >= Utils.view_size.x-16:
		velocity.x = -abs(velocity.x)
	pass

func shoot():
	while true:
		if(is_instance_valid(self)):
			var laser = scn_laser.instance()
			laser.position = $cannon.global_position
			projectiles_node.add_child(laser)
			Utils.main_node.add_child(laser)
		yield(Utils.create_timer(1.5), "timeout")




