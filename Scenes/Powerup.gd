extends Node2D

var food_files = [
"06_apple_pie_dish.png",
"53_gingerbreadman_dish.png",
"08_bread_dish.png",
"56_hotdog_dish.png",
"100_taco_dish.png",
"58_icecream_bowl.png",
"102_waffle_dish.png",
"60_jelly_dish.png",
"10_baguette_dish.png",
"62_jam_dish.png",
"12_bun_dish.png",
"64_lemonpie_dish.png",
"14_bacon_dish.png",
"66_loafbread_dish.png",
"16_burger_dish.png",
"68_macncheese_dish.png",
"19_burrito_dish.png",
"70_meatball_dish.png",
"21_bagel_dish.png",
"72_nacho_dish.png",
"23_cheesecake_dish.png",
"74_omlet_dish.png",
"25_cheesepuff_bowl.png",
"76_pudding_dish.png",
"27_chocolate_dish.png",
"78_potatochips_bowl.png",
"29_cookies_dish.png",
"80_pancakes_dish.png",
"31_chocolatecake_dish.png",
"82_pizza_dish.png",
"33_curry_dish.png",
"84_popcorn_bowl.png",
"35_donut_dish.png",
"86_roastedchicken_dish.png",
"37_dumplings_dish.png",
"87_ramen.png",
"39_friedegg_dish.png",
"89_salmon_dish.png",
"41_eggsalad_bowl.png",
"91_strawberrycake_dish.png",
"43_eggtart_dish.png",
"93_sandwich_dish.png",
"45_frenchfries_dish.png",
"94_spaghetti.png",
"47_fruitcake_dish.png",
"96_steak_dish.png",
"49_garlicbread_dish.png",
"98_sushi_dish.png",
"51_giantgummybear_dish.png"]

var type:GameGlobals.powerupType = GameGlobals.powerupType.DUD

@export var timeToLive = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$Dish.texture = load('images/food/' + food_files.pick_random())
	type = GameGlobals.powerupType.values().pick_random()
	GameGlobals.updateCountdown.connect(updateCountdown)

func updateCountdown():
	timeToLive -= 1
	if(timeToLive < 1):
		queue_free()

func onPlayerTouch(objIn):
	$CollectSound.play()
	match type:
		GameGlobals.powerupType.SCORE:
			GameGlobals.playerScores[objIn.deviceId] += 10
			GameGlobals.updateScore.emit(objIn.deviceId, 10)
			$Label.text = '10 Points'
		GameGlobals.powerupType.DUD:
			$Label.text = 'Bad luck!'
			objIn.handlePowerup(GameGlobals.powerupType.MUD)
		GameGlobals.powerupType.REVERSE_SCORE:
			$Label.text = 'King loser'
			GameGlobals.powerupTrigger.emit(GameGlobals.powerupType.REVERSE_SCORE)
		GameGlobals.powerupType.SPEED_PLAYER:
			$Label.text = 'Need for speed'
			objIn.handlePowerup(GameGlobals.powerupType.SPEED_PLAYER)
		GameGlobals.powerupType.MUD:
			$Label.text = 'Stuck in the mud'
			GameGlobals.powerupTrigger.emit(GameGlobals.powerupType.MUD)
			objIn.stuckBoostSeconds = 0
		GameGlobals.powerupType.TELEPORT:
			$Label.text = 'Suprise!'
			GameGlobals.powerupTrigger.emit(GameGlobals.powerupType.TELEPORT)
			
			
	$Label.visible = true
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Label,"scale",Vector2(5,5),1)
	tween.tween_property($Label,"position",Vector2(-$Label.size.x*2.5,0),1)
	tween.tween_property($Dish,"scale",Vector2(0,0),1)
	tween.connect('finished', self.queue_free)
