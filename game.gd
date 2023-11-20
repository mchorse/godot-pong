extends Node2D

var ballVelocity = Vector2(-5, 5)
var meScore = 0
var youScore = 0

func _ready():
	pass

func _update_score():
	$HUD/Control/Score.text = "%d | %d" % [meScore, youScore]

func _reset_ball(size, is_player):
	$Ball.position.x = size.x / 2
	$Ball.position.y = size.y / 2
	ballVelocity.x = 5 * (-1 if randf() < 0.5 else 1)
	ballVelocity.y = 0
	
	if is_player:
		youScore += 1
	else:
		meScore += 1
	
	_update_score()

func _physics_process(delta):
	$Ball.position += ballVelocity
	
	var size = get_viewport().get_visible_rect().size
	var w = $Ball.get_rect().size.x
	var y = $Ball.position.y
	var x = $Ball.position.x
	
	# Resets the ball size
	if x < -w * 2 or x > size.x + w * 2:
		_reset_ball(size, x < -w * 2)
	
	# Bounces off the edge vertically
	if y < w / 2 or y > size.y - w / 2:
		ballVelocity.y *= -1
	
	_handle_paddle_collision($PlayerPaddle)
	_handle_paddle_collision($NPCPaddle)
	_move_paddles(delta)

func _move_paddles(delta):
	var mouse = get_viewport().get_mouse_position()
	
	$PlayerPaddle.position.y = lerp($PlayerPaddle.position.y, mouse.y, 0.05)
	$NPCPaddle.position.y = lerp($NPCPaddle.position.y, $Ball.position.y, 0.05)
	
func _handle_paddle_collision(paddle: Sprite2D):
	var ball_rect: Rect2 = $Ball.get_rect()
	var paddle_rect: Rect2 = paddle.get_rect()
	
	ball_rect.position += $Ball.position
	paddle_rect.position += paddle.position
	
	if paddle_rect.intersects(ball_rect):
		ballVelocity.x *= -1
		ballVelocity.y = (paddle_rect.get_center().y - ball_rect.get_center().y) / (paddle_rect.size.y / 2) * -5
		ballVelocity *= 1.1
