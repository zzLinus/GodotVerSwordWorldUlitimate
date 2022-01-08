tool 


extends Area2D

export(String, FILE) var nextScenePath = ""

func getConfigWarning() -> String:
	if nextScenePath == "":
		return "no path for next scene is given"
	else:
		return ""






func _on_Portal_body_entered(body):
	if get_tree().change_scene(nextScenePath) != OK:
		print("unavaliable load scene")

