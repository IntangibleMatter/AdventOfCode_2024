#!/usr/bin/env -S godot --headless -s
extends SceneTree

var stones: PackedInt64Array


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)

	for i in f.get_as_text().split(" "):
		stones.append(int(i))
	for i in 25:
		process_stones()
	print(stones.size())

	quit()


func process_stones() -> void:
	var newstones: PackedInt64Array = []
	for i in stones:
		if i == 0:
			newstones.append(1)
		elif str(i).length() % 2 == 0:
			var nst := str(i)
			newstones.append(int(nst.substr(0, nst.length() / 2)))
			newstones.append(int(nst.substr(nst.length() / 2)))
		else:
			newstones.append(i * 2024)

	#print(newstones)
	stones = newstones
