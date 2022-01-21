extends mover

export(PackedScene) var DAGGER : PackedScene = preload("res://Scenes/Digger.tscn")

class_name fighter

signal hp_changed(newHp)
signal died

const INDICATOR_DAMAGE = preload("res://Scenes/DamageIndicator.tscn")

var hpMax : int = AutoloadScript.playerData.hpMax
var hp: int = AutoloadScript.playerData.hp setget set_hp
var defence : int = 0
var specise : int = AutoloadScript.playerData.specise
var attackIsStop : bool 
var receivKnockback : bool = true
var lastState : bool
var knockBackModifier : float = 2
var comboAction : int = 1
export(PackedScene) var effectHit : PackedScene = null
export(PackedScene) var runSmoke: PackedScene = null


onready var healthBar = $HealthBar
onready var collshape = $CollisionShape2D

onready var attackTimer = $Attacktimer
onready var comboTimer = $ComboTimer
onready var runSmokeTimer = $RunSmoke

func MoveWhithEnemy():
	if AutoloadScript.enemyNode != null:
		global_position = AutoloadScript.enemyNode.global_position


func set_hp(value : int):
	# print("hp befor change" + str(self.hp))
	if hp + value <= 0:
		hp = 0
		emit_signal("died")
		die()
		return
	else:
		hp += value

	if hp != hpMax:
		healthBar.show()

	healthBar.animateHpChange(hp)
	# print("hp after change" + str(self.hp))
	emit_signal("hp_changed",hp)

func WindKnightAttack(attackType : int):
	if attackType == 1:
		changeAnimationState("attack1")
	elif attackType == 2:
		changeAnimationState("attack2")
	elif attackType == 3:
		changeAnimationState("attack3")
	elif attackType == 4:
		changeAnimationState("attack4")
	elif attackType == 5:
		changeAnimationState("back1")
	elif attackType == 6:
		changeAnimationState("back2")



func ThrowDaggers() -> void:
	if DAGGER:
		var dagger = DAGGER.instance()
		var angle : float = PI
		var fireSoundPlayer = get_node("../FireSound")
		get_tree().current_scene.add_child(dagger)
		dagger.global_position = self.global_position  + Vector2.ONE * 16



		if(Input.is_action_pressed("down")):
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
			if direction == Vector2(1,1):
				angle = 0
			elif direction == Vector2(-1,1):
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
		indicator.lable.text = str(damage)


func ReceiveKnockback(damageSourcePos : Vector2,reciveDamage : int):
	if receivKnockback:
		var knockBackDir : Vector2 = damageSourcePos.direction_to(self.global_position)
		var knockBackStength : float = reciveDamage * knockBackModifier
		var knockBack : Vector2 = knockBackDir * knockBackStength
		
		# global_position += knockBack
		move_and_slide(knockBack * 10)


func _ready():
	healthBar.max_value = hpMax
	attackIsStop = true
	loadPlayerData()
	set_hp(0)

func yoveWhitEenmy():
	global_position = AutoloadScript.enemyNode.global_position


func _physics_process(delta):
	if self.name == "Player":
		if AutoloadScript.daggerHit == true:
			MoveWhithEnemy()
			AutoloadScript.playerDamage = 20
			WindKnightAttack(4)
			AutoloadScript.daggerHit = false
		if Input.is_action_pressed("windKnightAttack4") && specise == 1 && attackTimer.is_stopped():
			AutoloadScript.playerDamage = 5
			ThrowDaggers()

		#combo system

		if Input.is_action_pressed("windKnightAttack") && self.name == "Player" && attackIsStop: 
			if comboAction == 1:
				comboTimer.start()

			if comboTimer.is_stopped():
				comboAction = 1

			elif specise == 1 && attackTimer.is_stopped() && !comboTimer.is_stopped():
				if comboAction == 1:
					comboTimer.start()
					AutoloadScript.playerDamage = 10
					WindKnightAttack(comboAction)
					comboAction += 1
				elif comboAction == 2:
					comboTimer.start()
					AutoloadScript.playerDamage = 20
					WindKnightAttack(comboAction)
					comboAction += 1
				elif comboAction == 3:
					comboTimer.start()
					AutoloadScript.playerDamage = 30
					WindKnightAttack(comboAction)
					comboAction = 1

		if comboTimer.is_stopped() == true && lastState == false:
			if comboAction == 2:
				WindKnightAttack(5)
			elif comboAction == 3:
				WindKnightAttack(6)
			comboAction = 1

		lastState = comboTimer.is_stopped()


