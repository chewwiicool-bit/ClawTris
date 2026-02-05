#!/bin/bash
export GODOT_SILENCE_ROOT_WARNING=1
godot --headless --editor --quit --path .
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/ -ginclude_subdirs -gexit
