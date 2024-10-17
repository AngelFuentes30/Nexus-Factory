extends Node2D

var cell_size: float = 32.0  # Tamaño de cada celda en la cuadrícula
var grid_color: Color = Color(0, 1, 0, 0.5)  # Color de la cuadrícula (verde semitransparente)

func _draw():
	# Dibuja la cuadrícula
	for x in range(-get_viewport().size.x, get_viewport().size.x, cell_size):
		draw_line(Vector2(x, -get_viewport().size.y), Vector2(x, get_viewport().size.y), grid_color)
	for y in range(-get_viewport().size.y, get_viewport().size.y, cell_size):
		draw_line(Vector2(-get_viewport().size.x, y), Vector2(get_viewport().size.x, y), grid_color)
