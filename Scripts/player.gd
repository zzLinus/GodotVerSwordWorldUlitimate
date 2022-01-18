extends fighter

onready var sprite = $Sprite
onready var animPlayer = $AnimationPlayer
onready var hitbox = $BladeHit

var hitboxPos 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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
			direction = Vector2(-1,1)
			sprite.flip_h = true
			hitbox.position.x = hitboxPos.x
			changeAnimationState("run")
		elif Input.is_action_pressed("right"):
			velocity.x += 1
			direction = Vector2(1,1)
			sprite.flip_h = false 
			hitbox.position.x = -hitboxPos.x
			changeAnimationState("run")

		if(velocity.x == 0 && velocity.y == 0):
			changeAnimationState("idle")

	velocity = velocity.normalized()

	velocity = move_and_slide(velocity * 15000 * delta)


# Called when the node enters the scene tree for the first time.
func _ready():
	hitboxPos = hitbox.position
	pass # Replace with function body.


func changeAnimationState(animation:String) -> void:
	if currAnimState == animation || !attackIsStop:
		return

	if specise == 1 && animation == "run":
		animation = "windKnightRun"
	elif specise == 1 && animation == "idle":
		animation = "windKnightIdle"
	elif specise == 1 && animation == "attack1":
		animation = "windKnightAttack1"
		attackIsStop = false
	elif specise == 1 && animation == "attack2":
		animation = "windKnightAttack2"
		attackIsStop = false
	elif specise == 1 && animation == "attack3":
		if direction == Vector2(1,1):
			animation = "windKnightAttack3"
		else:
			animation = "windKnightAttack3left"
		attackIsStop = false
	elif specise == 1 && animation == "attack4":
		animation = "windKnightAttack4"
		attackIsStop = false

	animPlayer.play(animation)
	# animatedSprite.play(animation)
	currAnimState = animation

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
