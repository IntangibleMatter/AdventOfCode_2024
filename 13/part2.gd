#!/usr/bin/env -S godot --headless -s
extends SceneTree

var pmachines: Array[PrizeMachine]


func _init() -> void:
	var f := FileAccess.open("./demoin.txt", FileAccess.READ)

	var na: Vector2i
	var nb: Vector2i
	var np: Vector2i
	var re_x := RegEx.create_from_string("X\\+?=?(\\d+)")
	var re_y := RegEx.create_from_string("Y\\+?=?(\\d+)")
	while not f.eof_reached():
		var line := f.get_line()
		prints(line)
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
				int(re_x.search(line).strings[1]) + 10000000000000,
				int(re_y.search(line).strings[1]) + 10000000000000,
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

	func find_any_diophine(a: int, b: int, c: int) -> Vector2i:
		var g := gcd(a, b)
		if c % g:
			return Vector2i.ZERO
		return Vector2i(a * (c / g), b * (c / g))

	func shifted_solution(x: int, y: int, a: int, b: int, cnt: int) -> Vector2i:
		return Vector2i(x + cnt * b, y - cnt * a)

	func find_all_diophine(a: int, b: int, c: int) -> Array[Vector2i]:
		var any := find_any_diophine(a, b, c)
		var solutions: Array[Vector2i]

		if any == Vector2i.ZERO:
			return []

		var g := gcd(a, b)
		var sol: Vector2i

		a /= g
		b /= g

		return [Vector2i.ZERO]

	func calculate_cost() -> int:
		var gcom: Vector2i = Vector2i(gcd(abutton.x, bbutton.x), gcd(abutton.y, bbutton.y))
		prints("X", prize.x % gcom.x, "Y", prize.y % gcom.y)
		if (prize.x % gcom.x) != 0:
			prints("xxxNo solution for", gcom, abutton, bbutton, prize, prize.x % gcom.x)
			return 0
		elif (prize.y % gcom.y) != 0:
			prints("yyyNo solution for", gcom, abutton, bbutton, prize, prize.y % gcom.y)
			return 0
		prints("\tpossible solution for", abutton, bbutton, prize, "searching....")

		var lowest: int = 1 << 20
		var acount: int = 0
		var bcount: int = 0

		var loopcount: int = max(
			prize.x / abutton.x, prize.x / bbutton.x, prize.y / abutton.y, prize.y / bbutton.y
		)
		for a in loopcount:
			prints("a", a, "\t", abutton, bbutton, prize)
			for b in loopcount:
				prints("b", b, "\t", abutton, bbutton, prize)
				var calced: Vector2i = a * abutton + b * bbutton
				if calced.x > prize.x or calced.y > prize.y:
					print(":(")
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
