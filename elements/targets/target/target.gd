extends CharacterBody2D
class_name Target

# Ограничение на количество попыток генерации 
const GENERATION_LIMIT = 10

# Позиция, куда будет прикреплен нож к цели
const KNIFE_POSITION = Vector2(0, 180)  

# Позиция, куда будет прикреплено яблоко к цели
const APPLE_POSITION = Vector2(0, 176)
# Маржа для размещения объектов вокруг цели
const OBJECT_MARGIN = PI / 6

const EXPLOSION_TIME = 1.0

# Сцена для ножа и яблока
var knife_scene : PackedScene = load("res://elements/knife/knife.tscn")
var apple_scene : PackedScene = load("res://elements/apple/apple.tscn")

# Скорость вращения цели
var speed = PI  

# Ссылка на контейнер объектов в цели
@onready var items_container = $ItemsContainer  
@onready var sprite = $Sprite2D
@onready var knife_particles = $KnifeParticles2D
@onready var particles_target_parts = [
	$TargetParticles2D,
	$TargetParticles2D2,
	$TargetParticles2D3
]

func _ready():
	# Добавление объектов по умолчанию при инициализации сцены
	add_default_items(1, 4)
	await get_tree().create_timer(1).timeout 
	explode()

func _physics_process(delta : float):
	# Поворот цели с заданной скоростью
	rotation += speed * delta  

func explode():
	sprite.hide()
	items_container.hide()
	
	var tween = create_tween()
	
	for target_particles_part in particles_target_parts:
		tween.parallel().tween_property(target_particles_part, "modulate", Color("ffffff00"), EXPLOSION_TIME)
		target_particles_part.emitting = true
		
	knife_particles.rotation = -rotation
	knife_particles.emitting = true
	tween.parallel().tween_property(knife_particles, "modulate", Color("ffffff00"), EXPLOSION_TIME)
	tween.play()

func add_object_with_pivot(object : Node2D, object_rotation : float):
	# Создание узла-поворота для прикрепления объекта
	var pivot = Node2D.new()  
	# Установка поворота для узла-поворота
	pivot.rotation = object_rotation  
	# Добавление объекта к узлу-повороту
	pivot.add_child(object)  
	# Добавление узла-поворота в контейнер объектов цели
	items_container.add_child(pivot)  

func add_default_items(knives : int , apples : int):
	var occupied_rotations = []
	for i in range(knives):
		# Генерация свободного случайного поворота для ножа
		var pivot_rotation = get_free_random_rotation(occupied_rotations)
		if pivot_rotation == null:
			return
		occupied_rotations.append(pivot_rotation)
		# Создание экземпляра сцены ножа и его позиционирование
		var knife = knife_scene.instantiate()
		knife.position = KNIFE_POSITION
		# Прикрепление ножа к цели с сгенерированным поворотом
		add_object_with_pivot(knife, pivot_rotation)
		
	for i in range(apples):
		# Генерация свободного случайного поворота для яблока
		var pivot_rotation = get_free_random_rotation(occupied_rotations)
		if pivot_rotation == null:
			return
		occupied_rotations.append(pivot_rotation)
		# Создание экземпляра сцены яблока и его позиционирование
		var apple = apple_scene.instantiate()
		apple.position = APPLE_POSITION
		# Прикрепление яблока к цели с сгенерированным поворотом
		add_object_with_pivot(apple, pivot_rotation)

func get_free_random_rotation(occupied_rotations : Array, generation_attempts = 0):
	if generation_attempts >= GENERATION_LIMIT:
		return null
	
	# Генерация случайного поворота в диапазоне от 0 до 2 * PI
	var random_rotation = Globals.rng.randf_range(0, PI * 2)
	
	for occupied in occupied_rotations:
		# Проверка на конфликт существующих занятых объектов
		if random_rotation <= occupied + OBJECT_MARGIN / 2.0 and random_rotation >= occupied - OBJECT_MARGIN / 2.0:
			# Если конфликт существует, рекурсивная попытка снова сгенерировать поворот
			return get_free_random_rotation(occupied_rotations, generation_attempts + 1)
	
	# Если конфликт не существует, возвращается сгенерированный поворот
	return random_rotation 
