extends Sprite

onready var animaPlayer = $AnimationPlayer

var currAnimation : String 


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func changeAnimState(anim : String):
	if anim == currAnimation:
		return

	animaPlayer.play(anim)
	currAnimation = anim


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	changeAnimState("tiantianIdle")
