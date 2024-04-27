extends Node2D

# Предварительная загрузка сцены ножа
var knife_scene = preload("res://elements/knife/knife.tscn")  
var is_enabled = true
# Ссылка на узел ножа
@onready var knife = $Knife 
# Ссылка на узел таймера
@onready var timer = $Timer  

func create_new_knife():
	# Создаем новый нож из предзагруженной сцены
	knife = knife_scene.instantiate()  
	# Добавляем нож в качестве дочернего узла
	add_child(knife)  

func _input(event : InputEvent):
	if is_enabled and event is InputEventScreenTouch and event.is_pressed() and timer.time_left <= 0:
		# Если произошло касание экрана и таймер истек, бросаем нож
		knife.throw()  
		# Запускаем таймер
		timer.start()  

func _on_timer_timeout():
	# При истечении времени таймера создаем новый нож
	create_new_knife()  


