# Architecture Design: ClawTris

## 1. Overview
Проект ClawTris строится на разделении логики сетки (Grid), управления активной фигурой (Tetromino) и общего состояния игры (Game Manager). Мы используем Godot 4 и GDScript.

## 2. Node Structure (Сцена)

- **Main (Node2D)**: Корневой узел.
    - **GameManager (Node)**: Логика игры (счет, уровни, состояния).
    - **Board (TileMapLayer or Node2D)**: Визуальное отображение сетки и зафиксированных блоков.
    - **ActivePiece (Node2D)**: Текущая управляемая фигура.
    - **Spawner (Node2D)**: Логика и точка появления новых фигур.
    - **UI (CanvasLayer)**: Счет, следующая фигура, экран Game Over.
    - **Timer (Timer)**: Основной тик падения фигур.

## 3. Class Responsibilities

### `GameManager.gd`
- Управление состояниями: `START`, `PLAYING`, `PAUSED`, `GAMEOVER`.
- Подсчет очков и уровней.
- Обработка сигналов от `Board` (например, `lines_cleared`).
- Управление скоростью игры через `Timer`.

### `Board.gd`
- Хранит логическую сетку `10x20` (2D массив или словарь векторов).
- Проверка коллизий: `is_position_valid(cells: Array[Vector2i])`.
- Фиксация фигуры: `lock_piece(cells: Array[Vector2i], color_index: int)`.
- Очистка заполненных линий и смещение верхних блоков вниз.
- Отрисовка зафиксированных блоков.

### `Tetromino.gd` (ActivePiece)
- Хранит текущую форму, поворот и позицию.
- Методы: `move(direction)`, `rotate_clockwise()`, `rotate_counter_clockwise()`.
- Генерирует массив глобальных координат своих блоков для проверки в `Board`.

### `TetrominoData.gd` (Resource)
- Содержит данные о формах (массивы координат) и цветах для всех 7 типов фигур.

### `Spawner.gd`
- Логика "Bag" (рандом без повторений подряд).
- Предпросмотр следующей фигуры.

## 4. Signals & Communication

- `GameManager` -> `ActivePiece`: "Падай вниз по таймеру".
- `ActivePiece` -> `Board`: "Могу ли я переместиться/повернуться сюда?".
- `ActivePiece` -> `Board`: "Я приземлился, зафиксируй меня".
- `Board` -> `GameManager`: "Очищено N линий, добавь очки".
- `Board` -> `GameManager`: "Места для новой фигуры нет (Game Over)".

## 5. Technical Details
- **Coordinate System**: Используем `Vector2i` для работы с ячейками сетки. (0,0) - верхний левый угол.
- **Grid Size**: 10x20.
- **Tile Size**: 32x32 или 40x40 пикселей.
- **Input Map**: `move_left`, `move_right`, `rotate`, `soft_drop`, `hard_drop`.

## 6. Project Structure
- `res://scenes/` (Main.tscn, Board.tscn, Piece.tscn, TouchControls.tscn)
- `res://scripts/` (GameManager.gd, Board.gd, Piece.gd, Spawner.gd, TouchControls.gd)
- `res://resources/` (TetrominoData.gd, piece_data.tres)
- `res://assets/` (Sprites, Sounds, UI)
- `res://tests/` (GUT tests)

## 7. Mobile Adaptation (Android)

### Orientation & UI
- **Portrait Only**: Зафиксировано в `project.godot` (`window/handheld/orientation=1`).
- **Responsive Layout**: Используем Anchors и Containers для адаптации под разные соотношения сторон (от 16:9 до 21:9).
- **Stretch Mode**: `canvas_items` для четкой отрисовки 2D элементов на высоких разрешениях.

### Input
- **TouchScreenButton**: Используется для управления на мобильных устройствах.
- **Action Mapping**: Кнопки привязаны к стандартным `ui_left`, `ui_right`, `ui_up`, `ui_down`, `ui_accept`.
- **Emulate Touch from Mouse**: Включено для тестирования на ПК.

### Performance
- **Renderer**: Mobile (Vulkan Mobile) или Compatibility (OpenGL ES 3.0).
- **FPS**: Ограничение до 60 FPS для экономии заряда батареи.

### Build Requirements
- **JDK**: OpenJDK 17.
- **Android SDK**: Platform 35.
- **Debug Keystore**: Требуется для генерации отладочного APK.
