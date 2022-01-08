extends KinematicBody2D

var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2();
var initPos = Vector2(0,0)
var isMoving = false
onready var animatedSprite = $AnimatedSprite

func read_input(delta):
	velocity = Vector2()

	if Input.is_action_pressed("up"):
		velocity.y -= 1
		direction = Vector2(0,-1)
		animatedSprite.play("playerRun")
	elif Input.is_action_pressed("down"):
		velocity.y += 1
		direction = Vector2(0,1)
		animatedSprite.play("playerRun")
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		animatedSprite.flip_h = true
		direction = Vector2(-1,0)
		animatedSprite.play("playerRun")
	elif Input.is_action_pressed("right"):
		velocity.x += 1
		animatedSprite.flip_h = false
		direction = Vector2(1,0)
		animatedSprite.play("playerRun")

	if(velocity.x == 0 && velocity.y == 0):
		animatedSprite.stop()
		animatedSprite.play("playerIdle")

	velocity = velocity.normalized()

	velocity = move_and_slide(velocity * 15000 * delta)


func _physics_process(delta):
	read_input(delta)
	var node = get_parent()
	print(node.name)
	if node.name == "Catfe":
		node.scale.x = 0.5
		node.scale.y = 0.5