func die():
	queue_free()
	print("player died")


func _on_Hurtbox_area_entered(hitbox : Area2D):
	print(hitbox.get_parent().name)
	
	if(hitbox.get_parent().name == "Enemy" && attackTimer.is_stopped()):
		var baseDamage = hitbox.damage
		var hurtSoundPlayer = get_node("../HurtSound")

		# print(str(hitbox.get_path()) + "=>" + name)
		set_hp(-baseDamage)
		ReceiveKnockback(hitbox.global_position,baseDamage)
		spawnEffect(effectHit)
		spawnDmgindicator(baseDamage)
		# print(hitbox.get_parent().name + "'s hitbox touched" + name + "'s hurbox and damage " + str(baseDamage))
		# print("object hp: " + str(self.hp))
		attackTimer.start()
		hurtSoundPlayer.play()
	elif(hitbox.name == "PlayerDigger"):
		var baseDamage = hitbox.damage
		var hurtSoundPlayer = get_node("../HurtSound")
		# print("hitbox: " + hitbox.name)
		# print(str(hitbox.get_path()) + "=>" + name)
		set_hp(-baseDamage)
		ReceiveKnockback(hitbox.global_position,baseDamage)
		AutoloadScript.daggerHit = true
		AutoloadScript.enemyNode = get_node(self.get_path())
		spawnEffect(effectHit)
		spawnDmgindicator(baseDamage)
		# print(hitbox.get_parent().name + "'s hitbox touched" + name + "'s hurbox and damage " + str(baseDamage))
		# print("object hp: " + str(self.hp))
		hurtSoundPlayer.play()
	elif(hitbox.name == "BladeHit"):
		var baseDamage = hitbox.damage
		var hurtSoundPlayer = get_node("../HurtSound")
		# print("hitbox: " + hitbox.name)
		# print(str(hitbox.get_path()) + "=>" + name)
		set_hp(-baseDamage)
		ReceiveKnockback(hitbox.global_position,baseDamage)
		spawnEffect(effectHit)
		spawnDmgindicator(baseDamage)
		# print(hitbox.get_parent().name + "'s hitbox touched" + name + "'s hurbox and damage " + str(baseDamage))
		# print("object hp: " + str(self.hp))
		hurtSoundPlayer.play()
	else:
		print("hitbox: " + hitbox.name)
		pass


func _on_Hurtbox_body_entered(body:Node):
	pass # Replace with function body.



func _on_Player_died():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "windKnightAttack1":
		attackIsStop = true
	if anim_name == "windKnightAttack2":
		attackIsStop = true
	if anim_name == "windKnightAttack3":
		attackIsStop = true
	if anim_name == "windKnightAttack3left":
		attackIsStop = true
	if anim_name == "windKnightAttack4":
		attackIsStop = true
	if anim_name == "windKnightAttack1Close":
		attackIsStop = true
	if anim_name == "windKnightAttack2Close":
		attackIsStop = true
	
func SpawnRunSmoke():
	spawnEffect(runSmoke,global_position + Vector2(10,30))
	pass


func savePlayerData():
	AutoloadScript.playerData.hp = hp
	AutoloadScript.playerData.hpMax = hpMax
	AutoloadScript.playerData.specise = specise


func loadPlayerData() -> void:
	hp = AutoloadScript.playerData.hp
	hpMax = AutoloadScript.playerData.hpMax 
	specise = AutoloadScript.playerData.specise 
