extends Node
class_name StageManager

@export var creep_scene: PackedScene
@onready var center_tower: Marker2D = $"../World/Tower"
@onready var creep_container: Node2D = $"../World/CreepContainer"

var current_stage: int = 1
var max_creeps_allowed: int = 100

# 현재 라운드 진행 정보
var stage_timer: float = 0.0
var creeps_to_spawn: int = 0
var creeps_spawned_this_stage: int = 0
var spawn_timer: float = 0.0
var spawn_interval: float = 1.0

# 현재 라운드의 적 스탯 캐싱 (CSV 기반)
var current_hp: float = 10.0
var current_speed: float = 1.0

func _ready() -> void:
	_start_stage(current_stage)
	
var last_active_creeps: int = -1 # 이전 프레임의 크립 수를 기억할 변수

func _process(delta: float) -> void:
	# 1. 패배 조건 (100마리 초과) 검사
	var active_creeps: int = get_tree().get_nodes_in_group("creeps").size()
	
	# 실시간 크립 수를 UI로 보냄
	if active_creeps != last_active_creeps:
		GlobalSignalBus.creep_count_updated.emit(active_creeps, max_creeps_allowed)
		last_active_creeps = active_creeps # 기억해둠
	
	if active_creeps > max_creeps_allowed:
		_game_over()
		return
		
	# 2. 라운드 타이머 (30초가 지나면 자동 다음 라운드 시작)
	stage_timer -= delta
	if stage_timer <= 0:
		current_stage += 1
		_start_stage(current_stage)
		
	# 3. 크립 스폰 (30초 동안 30마리라면 1초 간격으로 스폰)
	if creeps_spawned_this_stage < creeps_to_spawn:
		spawn_timer -= delta
		if spawn_timer <= 0:
			_spawn_creep()
			creeps_spawned_this_stage += 1
			spawn_timer = spawn_interval

func _start_stage(stage: int) -> void:
	# 변경된 웨이브(라운드) 정보를 UI로 보냄
	GlobalSignalBus.round_updated.emit(stage)
	
	var stage_data: Dictionary = DataManager.get_stage_data(stage)
	
	# CSV에 더 이상 데이터가 없으면 (100라운드를 넘기면)
	if stage_data.is_empty():
		print("🎉 100 라운드 클리어! GAME CLEAR!")
		set_process(false)
		return
		
	print("===============================")
	print("⚔️ 라운드 %d 시작!" % stage)
	
	# CSV에서 이번 라운드 수치 파싱
	var duration: float = float(stage_data.get("DURATION", "30"))
	creeps_to_spawn = int(stage_data.get("SPAWN_COUNT", "0"))
	current_hp = float(stage_data.get("CREEP_HP", "10"))
	current_speed = float(stage_data.get("CREEP_SPEED", "1.0"))
	
	# 보스 등장 여부 확인 (엑셀의 IS_BOSS 컬럼)
	var is_boss: String = stage_data.get("IS_BOSS", "FALSE").to_upper()
	if is_boss == "TRUE":
		var boss_id: String = stage_data.get("BOSS_ID", "")
		print("🚨 경고: 보스 등장 라운드입니다! [보스ID: %s]" % boss_id)
		# TODO: 추후 일반 크립 대신 / 혹은 일반 크립과 함께 보스 스폰 로직 추가
	
	# 타이머 및 스폰 카운터 초기화
	creeps_spawned_this_stage = 0
	stage_timer = duration
	
	# 지정된 시간(DURATION) 동안 마리수(SPAWN_COUNT)가 균등하게 나오도록 간격(Interval) 계산
	if creeps_to_spawn > 0:
		spawn_interval = duration / float(creeps_to_spawn)

func _spawn_creep() -> void:
	if creep_scene == null: return
	
	var creep: Creep = creep_scene.instantiate() as Creep
	
	# 12시 스폰 기준점 (타워 위치)
	creep.center_position = center_tower.global_position
	# 적들이 완벽히 겹치지 않도록 궤도 반경을 약간 랜덤으로 줍니다 (285 ~ 315)
	creep.radius = 250
	
	# CSV 기반 스탯 적용! (라운드가 오를수록 체력과 속도가 적용됨)
	creep.max_hp = current_hp
	creep.current_hp = current_hp
	creep.speed = current_speed
	
	creep_container.add_child(creep)

func _game_over() -> void:
	set_process(false)
	print("❌ 크립이 %d마리를 초과했습니다! GAME OVER!" % max_creeps_allowed)
