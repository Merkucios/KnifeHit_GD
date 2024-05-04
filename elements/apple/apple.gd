extends Node2D

const EXPLOSION_TIME = 1.0

# Создаем переменную с именем is_hited (попали ли по яблоку) 
# и устанавливаем ее в значение "ложь" (False)
var is_hited = false

@onready var sprite = $Sprite2D

@onready var particles = [
	$AppleParticles2D,
	$AppleParticles2D2
]


# Функция _on_area_2d_body_entered() срабатывает, 
# когда другой объект входит в область 2D (нож врезается в яблоко)
func _on_area_2d_body_entered(body):
	# Проверяем, если попали по объекту
	if not is_hited:
		# Устанавливаем is_hited в значение "правда" (True)
		is_hited = true
		Globals.add_apples(1)
		sprite.hide()
		var tween = create_tween()
		
		for particle in particles:
			particle.emitting = true
			tween.parallel().tween_property(particle, "modulate", Color("ffffff00"), EXPLOSION_TIME)
			
		tween.play()
		await tween.finished
		# А затем освобождаем (удаляем) этот объект из игры (яблоко)
		queue_free()
