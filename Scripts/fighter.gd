extends mover

export(PackedScene) var DAGGER : PackedScene = preload("res://Scenes/Digger.tscn")

class_name fighter

signal hp_changed(newHp)
signal died

const INDICATOR_DAMAGE = preload("res://Scenes/DamageIndicator.tscn")

export(int) var hpMax : int = 300
export(int) var hp: int = hpMax setget set_hp
export(int) var defence : int = 0
export(int) var specise : int = 1
export(bool) var receivKnockback : bool = true
export(float) var knockBackModifier : float = 2
export(PackedScene) var effectHit : PackedScene = null


onready var healthBar = $HealthBar
onready var collshape = $CollisionShape2D
onready var attackTimer = $Timer


func set_hp(value : int):
	print("hp befor change" + str(self.hp))
	if hp + value == hp:
		return

	if hp + value < 0:
		hp = 0
		emit_signal("died")
		die()
		return
	else:
		hp += value

	if hp != hpMax:
		healthBar.show()

	healthBar.animateHpChange(hp)
	print("hp after change" + str(self.hp))
	emit_signal("hp_changed",hp)


func ThrowDaggers() -> void:
	if DAGGER:
		var dagger = DAGGER.instance()
		var angle : float = PI
		var fireSoundPlayer = get_node("../FireSound")
		get_tree().current_scene.add_child(dagger)
		dagger.global_position = self.global_position  + Vector2.ONE * 16



		if(Input.is_action_pressed("up")):
			angle = 2 * PI * 0.25
		if(Input.is_action_pressed("left")):
			angle = 2 * PI * 0.5
		if(Input.is_action_pressed("up")):
			angle = 2 * PI * 0.75
		if(Input.is_action_pressed("right")):
			angle = 2 * PI * 0
		if(Input.is_action_pressed("right") && Input.is_action_pressed("down")):
				angle = 2 * PI * 0.125
		if(Input.is_action_pressed("down") && Input.is_action_pressed("left")):
				angle = 2 * PI * 0.375
		if(Input.is_action_pressed("left") && Input.is_action_pressed("up")):
				angle = 2 * PI * 0.625
		if(Input.is_action_pressed("up") && Input.is_action_pressed("right")):
				angle = 2 * PI * 0.875

		if angle == PI:
			if direction == Vector2(1,0):
				angle = 0
			elif direction == Vector2(-1,0):
				angle = PI

		var dagger_rotation = angle
		dagger.rotation = dagger_rotation
		fireSoundPlayer.play()

		attackTimer.start()


func spawnEffect(effect: PackedScene,effectPos: Vector2 = global_position):
		var currEffect = effect.instance()
		get_tree().current_scene.add_child(currEffect)
		currEffect.global_position = effectPos
		return currEffect


func spawnDmgindicator(damage : int):
	var indicator = spawnEffect(INDICATOR_DAMAGE)
	if indicator:
		print("sucess load float text")
		indicator.lable.text = str(damage)


func ReceiveKnockback(damageSourcePos : Vector2,reciveDamage : int):
	if receivKnockback:
		var knockBackDir : Vector2 = damageSourcePos.direction_to(self.global_position)
		var knockBackStength : float = reciveDamage * knockBackModifier
		var knockBack : Vector2 = knockBackDir * knockBackStength
		
		# global_position += knockBack
		move_and_slide(knockBack * 50)


func changeAnimationState(animation:String) -> void:
	if currAnimState == animation:
		return

	if specise == 1 && animation == "run":
		animation = "knightRun"
	elif specise == 1 && animation == "idle":
		animation = "knightIdle"

	animatedSprite.play(animation)
	currAnimState = animation


func _ready():
	healthBar.max_value = hpMax


func _physics_process(delta):
	if Input.is_action_pressed("action_attack") && specise == 1 && attackTimer.is_stopped():
		ThrowDaggers()


func die():
	queue_free()
	print("player died")


func _on_Hurtbox_area_entered(hitbox : Area2D):
	var baseDamage = hitbox.damage
	var hurtSoundPlayer = get_node("../HurtSound")
	if baseDamage == 0:
		return
	
	if(hitbox.get_parent().name == "Enemy" && attackTimer.is_stopped()):
		print(str(hitbox.get_path()) + "=>" + name)
		set_hp(-baseDamage)
		ReceiveKnockback(hitbox.global_position,baseDamage)
		spawnEffect(effectHit)
		spawnDmgindicator(baseDamage)
		print(hitbox.get_parent().name + "'s hitbox touched" + name + "'s hurbox and damage " + str(baseDamage))
		print("object hp: " + str(self.hp))
		attackTimer.start()
		hurtSoundPlayer.play()
	elif(hitbox.get_parent().name != "Enemy"):
		print(str(hitbox.get_path()) + "=>" + name)
		set_hp(-baseDamage)
		ReceiveKnockback(hitbox.global_position,baseDamage)
		spawnEffect(effectHit)
		spawnDmgindicator(baseDamage)
		print(hitbox.get_parent().name + "'s hitbox touched" + name + "'s hurbox and damage " + str(baseDamage))
		print("object hp: " + str(self.hp))
		hurtSoundPlayer.play()


func _on_Hurtbox_body_entered(body:Node):
	pass # Replace with function body.
