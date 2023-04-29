class_name AudioLabel extends Resource

@export var start: float
@export var end: float
@export var label: String

func _init(p_start = 0.0, p_end = 0.0, p_label = ""):
	start = p_start
	end = p_end
	label = p_label
