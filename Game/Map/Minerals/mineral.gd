extends Node2D

# Variables comunes para todos los minerales
@export var cantidad: int = 1000  # Cantidad de recurso disponible
@export var tipo: String = "generic"  # Tipo de mineral

func extraer(cantidad_a_extraer: int) -> int:
	var extraido = min(cantidad, cantidad_a_extraer)
	cantidad -= extraido
	if cantidad <= 0:
		queue_free()  # Eliminar el mineral si se agota
	return extraido

func _ready():
	print("Mineral creado: %s con cantidad: %d" % [tipo, cantidad])
