extends CharacterBody2D

# Переменная, указывающая, летит ли нож в данный момент
var is_flying = false 

# Скорость полета ножа 
var speed = 4500.0  

func _physics_process(delta : float):
	if is_flying:
		# Перемещаем нож вверх с заданной скоростью
		var collision = move_and_collide(speed * delta * Vector2.UP)  
		if collision:
			# Если произошло столкновение, обрабатываем его
			handle_collision(collision)  

# Начинаем полет ножа
func throw():
	is_flying = true  

func handle_collision(collision : KinematicCollision2D):
	var collider = collision.get_collider()
	if collider is Target:
		# Если столкнулись с целью, добавляем нож к цели
		add_knife_to_target(collider)  
		 # Прекращаем полет ножа
		is_flying = false 

func add_knife_to_target(target : Target):
	# Удаляем нож из родительского узла
	get_parent().remove_child(self)  
	# Позиционируем нож относительно цели
	global_position = Target.KNIFE_POSITION  
	# Сбрасываем вращение ножа
	rotation = 0  
	# Добавляем нож к цели с учетом ее вращения
	target.add_object_with_pivot(self, -target.rotation)  
