extends Resource
class_name TetrominoData

enum Type { I, J, L, O, S, T, Z }

@export var type: Type
@export var cells: Array[Vector2i]
@export var color: Color

const DATA = {
	Type.I: {
		"cells": [Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0)],
		"color": Color.CYAN
	},
	Type.J: {
		"cells": [Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
		"color": Color.BLUE
	},
	Type.L: {
		"cells": [Vector2i(1, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
		"color": Color.ORANGE
	},
	Type.O: {
		"cells": [Vector2i(0, -1), Vector2i(1, -1), Vector2i(0, 0), Vector2i(1, 0)],
		"color": Color.YELLOW
	},
	Type.S: {
		"cells": [Vector2i(0, -1), Vector2i(1, -1), Vector2i(-1, 0), Vector2i(0, 0)],
		"color": Color.GREEN
	},
	Type.T: {
		"cells": [Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
		"color": Color.PURPLE
	},
	Type.Z: {
		"cells": [Vector2i(-1, -1), Vector2i(0, -1), Vector2i(0, 0), Vector2i(1, 0)],
		"color": Color.RED
	}
}
