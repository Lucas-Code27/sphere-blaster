extends MeshInstance3D

@export var noisemap: FastNoiseLite
@export var material: StandardMaterial3D

func _ready() -> void:
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(mesh, 0)
	mesh = surface_tool.commit()
	
	var mdt = MeshDataTool.new()
	
	mdt.create_from_surface(mesh, 0)
	
	for vert in mdt.get_vertex_count():
		var vert_pos: Vector3 = mdt.get_vertex(vert)
		var noise_offset: float = noisemap.get_noise_2d(vert_pos.x, vert_pos.z)
		mdt.set_vertex(vert, Vector3(vert_pos.x, vert_pos.y + noise_offset * 20, vert_pos.z))
	
	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)
	
	mesh.surface_set_material(0, material)
	
	surface_tool = SurfaceTool.new()
	surface_tool.create_from(mesh, 0)
	surface_tool.generate_normals()
	mesh = surface_tool.commit()
	
	create_trimesh_collision()
