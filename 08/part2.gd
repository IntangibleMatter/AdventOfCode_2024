#!/usr/bin/env -S godot --headless -s
extends SceneTree

var antennae: Dictionary = {}

var fullmap: Array[String]
var antinodes: Array[String]


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	fullmap.assign(f.get_as_text().split("\n"))
	fullmap.pop_back()
	setup_antinode_map()
	find_antennae()
	create_antinodes()
	var sum := 0
	for line in antinodes:
		sum += line.count("#")
	print(sum)

	quit()


func setup_antinode_map() -> void:
	var anode_width := fullmap[0].length()
	var empty_line := ""
	for i in anode_width:
		empty_line += "."

	#antinodes.resize(fullmap.size())
	#antinodes.fill(empty_line)
	antinodes = fullmap.duplicate()


func find_antennae() -> void:
	for y in fullmap.size():
		for x in fullmap[y].length():
			var ncar := fullmap[y][x]
			if ncar == ".":
				continue
			var anten: Array = antennae.get_or_add(ncar, [])
			anten.append(Vector2(x, y))


func create_antinodes() -> void:
	for car in antennae:
		var narr: Array = antennae[car]
		for i in narr:
			for j in narr:
				if j == i:
					continue
				var anodepos: Vector2 = i - j
				var offnodepos: Vector2 = i + anodepos
				prints("arrpos", i, j, anodepos, offnodepos)
				makeline(i, anodepos)
				#if offnodepos.y >= 0 and offnodepos.y < antinodes.size():
				#	if offnodepos.x >= 0 and offnodepos.x < antinodes[offnodepos.y].length():
				#		antinodes[offnodepos.y][offnodepos.x] = "#"
		printanti()


func printanti() -> void:
	for line in antinodes:
		print(line)


func makeline(from: Vector2, slope: Vector2) -> void:
	var traverse := func(slp: Vector2) -> void:
		var cpos := from
		while cpos.y >= 0 and cpos.y < antinodes.size():
			if cpos.x < 0 or cpos.x > antinodes[cpos.y].length():
				break
			antinodes[cpos.y][cpos.x] = "#"
			cpos += slp
	traverse.call(slope)
	traverse.call(slope * -1)
