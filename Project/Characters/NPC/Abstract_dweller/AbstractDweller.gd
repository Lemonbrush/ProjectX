extends KinematicBody2D
class_name AbstractDweller

enum State { IDLE, WALKING, TALKING, ACTING, CUSTOME }
enum Direction { LEFT = 1, RIGHT = -1 }

export(String) var dialogId
export (Resource) var voice_generator_configuration_file
export(Array, Resource) var actions
export(Resource) var currentState 
export var currentActionIndex = 0
export(bool) var watch_player_on_talk = true
export(String) var custome_animation
export(bool) var is_player_interaction_active = true
export(bool) var custom_animations_behavior = false

export(Direction) var defaultDirection = Direction.LEFT

onready var waitTimer = $WaitTimer
onready var actTimer = $ActTimer
onready var body = $Body
onready var interactionController = $Body/InteractionController
onready var animationPlayer = $AnimationPlayer
onready var dialogTextBoxController = $DialogTextBoxController
onready var interactionPopup = $InteractionPopup

var is_state_new = true

var velocity = Vector2.ZERO
var gravity = 500

func _ready():
	dialogTextBoxController.set_dialog_id(dialogId)
	dialogTextBoxController.set_letter_sounds_resource(voice_generator_configuration_file)
	
	if !actions:
		var idleAction = IdleNpcAction.new()
		idleAction.is_infinite = true
		actions = [idleAction]
		
	currentState = actions[currentActionIndex]
	
	interactionController.connect("on_interact", self, "on_npc_interact")
	interactionController.connect("on_approach", self, "on_npc_approach")
	interactionController.connect("on_leave", self, "finish_talking")
	waitTimer.connect("timeout", self, "wait_timer_timeout")
	actTimer.connect("timeout", self, "act_timer_timeout")
	
	#textBoxPopup.connect("dialogueFinished", self, "finish_talking")

func _process(delta):
	if !animationPlayer.current_animation:
		set_animation_with_state(currentState.state)
	
	match currentState.state:
		State.IDLE:
			process_idle(delta, currentState.wait_time, currentState.is_infinite)
		State.WALKING:
			process_walking(delta, currentState.target_x_position, currentState.move_speed)
		State.TALKING:
			process_talking(delta)
		State.ACTING:
			process_acting(delta)
		State.CUSTOME:
			process_custome_animation(delta)

func reset_state():
	currentActionIndex = 0
	currentState = actions[currentActionIndex]
	is_state_new = true
	
func setup_custome_animation(animation_name):
	var customeAction = NpcAction.new()
	customeAction.state = State.CUSTOME
	custome_animation = animation_name
	currentState = customeAction
	is_state_new = true
			
func setupNextAction():
	currentActionIndex += 1
	
	if currentActionIndex >= actions.size() || !actions[currentActionIndex]:
		currentActionIndex = 0
		
	currentState = actions[currentActionIndex]

	set_animation_with_state(currentState.state)
	is_state_new = true

### Walking

func process_walking(delta, targetXPosition, speed):
	if is_state_new:
		set_animation_with_state(currentState.state)
		is_state_new = false
		
	var direction = position.direction_to(Vector2(targetXPosition,0))
	direction.x = sign(direction.x)
	
	body.scale.x = direction.x
	
	velocity.y += gravity * delta	
	velocity.x = (direction * speed).x
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if targetXPosition > position.x - 1 && targetXPosition < position.x + 1:
		setupNextAction()

### Idle

func process_idle(delta, wait_time, is_infinite):
	if is_state_new:
		is_state_new = false
		
		if !is_infinite && wait_time > 0:
			waitTimer.wait_time = wait_time
			waitTimer.start()
	
	process_still(delta)

func wait_timer_timeout():
	setupNextAction()

### Talking

func process_talking(delta):
	if is_state_new:
		set_animation_with_state(State.TALKING)
		is_state_new = false
		waitTimer.paused = true
	
	process_still(delta)

func finish_talking():
	interactionPopup.hide()
	if currentState.state != State.CUSTOME:
		currentState = actions[currentActionIndex]
		set_animation_with_state(currentState.state)
		waitTimer.paused = false
		body.scale.x = defaultDirection

func on_npc_approach(_body):
	if is_player_interaction_active:
		interactionPopup.show()

func on_npc_interact(interactedBody):
	interactionPopup.hide()
	if currentState.state != State.TALKING && currentState.state != State.CUSTOME && is_player_interaction_active:
		is_state_new = true
		currentState = TalkNpcAction.new()
		
		if watch_player_on_talk:
			body.scale.x = 1 if interactedBody.position.x > position.x else -1

### Acting

func process_custome_animation(delta):
	if is_state_new:
		if animationPlayer.has_animation(custome_animation):
			animationPlayer.play(custome_animation)
		else:
			animationPlayer.stop()
		is_state_new = false
	
	process_still(delta)

func process_acting(delta):
	if is_state_new:
		is_state_new = false
		actTimer.start()
	
	process_still(delta)

func act_timer_timeout():
	setupNextAction()

### Helpers

func hide_popup():
	interactionPopup.hide()

func instant_hide_dialog():
	hide_popup()
	dialogTextBoxController.instant_hide()

func process_still(delta):
	velocity.y += gravity * delta
	velocity.x = 0
	velocity = move_and_slide(velocity, Vector2.UP)
	
func set_animation_with_state(state):	
	match state:
		State.IDLE:
			animationPlayer.play("Idle")
		State.WALKING:
			animationPlayer.play("Walk")
		State.TALKING:
			if animationPlayer.has_animation("Talking"):
				animationPlayer.play("Talking")
			else:
				animationPlayer.play("Idle")
		State.ACTING:
			animationPlayer.play("Act")
		State.CUSTOME:
			if animationPlayer.has_animation(custome_animation):
				animationPlayer.play(custome_animation)

func set_interaction_mode(can_interact: bool):
	is_player_interaction_active = can_interact
	dialogTextBoxController.setup_interaction_mode(can_interact)
