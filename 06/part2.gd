#!/usr/bin/env -S godot --headless -s
extends SceneTree

var map: Array[String] = []
var modmap: Array[String] = []
var loops: Array[Array] = []
var history: Array[Array] = []

enum DIR { UP, RIGHT, DOWN, LEFT }
const dirs: Dictionary = {
	DIR.UP: Vector2i.UP,
	DIR.RIGHT: Vector2i.RIGHT,
	DIR.DOWN: Vector2i.DOWN,
	DIR.LEFT: Vector2i.LEFT,
}


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	#var f := FileAccess.open("./demoin.txt", FileAccess.READ)
	map.assign(f.get_as_text().split("\n"))
	map.pop_back()
	modmap = map.duplicate()

	var gdir := DIR.UP
	var gpos := Vector2i.ZERO
	#var gpos : Vector2.ZERO
	var mcount := 1  # include the starting position
	var obcount := 0
	for y in map.size():
		for x in map[y].length():
			if map[y][x] == "^":
				gpos = Vector2i(x, y)
				break
		if gpos != Vector2i.ZERO:
			break

	# we can break out
	var seen_obs: Array[Vector2i]
	while true:
		var npos: Vector2i = gpos + dirs[gdir]
		if npos.y > map.size() - 1 or npos.y < 0 or npos.x > map[gpos.y].length() or npos.x < 0:
			break
		history.append([gpos, gdir])
		#prints("\n\n\n-------------------\n", npos, mcount, gdir, "\n-------------------\n\n\n")
		prints("\n-------------------\n", npos, mcount, gdir, "\n-------------------\n")
		match map[npos.y][npos.x]:
			".", "^":
				gpos = npos
				if not gpos + dirs[gdir] in seen_obs:
					var loop := walk_will_loop(gpos, gdir)
					if loop:
						seen_obs.append(gpos + dirs[gdir])
						obcount += 1
						print("loop!")

				#modmap[npos.y][npos.x] = "x" if modmap[npos.y][npos.x] != "x" else "X"
			"#":
				gdir += 1
				gdir = gdir % 4
		print_modmap()

	for loop in loops:
		#pass
		print(loop)
	print(obcount)
	quit()


func print_modmap() -> void:
	return
	for line in modmap:
		print(line)


func walk_will_loop(from: Vector2i, dir: DIR) -> bool:
	var visited: Array[Array] = history.duplicate(true)
	var locmap := modmap.duplicate()
	#var visited: Array[Vector2i] = []
	var gpos := from
	locmap[(from + dirs[dir]).y][(from + dirs[dir]).x] = "O"
	var gdir := (dir + 1) % 4
	visited.append([from, dir])
	while true:
		#prints("CHECKING LOOP", gpos, gdir)
		var npos: Vector2i = gpos + dirs[gdir]
		if npos.y > map.size() - 1 or npos.y < 0 or npos.x > map[gpos.y].length() - 1 or npos.x < 0:
			return false
		if npos.x > map[npos.y].length() - 1:
			return false
		if npos == from or [npos, gdir] in visited:
			#if npos == from or npos in visited:
			loops.append(
				[[npos == from, [npos, gdir] in visited, [npos, gdir], [gpos, gdir]], visited]
			)
			return true
		visited.append([gpos, gdir])
		#visited.append(gpos)
		#prints(npos, gdir)
		match map[npos.y][npos.x]:
			".", "^":
				gpos = npos
				locmap[npos.y][npos.x] = "x" if locmap[npos.y][npos.x] != "x" else "X"
			"#":
				gdir += 1
				gdir = gdir % 4
		for line in locmap:
			pass
			#print(line)
	#	print()
	return false
