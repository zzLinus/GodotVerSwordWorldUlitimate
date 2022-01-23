extends Node2D

var daggerHit : bool = false
var enemyNode 
var playerDamage

var playerData = {
	"hp" : 300,
	"hpMax" : 300,
	"level" : 1,
	"specise" : 1,
	"playerType" : 1
	}

func _ready():
	playerDamage = 400
	pass # Replace with function body.

