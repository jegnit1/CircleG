extends Node

# 노드 참조 캐싱
@onready var world: Node2D = $World
@onready var ui_layer: UILayer = $UILayer

# 게임 상태 변수
var current_round: int = 1
var current_gold: int = 0
var current_creeps: int = 0
var max_creeps: int = 100

# 초기화 및 테스트 환경 구성
func _ready() -> void:
	_init_game_state()
	_start_test_simulation()

# 게임 초기 상태 신호 방출
func _init_game_state() -> void:
	GlobalSignalBus.round_updated.emit(current_round)
	GlobalSignalBus.gold_updated.emit(current_gold)
	GlobalSignalBus.creep_count_updated.emit(current_creeps, max_creeps)

# UI 갱신 테스트용 타이머 생성 및 실행
func _start_test_simulation() -> void:
	var timer: Timer = Timer.new()
	timer.wait_time = 1.0
	timer.autostart = true
	timer.timeout.connect(_on_test_timer_timeout)
	add_child(timer)

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
