extends Control

@onready var name_input: LineEdit = $NameInput
@onready var age_input: LineEdit = $AgeInput
@onready var music_player: AudioStreamPlayer2D = $MusicGameMenu
@onready var type_sound_player: AudioStreamPlayer2D = $MusicWriting
@onready var screen_fade: ColorRect = $ScreenFade

func _ready() -> void:
	if name_input:
		name_input.text = ""
		name_input.text_changed.connect(_on_input_text_changed)

	if age_input:
		age_input.text = ""
		age_input.text_changed.connect(_on_input_text_changed)

	if music_player:
		music_player.volume_db = 0
		music_player.play()
	else:
		print("AudioStreamPlayer2D não encontrado!")

	# Garante que a tela está visível e transparente no início
	if screen_fade:
		screen_fade.visible = true
		screen_fade.color.a = 0.0

func _on_input_text_changed(new_text: String) -> void:
	if type_sound_player:
		type_sound_player.stop()
		type_sound_player.play()

func _on_start_button_pressed() -> void:
	var player_name = name_input.text.strip_edges()
	var age = age_input.text.strip_edges()

	if player_name == "" or age == "":
		push_warning("Preencha nome e idade.")
		return

	# Fade-out da música
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -15, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Fade-out da tela (opacidade do ColorRect)
	tween.tween_property(screen_fade, "color:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Quando terminar, troca a cena
	tween.finished.connect(func ():
		var game_scene = preload("res://scenes/levels/Level1.tscn").instantiate()
		get_tree().root.add_child(game_scene)
		queue_free()

		var game_manager = game_scene.get_node("GameManager")
		game_manager.player_name = player_name
		game_manager.player_age = age
	)
