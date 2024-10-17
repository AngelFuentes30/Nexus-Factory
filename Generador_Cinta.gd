extends Node2D

var conveyor_scene: PackedScene = preload("res://transport_lvl_1.tscn")  # Ruta a la escena de la cinta
var current_conveyor: Node2D = null  # Cinta actual que se está colocando
var conveyor_direction: int = 1  # Dirección inicial (1: Up, 2: Down, 3: Right, 4: Left)
var cell_size: int = 32  # Tamaño de la celda de la cuadrícula

func _ready() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	# Detecta el clic izquierdo para colocar la cinta
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		place_conveyor()

	# Detecta la acción para rotar la cinta antes de colocarla (usando la tecla R)
	if Input.is_action_just_pressed("rotate_conveyor"):
		rotate_conveyor()

# Función para colocar la cinta en la posición del mouse
func place_conveyor() -> void:
	var mouse_pos = get_global_mouse_position()
	# Redondear la posición al centro de la celda más cercana
	var grid_x = round(mouse_pos.x / cell_size) * cell_size
	var grid_y = round(mouse_pos.y / cell_size) * cell_size
	current_conveyor = conveyor_scene.instantiate()  # Instancia una nueva cinta
	add_child(current_conveyor)  # Añade la cinta a la escena
	current_conveyor.position = Vector2(grid_x, grid_y)  # Coloca la cinta en la posición redondeada
	current_conveyor.direction = conveyor_direction  # Aplica la dirección actual
	current_conveyor.call("update_animation")  # Llama a la función para actualizar la animación

# Función para rotar la cinta con la tecla R
func rotate_conveyor() -> void:
	conveyor_direction += 1  # Incrementa la dirección
	if conveyor_direction > 4:
		conveyor_direction = 1  # Reinicia la dirección después de 4
