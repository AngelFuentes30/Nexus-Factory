extends Node2D

# Configuración del mapa
var anchura: int = 100  # Número de celdas en el eje X
var altura: int = 100   # Número de celdas en el eje Y

# Configuración de recursos
var minerales = {
	"Hierro": preload("res://Game/Map/Minerals/iron.tscn"),
	"Carbon": preload("res://Game/Map/Minerals/coal.tscn"),
	"Cobre": preload("res://Game/Map/Minerals/copper.tscn"),
	"Cuarso": preload("res://Game/Map/Minerals/cuarso.tscn"),
	"Gold": preload("res://Game/Map/Minerals/gold.tscn"),
	"Piedra": preload("res://Game/Map/Minerals/stone.tscn")
}

var terreno_base = preload("res://Game/Map/World/sand.tscn")  # Nodo de arena
var water = preload("res://Game/Map/World/water.tscn")  # Nodo de agua
var arbol = preload("res://Game/Map/World/tree_desert.tscn")  # Nodo del árbol

# Parámetros de generación
var cantidad_clusters = {
	"Hierro": 10,  # Número de clústeres por tipo de mineral
	"Carbon": 10,
	"Cobre": 10,
	"Cuarso": 2,
	"Gold": 3,
	"Piedra": 4
}
var tamano_cluster = 40  # Número promedio de minerales por clúster
var radio_cluster = 5  # Radio de expansión del clúster (en celdas)
var tamano_celda: int = 32  # Tamaño en píxeles de cada celda

var cantidad_lagos = 10  # Número de lagos a generar
var tamano_lago_min = 10  # Tamaño mínimo del lago (número de celdas)
var tamano_lago_max = 50  # Tamaño máximo del lago (número de celdas)

var cantidad_arboles = 300  # Número de árboles a generar
var tamano_area_arbol = 3  # Tamaño del área para la generación de árboles (ej. 3x3 alrededor de cada árbol)

# Matriz de ocupación
var ocupacion: Array = []

func _ready():
	inicializar_ocupacion()
	generar_capa_base()
	generar_lagos()
	generar_minerales()
	generar_arboles()

# Inicializa la matriz de ocupación
func inicializar_ocupacion():
	ocupacion = []
	for x in range(anchura):
		ocupacion.append([]) 
		for y in range(altura):
			ocupacion[x].append(false)  # Marca todas las celdas como desocupadas

# Genera la capa base del terreno (arena)
func generar_capa_base():
	if not $Terreno:
		print("Nodo 'Terreno' no encontrado.")
		return
	
	var contenedor_terreno = $Terreno
	for x in range(anchura):
		for y in range(altura):
			var arena = terreno_base.instantiate()
			arena.position = Vector2(x * tamano_celda, y * tamano_celda)
			contenedor_terreno.add_child(arena)

# Genera los lagos en el mapa
func generar_lagos():
	if not $Water:
		print("Nodo 'Water' no encontrado.")
		return

	var contenedor_water = $Water
	print("Generando lagos...")

	for i in range(cantidad_lagos):
		# Elegir un punto inicial para el lago
		var centro_x = randi() % anchura
		var centro_y = randi() % altura
		var tamano_lago = int(randf_range(tamano_lago_min, tamano_lago_max))
		print("Generando lago", i, "en", centro_x, centro_y, "con tamaño", tamano_lago)

		# Lista de celdas a procesar, comenzando desde el centro
		var celdas_pendientes = [Vector2(centro_x, centro_y)]
		var generados = 0

		while celdas_pendientes.size() > 0 and generados < tamano_lago:
			var celda = celdas_pendientes.pop_front()
			var x = int(celda.x)
			var y = int(celda.y)

			# Verificar si la celda es válida
			if en_rango(x, y) and not ocupacion[x][y]:
				ocupar_celda(x, y, water, contenedor_water)
				generados += 1

				# Agregar las celdas vecinas a la lista
				for vecino in [
					Vector2(x + 1, y), Vector2(x - 1, y),  # Horizontal
					Vector2(x, y + 1), Vector2(x, y - 1)   # Vertical
				]:
					if en_rango(int(vecino.x), int(vecino.y)) and not ocupacion[int(vecino.x)][int(vecino.y)]:
						celdas_pendientes.append(vecino)

		if generados < tamano_lago:
			print("El lago", i, "no pudo alcanzar el tamaño completo. Generados:", generados)
		else:
			print("Lago", i, "generado con éxito con tamaño", generados)

# Genera minerales en clústeres
func generar_minerales():
	var contenedor_minerales = $Mineral  # Nodo contenedor para los minerales
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
		if not ocupacion[centro_x][centro_y]:  # Asegura que no haya nada en la posición inicial
			ocupar_celda(centro_x, centro_y, mineral_escena, contenedor)

			# Generar recursos alrededor del punto central
			for j in range(tamano_cluster):
				var offset_x = int(randf_range(-radio_cluster, radio_cluster))
				var offset_y = int(randf_range(-radio_cluster, radio_cluster))
				var nuevo_x = centro_x + offset_x
				var nuevo_y = centro_y + offset_y

				if en_rango(nuevo_x, nuevo_y) and not ocupacion[nuevo_x][nuevo_y]:
					ocupar_celda(nuevo_x, nuevo_y, mineral_escena, contenedor)
			return
		intentos += 1
	print("No se pudo generar un clúster para el mineral:", tipo)

# Genera árboles en el mapa
func generar_arboles():
	var contenedor_arboles = $Tree_Desert  # Nodo contenedor para los árboles
	print("Generando árboles...")

	for i in range(cantidad_arboles):
		# Elegir un punto inicial para el árbol
		var centro_x = randi() % anchura
		var centro_y = randi() % altura
		print("Generando árbol", i, "en", centro_x, centro_y)

		# Verificar si el lugar es válido para poner un árbol
		if es_area_valida_para_arbol(centro_x, centro_y):
			# Ocupa la celda con el árbol
			ocupar_celda(centro_x, centro_y, arbol, contenedor_arboles)
		else:
			print("No se pudo colocar el árbol en", centro_x, centro_y)  # Si no es válido, no se coloca

# Función que verifica si un área es válida para poner un árbol (no puede estar en agua ni en minerales)
func es_area_valida_para_arbol(x: int, y: int) -> bool:
	# Verificar si la celda central está libre y no tiene agua ni mineral
	if ocupacion[x][y]:
		return false

	# Verificar las celdas alrededor para asegurarse de que no haya agua ni minerales
	for offset_x in range(-tamano_area_arbol, tamano_area_arbol + 1):
		for offset_y in range(-tamano_area_arbol, tamano_area_arbol + 1):
			var nuevo_x = x + offset_x
			var nuevo_y = y + offset_y

			# Verificar si la celda está dentro del rango
			if en_rango(nuevo_x, nuevo_y):
				# Verificar si la celda ya está ocupada por agua o mineral
				if ocupacion[nuevo_x][nuevo_y]:
					return false

	# Si pasó todas las comprobaciones, es un lugar válido
	return true

# Ocupa una celda con un nodo (mineral o agua)
func ocupar_celda(x: int, y: int, nodo_escena: PackedScene, contenedor: Node):
	ocupacion[x][y] = true  # Marca la celda como ocupada
	var nodo = nodo_escena.instantiate()
	nodo.position = Vector2(x * tamano_celda, y * tamano_celda)
	contenedor.add_child(nodo)

# Verifica si una celda está dentro del rango del mapa
func en_rango(x: int, y: int) -> bool:
	return x >= 0 and x < anchura and y >= 0 and y < altura
