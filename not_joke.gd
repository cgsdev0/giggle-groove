extends Node2D

@export var joke: AudioLabelList

# Called when the node enters the scene tree for the first time.
func _ready():
	print(joke.labels[0].label)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
