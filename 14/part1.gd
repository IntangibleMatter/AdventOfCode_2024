#!/usr/bin/env -S godot --headless -s
extends SceneTree

var robots: Array[Robot]

var regex: RegEx

# demo input
#var gridsize: Vector2 = Vector2(11, 7)
# full input
var gridsize: Vector2 = Vector2(101, 103)

var map: Array[String]


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	regex = RegEx.create_from_string("p=(-?\\d+),(-?\\d+) v=(-?\\d+),(-?\\d+)")
	var fstring := f.get_as_text().split("\n", false)
	prints("gridsize", gridsize)
	for txt in fstring:
		var vals := regex.search(txt)
		#prints("TXT", txt)
		prints("VALS", txt, vals, vals.strings)
		robots.append(
			Robot.new(
				Vector2(vals.strings[1].to_int(), vals.strings[2].to_int()),
				Vector2(vals.strings[3].to_int(), vals.strings[4].to_int()),
				gridsize
			)
		)

	var mstring := ""
	for i in gridsize.x:
		mstring += "0"
	mstring[int(gridsize.x) / 2] = " "
	for i in gridsize.y:
		map.append(mstring)
	map[int(gridsize.y) / 2] = map[int(gridsize.y) / 2 + 1].replace("0", " ")

	for robot in robots:
		for i in 100:
			robot.move()

	var quadrants: Array[int] = [0, 0, 0, 0, 0]
	var centre: Vector2i = gridsize / 2 + Vector2.ZERO
	print(centre)
	for robot in robots:
		map[robot.position.y][robot.position.x] = str(
			map[robot.position.y][robot.position.x].to_int() + 1
		)
		print("ROBOT", robot.position)
		if robot.position.x < centre.x:
			if robot.position.y < centre.y:
				print("Q0")
				quadrants[0] += 1
				continue
			elif robot.position.y > centre.y:
				print("q1")
				quadrants[1] += 1
				continue
		elif robot.position.x > centre.x:
			if robot.position.y < centre.y:
				print("q2")
				quadrants[2] += 1
				continue
			elif robot.position.y > centre.y:
				print("q3")
				quadrants[3] += 1
				continue
		quadrants[4] += 1
		print("NO quad")
	for line in map:
		print(line)

	print("Safety factor:")
	prints(quadrants)
	print(quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3])

	quit()


class Robot:
	extends RefCounted
	var gridsize: Vector2
	var velocity: Vector2
	var position: Vector2

	func _init(pos: Vector2, vel: Vector2, gsize: Vector2) -> void:
		position = pos
		velocity = vel
		gridsize = gsize
		prints("\tROBOT", pos, vel, gsize)

	func move() -> void:
		position += velocity
		if position.x < 0:
			position.x += gridsize.x
			#prints("xpos+", position.x)
		elif position.x >= gridsize.x:
			position.x -= gridsize.x
			#prints("xpos-", position.x)
		if position.y < 0:
			position.y += gridsize.y
			#prints("ypos+", position.x)
		elif position.y >= gridsize.y:
			position.y -= gridsize.y
			#prints("ypos-", position.x)
