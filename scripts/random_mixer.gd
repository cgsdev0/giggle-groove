extends Node


@export var samples: Array[AudioStream] = []

var choices = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var idx = 0
	for sample in samples:
		var stream = AudioStreamPlayer.new()
		stream.stream = sample
		add_child(stream)
		choices.push_back(idx)
		idx += 1


func play_some(lmin: int, lmax: int):
	choices.shuffle()
	for i in range(randi_range(lmin, lmax)):
		await get_tree().create_timer(randf_range(0.0, 0.2)).timeout
		get_child(choices[i]).play()
