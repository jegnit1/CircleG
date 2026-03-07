extends Resource
class_name ArtifactData

@export var id: String = ""
@export_enum("D", "C", "B", "A", "S") var min_rank: String = "D"
@export_enum("D", "C", "B", "A", "S") var max_rank: String = "S"
@export var name_kr: String = ""
@export var name_en: String = "" # 추가된 영문 이름
@export_multiline var logic: String = ""
@export var icon: Texture2D
