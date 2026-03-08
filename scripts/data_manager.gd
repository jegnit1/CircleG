extends Node

var artifacts_data: Dictionary = {}
var stages_data: Dictionary = {} # 라운드별 데이터 보관
var skills_data: Dictionary = {}
# 플레이어(타워)의 현재 스탯
var player_stats: Dictionary = {
	"base_damage": 10.0,         # 기본 공격력
	"cooldown_speed": 1.0,       # 쿨타임 속도 (1.0 = 100% 기본속도)
	"gold_bonus": 0,             # 골드 획득 추가량 (+N 골드)
	"effect_range": 1.0          # 장판/폭발 범위 배수 (1.0 = 100%)
}

func _ready() -> void:
	# 게임 시작 시 모든 CSV 파일 파싱
	_load_artifacts_from_csv("res://data/csv/artifacts.csv")
	_load_stages_from_csv("res://data/csv/stages.csv") # 스테이지 데이터 로드
	_load_skills_from_csv("res://data/csv/skills.csv")

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
			var value: String = row[i].strip_edges() if i < row.size() else ""
			
			# [수정됨] 헤더에 숨어있을 수 있는 눈에 보이지 않는 BOM 문자를 강제로 제거!
			var clean_header: String = headers[i].strip_edges().replace("\uFEFF", "")
			row_data[clean_header] = value
			
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
	
func _load_skills_from_csv(file_path: String) -> void:
	if not FileAccess.file_exists(file_path):
		push_error("❌ 스킬 CSV 파일 누락: " + file_path)
		return
		
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var headers: PackedStringArray = file.get_csv_line()
	
	while not file.eof_reached():
		var row: PackedStringArray = file.get_csv_line()
		if row.size() < headers.size() or row[0].strip_edges().is_empty(): 
			continue
			
		var row_data: Dictionary = {}
		for i in range(headers.size()):
			var clean_header: String = headers[i].strip_edges().replace("\uFEFF", "")
			var value: String = row[i].strip_edges() if i < row.size() else ""
			row_data[clean_header] = value
		
		var skill_id: String = row_data.get("ID", "")
		if skill_id.is_empty(): continue
		
		# 아까 만드신 SkillData 틀에 데이터 채워넣기!
		var skill: SkillData = SkillData.new()
		skill.id = skill_id
		skill.type = row_data.get("TYPE", "ACTIVE")
		skill.damage = float(row_data.get("DAMAGE", "1.0"))
		skill.cooldown = float(row_data.get("COOL_DOWN", "1.0"))
		skill.target_type = row_data.get("TARGET", "HITSCAN")
		skill.element = row_data.get("ELEMENT", "NORMAL")
		skill.name_kr = row_data.get("NAME_KR", "미정")
		
		skills_data[skill_id] = skill # 딕셔너리에 저장
		
	file.close()
	print("✅ 로드된 스킬 개수: ", skills_data.size())

# 🌟 [추가] 특정 스킬을 꺼내오는 함수
func get_skill(id: String) -> SkillData:
	return skills_data.get(id, null)
	
# 중복 없이 원하는 개수만큼 스킬을 뽑아주는 함수
func get_random_skills(count: int) -> Array[SkillData]:
	var result: Array[SkillData] = []
	var keys: Array = skills_data.keys().duplicate() # 원본 훼손 방지를 위해 복사
	
	for i in range(count):
		if keys.is_empty(): 
			break # 더 이상 뽑을 스킬이 없으면 중단
			
		var rand_idx: int = randi() % keys.size()
		var chosen_key: String = keys[rand_idx]
		
		result.append(skills_data[chosen_key])
		keys.remove_at(rand_idx) # 뽑은 건 후보에서 제거 (중복 방지)
		
	return result
