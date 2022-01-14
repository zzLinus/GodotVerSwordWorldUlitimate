extends mover

export(PackedScene) var DAGGER : PackedScene = preload("res://Scenes/Digger.tscn")

class_name fighter

signal hp_changed(newHp)
signal died

export(int) var hpMax : int = 100
export(int) var hp: int = hpMax setget set_hp
export(int) var defence : int = 0
export(int) var specise : int = 1


onready var sprite = $Spirte
onready var collshape = $CollisionShape2D
onready var animPlayer = $AniamtionPlayer
onready var animatiedSprite = $AnimatedSprite
onready var attackTimer = $Timer

func set_hp(value : int):
	print("hp befor change" + str(self.hp))
	if hp + value == hp:
		return

	if hp + value < 0:
		hp = 0
		emit_signal("died")
		return
	else:
		hp += value

	print("hp after change" + str(self.hp))
	emit_signal("hp_changed",hp)

func ThrowDaggers():
	if DAGGER:
		var dagger = DAGGER.instance()
		var angle : float = PI
		get_tree().current_scene.add_child(dagger)
		dagger.global_position = self.global_position  + Vector2.ONE * 16

		if(Input.is_action_pressed("weaponDown")):
			angle = 2 * PI * 0.25
		if(Input.is_action_pressed("weaponLeft")):
			angle = 2 * PI * 0.5
		if(Input.is_action_pressed("weaponUp")):
			angle = 2 * PI * 0.75
		if(Input.is_action_pressed("weaponRight")):
			angle = 2 * PI * 0
		if(Input.is_action_pressed("weaponRight") && Input.is_action_pressed("weaponDown")):
				angle = 2 * PI * 0.125
		if(Input.is_action_pressed("weaponDown") && Input.is_action_pressed("weaponLeft")):
				angle = 2 * PI * 0.375
		if(Input.is_action_pressed("weaponLeft") && Input.is_action_pressed("weaponUp")):
				angle = 2 * PI * 0.625
		if(Input.is_action_pressed("weaponUp") && Input.is_action_pressed("weaponRight")):
				angle = 2 * PI * 0.875

		if angle == PI:
			if direction == Vector2(1,0):
				angle = 0
			elif direction == Vector2(-1,0):
				angle = PI

		var dagger_rotation = angle
		dagger.rotation = dagger_rotation

		attackTimer.start()


func changeAnimationState(animation:String) -> void:
	if currAnimState == animation:
		return

	if specise == 1 && animation == "run":
		animation = "knightRun"
	elif specise == 1 && animation == "idle":
		animation = "knightIdle"

	animatedSprite.play(animation)
	currAnimState = animation

func _physics_process(delta):
	if Input.is_action_pressed("action_attack") && specise == 1 && attackTimer.is_stopped():
		ThrowDaggers()

func die():
	queue_free()




	print("player died")


func _on_Hurtbox_area_entered(hitbox : Area2D):
	var baseDamage = hitbox.damage
	if baseDamage == 0:
		return
	print(str(hitbox.get_path()) + "=>" + name)
	set_hp(-baseDamage)
	print(hitbox.get_parent().name + "'s hitbox touched" + name + "'s hurbox and damage " + str(baseDamage))
	print("object hp: " + str(self.hp))


func _on_Hurtbox_body_entered(body:Node):
	pass # Replace with function body.
