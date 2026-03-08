extends Node

# 노드 참조 캐싱
@onready var world: Node2D = $World
@onready var ui_layer: UILayer = $UILayer

# 게임 상태 변수
var current_round: int = 1
var current_gold: int = 300
var current_creeps: int = 0
var max_creeps: int = 100

# 초기화 및 테스트 환경 구성
func _ready() -> void:
	_init_game_state()
	# 🌟 [추가] 적이 죽었다는 신호를 귀 기울여 듣습니다.
	GlobalSignalBus.enemy_killed.connect(_on_enemy_killed)

# 게임 초기 상태 신호 방출
func _init_game_state() -> void:
	GlobalSignalBus.round_updated.emit(current_round)
	GlobalSignalBus.gold_updated.emit(current_gold)
	GlobalSignalBus.creep_count_updated.emit(current_creeps, max_creeps)


# 1초마다 자원 및 적 개체 수 증가 시뮬레이션
func _on_test_timer_timeout() -> void:
	current_gold += 15
	current_creeps += 5
	
	if current_creeps >= max_creeps:
		current_creeps = max_creeps
		# 실제 게임에서는 여기서 Game Over 로직 호출
		
	GlobalSignalBus.gold_updated.emit(current_gold)
	GlobalSignalBus.creep_count_updated.emit(current_creeps, max_creeps)
	
	# 10초(50마리)마다 라운드 증가
	if current_creeps % 50 == 0 and current_creeps < max_creeps:
		current_round += 1
		GlobalSignalBus.round_updated.emit(current_round)
		
# 🌟 [추가] 골드 사용(차감) 함수
# 돈이 충분해서 결제에 성공하면 true, 돈이 모자라면 false를 반환합니다.
func use_gold(amount: int) -> bool:
	if current_gold >= amount:
		current_gold -= amount
		# 돈이 깎였으니 상단 UI(골드 라벨)의 숫자도 즉시 업데이트 하라고 신호를 보냅니다!
		GlobalSignalBus.gold_updated.emit(current_gold) 
		return true
	else:
		return false
		
# 🌟 [추가] 돈이 떨어졌다는 신호를 받으면 실행되는 함수
func _on_enemy_killed(reward: int) -> void:
	current_gold += reward # 내 지갑에 돈을 추가!
	
	# UI한테 "내 지갑에 돈 바뀌었으니까 글자 업데이트 해!" 라고 알려줌
	GlobalSignalBus.gold_updated.emit(current_gold)
