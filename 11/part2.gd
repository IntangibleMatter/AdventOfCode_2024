#!/usr/bin/env -S godot --headless -s
extends SceneTree

var stones: PackedInt64Array
#var stone_strings: PackedStringArray
var currline: String
#var n_stone_strings: PackedStringArray
#var iof: FileAccess
const tempfilepath := "tempholding.txt"
const prevfilepath := "hold.txt"

var tempfile: FileAccess
var prevfile: FileAccess
var prevfilesize: int = 438780048  # size of hold.txt at end of line 46
var newfilesize: int = 0

const MAX_SIZE := 512


func _init() -> void:
	#write_to_file()
	# commented out because we're picking up at iteration 46
	#var f := FileAccess.open("./input.txt", FileAccess.READ)
	#OS.execute("cp", [f.get_path_absolute(), prevfilepath])

	#for i in f.get_as_text().split(" "):
	#	stones.append(int(i))
	#currline = f.get_as_text()
	for i in range(47, 75):
		tempfile = FileAccess.open(tempfilepath, FileAccess.WRITE)
		prevfile = FileAccess.open(prevfilepath, FileAccess.READ)
		var lineidx := 0
		while not prevfile.eof_reached():
			currline = prevfile.get_line()
			process_stones(read_ints_from_line(currline))
			lineidx += 1
			#prints("\tprocessed: ", line, "/", stone_strings.size(), "(loop %d)" % i)
			prints(
				"\tprocessed",
				lineidx,
				"/",
				prevfilesize,
				"%2.4f%%" % (lineidx / float(prevfilesize) * 100),
				"\t(loop %d)" % i
			)
		prevfilesize = newfilesize
		newfilesize = 0
		#stone_strings = n_stone_strings
		#n_stone_strings = []
		tempfile.close()
		prevfile.close()
		write_to_file()
		prints("done:", i, "/ 75", (i / 75.0) * 100)
	var sum := 0
	prevfile = FileAccess.open(prevfilepath, FileAccess.READ)
	while not prevfile.eof_reached():
		sum += prevfile.get_line().split(" ", false).size()
	#for i in stone_strings:
	#	sum += i.split(" ", false).size()
	print(sum)

	quit()


func read_ints_from_line(line: String) -> PackedInt64Array:
	var out: PackedInt64Array
	for i in line.split(" ", false):
		out.append(int(i))
	return out


func write_to_file() -> void:
	OS.execute("cp", ["/dev/null", prevfilepath])
	OS.execute("cp", [tempfilepath, prevfilepath])
	OS.execute("cp", ["/dev/null", tempfilepath])
	#var file := FileAccess.open(tempfilepath, FileAccess.WRITE)
	#for line in stone_strings:
	#	file.store_line(line)
	#file.close()


"""
func shorten_lines(arr: PackedStringArray) -> PackedStringArray:
	var out: PackedStringArray
	for line in arr:
		var splitline := line.split(" ")
		if splitline.size() < MAX_SIZE:
			out.append(line)
		else:
			var lcount: int = 0
			var nstr := ""
			for i in splitline:
				nstr += i + " "
				lcount += 1
				if lcount > MAX_SIZE:
					lcount = 0
					out.append(nstr)
					nstr = ""
			if not nstr.is_empty():
				out.append(nstr)

	return out
"""


func process_stones(istones: PackedInt64Array) -> void:  # PackedStringArray:
	var newstones: PackedInt64Array = []
	for i in istones:
		#prints(i)
		if i == 0:
			newstones.append(1)
		elif str(i).length() % 2 == 0:
			var nst := str(i)
			newstones.append(int(nst.substr(0, nst.length() / 2)))
			newstones.append(int(nst.substr(nst.length() / 2)))
		else:
			newstones.append(i * 2024)

	#print(newstones)
	var out: PackedStringArray = [""]
	var lcount: int = 0
	for i in newstones:
		lcount += 1
		if lcount > MAX_SIZE:
			out.append("")
		out[-1] += str(i) + " "

	for line in out:
		if line.is_empty():
			continue
		newfilesize += 1
		tempfile.store_line(line)
#	return out
#stones = newstones
