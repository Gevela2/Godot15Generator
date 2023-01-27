extends Node3D

var Block1 = preload("res://Block1.tscn")
var Block2 = preload("res://Block2.tscn")
var LargeScene = preload("res://Block3.tscn")


@onready var Navigation = $NavigationRegion3D
@onready var Generator = $Generator
@onready var player = $Player
var LastInstancePosition
var PathCollection : Array
var Gap : float = 2.5
var StartPosition = Vector3(0,0,0)
var numinstances : int = 10
var new_position : Vector3
var x_pos : int
var y_pos : int
var LastInstanced
var LastInstancedGap = 14
var need_rotation = false
func _ready():
	PathCollection = [Block1,Block2]
	generate(StartPosition)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Generator.global_transform.origin = LastInstancePosition.global_transform.origin
	
	if player != null and Generator.Generate == true:
		x_pos = randi_range(0,10)
		y_pos = 0
		generate(Vector3(x_pos,y_pos,LastInstancePosition.get_global_position().z + 14))
		Generator.Generate = false

func generate(pos):
	var new_node = Node3D.new()
	Navigation.add_child(new_node)
	var random_BlockPath = PathCollection[randf() * PathCollection.size()]
	var instance = random_BlockPath.instantiate()
	new_node.add_child(instance)
	instance.translate(pos)
	for i in range(1,numinstances):
		pos.z += Gap
		random_BlockPath = PathCollection[randf() * PathCollection.size()]
		instance = random_BlockPath.instantiate()
		new_node.add_child(instance)
		instance.translate(pos)
	LastInstanced = LargeScene.instantiate()
	LastInstanced.translate(pos + Vector3(0,0,LastInstancedGap))
	new_node.add_child(LastInstanced)
	Navigation.bake_navigation_mesh()
	LastInstancePosition = LastInstanced

	

















