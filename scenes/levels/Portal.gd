extends Area2D

@export var target_scene_path: String = ""  # Caminho para a próxima cena
@export var spawn_portal_name: String = ""  # Nome do portal de destino (opcional)

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		var game_manager = get_node("/root/GameManager")
		game_manager.spawn_at_portal = spawn_portal_name  # Define o local de spawn
		get_tree().change_scene_to_file(target_scene_path)  # Troca de cena
