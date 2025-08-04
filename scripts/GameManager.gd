extends Node

# Busca o DataSender como irmão no nó Main, e faz cast para o tipo correto
@onready var sender: DataSender = Sender

var elapsed_time: float = 0.0
var player_name: String
var player_age: String
var spawn_at_portal: String = ""
var dialogue_active: bool = false
var player_locked: bool = false

func _process(delta: float) -> void:
	elapsed_time += delta

func register_npc_interaction(npc_name: String, action_str: String) -> void:
	sender.send_choice(player_name, npc_name, action_str, elapsed_time, player_age)
	elapsed_time = 0.0
