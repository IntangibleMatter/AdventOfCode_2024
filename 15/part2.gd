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

	convert_map()
	printmap()

	set_rpos()
	traverse()

	var sum := 0
	for y in map.size():
		for x in map[y].length():
			if map[y][x] == "[":
				sum += pos_to_fishcoords(Vector2(x, y))
	prints("sum")
	print(sum)

	quit()


func convert_map() -> void:
	for line in map.size():
		var nstring := ""
		for chara in map[line]:
			match chara:
				"#":
					nstring += "##"
				"O":
					nstring += "[]"
				".":
					nstring += ".."
				"@":
					nstring += "@."
		map[line] = nstring


func set_rpos() -> void:
	for y in map.size():
		for x in map[y].length():
			if map[y][x] == "@":
				rpos = Vector2(x, y)


func checkmove(from: Vector2, dir: Vector2) -> bool:
	var targ := from + dir
	prints(from, dir, targ, map[from.y][from.x], map[targ.y][targ.x])
	match map[targ.y][targ.x]:
		"#":
			return false
		"[":
			if dir.x == 0:  # moving vertical
				var canmove1 := checkmove(targ, dir)
				var canmove2 := checkmove(targ + Vector2.RIGHT, dir)
				return canmove1 and canmove2
			else:
				return checkmove(targ, dir)
		"]":
			if dir.x == 0:  # moving vertical
				var canmove1 := checkmove(targ, dir)
				var canmove2 := checkmove(targ + Vector2.LEFT, dir)
				return canmove1 and canmove2
			else:
				return checkmove(targ, dir)
		".":
			prints("canmove")
			return true
	return false


func domove(from: Vector2, dir: Vector2) -> void:
	var targ := from + dir
	match map[targ.y][targ.x]:
		"#":
			return
		"[":
			if dir.x == 0:
				domove(targ, dir)
				domove(targ + Vector2.RIGHT, dir)
			else:
				domove(targ, dir)
			map[targ.y][targ.x] = map[from.y][from.x]
		"]":
			if dir.x == 0:
				domove(targ, dir)
				domove(targ + Vector2.LEFT, dir)
			else:
				domove(targ, dir)
			map[targ.y][targ.x] = map[from.y][from.x]
		".", " ":
			map[targ.y][targ.x] = map[from.y][from.x]
	map[from.y][from.x] = "."
	printmap()


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
		var moved := checkmove(rpos, dir)
		if moved:
			#map[(rpos + dir).y][(rpos + dir).x] = map[rpos.y][rpos.x]
			#map[rpos.y][rpos.x] = "."
			domove(rpos, dir)
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
