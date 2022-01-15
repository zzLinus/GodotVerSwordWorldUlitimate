extends Node2D

onready var animPlayer = $AnimationPlayer


func _process(delta):
	animPlayer.play("number")

