#!/usr/bin/env -S godot --headless -s
extends SceneTree

var map: Array[String] = []
var modmap: Array[String] = []
var gpos := Vector2i.ZERO

enum DIR { UP, RIGHT, DOWN, LEFT }
const dirs: Dictionary = {
	DIR.UP: Vector2i.UP,
	DIR.RIGHT: Vector2i.RIGHT,
	DIR.DOWN: Vector2i.DOWN,
	DIR.LEFT: Vector2i.LEFT,
}

var visited: Array[Vector2i] = []


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	map.assign(f.get_as_text().split("\n"))
	map.pop_back()
	modmap = map.duplicate()

	var gdir := DIR.UP
	#var gpos : Vector2.ZERO
	var mcount := 1  # include the starting position
	for y in map.size():
		for x in map[y].length():
			if map[y][x] == "^":
				gpos = Vector2i(x, y)
				break
		if gpos != Vector2i.ZERO:
			break

	# we can break out
	while true:
		var npos: Vector2i = gpos + dirs[gdir]
		if npos.y > map.size() - 1 or npos.y < 0 or npos.x > map[gpos.y].length() or npos.x < 0:
			break
		prints("size", map.size(), map[npos.y].length())
		visited.append(gpos)
		prints(npos, mcount, gdir)
		match map[npos.y][npos.x]:
			".", "^":
				gpos = npos
				#modmap[npos.y][npos.x] = "x" if modmap[npos.y][npos.x] != "x" else "X"
			"#":
				gdir += 1
				gdir = gdir % 4
		if not gpos in visited:
			mcount += 1
		print_modmap()

	print(mcount)
	quit()


func print_modmap() -> void:
	return
	for line in modmap:
		print(line)
