#!/usr/bin/env -S godot --headless -s
extends SceneTree


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	var lines: Array = Array(f.get_as_text().split("\n")).map(
		func(line: String): return Array(line.split(" ")).map(func(i: String): return int(i))
	)
	lines.pop_back()

	var safe: int = 0

	for line in lines:
		if checkifsafe(line):
			print("SAFE\n")
			safe += 1
		else:
			var linesafe := false
			for i in line.size():
				var nline: Array = line.duplicate()
				nline.remove_at(i)
				if checkifsafe(nline):
					linesafe = true
					print("GROUPSAFE")

			if linesafe:
				safe += 1
				print("THAT GROUP WAS SAFE\n\n")
			else:
				print("THAT GROUP WAS UNSAFE\n\n")

	print(safe)

	quit()


func checkifsafe(line: Array) -> bool:
	print(line)
	var sorted: Array[int]  # ascending
	sorted.assign(line.duplicate())
	sorted.sort()
	var sortrev := sorted.duplicate()  # descending
	sortrev.reverse()
	if line == sorted or line == sortrev:
		var inc := true
		for i in line.size() - 1:
			if abs(line[i] - line[i + 1]) > 3 or line[i] == line[i + 1]:
				inc = false
				return false
		if inc:
			return true
	return false
