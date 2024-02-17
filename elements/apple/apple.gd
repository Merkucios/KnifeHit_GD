extends Node2D

# Создаем переменную с именем is_hited (попали ли по яблоку) 
# и устанавливаем ее в значение "ложь" (False)
var is_hited = false

# Функция _on_area_2d_body_entered() срабатывает, 
# когда другой объект входит в область 2D (нож врезается в яблоко)
func _on_area_2d_body_entered(body):
	# Проверяем, если попали по объекту
	if not is_hited:
		# Устанавливаем is_hited в значение "правда" (True)
		is_hited = true
		# А затем освобождаем (удаляем) этот объект из игры (яблоко)
		queue_free()
