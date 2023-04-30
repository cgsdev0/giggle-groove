class_name AudioLabel extends Resource

@export var start: float
@export var end: float
@export var label: String
@export var index: int
@export var section: int

var _label_clean = null
var label_clean: String = "" :
	get:
		if _label_clean == null:
			_label_clean = label.split("{")[0]
		return _label_clean

func _init(p_start = 0.0, p_end = 0.0, p_label = ""):
	start = p_start
	end = p_end
	label = p_label
	index = 0
	section = 0
