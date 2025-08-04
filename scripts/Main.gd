extends Node2D

@onready var player = $Player  # ajuste para o caminho correto

func _ready():
	#var spawn_name = GameManager.spawn_at_portal
	#if spawn_name != "":
		#var target_portal = find_child(spawn_name, true, false)

	var spawn_portal_name = get_node("/root/GameManager").spawn_at_portal
	if spawn_portal_name != "":
		var spawn_portal = get_node_or_null(spawn_portal_name)
		if spawn_portal:
			var player = get_node("Player")
			player.global_position = spawn_portal.global_position
