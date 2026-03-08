extends Node

var artifacts_data: Dictionary = {}
var stages_data: Dictionary = {} # 라운드별 데이터 보관

func _ready() -> void:
	# 게임 시작 시 모든 CSV 파일 파싱
	_load_artifacts_from_csv("res://data/csv/artifacts.csv")
	_load_stages_from_csv("res://data/csv/stages.csv") # 스테이지 데이터 로드

# 기존 아티팩트 로드 함수 (변경 없음)
func _load_artifacts_from_csv(file_path: String) -> void:
	if not FileAccess.file_exists(file_path): return
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var headers: PackedStringArray = file.get_csv_line()
	while not file.eof_reached():
		var row: PackedStringArray = file.get_csv_line()
		if row.size() < headers.size() or row[0].strip_edges().is_empty(): continue
		var row_data: Dictionary = {}
		for i in range(headers.size()):
			row_data[headers[i].strip_edges()] = row[i].strip_edges()
		
		var artifact_id: String = row_data.get("ID", "")
		if artifact_id.is_empty(): continue
		
		var artifact: ArtifactData = ArtifactData.new()
		artifact.id = artifact_id
		artifact.name_kr = row_data.get("NAME_KR", "미정")
		artifact.name_en = row_data.get("NAME_EN", "Unknown")
		artifact.logic = row_data.get("LOGIC", "")
		
		var icon_path: String = "res://assets/icons/artifacts/" + artifact_id.to_lower() + ".png"
		if FileAccess.file_exists(icon_path):
			artifact.icon = load(icon_path)
			
		artifacts_data[artifact_id] = artifact
	file.close()

# 🌟 [추가됨] 스테이지 데이터 로드 함수
func _load_stages_from_csv(file_path: String) -> void:
	if not FileAccess.file_exists(file_path):
		push_error("❌ 스테이지 CSV 파일 누락: " + file_path)
		return
		
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var headers: PackedStringArray = file.get_csv_line()
	
	while not file.eof_reached():
		var row: PackedStringArray = file.get_csv_line()
		if row.size() < headers.size() or row[0].strip_edges().is_empty():
			continue
			
		var row_data: Dictionary = {}
		for i in range(headers.size()):
			# 엑셀에 빈칸이 있어도 안전하게 빈 문자열로 들어감
			var value: String = row[i].strip_edges() if i < row.size() else ""
			row_data[headers[i].strip_edges()] = value
			
		var stage_num: int = int(row_data.get("STAGE", "0"))
		if stage_num > 0:
			stages_data[stage_num] = row_data # STAGE 번호(1~100)를 Key로 딕셔너리 통째로 저장
			
	file.close()
	print("✅ 로드된 스테이지 개수: ", stages_data.size())

# 특정 스테이지(라운드)의 데이터를 반환하는 함수
func get_stage_data(stage: int) -> Dictionary:
	return stages_data.get(stage, {})
	
# 특정 아티팩트의 데이터를 반환하는 함수 (누락되었던 부분)
func get_artifact(id: String) -> ArtifactData:
	return artifacts_data.get(id, null)
