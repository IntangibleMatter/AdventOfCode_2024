#!/usr/bin/env -S godot --headless -s
extends SceneTree

const DIRS: PackedVector2Array = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]

var map: Array[String]
# Point: Array[Region]
var regions: Dictionary = {}  #Array[Region]


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	map.assign(f.get_as_text().split("\n", false))
	prints(map)

	for y in map.size():
		for x in map[y].length():
			if not check_if_point_in_region(Vector2(x, y)):
				regions.get_or_add(map[y][x], []).append(Region.new(map[y][x], map))
				regions[map[y][x]][-1].flood_fill(Vector2(x, y))

	var sum: int = 0
	for r in regions:
		for region in regions[r]:
			prints(r, region.points, "\t\tcost:", region.get_cost())
			sum += region.get_cost()
	print("cost:")
	print(sum)

	quit()


func check_if_point_in_region(point: Vector2) -> bool:
	for r in regions:
		for region in regions[r]:
			if point in region.points:
				return true
	return false


class Region:
	extends RefCounted

	var map: Array[String]
	var type: String
	var points: PackedVector2Array
	var area: int:
		get:
			return points.size()
	var perim: int = 0

	#var cost: int:
	func get_cost() -> int:
		prints("Area:", area, "perim:", perim)
		return area * perim

	func _init(ntype: String, nmap: Array[String]) -> void:
		map = nmap
		type = ntype

	func flood_fill(from: Vector2) -> void:
		if not from in points:
			points.append(from)
			perim += get_perim_at_point(from)
		var stack: Array[Vector2] = [from]

		while stack:
			prints("Stack", type, stack)
			var cloc: Vector2 = stack.pop_back()
			for d in DIRS:
				var ndir: Vector2 = cloc + d
				if ndir.y < 0 or ndir.y >= map.size():
					continue
				elif ndir.x < 0 or ndir.x >= map[ndir.y].length():
					continue
				if map[ndir.y][ndir.x] == type and not ndir in points:
					perim += get_perim_at_point(ndir)
					points.append(ndir)
					stack.push_back(ndir)

	func get_perim_at_point(point: Vector2) -> int:
		var nperim: int = 0
		for d in DIRS:
			var ndir: Vector2 = point + d
			if ndir.y < 0 or ndir.y >= map.size():
				nperim += 1
				continue
			elif ndir.x < 0 or ndir.x >= map[ndir.y].length():
				nperim += 1
				continue
			elif map[ndir.y][ndir.x] != type:
				nperim += 1
				continue
		return nperim

	func add_point(point: Vector2) -> void:
		if point in points:
			return
		var nperim: int = 4
		for dir in DIRS:
			if point + dir in points:
				nperim -= 1
		perim += nperim
