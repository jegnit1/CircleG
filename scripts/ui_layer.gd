extends CanvasLayer
class_name UILayer

# 우측 상단 상태 HUD 참조 캐싱 (RightPanel 뒤에 VBox/ 추가됨)
@onready var wave_label: Label = $MainLayout/TopSection/RightPanel/VBox/StatusHUD/VBox/HBox/WaveLabel
@onready var enemy_count_label: Label = $MainLayout/TopSection/RightPanel/VBox/StatusHUD/VBox/HBox/EnemyCountLabel
@onready var gold_label: Label = $MainLayout/TopSection/RightPanel/VBox/StatusHUD/VBox/GoldLabel




# 우측 정보 패널 (탭 제거 및 단일 뷰 통합 반영)
@onready var active_grid: GridContainer = $MainLayout/TopSection/RightPanel/VBox/TabContainer/Skills/VBox/ActiveGrid
@onready var passive_grid: GridContainer = $MainLayout/TopSection/RightPanel/VBox/TabContainer/Skills/VBox/PassiveGrid
@onready var artifact_box: GridContainer = $MainLayout/TopSection/RightPanel/VBox/TabContainer/Skills/VBox/ArtifactBox
@onready var lbl_damage: Label = $RightPanel/VBoxContainer/TabContainer/Stats/VBoxContainer/LblDamage
@onready var lbl_cooldown: Label = $RightPanel/VBoxContainer/TabContainer/Stats/VBoxContainer/LblCooldown
@onready var lbl_gold: Label = $RightPanel/VBoxContainer/TabContainer/Stats/VBoxContainer/LblGold

# 하단 바 조작부 및 슬롯 컨테이너 참조 캐싱
@onready var btn_draw_skill: Button = $MainLayout/BottomBar/MarginContainer/HBox/ActionButtons/BtnDrawSkill
@onready var btn_draw_equip: Button = $MainLayout/BottomBar/MarginContainer/HBox/ActionButtons/BtnDrawEquip
@onready var btn_summon_boss: Button = $MainLayout/BottomBar/MarginContainer/HBox/ActionButtons/BtnSummonBoss
@onready var equip_box: HBoxContainer = $MainLayout/BottomBar/MarginContainer/HBox/Equipments
@onready var consumables_box: HBoxContainer = $MainLayout/BottomBar/MarginContainer/HBox/Consumables
@onready var btn_next_wave: Button = $MainLayout/BottomBar/MarginContainer/HBox/BtnNextWave
@onready var skill_select_panel: Panel = $SkillSelectPanel
@onready var cards: Array[Button] = [
	$SkillSelectPanel/HBoxContainer/Card1,
	$SkillSelectPanel/HBoxContainer/Card2,
	$SkillSelectPanel/HBoxContainer/Card3
]

# 슬롯 프리팹 로드
const SLOT_SCENE: PackedScene = preload("res://scenes/ui_slot.tscn")


# 객체 초기화 및 신호 바인딩
func _ready() -> void:
	_init_all_slots()
	_connect_global_signals()
	_connect_buttons()
	
func update_stats_ui() -> void:
	var stats = DataManager.player_stats	
	lbl_damage.text = "⚔️ 기본 공격력: " + str(stats["base_damage"])	
	var cd_percent = int(stats["cooldown_speed"] * 100)
	lbl_cooldown.text = "⏳ 쿨타임 가속: " + str(cd_percent) + "%"	
	lbl_gold.text = "💰 골드 획득 보너스: +" + str(stats["gold_bonus"])

# 규격에 따른 슬롯 동적 생성
func _init_all_slots() -> void:
	_create_slots(active_grid, "active", 7)
	_create_slots(passive_grid, "passive", 7)
	_create_slots(equip_box, "equip", 3)
	_create_slots(artifact_box, "artifact", 5)
	_create_slots(consumables_box, "consumable", 2)

# 단일 슬롯 인스턴스화 및 부착
func _create_slots(container: Control, slot_type: String, count: int) -> void:
	for i in range(count):
		var slot_instance: UISlot = SLOT_SCENE.instantiate() as UISlot
		container.add_child(slot_instance)
		slot_instance.initialize(slot_type, i)
		
		# 연동 테스트: 아티팩트 첫 번째 칸에 생성한 리소스 주입
		if slot_type == "artifact" and i == 0:
			var test_art: Resource = DataManager.get_artifact("ART_RICH")
			slot_instance.update_visuals(test_art)

