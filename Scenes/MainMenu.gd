extends Control

export(String, FILE) var MainScenePath = ""

var menuOriPos : Vector2 = Vector2.ZERO
var menuOriSize : Vector2 = Vector2.ZERO

var currMenu
var menuStack := []
var transitionTime : float = 0.5

onready var menu1 = $Menu1
onready var menu2 = $Menu2
onready var tween = $Tween


func _ready():
	menuOriPos = Vector2(0, 0)
	menuOriSize = get_viewport_rect().size
	currMenu = menu1


func MoveToNextMenu(nextMenuID : String):
	var nextMenu = GetMenuFromID(nextMenuID)
	tween.interpolate_property(currMenu,"rect_global_position",currMenu.rect_global_position	,
		Vector2(-menuOriSize.x, 0),transitionTime)
	tween.interpolate_property(nextMenu,"rect_global_position",nextMenu.rect_global_position	,
		menuOriPos,transitionTime)
	tween.start()
	menuStack.append(currMenu)
	currMenu = nextMenu




func MoveToPreMenu():
	var preMenu = menuStack.pop_back()
	if preMenu != null:
		tween.interpolate_property(currMenu,"rect_global_position",currMenu.rect_global_position,
			Vector2(menuOriSize.x, 0),transitionTime)
		tween.interpolate_property(preMenu,"rect_global_position",preMenu.rect_global_position,
			menuOriPos,transitionTime)
		tween.start()
	
	currMenu = preMenu




func GetMenuFromID(menuID : String) -> Control:
	match menuID:
		"menu1":
			return menu1
		"menu2":
			return menu2
		_:
			return menu1




func _on_StartGame_pressed() -> void:
	get_tree().change_scene(MainScenePath)


func _on_SecondMenu_pressed() -> void:
	MoveToNextMenu("menu2")


func _on_ToolButton_pressed():
	MoveToPreMenu()
