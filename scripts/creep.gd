extends Area2D
class_name Creep

var center_position: Vector2 = Vector2.ZERO
var radius: float = 300.0
var speed: float = 1.0 # CSV의 CREEP_SPEED 적용
var current_angle: float = -PI / 2.0 # 무조건 -90도(12시) 방향에서 시작

var max_hp: float = 10.0
var current_hp: float = 10.0 # CSV의 CREEP_HP 적용
var gold_reward: int = 15 # 이 녀석을 잡으면 주는 골드량!

func _ready() -> void:
	current_hp = max_hp
	add_to_group("creeps") # 매니저가 개수를 세기 쉽도록 그룹에 등록

func _process(delta: float) -> void:
	# 속도에 따라 각도 감소 (반시계 방향 회전)
	current_angle -= speed * delta 
	
	# 삼각함수를 이용해 궤도 위치 계산
	global_position = center_position + Vector2(
		cos(current_angle) * radius,
		sin(current_angle) * radius
	)

# 추후 스킬 시스템에서 호출할 데미지 함수
func take_damage(damage_amount: float) -> void:
	current_hp -= damage_amount
	
	# 🌟 [이펙트 1] 피격 시 빨갛게 번쩍!
	modulate = Color.RED # 내 색깔을 즉시 빨간색으로 변경
	
	# Tween(트윈)을 생성해서 0.15초 동안 서서히 원래 색(WHITE)으로 돌아오게 합니다.
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.15)
	
	_show_damage_text(damage_amount)
	
	if current_hp <= 0:
		_die()
		
# 🌟 [수정됨] 통통 튀는 데미지 숫자 생성 함수
func _show_damage_text(amount: float) -> void:
	var label = Label.new()
	label.text = str(amount) 
	
	# 🎨 1. 글자 크기를 24 -> 14로 대폭 줄이고 테두리도 얇게 수정했습니다.
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color.YELLOW)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 3)
	
	# 📍 글자가 작아졌으니 시작 위치도 머리 바로 위쪽으로 살짝 내렸습니다.
	label.global_position = global_position + Vector2(-10, -15)
	label.z_index = 100 
	
	get_tree().current_scene.add_child(label)
	
	# 🌟 [수정할 부분!] 🌟
	# 그냥 create_tween()을 쓰면 몬스터에 묶입니다.
	# label.create_tween() 이라고 써서, 이 애니메이션의 주인을 라벨로 바꿔주세요!
	var text_tween = label.create_tween()
	
	# 1. 두 애니메이션(이동, 투명화)을 동시에 실행
	text_tween.set_parallel(true) 
	text_tween.tween_property(label, "global_position:y", label.global_position.y - 30, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	text_tween.tween_property(label, "modulate:a", 0.0, 0.5)
	
	# 이제 몬스터가 죽든 말든 라벨이 끝까지 애니메이션을 재생하고 스스로를 지웁니다!
	text_tween.finished.connect(label.queue_free)

func _die() -> void:
	print("💀 [%s] 처치 됨!" % name)
	GlobalSignalBus.enemy_killed.emit(gold_reward)
	# [보너스] 죽을 때 골드를 주거나 하는 로직을 나중에 여기에 추가할 수 있습니다!
	
	# queue_free()는 고도 엔진에서 "이 노드를 화면과 메모리에서 완전히 삭제해라!" 라는 아주 중요한 기본 함수입니다.
	queue_free()
