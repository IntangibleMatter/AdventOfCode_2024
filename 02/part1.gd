#!/usr/bin/env -S godot --headless -s
extends SceneTree


## Accidentally did all of part 2 in this file
## tried to revert it to the correct point but don't know if I did or not
## So... good luck ig?
func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	var lines: Array = Array(f.get_as_text().split("\n")).map(
		func(line: String): return Array(line.split(" ")).map(func(i: String): return int(i))
	)
	lines.pop_back()

	var safe: int = 0

	for line in lines:
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
					print("AILED\nFAILASD\nFLAKLS\n")
					inc = false
					break
			if inc:
				safe += 1
		prints("safe", safe)

	print(safe)

	quit()
