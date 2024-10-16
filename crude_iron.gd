extends Area2D

var base_speed: float = 0.0  # Velocidad base de la mena
var speed: float = 0.0  # Velocidad actual de la mena
var on_belt_count: int = 0  # Contador de cintas en las que está la mena

func _ready() -> void:
	add_to_group("Transportable")  # Asegúrate de que el nodo esté en el grupo "Transportable"

# Función que se llama cuando entra en una cinta
func on_belt_enter(cinta):
	on_belt_count += 1
	speed += cinta.move_speed * 0.5  # Aumenta la velocidad solo si está sobre una cinta

# Función que se llama cuando sale de una cinta
func on_belt_exit(cinta):
	on_belt_count = max(on_belt_count - 1, 0)
	if on_belt_count == 0:
		speed = base_speed  # Restablece la velocidad base cuando no hay cintas

# Función que se llama en cada frame para mover la mena si tiene velocidad
func _process(delta: float) -> void:
	if speed != 0:
		position += Vector2(0, -speed) * delta  # Ajusta la dirección según la orientación de la cinta
