extends PanelContainer


var pressed = [false, false]
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Signals.start_game1a.connect(show_once)
	Signals.restart.connect(restart)

func restart():
	hide()
	
func show_once():
	if !Signals.is_started:
		return
	if pressed[0] && pressed[1]:
		Signals.start_game2.emit()
		return
	show()

func _process(delta):
	if !visible:
		return
	if Input.is_action_just_pressed("row0") && !pressed[0]:
		pressed[0] = true
		$Confirm.play()
	if Input.is_action_just_pressed("row1") && !pressed[1]:
		pressed[1] = true
		$Confirm.play()
	if pressed[0] && pressed[1] && visible:
		hide()
		Signals.start_game2.emit()
