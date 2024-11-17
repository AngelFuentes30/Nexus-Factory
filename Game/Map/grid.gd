# Grid.gd
extends Node2D

var cell_size: float = 32.0  # Tamaño de cada celda en la cuadrícula
var grid_color: Color = Color(0, 1, 0, 0.5)  # Color de la cuadrícula (verde semitransparente)

# Método de dibujo para la cuadrícula
func _draw() -> void:
	# Calcular el centro del viewport
	var viewport_size = get_viewport().size
	var half_viewport_x = viewport_size.x / 2
	var half_viewport_y = viewport_size.y / 2

	# Dibuja las líneas verticales de la cuadrícula
	for x in range(-half_viewport_x, half_viewport_x, cell_size):
		draw_line(Vector2(x, -half_viewport_y), Vector2(x, half_viewport_y), grid_color)
	
	# Dibuja las líneas horizontales de la cuadrícula
	for y in range(-half_viewport_y, half_viewport_y, cell_size):
		draw_line(Vector2(-half_viewport_x, y), Vector2(half_viewport_x, y), grid_color)

# Función para recibir la posición del clic desde el Generador_Cinta
func _on_mouse_click_position(mouse_pos: Vector2) -> void:
	# Redondear la posición al centro de la celda más cercana
	var grid_x = floor(mouse_pos.x / cell_size) * cell_size + cell_size / 2
	var grid_y = floor(mouse_pos.y / cell_size) * cell_size + cell_size / 2

	# Instancia una nueva cinta
	var current_conveyor = preload("res://Game/Structures/Transport/transport_lvl_1.tscn").instantiate()

	# Coloca la cinta en el nodo de mapa
	add_child(current_conveyor)

	# Coloca la cinta en la posición redondeada
	current_conveyor.position = Vector2(grid_x, grid_y)

	# Llama a la función para actualizar la animación en caso de que exista
	if current_conveyor.has_method("update_animation"):
		current_conveyor.call("update_animation")
