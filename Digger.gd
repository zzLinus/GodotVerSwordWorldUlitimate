extends hitbox

export(int) var speed : int = 1000

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta

func _ready():
	damage = 50

func destroy():
	queue_free()


func _on_PlayerDigger_area_entered(area):
	destroy()


func _on_PlayerDigger_body_entered(body):
	destroy()


func _on_VisibilityNotifier2D_screen_exited():
	destroy()
