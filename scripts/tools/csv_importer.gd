@tool
extends EditorScript

# 파일 경로 설정
const CSV_PATH: String = "res://data/csv/artifacts.csv"
const OUTPUT_DIR: String = "res://data/artifacts/"

# 에디터에서 스크립트 실행 시 호출되는 메인 함수
func _run() -> void:
	print("🚀 [데이터 빌드] CSV -> TRES 변환을 시작합니다...")
	
	# 출력 디렉토리가 없으면 자동 생성
	if not DirAccess.dir_exists_absolute(OUTPUT_DIR):
		DirAccess.make_dir_recursive_absolute(OUTPUT_DIR)
		
	var file: FileAccess = FileAccess.open(CSV_PATH, FileAccess.READ)
	if not file:
		printerr("❌ CSV 파일을 찾을 수 없습니다: ", CSV_PATH)
		return
		
	# 첫 줄(헤더) 읽기
	var headers: PackedStringArray = file.get_csv_line()
	
	var count: int = 0
	# 데이터 행 순회
	while not file.eof_reached():
		var row: PackedStringArray = file.get_csv_line()
		
		# 빈 줄이거나 데이터가 부족한 줄 무시
		if row.size() < headers.size() or row[0].strip_edges().is_empty():
			continue
			
		# 행 데이터를 딕셔너리로 임시 매핑
		var row_data: Dictionary = {}
		for i in range(headers.size()):
			row_data[headers[i].strip_edges()] = row[i].strip_edges()
			
		var artifact_id: String = row_data.get("ID", "")
		if artifact_id.is_empty():
			continue
			
		# 1. 아티팩트 데이터 리소스(.tres) 인스턴스 생성
		var artifact: ArtifactData = ArtifactData.new()
		
		# 2. CSV 데이터 매핑
		artifact.id = artifact_id
		artifact.min_rank = row_data.get("MIN_RANK", "D")
		artifact.max_rank = row_data.get("MAX_RANK", "S")
		artifact.name_kr = row_data.get("NAME_KR", "미정")
		artifact.name_en = row_data.get("NAME_EN", "Unknown")
		artifact.logic = row_data.get("LOGIC", "")
		
		# 🌟 [추가된 부분] 이미지 자동 탐색 및 연결
		var icon_path: String = "res://assets/icons/artifacts/" + artifact_id.to_lower() + ".png"
		if FileAccess.file_exists(icon_path):
			artifact.icon = load(icon_path)
		else:
			# 이미지가 아직 없으면 경고만 띄우고 빈 상태로 둠
			print("⚠️ 아이콘 누락 (나중에 추가하세요): ", icon_path)
		
		# 3. .tres 파일로 물리적 저장
		var save_path: String = OUTPUT_DIR + artifact_id.to_lower() + ".tres"
		var error: Error = ResourceSaver.save(artifact, save_path)
		
		if error == OK:
			count += 1
		else:
			printerr("❌ 저장 실패: ", save_path)
			
	file.close()
	
	# 에디터 파일 시스템 새로고침 (생성된 파일 즉시 표시)
	var editor_interface := get_editor_interface()
	if editor_interface:
		editor_interface.get_resource_filesystem().scan()
		
	print("✅ 성공! 총 %d개의 아티팩트 리소스가 성공적으로 생성/갱신되었습니다." % count)
