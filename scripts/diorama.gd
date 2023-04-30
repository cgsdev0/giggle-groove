extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.start_game.connect(do_anim)


func do_anim():
	$Curtains.play("open")
	await $Curtains.animation_finished
	Signals.start_game2.emit()
