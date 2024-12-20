#!/usr/bin/env -S godot --headless -s
extends SceneTree

var map: Array[String]
var goal: Vector2
var start: Vector2

const DIRS: Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
const ROTATE_COST := 1000
const STEP_COST := 1


func _init() -> void:
	var f := FileAccess.open("./demoin.txt", FileAccess.READ)
	map.assign(f.get_as_text().split("\n", false))
	mapgen()
	var cost := pathfind()
	prints("COST:")
	print(cost)
	quit()


func mapgen() -> void:
	for y in map.size():
		for x in map[y].length():
			if map[y][x] == "S":
				start = Vector2(x, y)
			elif map[y][x] == "E":
				goal = Vector2(x, y)
		if goal != Vector2.ZERO and start != Vector2.ZERO:
			break
	pass


# RedBlobGames is my GOAT
func pathfind() -> float:
	#var explored: Dictionary = {[start, Vector2.RIGHT]: 0}
	# [point, cost, direction, came from]
	var frontier: Array[Array] = [[start, 0, Vector2.RIGHT, start]]
	# point: {camefrom_point: cost}
	var came_from: Dictionary = {start: {start: 0}}
	while not frontier.is_empty():
		sort_priority_queue(frontier)
		var currdata: Array = frontier.pop_front()
		var currpos: Vector2 = currdata[0]
		var currcost: int = currdata[1]
		var currdir: Vector2 = currdata[2]
		var currfrom: Vector2 = currdata[3]
		for next in get_valid_moves_at(currpos, currfrom):
			var ncost: int = currcost + get_move_cost(currpos, next, currdir)
			var costdata: Dictionary = came_from.get_or_add(next, {})
			if costdata.get_or_add(currpos, ncost) > ncost:
				costdata[currpos] = ncost

	return 0


func print_path(point: Vector2, history: Dictionary) -> void:
	var nmap := map.duplicate()
	var node := point
	nmap[node.y][node.x] = "O"
	#node = history[node]
	while history.get(node) != start:
		node = history.get(node)
		nmap[node.y][node.x] = "ﾂ"
	prints("\nMAP", point)
	for line in nmap:
		print_rich(line.replace("ﾂ", "[color=red]ﾂ[/color]").replace("O", "[color=blue]O[/color]"))
	print("")
	print_rich("[color=red]TEST[/color]")


func get_valid_moves_at(point: Vector2, from: Vector2) -> Array[Vector2]:
	var valid: Array[Vector2]
	for d in DIRS:
		var ndir: Vector2 = point + d
		if ndir == from:
			continue
		if ndir.y < 0 or ndir.y >= map.size():
			continue
		if ndir.x < 0 or ndir.x >= map[ndir.y].length():
			continue
		if map[ndir.y][ndir.x] != "#":
			valid.append(ndir)
	return valid


func get_move_heuristic(move: Vector2) -> float:
	var adist: Vector2 = abs(move - goal)
	return adist.y + adist.x + 1000.0 if (adist.y != 0 and adist.x != 0) else 0.0


func get_move_cost(from: Vector2, to: Vector2, fromdir: Vector2) -> int:
	if (to - from) == fromdir:
		return STEP_COST  # same direction
	else:
		return abs((from - to).angle()) / (PI / 2) * ROTATE_COST + STEP_COST  # 90degree angle


func sort_priority_queue(queue: Array[Array]) -> void:
	queue.sort_custom(func(a: Array, b: Array) -> bool: return a[1] < b[1])


func order_possible_moves(moves: Array[Vector2], cdir: Vector2) -> void:
	moves.sort_custom(
		func(a: Vector2, b: Vector2) -> bool:
			var acost: float = (
				abs(a - goal).length() + abs(a - start).length() + 1000
				if cdir.x == 0 and a.x != 0
				else 0
			)
			var bcost: float = (
				abs(b - goal).length() + abs(b - start).length() + 1000
				if cdir.x == 0 and b.x != 0
				else 0
			)
			return acost < bcost
	)
