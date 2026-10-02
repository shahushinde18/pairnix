extends Node

# --- Replace these with your actual IDs from AdMob ---
const BANNER_UNIT_ID: String = "ca-app-pub-6795524737669539/7086233159"
const INTERSTITIAL_UNIT_ID: String = "ca-app-pub-6795524737669539/6492085218"

# Google's official test unit IDs (USE THESE WHILE TESTING):
const TEST_BANNER_ID: String = "ca-app-pub-3940256099942544/6300978111"
const TEST_INTERSTITIAL_ID: String = "ca-app-pub-3940256099942544/1033173712"

# Set to true while testing in editor or local device debug builds:
@export var is_test_mode: bool = false

var ad_view: AdView
var interstitial_ad: InterstitialAd
var _interstitial_callback: InterstitialAdLoadCallback
var _init_listener: OnInitializationCompleteListener
var _is_initialized: bool = false

var game_count: int = 0

func _ready() -> void:
	# 1. Setup Interstitial Callback handlers
	_interstitial_callback = InterstitialAdLoadCallback.new()
	_interstitial_callback.on_ad_loaded = func(ad: InterstitialAd):
		print("AdMob: Interstitial loaded successfully.")
		interstitial_ad = ad
	
	_interstitial_callback.on_ad_failed_to_load = func(error: LoadAdError):
		print("AdMob: Interstitial failed to load: ", error.message)
		interstitial_ad = null

	# 2. Setup initialization listener
	_init_listener = OnInitializationCompleteListener.new()
	_init_listener.on_initialization_complete = func(status: InitializationStatus):
		print("AdMob: SDK initialized successfully.")
		_is_initialized = true
		load_interstitial()

	# 3. Initialize Google Mobile Ads SDK with the listener
	MobileAds.initialize(_init_listener)


# ==================== BANNER LOGIC ====================

func show_banner() -> void:
	if ad_view != null:
		ad_view.destroy()
		ad_view = null

	var unit_id = TEST_BANNER_ID if is_test_mode else BANNER_UNIT_ID
	
	# Banner at bottom
	ad_view = AdView.new(unit_id, AdSize.BANNER, AdPosition.BOTTOM)
	ad_view.load_ad(AdRequest.new())

func hide_banner() -> void:
	if ad_view != null:
		ad_view.destroy()
		ad_view = null

# ================= INTERSTITIAL LOGIC =================

func load_interstitial() -> void:
	# Guard clause: prevent loading before SDK is fully initialized
	if not _is_initialized and not MobileAds.get_initialization_status():
		print("AdMob: Waiting for SDK to initialize before loading interstitial.")
		return

	var unit_id = TEST_INTERSTITIAL_ID if is_test_mode else INTERSTITIAL_UNIT_ID
	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), _interstitial_callback)

func show_interstitial() -> void:
	game_count += 1
	
	# Only display after the 2nd time played (game 2, 4, 6, etc.)
	if game_count % 2 == 0:
		if interstitial_ad != null:
			interstitial_ad.show()
			# Preload the next one immediately after showing
			interstitial_ad = null
			load_interstitial()
		else:
			print("AdMob: Interstitial not ready yet.")
			load_interstitial()
	else:
		print("AdMob: Skipping interstitial for game #", game_count)
