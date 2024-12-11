#!/usr/bin/env -S godot --headless -s
# shoutout u/TiCoinCoin for the inspiration
extends SceneTree

var stones: Dictionary = {}
var nstones: Dictionary = {}


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)

	for i in f.get_as_text().split(" "):
		stones[int(i)] = 1
	for i in 75:
		process_stones()
		stones = nstones
		nstones = {}
		prints("\tprocessed", i, "/75", "(%2.3f%%)" % (i / 75.0 * 100))
	#print(stones)
	var sum := 0
	for s in stones:
		sum += stones[s]
	print("sum:")
	print(sum)

	quit()


func process_stones() -> void:
	prints("processing stones...\t", stones.size(), "unique stones")
	for i in stones:
		#prints(nstones, stones)
		if i == 0:
			if not nstones.has(1):
				nstones[1] = 0
			nstones[1] += stones[i]
		elif str(i).length() % 2 == 0:
			var nst := str(i)
			var nst1 := int(nst.substr(0, nst.length() / 2))
			var nst2 := int(nst.substr(nst.length() / 2))
			if not nstones.has(nst1):
				nstones[nst1] = 0
			if not nstones.has(nst2):
				nstones[nst2] = 0
			nstones[nst1] += stones[i]
			nstones[nst2] += stones[i]
		else:
			if not nstones.has(i * 2024):
				nstones[i * 2024] = 0
			nstones[i * 2024] += stones[i]
		#print(nstones)

	#print(newstones)
	#stones = newstones
