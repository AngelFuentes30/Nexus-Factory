extends Area2D

var move_speed: float = 50.0  # Velocidad de movimiento de la cinta
var bodies_on_belt = []  # Almacena los cuerpos que están en la cinta

func _ready() -> void:
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)

# Función que se llama cuando un cuerpo entra en la cinta
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Transportable"):
		bodies_on_belt.append(body)
		if body.has_method("set_move_speed"):
			body.set_move_speed(move_speed)  # Asignar la velocidad de la cinta a la mena

# Función que se llama cuando un cuerpo sale de la cinta
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Transportable"):
		bodies_on_belt.erase(body)
		if body.has_method("set_move_speed"):
			body.set_move_speed(0)  # Detener el movimiento de la mena al salir de la cinta

# Función para actualizar el movimiento del jugador sobre la cinta
func _process(delta: float) -> void:
	for body in bodies_on_belt:
		if body is CharacterBody2D:
			body.velocity = Vector2(0, -move_speed)  # Ajusta la dirección según la cinta
			body.move_and_slide()
