#!/usr/bin/env -S godot --headless -s
extends SceneTree

var pmachines: Array[PrizeMachine]


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)

	var na: Vector2i
	var nb: Vector2i
	var np: Vector2i
	var re_x := RegEx.create_from_string("X\\+?=?(\\d+)")
	var re_y := RegEx.create_from_string("Y\\+?=?(\\d+)")
	while not f.eof_reached():
		var line := f.get_line()
		if line.begins_with("Button A"):
			na = Vector2i(
				int(re_x.search(line).strings[1]),
				int(re_y.search(line).strings[1]),
			)
		elif line.begins_with("Button B"):
			nb = Vector2i(
				int(re_x.search(line).strings[1]),
				int(re_y.search(line).strings[1]),
			)
		elif line.begins_with("Prize:"):
			np = Vector2i(
				int(re_x.search(line).strings[1]),
				int(re_y.search(line).strings[1]),
			)
		else:
			pmachines.append(PrizeMachine.new(na, nb, np))
			na = Vector2i.ZERO
			nb = Vector2i.ZERO
			np = Vector2i.ZERO
	if na != Vector2i.ZERO:
		pmachines.append(PrizeMachine.new(na, nb, np))

	var sum: int = 0
	for machine in pmachines:
		sum += machine.calculate_cost()
		prints("sum", sum)
	print(sum)
	quit()


class PrizeMachine:
	extends RefCounted
	var abutton: Vector2i
	var bbutton: Vector2i
	var prize: Vector2i

	func _init(a: Vector2i, b: Vector2i, ppos: Vector2i) -> void:
		abutton = a
		bbutton = b
		prize = ppos

	func calculate_cost() -> int:
		var lowest: int = 1 << 20
		var acount: int = 0
		var bcount: int = 0

		var loopcount: int = 101  #max(
#			prize.x / abutton.x, prize.x / bbutton.x, prize.y / abutton.y, prize.y / bbutton.y
		#	)
		for a in loopcount:
			for b in loopcount:
				var calced: Vector2i = a * abutton + b * bbutton
				if calced.x > prize.x or calced.y > prize.y:
					break
				elif calced == prize:
					prints("found solution:", a, b)
					if lowest > a * 3 + b * 1:
						prints("Improvement!:", a, b)
						lowest = a * 3 + b * 1
						acount = a
						bcount = b
						break
		prints("Machine", abutton, bbutton, prize, "\tCosts", acount * 3 + bcount * 1)
		return acount * 3 + bcount * 1
