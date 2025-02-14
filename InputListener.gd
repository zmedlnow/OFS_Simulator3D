extends Node
onready var a_magnitude = $"../UI/DistanceLabelAlpha"
onready var b_magnitude = $"../UI/DistanceLabelBeta"
onready var g_magnitude = $"../UI/DistanceLabelGamma"
onready var n_indicator = $"../Space/Neutral/NIndicator"
onready var l_indicator = $"../Space/L+/LIndicator"
onready var r_indicator = $"../Space/R+/RIndicator"
onready var c_indicator = $"../Space/C+/CIndicator"

onready var front_camera = $"../Camera"
onready var upper_camera = $"../Camera2"

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_D:
		a_magnitude.visible = not a_magnitude.visible
		b_magnitude.visible = not b_magnitude.visible
		g_magnitude.visible = not g_magnitude.visible
	if event is InputEventKey and event.pressed and event.scancode == KEY_N:
		n_indicator.visible = not n_indicator.visible
		l_indicator.visible = not l_indicator.visible
		r_indicator.visible = not r_indicator.visible
		c_indicator.visible = not c_indicator.visible
	if event is InputEventKey and event.pressed and event.scancode == KEY_P:
		if front_camera.projection == Camera.PROJECTION_PERSPECTIVE:
			front_camera.projection = Camera.PROJECTION_ORTHOGONAL
			upper_camera.projection = Camera.PROJECTION_ORTHOGONAL
		else:
			front_camera.projection = Camera.PROJECTION_PERSPECTIVE
			upper_camera.projection = Camera.PROJECTION_PERSPECTIVE
	if event is InputEventKey and event.pressed and event.scancode == KEY_9:
		front_camera.current = true
	if event is InputEventKey and event.pressed and event.scancode == KEY_0:
		upper_camera.current = true
		
