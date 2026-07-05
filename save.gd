extends ResourcePreloader


class Gamedata extends  Resource:
	@export var car=0
	@export var care=""
var gamedata=Gamedata.new()


func _on_setcar_item_activated(index: int) -> void:
	gamedata.car=index
	ResourceSaver.save(gamedata, "user://savegame.tres")
