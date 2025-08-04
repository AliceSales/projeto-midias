extends Node
class_name DataSender

@export var endpoint_url: String = "https://script.google.com/macros/s/AKfycby-QoAxG5r6aFNr4dNGDqtm_wbc3amavWEid9kaqyue6NYjyRm8Sbl5zU46t-AB3fWi8g/exec"

func send_choice(player_name: String, npc_name: String, action: String, time_taken: float, age: String) -> void:
	var http = HTTPRequest.new()
	add_child(http)
	http.timeout = 10
	http.connect("request_completed", Callable(self, "_on_request_completed"))
	var payload = {
		"name": player_name,
		"age": age,
		"npc": npc_name,
		"action": action,
		"time": str(time_taken)
	}
	var headers = ["Content-Type: application/json"]
	var json_body = JSON.stringify(payload)
	http.request(endpoint_url, headers, HTTPClient.METHOD_POST, json_body)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Dados enviados com sucesso")
	else:
		push_warning("Falha ao enviar dados: %s" % response_code)
