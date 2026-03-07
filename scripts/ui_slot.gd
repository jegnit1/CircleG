extends PanelContainer
class_name UISlot

# 하위 노드 참조 할당
@onready var icon_rect: TextureRect = $MarginContainer/IconRect
@onready var level_label: Label = $MarginContainer/LevelLabel

# 슬롯 식별 데이터
var current_slot_type: String = ""
var current_slot_index: int = -1

# 노드 초기화
func _ready() -> void:
	_clear_slot()

# 슬롯 고유 식별자 부여
func initialize(slot_type: String, index: int) -> void:
	current_slot_type = slot_type
	current_slot_index = index

# 시각 요소 초기화
func _clear_slot() -> void:
	icon_rect.texture = null
	level_label.text = ""

# 외부 데이터 기반 렌더링 갱신
func update_visuals(data: Dictionary) -> void:
	if data.is_empty():
		_clear_slot()
		return
		
	var icon_path: String = data.get("icon_path", "")
	if icon_path != "":
		icon_rect.texture = load(icon_path)
		
	var level: int = data.get("level", 1)
	level_label.text = "Lv." + str(level) if level > 1 else ""
