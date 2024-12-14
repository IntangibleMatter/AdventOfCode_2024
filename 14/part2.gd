#!/usr/bin/env -S godot --headless -s
extends SceneTree

var robots: Array[Robot]

var regex: RegEx

var savedimgs: int = 0
#var uid: String = ResourceUID.id_to_text(int(Time.get_unix_time_from_system())).replace("uid://", "")
const userpath := "user://day14/imgs/"
const imgpath := userpath + "{0}.png"

# demo input
#var gridsize: Vector2 = Vector2(11, 7)
# full input
var gridsize: Vector2 = Vector2(101, 103)

var map: Array[String]


func updatemap() -> void:
	map.clear()
	var mstring := ""
	for i in gridsize.x:
		mstring += "0"
	mstring[int(gridsize.x) / 2] = " "
	for i in gridsize.y:
		map.append(mstring)

	for robot in robots:
		map[robot.position.y][robot.position.x] = str(
			map[robot.position.y][robot.position.x].to_int() + 1
		)
	map[int(gridsize.y) / 2] = map[int(gridsize.y) / 2 + 1].replace("0", " ")

	for i in map.size():
		map[i] = map[i].replace("0", ".")

	maptoimage()


func maptoimage() -> void:
	if not DirAccess.dir_exists_absolute(userpath):
		DirAccess.make_dir_recursive_absolute(userpath)
	var img := Image.create(int(gridsize.x), int(gridsize.y), false, Image.FORMAT_RGB8)
	img.fill(Color.BLACK)
	for y in map.size():
		for x in map[y].length():
			var col := Color.BLACK
			match map[y][x]:
				"1":
					col = Color.DARK_GREEN
				"2":
					col = Color.FOREST_GREEN
				"3":
					col = Color.LAWN_GREEN
				"4":
					col = Color.GREEN_YELLOW
				"5":
					col = Color.ROYAL_BLUE
				"6":
					col = Color.DODGER_BLUE
				"7":
					col = Color.DEEP_SKY_BLUE
				"8":
					col = Color.DARK_RED
				"9":
					col = Color.RED
				"0", ".", " ":
					col = Color.BLACK
				_:
					col = Color.FUCHSIA
			img.set_pixel(x, y, col)
	img.resize(gridsize.x * 6, gridsize.y * 6, Image.INTERPOLATE_NEAREST)
	var err := img.save_png(imgpath.format([savedimgs]))
	prints("saved img", err, imgpath.format([savedimgs]))
	savedimgs += 1


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	regex = RegEx.create_from_string("p=(-?\\d+),(-?\\d+) v=(-?\\d+),(-?\\d+)")
	var fstring := f.get_as_text().split("\n", false)
	prints("gridsize", gridsize)
	for txt in fstring:
		var vals := regex.search(txt)
		robots.append(
			Robot.new(
				Vector2(vals.strings[1].to_int(), vals.strings[2].to_int()),
				Vector2(vals.strings[3].to_int(), vals.strings[4].to_int()),
				gridsize
			)
		)

	updatemap()

	for i in 10000:
		for robot in robots:
			robot.move()
		updatemap()

	updatemap()

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

	func move() -> void:
		position += velocity
		if position.x < 0:
			position.x += gridsize.x
		elif position.x >= gridsize.x:
			position.x -= gridsize.x
		if position.y < 0:
			position.y += gridsize.y
		elif position.y >= gridsize.y:
			position.y -= gridsize.y
