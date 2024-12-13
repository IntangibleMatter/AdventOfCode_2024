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
				regions[map[y][x]][-1].calculate(Vector2(x, y))

	var sum: int = 0
	for r in regions:
		for region in regions[r]:
			#prints(r, region.points, "\t\tcost:", region.get_cost())
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
	var sides: int = 0
	var bounds: Rect2i
	# Vector2:int
	var perim: Dictionary

	#var cost: int:
	func get_cost() -> int:
		#prints("Area:", area, "perim:", perim)
		return area * sides

	func _init(ntype: String, nmap: Array[String]) -> void:
		map = nmap
		type = ntype

	func calculate(start: Vector2) -> void:
		flood_fill(start)
		bounds = calculate_bounds()
		sides = calculate_sides()
		#prints(type, sides, bounds)

	func flood_fill(from: Vector2) -> void:
		if not from in points:
			points.append(from)
			#perim += get_perim_at_point(from)
		var stack: Array[Vector2] = [from]

		while stack:
			#prints("Stack", type, stack)
			var cloc: Vector2 = stack.pop_back()
			for d in DIRS:
				var ndir: Vector2 = cloc + d
				if ndir.y < 0 or ndir.y >= map.size():
					continue
				elif ndir.x < 0 or ndir.x >= map[ndir.y].length():
					continue
				if map[ndir.y][ndir.x] == type and not ndir in points:
					var point_perim := get_perim_at_point(ndir)
					if point_perim:
						perim[ndir] = point_perim
					points.append(ndir)
					stack.push_back(ndir)

	func calculate_sides() -> int:
		prints("calculating sides for", type, "in box", bounds)
		var sidecount: int = 0
		# left side
		#prints("--------left")
		for x in range(bounds.position.x - 1, bounds.position.x + bounds.size.x):
			var on_side: bool = false
			for y in range(bounds.position.y - 1, bounds.position.y + bounds.size.y):
				#prints(
				#	map[y][x] if x > 0 and x < map[y].length() else "_",
				#	map[y][x + 1] if x + 1 > 0 and x + 1 < map[y].length() else "_"
				#)
				if not Vector2(x, y) in points and Vector2(x + 1, y) in points:
					#prints("on side", x, y, x + 1, y)
					on_side = true
				else:
					#prints("off side", x, y)
					if on_side:
						sidecount += 1
						on_side = false
			if on_side:  # account for end
				sidecount += 1
			#print(sidecount)

		#prints("-----------right")
		for x in range(bounds.position.x, bounds.position.x + bounds.size.x + 1):
			var on_side: bool = false
			for y in range(bounds.position.y - 1, bounds.position.y + bounds.size.y):
				#prints(
				#	map[y][x] if x > 0 and x < map[y].length() else "_",
				#	map[y][x - 1] if x - 1 > 0 and x - 1 < map[y].length() else "_"
				#)
				if not Vector2(x, y) in points and Vector2(x - 1, y) in points:
					#prints("on side", x, y, x - 1, y)
					on_side = true
				else:
					#prints("off side", x, y)
					if on_side:
						sidecount += 1
						on_side = false
			if on_side:  # account for end
				sidecount += 1
			#print(sidecount)

		#print("-------------top")
		for y in range(bounds.position.y - 1, bounds.position.y + bounds.size.y):
			var on_side: bool = false
			for x in range(bounds.position.x - 1, bounds.position.x + bounds.size.x):
				#prints(
				#	map[y][x] if y > 0 and y < map.size() else "_",
				#	map[y + 1][x] if y + 1 > 0 and y + 1 < map.size() else "_"
				#)
				if not Vector2(x, y) in points and Vector2(x, y + 1) in points:
					#prints("on side", x, y, x, y + 1)
					on_side = true
				else:
					#prints("off side", x, y)
					if on_side:
						sidecount += 1
						on_side = false
			if on_side:  # account for end
				sidecount += 1
			#print(sidecount)

		#print("----------bottom")
		for y in range(bounds.position.y, bounds.position.y + bounds.size.y + 1):
			var on_side: bool = false
			for x in range(bounds.position.x - 1, bounds.position.x + bounds.size.x):
				#prints(
				#	map[y][x] if y > 0 and y < map.size() else "_",
				#	map[y - 1][x] if y - 1 > 0 and y - 1 < map.size() else "_"
				#)
				if not Vector2(x, y) in points and Vector2(x, y - 1) in points:
					#prints("on side", x, y, x, y - 1)
					on_side = true
				else:
					#prints("off side", x, y)
					if on_side:
						sidecount += 1
						on_side = false
			if on_side:  # account for end
				sidecount += 1
			#print(sidecount)

		return sidecount

	func calculate_bounds() -> Rect2i:
		var points_as_array: Array[Vector2]
		points_as_array.assign(points)
		var top: int = (
			Array(points)
			. map(func(i) -> int: return int(i.y))
			. reduce(func(a, b) -> int: return min(a, b))
		)
		var left: int = (
			Array(points)
			. map(func(i) -> int: return int(i.x))
			. reduce(func(a, b) -> int: return min(a, b))
		)
		var bottom: int = (
			Array(points)
			. map(func(i) -> int: return int(i.y))
			. reduce(func(a, b) -> int: return max(a, b))
		)
		var right: int = (
			Array(points)
			. map(func(i) -> int: return int(i.x))
			. reduce(func(a, b) -> int: return max(a, b))
		)
		return Rect2i(left, top, right - left + 1, bottom - top + 1)

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

	"""
	func add_point(point: Vector2) -> void:
		if point in points:
			return
		var nperim: int = 4
		for dir in DIRS:
			if point + dir in points:
				nperim -= 1
		#perim += nperim
	"""
