#!/usr/bin/env -S godot --headless -s
extends SceneTree

var pmachines: Array[PrizeMachine]


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)

	var na: Vector2i
	var nb: Vector2i
	var np: PackedInt64Array
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
			#"""
			np = [
				int(re_x.search(line).strings[1]) + 10000000000000,
				int(re_y.search(line).strings[1]) + 10000000000000
			]
			#"""
			#np = [int(re_x.search(line).strings[1]), int(re_y.search(line).strings[1])]
		else:
			pmachines.append(PrizeMachine.new(na, nb, np))
			na = Vector2i.ZERO
			nb = Vector2i.ZERO
			np = []
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
	var prize: PackedInt64Array

	func _init(a: Vector2i, b: Vector2i, ppos: PackedInt64Array) -> void:
		abutton = a
		bbutton = b
		prize = ppos

	# shoutout geeksforgeeks (my beloved)
	static func gcd(a: int, b: int) -> int:  # stein's algorithm
		if a == 0:
			return b
		if b == 0:
			return a

		var k := 0
		while (a | b) & 1 == 0:
			a = a >> 1
			b = b >> 1
			k += 1

		while a & 1 == 0:
			a = a >> 1

		while b != 0:
			while b & 1 == 0:
				b = b >> 1

			if a > b:
				var temp := a
				a = b
				b = temp
			b = b - a

		return a << k

	func gauss_elim(a: PackedFloat64Array, b: PackedFloat64Array) -> PackedFloat64Array:
		# pivot first row
		var a0 := a[0]
		a[0] /= a0
		a[1] /= a0
		a[2] /= a0
		prints("gausselim 0\n", a, "\n", b)

		# eliminate first column
		var b0 := b[0]
		b[0] -= (b0 * a[0])
		b[1] -= (b0 * a[1])
		b[2] -= (b0 * a[2])
		prints("gausselim 1\n", a, "\n", b)

		#pivot second row
		var b1 := b[1]
		b[0] /= b1
		b[1] /= b1
		b[2] /= b1
		prints("gausselim 2\n", a, "\n", b)

		# eliminate second column
		var a1 := a[1]
		a[0] -= (a1 * b[0])
		a[1] -= (a1 * b[1])
		a[2] -= (a1 * b[2])
		prints("gausselim 3\n", a, "\n", b)

		return [a[2], b[2]]

	func calculate_cost() -> int:
		print()
		var gcom: Vector2i = Vector2i(gcd(abutton.x, bbutton.x), gcd(abutton.y, bbutton.y))
		prints("X", prize[0] % gcom.x, "Y", prize[1] % gcom.y)
		if (prize[0] % gcom.x) != 0:
			prints("xxxNo solution for", gcom, abutton, bbutton, prize, prize[0] % gcom.x)
			return 0
		elif (prize[1] % gcom.y) != 0:
			prints("yyyNo solution for", gcom, abutton, bbutton, prize, prize[1] % gcom.y)
			return 0
		prints("\tpossible solution for", abutton, bbutton, prize, "searching....")

		var solution := gauss_elim(
			[abutton.x, bbutton.x, prize[0]], [abutton.y, bbutton.y, prize[1]]
		)

		prints("Solution?", abutton, bbutton, prize, solution)

		if abs(solution[0] - round(solution[0])) < 0.01:
			prints("X VALID")
			if abs(solution[1] - round(solution[1])) < 0.01:
				prints("Y VALID!!!!")
			else:
				solution = [0, 0]
		else:
			solution = [0, 0]

		if solution[0] < 0 or solution[1] < 0:
			prints("Solution negative :(")
			solution = [0, 0]

		var nsolution: PackedInt64Array = [round(solution[0]), round(solution[1])]

		#var lowest: int = 1 << 20
		#var acount: int = 0
		#var bcount: int = 0
		prints("Machine", abutton, bbutton, prize, "\tCosts", nsolution[0] * 3 + nsolution[1] * 1)
		#	prints("Machine", abutton, bbutton, prize, "\tCosts", acount * 3 + bcount * 1)
		return nsolution[0] * 3 + nsolution[1] * 1
