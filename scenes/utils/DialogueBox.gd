extends CanvasLayer

signal dialogue_finished(option)

@onready var portrait = $Panel/TextureRect
@onready var name_label = $Panel/Label
@onready var text_label = $Panel/RichTextLabel
@onready var options_box = $Panel/VBoxContainer

var dialogue_data = []
var current_line = 0
var callback_npc = null
var show_choices := true

func _ready():
	# Limpa conexões duplicadas
	for button in options_box.get_children():
		for conn in button.pressed.get_connections():
			button.pressed.disconnect(conn.callable)
	
	# Conecta novamente
	for button in options_box.get_children():
		button.pressed.connect(func():
			_on_option_button_pressed(button.text)
	)

func start(dialogue, npc, show_choices_recive:=true):
	print(show_choices)
	visible = true
	dialogue_data = dialogue
	current_line = 0
	callback_npc = npc
	get_node("/root/GameManager").dialogue_active = true
	options_box.visible = show_choices  # <- só mostra se for diálogo com escolha
	show_choices = show_choices_recive
	show_line()

func show_line():
	var line = dialogue_data[current_line]
	portrait.texture = load(line["portrait"])
	name_label.text = line["name"].split(" ")[0]
	text_label.text = line["text"]

	var is_last_line = current_line == dialogue_data.size() - 1
	options_box.visible = is_last_line and show_choices

	if is_last_line:
		if options_box.get_child_count() > 0:
			options_box.get_child(0).grab_focus()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and not options_box.visible:
		current_line += 1
		if current_line < dialogue_data.size():
			show_line()
		else:
			finish()

func finish():
	visible = false
	get_node("/root/GameManager").dialogue_active = false
	if callback_npc:
		callback_npc.on_dialogue_finished()  # <- função do NPC chamada após diálogo

func _on_option_button_pressed(option):
	emit_signal("dialogue_finished", option)
	if callback_npc:
		callback_npc.receive_dialogue_choice(option)  # <- escolha do jogador
	finish()
