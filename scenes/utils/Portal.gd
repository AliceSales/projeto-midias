extends Area2D
class_name Portal

@export var target_scene_path: String      # Ex: "res://scenes/Fase2.tscn"
@export var target_portal_name: String     # Nome do portal correspondente na outra fase

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":  # ou verifique: if body is CharacterBody2D
		var game_state = get_node("/root/GameManager")  # autoload
		game_state.spawn_at_portal = target_portal_name
		get_tree().change_scene_to_file(target_scene_path)
