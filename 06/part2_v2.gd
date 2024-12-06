#!/usr/bin/env -S godot --headless -s
extends SceneTree

var gmap: Array[String] = []
#var modmap: Array[String] = []
#var gpos := Vector2i.ZERO
var init_gpos := Vector2i.ZERO

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
	gmap.assign(f.get_as_text().split("\n"))
	gmap.pop_back()
	#modmap = gmap.duplicate()

	#var gpos : Vector2.ZERO
	var mcount := 1  # include the starting position
	for y in gmap.size():
		for x in gmap[y].length():
			if gmap[y][x] == "^":
				#	gpos = Vector2i(x, y)
				init_gpos = Vector2i(x, y)
				break
		if init_gpos != Vector2i.ZERO:
			break

	var obcount := 0
	var msize := (gmap.size() - 1) * (gmap[0].length() - 1)
	var prog = 0
	for y in gmap.size():
		for x in gmap[y].length():
			prog += 1
			prints("Progress:", prog / float(msize) * 100, "\t", prog, "/", msize)
			if gmap[y][x] == "#":
				prints("skip", x, y)
				continue
			prints("Checking", x, y)
			if will_loop(Vector2i(x, y)):
				prints("-------------- LOOP FOUND!!")
				obcount += 1

	# we can break out

	print(obcount)
	quit()


func print_modmap(map: Array[String]) -> void:
	for line in map:
		print(line)
	print()


func will_loop(pos: Vector2i) -> bool:
	var gdir := DIR.UP
	var gpos := init_gpos
	var history: Array[Array]
	var map := gmap.duplicate()
	map[pos.y][pos.x] = "O"
	var modmap := map.duplicate()
	#print_modmap(map)

	while true:
		var npos: Vector2i = gpos + dirs[gdir]
		if npos.y > map.size() - 1 or npos.y < 0 or npos.x > map[gpos.y].length() or npos.x < 0:
			return false
		#prints("size", gmap.size(), gmap[npos.y].length())
		if [gpos, gdir] in history:
			return true
		history.append([gpos, gdir])
		match map[npos.y][npos.x]:
			".", "^":
				gpos = npos
				modmap[npos.y][npos.x] = "x" if modmap[npos.y][npos.x] != "x" else "X"
			"#", "O":
				gdir += 1
				gdir = gdir % 4
		#print_modmap(modmap)
	return false
