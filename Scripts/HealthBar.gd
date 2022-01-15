extends TextureProgress
onready var tween = $Tween

func _ready():
	yield(get_tree(),"idle_frame")
	value = get_parent().hp
	max_value = get_parent().hpMax

func animateHpChange(newHp : int,oldHp : int = value):
	tween.interpolate_property(self, "value", oldHp, newHp, 0.1, tween.TRANS_SINE, tween.EASE_IN_OUT, 0.025)
	tween.start()
