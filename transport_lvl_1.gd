extends Area2D

var move_speed: float = 50.0  # Velocidad de movimiento de la cinta
var animated_sprite: AnimatedSprite2D
var direction: int  # Dirección actual basada en el generador
var bodies_on_belt = []  # Almacena los cuerpos que están en la cinta

func _ready() -> void:
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)
	animated_sprite = $Animated_Transport_lvl1/AnimatedSprite2D
	update_animation()

# Función para actualizar la animación y la dirección según la variable de dirección
func update_animation() -> void:
	match direction:
		1:  # Arriba
			animated_sprite.play("Rect_Up")
		2:  # Abajo
			animated_sprite.play("Rect_Down")
		3:  # Derecha
			animated_sprite.play("Rect_Right")
		4:  # Izquierda
			animated_sprite.play("Rect_Left")

# Función que se llama cuando un cuerpo entra en la cinta
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Transportable") and not bodies_on_belt.has(body):  
		bodies_on_belt.append(body)  # Agrega el cuerpo a la lista
		update_body_velocity(body)  # Actualiza la velocidad del cuerpo al entrar

# Función que se llama cuando un cuerpo sale de la cinta
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Transportable") and bodies_on_belt.has(body):  
		bodies_on_belt.erase(body)  # Elimina el cuerpo de la lista
		reset_body_velocity(body)  # Restablece la velocidad del cuerpo al salir

# Función para actualizar la velocidad del cuerpo según la dirección de la cinta
func update_body_velocity(body: Node) -> void:
	if body.has_method("set_move_speed"):
		var new_velocity = get_direction_vector(direction) * move_speed

		# Verifica si hay otras cintas moviendo al cuerpo
		var current_velocity = body.velocity
		if current_velocity == Vector2.ZERO or current_velocity == new_velocity:
			body.set_move_speed(move_speed)  # Asigna la velocidad de la cinta al objeto
			body.velocity = new_velocity  # Ajusta la velocidad del cuerpo

# Función para restablecer la velocidad al salir de la cinta
func reset_body_velocity(body: Node) -> void:
	if body.has_method("set_move_speed"):
		body.set_move_speed(0)  # Detener el movimiento al salir

# Función para obtener el vector de dirección
func get_direction_vector(dir: int) -> Vector2:
	match dir:
		1: return Vector2.UP
		2: return Vector2.DOWN
		3: return Vector2.RIGHT
		4: return Vector2.LEFT
	return Vector2.ZERO

# Función para actualizar el movimiento de los cuerpos en la cinta
func _process(delta: float) -> void:
	for body in bodies_on_belt:
		if body is CharacterBody2D:
			body.velocity = get_direction_vector(direction) * move_speed  # Mover el cuerpo en la dirección de la cinta
			body.move_and_slide()  # Actualiza la posición del cuerpo
