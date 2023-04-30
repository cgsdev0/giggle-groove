extends Node

@export var jokes: Array[AudioLabelList]

var joke_idx = 0
func _ready():
	Signals.next_joke.connect(on_next)
	Signals.start_game2.connect(on_next)
	jokes.shuffle()
	# on_next()

func on_next():
	if joke_idx >= len(jokes):
		joke_idx = 0
		jokes.shuffle()
	$Control.joke = jokes[joke_idx]
	$Control.start_joke()
	joke_idx += 1


func _on_button_pressed():
	$%Button.hide()
	Signals.start_game.emit()
