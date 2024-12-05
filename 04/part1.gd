#!/usr/bin/env -S godot --headless -s
extends SceneTree

var ws: Array[String]
var count: int = 0

var display: Array[String]


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	ws.assign(Array(f.get_as_text().split("\n")))

	ws.pop_back()
	#print(ws)

	for i in ws.size():
		var nst: String = ""
		for j in ws[i].length():
			nst += "."
		display.append(nst)

	for y in ws.size():
		#prints("\n----\nchecking y", y, ws[y])
		for x in ws[y].length():
			#prints("checking x", x, ws[y][x])
			if ws[y][x] == "X":
				prints("checking at", x, y)
				var checked := check_at(x, y)
				count += checked
				display[y][x] = str(checked)

	print(count)
	print("----")
	for line in display:
		print(line)
	quit()


func check_at(x: int, y: int) -> int:
	var sum := 0

	for i in range(-1, 2):
		if y + (i * 3) < 0 or y + (i * 3) >= ws.size():
			#prints("Skipping y", y + i, "due to out of bounds")
			continue
		for j in range(-1, 2):
			if x + (j * 3) < 0 or x + (j * 3) >= ws[y + i].length():
				#prints("Skipping x, y", x + j, y + i, "due to x out of range")
				continue
			if ws[y + i][x + j] == "M":
				prints("XM from", x, y, "to", x + j, y + i)
				if ws[y + (i * 2)][x + (j * 2)] == "A":
					prints("XMA from", x, y, "to", x + j * 2, y + i * 2)
					if ws[y + (i * 3)][x + j * 3] == "S":
						prints("Found match from", x, y, "to", x + j * 3, y + i * 3)
						sum += 1

			#prints("Char at", y + i, x + j, "is", ws[y + i][x + j])

	return sum
