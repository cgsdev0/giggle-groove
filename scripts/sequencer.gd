extends Node

@export var jokes: Array[AudioLabelList]

var joke_idx = 0

var count_jokes = 0
func _ready():
	Signals.next_joke.connect(on_next)
	Signals.start_game2.connect(on_start)
	Signals.game_over2.connect(on_game_end)
	Signals.game_over.connect(on_game_end1)
	if !OS.is_debug_build():
		jokes.shuffle()

func _process(delta):
	if Input.is_action_just_pressed("restart") && Signals.is_started:
		Signals.restart.emit()
		count_jokes = 0
		jokes.shuffle()
		$RootControl/Control.laugh_streak = 0
		$RootControl/Control.clear()
		Signals.start_game2.emit()
		
func on_game_end1():
	$RootControl/Control.clear()
	$RootControl/Control/AnimationPlayer.play_backwards("show_ui")
	
func on_start():
	count_jokes = 0
	on_next()

	
func on_next():
	if !Signals.is_started:
		return
	if (OS.is_debug_build() && count_jokes >= 2) || count_jokes >= 10:
		Signals.game_over.emit()
		return
	if joke_idx >= len(jokes):
		joke_idx = 0
		jokes.shuffle()
	$RootControl/Control.joke = jokes[joke_idx]
	Signals.joke_start.emit(jokes[joke_idx])
	$RootControl/Control.start_joke()
	joke_idx += 1
	count_jokes += 1

func on_game_end():
	$RootControl/Control.laugh_streak = 0
	$RootControl/Control.clear()
	$%Scoreboard.show_summary()
	$%Grumbly.play_backwards("fade_out")

func show_play_button():
	$%Button.show()
	
func _on_button_pressed():
	$%Button.hide()
	$%Grumbly.play("fade_out")
	Signals.start_game.emit()
	await get_tree().create_timer(1.0, false).timeout
	$RootControl/Control/AnimationPlayer.play("show_ui")
