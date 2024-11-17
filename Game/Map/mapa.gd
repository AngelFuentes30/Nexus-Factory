extends Node2D

# Configuración del mapa
var anchura: int = 100  # Número de celdas en el eje X
var altura: int = 100   # Número de celdas en el eje Y

# Configuración de recursos
var minerales = {
	"Hierro": preload("res://Game/Map/Minerals/iron.tscn"),
	"Carbon": preload("res://Game/Map/Minerals/coal.tscn")
}

var terreno_base = preload("res://Game/Map/World/sand.tscn")  # Nodo de arena

# Parámetros de generación
var cantidad_clusters = {
	"Hierro": 10,  # Número de clústeres por tipo de mineral
	"Carbon": 10
}
var tamano_cluster = 40  # Número promedio de minerales por clúster
var radio_cluster = 5  # Radio de expansión del clúster (en celdas)
var tamano_celda: int = 32  # Tamaño visual de cada celda en píxeles

# Matriz de ocupación
var ocupacion: Array = []

func _ready():
	inicializar_ocupacion()
	generar_capa_base()
	generar_minerales()

# Inicializa la matriz de ocupación
func inicializar_ocupacion():
	ocupacion = []
	for x in range(anchura):
		ocupacion.append([])
		for y in range(altura):
			ocupacion[x].append(false)  # Marca todas las celdas como desocupadas

# Genera la capa base del terreno (arena)
func generar_capa_base():
	var contenedor_terreno = $Terreno  # Asegúrate de tener un nodo llamado "Terreno" en tu escena
	for x in range(anchura):
		for y in range(altura):
			var arena = terreno_base.instantiate()
			arena.position = Vector2(x * tamano_celda, y * tamano_celda)
			contenedor_terreno.add_child(arena)

# Genera minerales en clústeres
func generar_minerales():
	var contenedor_minerales = $Mineral  # Asegúrate de tener un nodo llamado "Mineral" en tu escena
	for tipo in minerales.keys():
		for i in range(cantidad_clusters[tipo]):  # Para cada clúster
			generar_cluster(tipo, contenedor_minerales)

# Genera un clúster de un tipo de mineral
func generar_cluster(tipo: String, contenedor: Node) -> void:
	var mineral_escena = minerales[tipo]
	var intentos = 0

	while intentos < 100:  # Encuentra un punto de inicio para el clúster
		var centro_x = randi() % anchura
		var centro_y = randi() % altura
		if not ocupacion[centro_x][centro_y]:  # Aseguramos que no haya nada en la posición inicial
			ocupar_celda(centro_x, centro_y, mineral_escena, contenedor)

			# Generar recursos alrededor del punto central
			for j in range(tamano_cluster):  # Generar minerales dentro del clúster
				var offset_x = int(randf_range(-radio_cluster, radio_cluster))
				var offset_y = int(randf_range(-radio_cluster, radio_cluster))
				var nuevo_x = centro_x + offset_x
				var nuevo_y = centro_y + offset_y

				if en_rango(nuevo_x, nuevo_y) and not ocupacion[nuevo_x][nuevo_y]:
					ocupar_celda(nuevo_x, nuevo_y, mineral_escena, contenedor)
			return
		intentos += 1
	print("No se pudo generar un clúster para el mineral:", tipo)

# Ocupa una celda con un mineral
func ocupar_celda(x: int, y: int, mineral_escena: PackedScene, contenedor: Node):
	ocupacion[x][y] = true  # Marca la celda como ocupada
	var mineral = mineral_escena.instantiate()
	mineral.position = Vector2(x * tamano_celda, y * tamano_celda)
	contenedor.add_child(mineral)

# Verifica si una celda está dentro del rango del mapa
func en_rango(x: int, y: int) -> bool:
	return x >= 0 and x < anchura and y >= 0 and y < altura
