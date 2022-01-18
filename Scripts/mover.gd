extends KinematicBody2D
class_name mover

var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2();
var initPos = Vector2(0,0)
var isMoving = false
var currAnimState : String = ""

func changeAnimationState(animation:String) -> void:
	if currAnimState == animation:
		return

	print("change animation state to " + animation)
	currAnimState = animation



func move(delta):
	velocity = Vector2()

	if not Input.is_action_pressed("stop"):
		if Input.is_action_pressed("up"):
			velocity.y -= 1
			changeAnimationState("run")
		elif Input.is_action_pressed("down"):
			velocity.y += 1
			changeAnimationState("run")

		if Input.is_action_pressed("left"):
			velocity.x -= 1
			direction = Vector2(-1,0)
			changeAnimationState("run")
		elif Input.is_action_pressed("right"):
			velocity.x += 1
			direction = Vector2(1,0)
			changeAnimationState("run")

		if(velocity.x == 0 && velocity.y == 0):
			changeAnimationState("idle")

	velocity = velocity.normalized()

	velocity = move_and_slide(velocity * 15000 * delta)


func _physics_process(delta):
	move(delta)
	var node = get_parent()
	if node.name == "Catfe":
		node.scale.x = 0.5
		node.scale.y = 0.5
