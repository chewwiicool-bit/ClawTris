extends Resource
class_name TetrominoData

enum Type { I, J, L, O, S, T, Z }

@export var type: Type
@export var cells: Array[Vector2i]
@export var color: Color

const DATA = {
	Type.I: {
		"cells": [Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0)],
		"color": Color(0, 1, 1, 2) # Neon Cyan
	},
	Type.J: {
		"cells": [Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
		"color": Color(0, 0.5, 1, 2)
	},
	Type.L: {
		"cells": [Vector2i(1, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
		"color": Color(1, 0.5, 0, 2)
	},
	Type.O: {
		"cells": [Vector2i(0, -1), Vector2i(1, -1), Vector2i(0, 0), Vector2i(1, 0)],
		"color": Color(1, 1, 0, 2)
	},
	Type.S: {
		"cells": [Vector2i(0, -1), Vector2i(1, -1), Vector2i(-1, 0), Vector2i(0, 0)],
		"color": Color(0, 1, 0, 2)
	},
	Type.T: {
		"cells": [Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
		"color": Color(1, 0, 1, 2) # Neon Magenta
	},
	Type.Z: {
		"cells": [Vector2i(-1, -1), Vector2i(0, -1), Vector2i(0, 0), Vector2i(1, 0)],
		"color": Color(1, 0, 0, 2)
	}
}
