extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.start_game.connect(do_anim)
	Signals.game_over.connect(do_anim2)
	Signals.joke_start.connect(on_joke)
	
func tween_out(l1, l2):
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(l1, "energy", 0.58, 0.2)
	tween.tween_property(l2, "energy", 0.0, 0.2)
	
func on_joke(joke):
	match joke.voice:
		AudioLabelList.Voice.ROBOT:
			tween_out($RobotLight, $SamLight)
		AudioLabelList.Voice.SAM:
			tween_out($SamLight, $RobotLight)

func do_anim2():
	$Curtains.play("end_show")
	await $Curtains.animation_finished
	$Curtains.play_backwards("open")
	await $Curtains.animation_finished
	Signals.game_over2.emit()
	
func do_anim():
	$Curtains.play("open")
	await $Curtains.animation_finished
	Signals.start_game2.emit()
