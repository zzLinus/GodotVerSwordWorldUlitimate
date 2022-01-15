extends AudioStreamPlayer
onready var audioPlayer = $"."

func _process(delta):
	if audioPlayer.playing == false:
		audioPlayer.play()
