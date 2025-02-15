extends Node
onready var n_amplitude = $"../UI/NeutralAmp"
onready var l_amplitude = $"../UI/LeftAmp"
onready var r_amplitude = $"../UI/RightAmp"
onready var c_amplitude = $"../UI/CenterAmp"
onready var n_indicator = $"../Space/Neutral/NIndicator"
onready var l_indicator = $"../Space/L+/LIndicator"
onready var r_indicator = $"../Space/R+/RIndicator"
onready var c_indicator = $"../Space/C+/CIndicator"

onready var front_camera = $"../Camera"
onready var upper_camera = $"../Camera2"

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_D:
		n_amplitude.visible = not n_amplitude.visible
		l_amplitude.visible = not l_amplitude.visible
		r_amplitude.visible = not r_amplitude.visible
		c_amplitude.visible = not c_amplitude.visible
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
		
