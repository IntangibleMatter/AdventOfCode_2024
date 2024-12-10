#!/usr/bin/env -S godot --headless -s
extends SceneTree

var trailheads: Array[Vector2]
var map: Array[String]

# Vector2 : Array[Vector2] (trailhead:finals)
var paths: Dictionary = {}


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	prints("map:\n", f.get_as_text(), "\n")
	map.assign(f.get_as_text().split("\n"))
	map.pop_back()
	for y in map.size():
		for x in map[y].length():
			if map[y][x] == "0":
				trailheads.append(Vector2(x, y))
				find_markers(trailheads[-1], trailheads[-1])
	prints("Trailheads:", trailheads)
	prints("Paths:", paths)

	var sum := 0

	for i in paths.values():
		sum += i.size()

	print(sum)

	quit()


func find_markers(from: Vector2, trailhead: Vector2) -> void:
	var idx := int(map[from.y][from.x])
	prints("searching neighbors of ", from, idx, trailhead)
	if map[from.y][from.x] == "9":
		prints("POSSIBLE PATH")
		if not from in paths.get_or_add(trailhead, []):
			paths[trailhead].append(from)
			prints("found path from", trailhead, "to", from, "!!!!")
			return
		return
	for i in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var npos: Vector2 = from + i
		if npos.y < 0 or npos.y >= map.size():
			continue
		elif npos.x < 0 or npos.x >= map[npos.y].length():
			continue

		if int(map[npos.y][npos.x]) == idx + 1:
			prints("\tpossible direction found, searching neighbors...", npos, idx + 1)
			find_markers(npos, trailhead)
