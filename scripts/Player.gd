extends CharacterBody2D

@export var speed: float = 200.0
@onready var anim = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if get_node("/root/GameManager").dialogue_active or get_node("/root/GameManager").player_locked:
		return  # impede movimento

	var dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up")
	)

	if dir.length() > 0:
		dir = dir.normalized()
		# Decide qual animação tocar com base no eixo dominante
		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				anim.play("left")
			else:
				anim.play("right")
		else:
			if dir.y > 0:
				anim.play("down")
			else:
				anim.play("top")

	velocity = dir * speed
	move_and_slide()

func play_absorption_effect():
	var effect = $AbsorptionEffect
	effect.emitting = true
	modulate = Color(1, 0.5, 0.5)  # vermelho temporário
	await get_tree().create_timer(1.2).timeout
	modulate = Color(1, 1, 1)

func on_dialogue_finished():
	pass
