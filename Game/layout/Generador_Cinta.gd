extends Node2D

# Precarga la escena de la cinta
var conveyor_scene: PackedScene = preload("res://Game/Structures/Transport/transport_lvl_1.tscn")
var conveyor_direction: int = 1  # 1: Arriba, 2: Abajo, 3: Derecha, 4: Izquierda
var cell_size: int = 32  # Tamaño de la celda de la cuadrícula

# Conectar la señal de la cámara al inicializar el nodo
func _ready() -> void:
	var camera = get_node("%Camera_Player")  # Asegúrate que la ruta sea correcta
	camera.connect("mouse_click_position", Callable(self, "_on_mouse_click_position"))


# Función que se ejecuta cuando se recibe la posición del clic
func _on_mouse_click_position(mouse_pos: Vector2) -> void:
	place_conveyor(mouse_pos)

# Función para colocar la cinta en la posición recibida
func place_conveyor(mouse_pos: Vector2) -> void:
	# Redondear la posición al centro de la celda más cercana
	var grid_x = round(mouse_pos.x / cell_size) * cell_size
	var grid_y = round(mouse_pos.y / cell_size) * cell_size
	
	# Instancia una nueva cinta
	var current_conveyor = conveyor_scene.instantiate()
	
	# Coloca la cinta en el nodo de mapa
	var map_node = get_node("%Grid")  # Cambia esta ruta según tu escena
	map_node.add_child(current_conveyor)
	
	# Coloca la cinta en la posición redondeada
	current_conveyor.position = Vector2(grid_x, grid_y)
	
	# Aplica la dirección actual
	current_conveyor.direction = conveyor_direction
	
	# Llama a la función para actualizar la animación
	current_conveyor.call("update_animation")
func rotate_conveyor() -> void:
	conveyor_direction += 1
	if conveyor_direction > 4:
		conveyor_direction = 1
