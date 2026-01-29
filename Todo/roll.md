```gd
extends CharacterBody2D

# 角色状态枚举
enum PlayerState {
    NORMAL,      # 正常状态
    ROLLING,     # 翻滚中
    ATTACKING    # 攻击中（如果有）
}

# 导出变量，方便在编辑器中调整
@export var walk_speed := 200.0
@export var roll_speed := 400.0
@export var roll_duration := 0.5  # 翻滚持续时间（秒）

# 状态变量
var current_state = PlayerState.NORMAL
var roll_timer := 0.0
var roll_direction := Vector2.DOWN  # 默认翻滚方向

# 节点引用
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape = $CollisionShape2D

func _ready():
    # 连接动画结束信号
    animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
    match current_state:
        PlayerState.NORMAL:
            handle_normal_state(delta)
        PlayerState.ROLLING:
            handle_rolling_state(delta)

func handle_normal_state(delta):
    # 获取输入方向
    var input_direction = Vector2.ZERO
    input_direction.x = Input.get_axis("move_left", "move_right")
    input_direction.y = Input.get_axis("move_up", "move_down")

    # 标准化输入方向（防止对角线移动更快）
    if input_direction.length() > 0:
        input_direction = input_direction.normalized()

    # 更新速度
    velocity = input_direction * walk_speed

    # 移动角色
    move_and_slide()

    # 播放行走/站立动画
    update_animation(input_direction)

    # 检查翻滚输入
    if Input.is_action_just_pressed("roll") and input_direction.length() > 0:
        start_roll(input_direction)

func handle_rolling_state(delta):
    # 更新计时器
    roll_timer -= delta

    # 翻滚结束
    if roll_timer <= 0:
        end_roll()
        return

    # 翻滚期间保持移动
    velocity = roll_direction * roll_speed
    move_and_slide()

    # 可选：翻滚期间缩小碰撞体（模拟蜷缩动作）
    # collision_shape.scale = Vector2(0.8, 0.6)

func start_roll(direction: Vector2):
    # 切换到翻滚状态
    current_state = PlayerState.ROLLING
    roll_direction = direction.normalized()
    roll_timer = roll_duration

    # 播放翻滚动画
    animation_player.play("roll")

    # 可选：禁用正常状态下的碰撞层（实现无敌帧）
    # set_collision_layer_value(1, false)  # 第1层（玩家层）
    # set_collision_mask_value(2, false)   # 不检测敌人层（第2层）

    # 可选：播放音效
    # $RollSound.play()

func end_roll():
    # 回到正常状态
    current_state = PlayerState.NORMAL
    velocity = Vector2.ZERO

    # 恢复碰撞体大小
    # collision_shape.scale = Vector2(1.0, 1.0)

    # 恢复碰撞层
    # set_collision_layer_value(1, true)
    # set_collision_mask_value(2, true)

func update_animation(direction: Vector2):
    if direction.length() > 0:
        # 更新精灵朝向
        if abs(direction.x) > 0.1:
            sprite.flip_h = direction.x < 0

        # 播放行走动画
        animation_player.play("walk")
    else:
        animation_player.play("idle")

func _on_animation_finished(anim_name):
    # 如果翻滚动画结束，强制结束翻滚状态
    if anim_name == "roll" and current_state == PlayerState.ROLLING:
        end_roll()

# 检测是否在翻滚中（供其他脚本使用）
func is_rolling() -> bool:
    return current_state == PlayerState.ROLLING
```
