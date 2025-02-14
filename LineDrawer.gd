extends ImmediateGeometry

onready var target_position = Vector3(0, 0, 0)
onready var n_position_node = $"../Space/Neutral"
onready var l_position_node = $"../Space/L+"
onready var r_position_node = $"../Space/R+"
onready var c_position_node = $"../Space/C+"
onready var a_distance_label = $"../UI/DistanceLabelAlpha"
onready var b_distance_label = $"../UI/DistanceLabelBeta"
onready var g_distance_label = $"../UI/DistanceLabelGamma"

func _process(_delta):
	clear()
	begin(Mesh.PRIMITIVE_LINES, null)
	add_vertex(n_position_node.global_transform.origin)
	add_vertex(target_position)
	end()

	var distance = n_position_node.global_transform.origin.distance_to(target_position)
	var percentage = (distance / 2.0) * 100
	a_distance_label.text = "%.0f%%" % percentage
	
	var fraction = max(min((distance - 1.8) / (2.0 - 1.8), 1.0), 0.0)
	
	if percentage > 100:
		material_override.albedo_color = Color.fuchsia
		a_distance_label.modulate = Color.purple
	else:
		var base_color = Color(3, 3, 3)
		var target_color = Color.hotpink
		var color = base_color.linear_interpolate(target_color, fraction)
		a_distance_label.modulate = color
		material_override.albedo_color = color
	
