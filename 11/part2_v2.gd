#!/usr/bin/env -S godot --headless -s
extends SceneTree

const DEPTH := 75
var stones: PackedInt64Array
var stonecount: int = 0


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)

	for i in f.get_as_text().split(" "):
		stones.append(int(i))

	for i in stones:
		process_stones(PackedInt64Array([i]), 0)
	print(stonecount)

	quit()


func process_stones(nstones: PackedInt64Array, cdepth: int) -> void:
	prints("processing", cdepth, "\t---", nstones.size(), "\t", stonecount)
	if cdepth >= DEPTH:
		stonecount += nstones.size()
		return
	var newstones: PackedInt64Array = []
	for i in nstones:
		if i == 0:
			newstones.append(1)
		elif str(i).length() % 2 == 0:
			var nst := str(i)
			newstones.append(int(nst.substr(0, nst.length() / 2)))
			newstones.append(int(nst.substr(nst.length() / 2)))
		else:
			newstones.append(i * 2024)

	#print(newstones)
	if newstones.size() > 1024:
		for i in newstones:
			process_stones(PackedInt64Array([i]), cdepth + 1)
	else:
		process_stones(newstones, cdepth + 1)
