extends CanvasLayer
class_name UILayer

# 노드 참조 캐싱 (트리 구조 변경 시 경로 수정 필요)
@onready var wave_label: Label = $MainVBox/TopSection/CombatArea/TopHUD/HBox/WaveLabel
@onready var enemy_count_label: Label = $MainVBox/TopSection/CombatArea/TopHUD/HBox/EnemyCountLabel
@onready var gold_label: Label = $MainVBox/BottomBar/MarginContainer/HBox/GoldLabel
@onready var btn_next_wave: Button = $MainVBox/BottomBar/MarginContainer/HBox/BtnNextWave
@onready var consumables_box: HBoxContainer = $MainVBox/BottomBar/MarginContainer/HBox/ConsumablesBox

@onready var active_grid: GridContainer = $MainVBox/TopSection/RightPanel/MenuTabs/Skills/VBox/ActiveGrid
@onready var passive_grid: GridContainer = $MainVBox/TopSection/RightPanel/MenuTabs/Skills/VBox/PassiveGrid
@onready var equip_box: HBoxContainer = $MainVBox/TopSection/RightPanel/MenuTabs/Equipments/VBox/EquipBox
@onready var artifact_box: GridContainer = $MainVBox/TopSection/RightPanel/MenuTabs/Equipments/VBox/ArtifactBox

@onready var btn_draw_skill: Button = $MainVBox/TopSection/RightPanel/MenuTabs/Shop/BtnDrawSkill
@onready var btn_draw_equip: Button = $MainVBox/TopSection/RightPanel/MenuTabs/Shop/BtnDrawEquip
@onready var btn_summon_boss: Button = $MainVBox/TopSection/RightPanel/MenuTabs/Shop/BtnSummonBoss

# 슬롯 씬 메모리 로드
const SLOT_SCENE: PackedScene = preload("res://scenes/ui_slot.tscn")

# 객체 초기화 및 이벤트 바인딩
func _ready() -> void:
	_init_all_slots()
	_connect_global_signals()
	_connect_buttons()

# 슬롯 수량 규격에 따른 동적 생성
func _init_all_slots() -> void:
	_create_slots(active_grid, "active", 7)
	_create_slots(passive_grid, "passive", 7)
	_create_slots(equip_box, "equip", 3)
	_create_slots(artifact_box, "artifact", 5)
	_create_slots(consumables_box, "consumable", 2)

# 단일 슬롯 인스턴스화 및 컨테이너 부착
func _create_slots(container: Control, slot_type: String, count: int) -> void:
	for i in range(count):
		var slot_instance: UISlot = SLOT_SCENE.instantiate() as UISlot
		container.add_child(slot_instance)
		slot_instance.initialize(slot_type, i)

# 전역 상태 갱신 신호 연결
func _connect_global_signals() -> void:
	GlobalSignalBus.gold_updated.connect(_on_gold_updated)
	GlobalSignalBus.creep_count_updated.connect(_on_creep_count_updated)
	GlobalSignalBus.round_updated.connect(_on_round_updated)

# 클릭 인터랙션 신호 연결
func _connect_buttons() -> void:
	btn_next_wave.pressed.connect(func(): print("다음 웨이브 강제 시작 호출"))
	btn_draw_skill.pressed.connect(func(): GlobalSignalBus.draw_popup_requested.emit("skill"))
	btn_draw_equip.pressed.connect(func(): GlobalSignalBus.draw_popup_requested.emit("equip"))
	btn_summon_boss.pressed.connect(func(): print("보스 소환 호출"))

# 골드 수치 렌더링
func _on_gold_updated(amount: int) -> void:
	gold_label.text = "Gold: %d" % amount

# 적 제한 렌더링 및 100마리 초과 경고 표시
func _on_creep_count_updated(current: int, maximum: int) -> void:
	enemy_count_label.text = "Enemies: %d / %d" % [current, maximum]
	if current >= maximum:
		enemy_count_label.add_theme_color_override("font_color", Color.RED)
	else:
		enemy_count_label.remove_theme_color_override("font_color")

# 라운드 수치 렌더링
func _on_round_updated(round_num: int) -> void:
	wave_label.text = "Wave %d" % round_num