# 전역 상태 신호 구독
func _connect_global_signals() -> void:
	GlobalSignalBus.gold_updated.connect(_on_gold_updated)
	GlobalSignalBus.creep_count_updated.connect(_on_creep_count_updated)
	GlobalSignalBus.round_updated.connect(_on_round_updated)

# 버튼 클릭 인터랙션 구독
func _connect_buttons() -> void:
	btn_next_wave.pressed.connect(func(): print("다음 웨이브 강제 시작 호출"))
	btn_draw_skill.pressed.connect(func(): GlobalSignalBus.draw_popup_requested.emit("skill"))
	btn_draw_equip.pressed.connect(func(): GlobalSignalBus.draw_popup_requested.emit("equip"))
	btn_summon_boss.pressed.connect(func(): print("보스 소환 호출"))

# 골드 수치 렌더링
func _on_gold_updated(amount: int) -> void:
	gold_label.text = "💰 %d Gold" % amount

# 적 제한 렌더링 및 초과 경고 표시
func _on_creep_count_updated(current: int, maximum: int) -> void:
	enemy_count_label.text = "Enemies: %d / %d" % [current, maximum]
	if current >= maximum:
		enemy_count_label.add_theme_color_override("font_color", Color.RED)
	else:
		enemy_count_label.remove_theme_color_override("font_color")

# 라운드 수치 렌더링
func _on_round_updated(round_num: int) -> void:
	wave_label.text = "Wave %d" % round_num
	
func _on_btn_draw_skill_pressed() -> void:
	var draw_cost: int = 100 # 스킬 뽑기 가격
	
	var main_node = get_parent() 
	if main_node.has_method("use_gold"):
		var is_paid: bool = main_node.use_gold(draw_cost)
		
		if not is_paid:
			print("❌ 골드가 부족합니다! (현재 골드 부족)")
			# TODO: 나중에 화면에 빨간색 경고 메세지 띄우기
			return # 🌟 중요: 골드가 없으면 여기서 함수를 끝내버립니다. (카드가 안 나옴)
	
	var drawn_skills: Array[SkillData] = DataManager.get_random_skills(3)
	
	# 뽑은 스킬이 3개가 안되면 리턴 (에러 방지)
	if drawn_skills.size() < 3: return 
	
	for i in range(3):
		var skill: SkillData = drawn_skills[i]
		var card: Button = cards[i]
		
		# VBoxContainer 안의 자식 노드들 가져오기 (이름은 만드신 대로 맞춰주세요!)
		var icon_rect: TextureRect = card.get_node("VBoxContainer/TextureRect")
		var name_label: Label = card.get_node("VBoxContainer/NameLabel")
		var desc_label: Label = card.get_node("VBoxContainer/DescLabel")
		
		# 1. 텍스트 채우기
		name_label.text = skill.name_kr		
		# (logic 변수가 없다면 "데미지: %s\n쿨타임: %s초" 로 넣어도 됩니다)
		desc_label.text = "데미지 %s배 / 쿨타임 %s초\n%s" % [skill.damage, skill.cooldown, skill.logic]
		
		if card.pressed.is_connected(_on_card_selected):
			var connections = card.pressed.get_connections()
			for conn in connections:
				card.pressed.disconnect(conn.callable)
				
		# 2. 아이콘 채우기 (아직 이미지가 없다면 엔진 기본 아이콘 등 임시 사용)
		# icon_rect.texture = load("res://assets/icons/skills/" + skill.id + ".png")
		card.pressed.connect(_on_card_selected.bind(skill))
		
	# 3. 데이터가 다 채워졌으니 숨겨뒀던 화면(패널)을 보여준다!
	skill_select_panel.show()
	
# 카드를 클릭했을 때 실행되는 함수
func _on_card_selected(selected_skill: SkillData) -> void:
	print("✨ 스킬 선택 완료! 타워에 장착합니다: [%s]" % selected_skill.name_kr)
	
	# 1. 스킬 선택 창(패널)을 다시 숨깁니다.
	skill_select_panel.hide()
	
	# 2. 타워가 들을 수 있도록 "스킬 장착!" 신호를 보냅니다.
	GlobalSignalBus.skill_equipped.emit(selected_skill)
