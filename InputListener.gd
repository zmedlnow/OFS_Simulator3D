extends Node
onready var a_distance_label = $"../UI/DistanceLabelAlpha"
onready var b_distance_label = $"../UI/DistanceLabelBeta"
onready var g_distance_label = $"../UI/DistanceLabelGamma"
onready var n_indicator = $"../Space/Neutral/NIndicator"
onready var l_indicator = $"../Space/Neutral/LIndicator"
onready var r_indicator = $"../Space/Neutral/RIndicator"
onready var c_indicator = $"../Space/Neutral/CIndicator"

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_D:
		a_distance_label.visible = not a_distance_label.visible
		b_distance_label.visible = not b_distance_label.visible
		g_distance_label.visible = not g_distance_label.visible
	if event is InputEventKey and event.pressed and event.scancode == KEY_N:
		n_indicator.visible = not n_indicator.visible
		l_indicator.visible = not l_indicator.visible
		r_indicator.visible = not r_indicator.visible
		c_indicator.visible = not c_indicator.visible
