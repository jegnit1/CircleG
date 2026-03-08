extends Area2D
class_name Creep

var center_position: Vector2 = Vector2.ZERO
var radius: float = 300.0
var speed: float = 1.0 # CSV의 CREEP_SPEED 적용
var current_angle: float = -PI / 2.0 # 무조건 -90도(12시) 방향에서 시작

var max_hp: float = 10.0
var current_hp: float = 10.0 # CSV의 CREEP_HP 적용

func _ready() -> void:
	add_to_group("creeps") # 매니저가 개수를 세기 쉽도록 그룹에 등록

func _process(delta: float) -> void:
	# 속도에 따라 각도 감소 (반시계 방향 회전)
	current_angle -= speed * delta 
	
	# 삼각함수를 이용해 궤도 위치 계산
	position = center_position + Vector2(
		cos(current_angle) * radius,
		sin(current_angle) * radius
	)

# 추후 스킬 시스템에서 호출할 데미지 함수
func take_damage(amount: float) -> void:
	current_hp -= amount
	if current_hp <= 0:
		die()

func die() -> void:
	# TODO: 골드 및 경험치 획득 로직
	queue_free()
