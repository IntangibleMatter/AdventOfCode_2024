#!/usr/bin/env -S godot --headless -s
extends SceneTree

var left: PackedInt32Array = []
var right: PackedInt32Array = []


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	for line in f.get_as_text().split("\n"):
		if line.length() <= 0:
			continue
		var nline := line.split("  ")
		left.append(int(nline[0]))
		right.append(int(nline[1]))

	left.sort()
	right.sort()

	var dists: PackedInt32Array = []

	for i in left.size():
		dists.append(abs(left[i] - right[i]))

	print(Array(dists).reduce(func(a, b): return a + b, 0))

#	print(left)
	quit()
