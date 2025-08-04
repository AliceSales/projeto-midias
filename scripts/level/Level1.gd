extends CanvasLayer

@onready var video_player = $VideoPlayer
@onready var fade_rect = $FadeRect
@onready var npc = get_node("NPC")  # Referência ao NPC
@onready var dialogue_ui = $DialogueBox
@onready var player = get_node("Player")  # Referência ao Player

func _ready():
	# Começa a cena escura
	fade_rect.color.a = 1.0
	npc.reached_target.connect(_on_npc_disappeared)
	# Toca o vídeo de introdução
	#video_player.play()
	#video_player.finished.connect(_on_video_finished)
	_on_video_finished() #descomentar isso para pular o vídeo
	# Travar jogo durante o vídeo
	set_process(false)
	set_physics_process(false)

func _on_video_finished():
	# Esconde o vídeo
	video_player.visible = false

	# Fade-out suave
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.5)
	tween.finished.connect(_start_game_after_fade)

func _start_game_after_fade():
	# Libera o processamento do jogo
	set_process(true)
	set_physics_process(true)

	# Spawn do jogador
	var spawn_portal_name = get_node("/root/GameManager").spawn_at_portal
	if spawn_portal_name != "":
		var spawn_portal = get_node_or_null(spawn_portal_name)
		if spawn_portal:
			var player = get_node("Player")
			player.global_position = spawn_portal.global_position

	# Define o diálogo inicial e pós-ajuda
	npc.dialogo = [
		{"name": "Old man", "portrait": "res://assets/Personagens/old man/Old man portrait.png", "text": "Olá, viajante."},
		{"name": "Old man", "portrait": "res://assets/Personagens/old man/Old man portrait.png", "text": "Você pode me ajudar?"}
	]
	npc.dialogo_pos_ajuda = [
		{"name": "Old man", "portrait": "res://assets/Personagens/old man/Old man portrait.png", "text": "Obrigado por ter me ajudado. Já estou bem."}
	]

func _on_npc_disappeared():
	dialogue_ui.start([
		{"name": "Kuma", "portrait": "res://assets/kuma.png", "text": "Eu devo segui-lo."}
	], player, false)
