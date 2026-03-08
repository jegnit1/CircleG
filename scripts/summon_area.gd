# scripts/summoned_area.gd
class_name SummonedArea
extends Node2D

var damage: float = 0.0
var radius: float = 120.0
var duration: float = 5.0      # 유지 시간 (예: 5초 동안 바닥에 남음)
var tick_interval: float = 1.0 # 틱 데미지 간격 (예: 1초마다 데미지)
var element: String = "POISON"

var _life_timer: float = 0.0
var _tick_timer: float = 0.0

func _ready() -> void:
	z_index = -1 # 크립들 발 밑에 깔리게 설정
	_create_visual()

func _process(delta: float) -> void:
	# 1. 수명 타이머: N초가 지나면 스스로 증발합니다.
	_life_timer += delta
	if _life_timer >= duration:
		queue_free() 
		return

	# 2. 틱(Tick) 타이머: 장판 위에 있는 적들에게 N초마다 데미지를 줍니다.
	_tick_timer += delta
	if _tick_timer >= tick_interval:
		_tick_timer = 0.0 # 타이머 초기화
		_deal_damage()

# 🌟 범위 안의 적들에게 데미지를 뿌리는 함수
func _deal_damage() -> void:
	var creeps = get_tree().get_nodes_in_group("creeps")
	for creep in creeps:
		# 에러 방지를 위해 크립이 살아있는지 확인하고 거리를 잽니다.
		if is_instance_valid(creep) and global_position.distance_to(creep.global_position) <= radius:
			if creep.has_method("take_damage"):
				creep.take_damage(damage)

# 🎨 바닥에 깔리는 반투명 원 그리기
func _create_visual() -> void:
	var aoe_visual = Polygon2D.new()
	if element == "ICE":
		aoe_visual.color = Color(0.2, 0.8, 1.0, 0.5)
	elif element == "FIRE":
		aoe_visual.color = Color(1.0, 0.3, 0.1, 0.5)
	else:
		aoe_visual.color = Color(0.3, 0.9, 0.3, 0.5) # 독구름
		
	var points: PackedVector2Array = []
	for i in range(32):
		var angle = i * (PI * 2.0 / 32.0)
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	aoe_visual.polygon = points
	add_child(aoe_visual)
