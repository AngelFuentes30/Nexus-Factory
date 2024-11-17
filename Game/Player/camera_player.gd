extends Camera2D

# Señal para enviar la posición del mouse cuando se hace clic
signal mouse_click_position(mouse_pos: Vector2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		emit_signal("mouse_click_position", mouse_pos)
