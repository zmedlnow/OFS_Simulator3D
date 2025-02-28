extends ImmediateGeometry

onready var target_position = Vector3(0, 0, 0)
onready var position_node = $"../Indicator"

onready var vector_length = $"../UI/VectorLength"

func _process(_delta):
	clear()
	begin(Mesh.PRIMITIVE_LINES, null)
	add_vertex(position_node.global_transform.origin)
	add_vertex(target_position)
	end()

	var distance = position_node.global_transform.origin.distance_to(target_position)
	
	if distance > 1:
		material_override.albedo_color = Color.fuchsia
	else:
		material_override.albedo_color = Color(3, 3, 3)
	
