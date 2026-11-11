class_name Enemy extends Area3D

@onready var target: CharacterBody3D = get_parent().player

const SPEED = 60

func _physics_process(delta: float) -> void:
	var direction: Vector3 = (target.global_position - global_position).normalized()
	global_position += direction * SPEED * delta


func _on_body_entered(body: Node3D) -> void:
	get_parent().game_over()
	get_tree().paused = true
