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


# Called when the node enters the scene tree for the first time.
func _ready():
	$Dish.texture = load('images/food/' + food_files.pick_random())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
