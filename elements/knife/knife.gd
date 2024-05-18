extends CharacterBody2D

enum State {
	IDLE, # Начальное состояние
	FLY_TO_TARGET, # Полет к цели
	FLY_AWAY # Улет от цели
}

# Изначальное состояние
var state = State.IDLE

# Скорость полета ножа 
var speed = 4500.0  

@onready var sprite = $Sprite2D

# Вектор отбрасывания ножа 
var fly_away_direction = Vector2.DOWN
# Скорость полета отброшенного ножа 
var fly_away_speed = 1000.0
# Скорость вращения отброшенного ножа 
var fly_away_rotation_speed = 1500.0
# Отклонение отброшенного ножа
var fly_away_deviation = PI / 8.0

func _ready():
	sprite.texture = Globals.KNIFE_TEXTURES[Globals.active_knife_index]

func _physics_process(delta : float):
	match state:
		State.FLY_TO_TARGET:
			# Перемещаем нож вверх с заданной скоростью
			var collision = move_and_collide(speed * delta * Vector2.UP)  
			if collision:
			# Если произошло столкновение, обрабатываем его
				handle_collision(collision)  
		State.FLY_AWAY:
			global_position += fly_away_direction * fly_away_speed * delta
			rotation += fly_away_rotation_speed * delta
			return

# Изменяем состояние ножа
func change_state(new_state : State):
	state = new_state

# Начинаем полет ножа
func throw():
	change_state(State.FLY_TO_TARGET) 
	
# Отбрасывание ножа при попадании в другой нож
func throw_away(direction : Vector2):
	var direction_deviation = Globals.rng.randf_range(-fly_away_deviation, fly_away_deviation)
	fly_away_direction = direction.rotated(direction_deviation)
	change_state(State.FLY_AWAY) 

func handle_collision(collision : KinematicCollision2D):
	var collider = collision.get_collider()
	if collider is Target:
		# Если столкнулись с целью, добавляем нож к цели
		add_knife_to_target(collider)  
		 # Прекращаем полет ножа
		change_state(State.IDLE)
		collider.take_damage()
		Globals.add_point()
	else:
		throw_away(collision.get_normal())
		Events.game_over.emit()

func add_knife_to_target(target : Target):
	# Удаляем нож из родительского узла
	get_parent().remove_child(self)  
	# Позиционируем нож относительно цели
	global_position = Target.KNIFE_POSITION  
	# Сбрасываем вращение ножа
	rotation = 0  
	# Добавляем нож к цели с учетом ее вращения
	target.add_object_with_pivot(self, -target.rotation)  
