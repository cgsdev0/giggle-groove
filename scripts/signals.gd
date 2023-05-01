extends Node

signal next_joke

signal start_game
signal start_game1a # lmao
signal start_game2 # after animation

signal game_over
signal game_over2 # after animation

signal joke_start(joke)
signal restart

var is_started = false

var game_idx = 0

func _ready():
	start_game.connect(_on_start)
	game_over.connect(_on_end)
	restart.connect(_on_restart)
	
func _on_restart():
	game_idx += 1
	
func _on_start():
	is_started = true

func _on_end():
	is_started = false
