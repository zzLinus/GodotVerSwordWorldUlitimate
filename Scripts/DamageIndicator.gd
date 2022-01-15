extends Node2D

export(int) var SPEED : int = 50
export(int) var FRICTION : int = 15
var shiftDir : Vector2 = Vector2.ZERO

onready var lable = $Text

func _ready():
	shiftDir = Vector2(rand_range(-1, 1),rand_range(-1, 1))

func _process(delta):
	global_position += SPEED * shiftDir * delta
	SPEED = max(SPEED - FRICTION * delta, 0)
