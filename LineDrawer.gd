extends ImmediateGeometry

onready var target_position = Vector3(0, 0, 0)
onready var position_node = $"../Indicator"

func _process(_delta):
	clear()
	begin(Mesh.PRIMITIVE_LINES, null)
	add_vertex(position_node.global_transform.origin)
	add_vertex(target_position)
	end()

	var distance = position_node.global_transform.origin.distance_to(target_position)
	var percentage = distance * 100
	
	if percentage > 100:
		material_override.albedo_color = Color.fuchsia
	else:
		var base_color = Color(3, 3, 3)
		material_override.albedo_color = base_color
	
