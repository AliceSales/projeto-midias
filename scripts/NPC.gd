extends Node2D

@export var npc_name: String = "NPC"
@onready var dialog_panel = $TextureButton
@onready var dialogue_ui = get_parent().get_node("DialogueBox")
@onready var player = get_parent().get_node("Player")
@onready var animation = $AnimationPlayer
@onready var target_node = get_parent().get_node("TargetPosition")
signal reached_target

var in_range = false
var dialogo = []
var dialogo_pos_ajuda = []
var foi_ajudado = false
var andando = false

func _ready():
	dialog_panel.visible = false
	animation.play("idle")

func _physics_process(delta):
	if andando:
		get_node("/root/GameManager").player_locked = true
		var target_pos = target_node.global_position
		var dir = (target_pos - global_position).normalized()
		position += dir * 60 * delta

		if global_position.distance_to(target_pos) < 4:
			get_node("/root/GameManager").player_locked = false
			andando = false
			_on_reach_target()
		return

	if position.distance_to(player.position) < 200:
		in_range = true
		dialog_panel.visible = true

		if Input.is_action_just_pressed("interact"):
			_on_talk()
	else:
		in_range = false
		dialog_panel.visible = false

func _on_talk():
	if in_range:
		dialog_panel.visible = false
		if foi_ajudado:
			dialogue_ui.start(dialogo_pos_ajuda, self)
		else:
			dialogue_ui.start(dialogo, self)
		_send_choice("Conversou com o NPC")

func _send_choice(action: String):
	var gm = get_parent().get_node("GameManager")
	gm.register_npc_interaction(npc_name, action)
	dialog_panel.visible = false

func on_dialogue_finished():
	print("FINALIZOU O DIÁLOGO")

func receive_dialogue_choice(option):
	if foi_ajudado:
		return

	if option == "Ajudar":
		help()
	elif option == "Ignorar":
		ignore()

func help():
	player.play_absorption_effect()
	_send_choice("Ajudou o NPC")
	foi_ajudado = true
	dialog_panel.visible = false

	if target_node:
		get_node("/root/GameManager").player_locked = true
		andando = true

func ignore():
	_send_choice("Ignorou o NPC")
	dialog_panel.visible = false

func _on_reach_target():
	animation.play("idle")
	visible = false  # <- Se quiser que ele suma do mapa
	reached_target.emit()  # <- EMITE O SINAL para o level
