extends Area2D

# Velocidad de movimiento hacia la izquierda
var move_speed: float = 100.0

# Almacena los cuerpos que están en la cinta
var bodies_on_belt = []

# Función que se llama cuando el nodo entra en la escena
func _ready() -> void:
	# Conectar las señales de colisión correctamente
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)

# Función que se llama cuando un cuerpo entra en el área de colisión
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D or body is RigidBody2D:
		bodies_on_belt.append(body)  # Agregar el cuerpo a la lista

# Función que se llama cuando un cuerpo sale del área de colisión
func _on_body_exited(body: Node) -> void:
	bodies_on_belt.erase(body)  # Eliminar el cuerpo de la lista

# Actualizar el movimiento de los cuerpos sobre la cinta en cada frame
func _process(_delta: float) -> void:
	for body in bodies_on_belt:
		if body is CharacterBody2D:
			body.velocity.x = -move_speed  # Mover hacia la izquierda
			body.move_and_slide()  # Aplicar el movimiento
		elif body is RigidBody2D:
			body.apply_impulse(Vector2(-move_speed, 0))  # Aplicar fuerza si es RigidBody2D
