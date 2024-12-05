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
	var counts: Dictionary = {}

	for i in right:
		counts[i] = counts.get(i, 0) + 1

	print(
		Array(left).reduce(
			func(a, b):
				prints("a:", a, "counts:", counts.get(b, 0), "b:", b)
				return b * counts.get(b, 0) + a,
			0
		)
	)

	quit()
