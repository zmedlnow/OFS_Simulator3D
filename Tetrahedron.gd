extends ImmediateGeometry

onready var target_position = Vector3(0, 0, 0)
onready var n_node = $"../Neutral/NIndicator"
onready var l_node = $"../L+/LIndicator"
onready var r_node = $"../R+/RIndicator"
onready var c_node = $"../C+/CIndicator"

func _process(_delta):
	clear()
	begin(Mesh.PRIMITIVE_LINES, null)
	add_vertex(n_node.global_transform.origin)
	add_vertex(l_node.global_transform.origin)
	add_vertex(l_node.global_transform.origin)
	add_vertex(r_node.global_transform.origin)
	add_vertex(r_node.global_transform.origin)
	add_vertex(c_node.global_transform.origin)
	add_vertex(c_node.global_transform.origin)
	add_vertex(n_node.global_transform.origin)
	add_vertex(n_node.global_transform.origin)
	add_vertex(r_node.global_transform.origin)
	add_vertex(l_node.global_transform.origin)
	add_vertex(c_node.global_transform.origin)
	end()

	material_override.albedo_color = Color(3, 3, 3)
	
