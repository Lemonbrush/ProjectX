extends Resource
class_name Save_file_resource

export(String) var lastVisitedSceneName
export(Vector2) var playerPosition

# { "level_name": level_scene.tres }
export var savedLevelScenes: Dictionary = {}
