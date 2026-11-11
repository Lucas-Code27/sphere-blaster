extends Node

@export var player: CharacterBody3D

@onready var lose_text: Label = $UI/LoseText

@onready var spawn_timer: Timer = $SpawnTimer

@onready var button_retry: Button = $UI/ButtonRetry

const SPAWN_RANGE = 1000.0

const ENEMY_SCENE = preload("res://enemies/enemy.tscn")

func _ready() -> void:
	get_tree().paused = false

func game_over() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	spawn_timer.stop()
	button_retry.show()
	lose_text.show()

func _on_spawn_timer_timeout() -> void:
	var enemy_inst: Area3D = ENEMY_SCENE.instantiate()
	add_child(enemy_inst)
	enemy_inst.global_position = Vector3(randf_range(-SPAWN_RANGE, SPAWN_RANGE), 200, randf_range(-SPAWN_RANGE, SPAWN_RANGE))

func _on_button_retry_pressed() -> void:
	get_tree().reload_current_scene()
