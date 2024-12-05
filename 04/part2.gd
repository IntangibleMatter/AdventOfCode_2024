#!/usr/bin/env -S godot --headless -s
extends SceneTree

var ws: Array[String]
var sum: int = 0


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	ws.assign(f.get_as_text().split("\n"))
	ws.pop_back()
	print(ws)

	for y in range(1, ws.size() - 1):
		for x in range(1, ws[y].length() - 1):
			#prints("checking", x, y, ws[y][x])
			if ws[y][x] == "A":
				sum += check(x, y)

	print(sum)
	quit()


func check(x: int, y: int) -> int:
	var matches: int = 0
	for i in [-1, 1]:
		for j in [-1, 1]:
			if ws[y + i][x + j] == "M":
				if ws[y - i][x - j] == "S":
					matches += 1

	if matches == 2:
		return 1
	return 0
