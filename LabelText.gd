extends Node

onready var n_amplitude: Label = $"../UI/NeutralAmp"
onready var l_amplitude: Label = $"../UI/LeftAmp"
onready var r_amplitude: Label = $"../UI/RightAmp"
onready var c_amplitude: Label = $"../UI/CenterAmp"
onready var vector_length: Label = $"../UI/VectorLength"

onready var indicator: MeshInstance = $"../Indicator"

onready var n_origin: Position3D = $"../Neutral"
onready var l_origin: Position3D = $"../L+"
onready var r_origin: Position3D = $"../R+"
onready var c_origin: Position3D = $"../C+"

onready var n_ind: MeshInstance = $"../Neutral/NIndicator"
onready var l_ind: MeshInstance = $"../L+/LIndicator"
onready var r_ind: MeshInstance = $"../R+/RIndicator"
onready var c_ind: MeshInstance = $"../C+/CIndicator"


func _ready():
	update_text(1, 1, 1, 1, 0)
	
func _process(_delta):
	var n = calc_amp(n_ind)
	var l = calc_amp(l_ind)
	var r = calc_amp(r_ind)
	var c = calc_amp(c_ind)

	var v = calc_vector()
	
	update_text(n, l, r, c, v)

func calc_amp(e_ind: MeshInstance) -> float:
	var distance = n_origin.global_translation.direction_to(e_ind.global_translation).dot(n_origin.global_translation.direction_to(indicator.global_translation)) * indicator.global_translation.length() + 1
	
	#n_origin.global_translation.direction_to(e_ind.global_translation)
	#n_origin.global_translation.direction_to(indicator.global_translation)
	#indicator.global_translation.length
	
	var amp = distance
	if distance > 1:
		amp = 1
	elif distance < 0:
		amp = 0
	return amp

func calc_vector():
	var distance = n_origin.global_translation.distance_to(indicator.global_translation)
	if distance > 1:
		vector_length.add_color_override("font_color", Color8(255, 0, 0, 255))
	else:
		vector_length.remove_color_override("font_color")
	return distance

func update_text(n, l, r, c, v):
	n_amplitude.text = "%0.3f" % n
	l_amplitude.text = "%0.3f" % l
	r_amplitude.text = "%0.3f" % r
	c_amplitude.text = "%0.3f" % c
	vector_length.text = "%0.3f" % v
