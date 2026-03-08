extends PanelContainer
class_name UISlot

# 하위 노드 참조 할당
@onready var icon_rect: TextureRect = $MarginContainer/IconRect
@onready var level_label: Label = $MarginContainer/LevelLabel

# 슬롯 식별 데이터
var current_slot_type: String = ""
var current_slot_index: int = -1
var _current_data: Variant = null

# 노드 초기화
func _ready() -> void:
	_clear_slot()
	# [추가] 마우스 진입/이탈 시그널 연결
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

# 슬롯 고유 식별자 부여
func initialize(slot_type: String, index: int) -> void:
	current_slot_type = slot_type
	current_slot_index = index

# 시각 요소 초기화
func _clear_slot() -> void:
	icon_rect.texture = null
	level_label.text = ""

# 외부 데이터 기반 렌더링 갱신
func update_visuals(data: Variant) -> void:
	_current_data = data # [추가] 툴팁용으로 데이터 저장
	
	if data == null:
		_clear_slot()
		return
		
	# 덕 타이핑(Duck Typing)을 활용한 안전한 텍스처 바인딩
	var icon_tex: Texture2D = data.get("icon") if typeof(data) == TYPE_OBJECT else null
	if icon_tex != null:
		icon_rect.texture = icon_tex
	else:
		icon_rect.texture = null
		
	# 레벨 표시
	var level: int = data.get("level") if (typeof(data) == TYPE_OBJECT and "level" in data) else 1
	level_label.text = "Lv." + str(level) if level > 1 else ""
	
func _on_mouse_entered() -> void:
	if _current_data != null:
		GlobalSignalBus.tooltip_requested.emit(_current_data)

func _on_mouse_exited() -> void:
	GlobalSignalBus.tooltip_hidden.emit()
