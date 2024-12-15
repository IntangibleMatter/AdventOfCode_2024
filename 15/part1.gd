#!/usr/bin/env -S godot --headless -s
extends SceneTree

var map: Array[String]
var moves: String = ""
var rpos: Vector2 = Vector2.ZERO


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	var done_map := false
	while not f.eof_reached():
		var line := f.get_line()
		if line.is_empty():
			done_map = true
		elif not done_map:
			map.append(line)
		else:
			moves += line

	set_rpos()
	traverse()

	var sum := 0
	for y in map.size():
		for x in map[y].length():
			if map[y][x] == "O":
				sum += pos_to_fishcoords(Vector2(x, y))
	prints("sum")
	print(sum)

	quit()


func set_rpos() -> void:
	for y in map.size():
		for x in map[y].length():
			if map[y][x] == "@":
				rpos = Vector2(x, y)


func move(from: Vector2, dir: Vector2) -> bool:
	var targ := from + dir
	prints(from, dir, targ, map[from.y][from.x], map[targ.y][targ.x])
	match map[targ.y][targ.x]:
		"#":
			return false
		"O", "@":
			var canmove := move(targ, dir)
			if canmove:
				map[targ.y][targ.x] = map[from.y][from.x]
				prints("canmove")
				printmap()
			return canmove
		".":
			map[targ.y][targ.x] = map[from.y][from.x]
			prints("canmove")
			printmap()
			return true
	return false


func traverse() -> void:
	for i in moves:
		var dir: Vector2 = Vector2.ZERO
		prints("Move:", i)
		match i:
			"^":
				dir = Vector2.UP
			">":
				dir = Vector2.RIGHT
			"v":
				dir = Vector2.DOWN
			"<":
				dir = Vector2.LEFT
		var moved := move(rpos, dir)
		if moved:
			map[(rpos + dir).y][(rpos + dir).x] = map[rpos.y][rpos.x]
			map[rpos.y][rpos.x] = "."
			rpos = rpos + dir

		print("Moved" if moved else "Didn't Move")
		printmap()
		print()
		print()


func pos_to_fishcoords(pos: Vector2) -> int:
	return 100 * pos.y + pos.x


func printmap() -> void:
	return
	for line in map:
		print(line)
