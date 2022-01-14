extends fighter

func changeAnimationState(animation:String) -> void:
	if currAnimState == animation:
		return

	if specise == 1 && animation == "run":
		animation = "knightRun"
	elif specise == 1 && animation == "idle":
		animation = "knightIdle"

	if specise == 2 && animation == "run":
		animation = "monsterRun"
	elif specise == 2 && animation == "idle":
		animation = "monsterIdle"

	animatedSprite.play(animation)
	currAnimState = animation

func move(delta):
	velocity = Vector2()

	if Input.is_key_pressed(KEY_UP):
		velocity.y -= 1
		direction = Vector2(0,-1)
		changeAnimationState("run")

	elif Input.is_key_pressed(KEY_DOWN):
		velocity.y += 1
		direction = Vector2(0,1)
		changeAnimationState("run")

	if Input.is_key_pressed(KEY_LEFT):
		velocity.x -= 1
		animatedSprite.flip_h = true
		direction = Vector2(-1,0)

		changeAnimationState("run")

	elif Input.is_key_pressed(KEY_RIGHT):
		velocity.x += 1
		animatedSprite.flip_h = false
		direction = Vector2(1,0)
		changeAnimationState("run")

	if(velocity.x == 0 && velocity.y == 0):
		changeAnimationState("idle")

	velocity = velocity.normalized()

	velocity = move_and_slide(velocity * 15000 * delta)

func _ready():
	specise = 2

func _physics_process(delta):
	move(delta)
	var node = get_parent()
	if node.name == "Catfe":
		node.scale.x = 0.5
		node.scale.y = 0.5


