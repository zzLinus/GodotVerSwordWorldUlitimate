extends Node2D
onready var mainMenuBGM = $"mainMenu"
onready var mainGameBGM = $"BGMPlayer"


func _process(delta):
	var currSceneName : String = get_tree().current_scene.name
	if currSceneName == "CanvasLayer":
		if mainMenuBGM.playing == false:
			mainMenuBGM.play()
	elif currSceneName == "main":
		mainMenuBGM.stop()
		if mainGameBGM.playing == false:
			mainGameBGM.play()
