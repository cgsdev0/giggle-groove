class_name JokeWord extends Control


var controller: JokeController
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controller.get_progress() > anchor_left:
		get_child(0).text = ""
