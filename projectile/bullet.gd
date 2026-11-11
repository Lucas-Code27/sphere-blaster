extends Area3D

const SPEED = 100

func _physics_process(delta: float) -> void:
	global_position += -global_basis.z * SPEED * delta

func _on_body_entered(body: Node3D) -> void:
	queue_free()

func _on_area_entered(area: Area3D) -> void:
	if area is Enemy:
		var part_inst: CPUParticles3D = load("res://enemy_death_particle.tscn").instantiate()
		get_parent().add_child(part_inst)
		part_inst.global_position = area.global_position
		
		area.queue_free()
		queue_free()
