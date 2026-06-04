extends Node2D

# ================= VARIABILE JUCATOR =================
var hp = 100
var cash = 10
var swag = 50
var iq = 50
var floor_level = 0
var story_step = 1
var are_acadea = false 

# ================= IMAGINI =================
var imagine_karen = preload("res://karen.png")
var imagine_vanzator = preload("res://vanzator.png")
var imagine_curier = preload("res://curier.png")
var imagine_femeie = preload("res://femeie.png")
var imagine_fantoma = preload("res://fantoma.png")
var imagine_copil = preload("res://copil.png") 
var npc_curent = "Ghid"

# ================= VARIABILE NPC & SISTEME =================
var item1_nume = ""
var item1_pret = 0
var item2_nume = ""
var item2_pret = 0
var karen_etaje = 0
var karen_extra_etaje = 0
var curier_etaje = 0
var copil_etaje_jos = 0

var istoric_npc = [] 

# ================= VARIABILE PREVIEW =================
var preview_text_a = ""
var preview_text_b = ""
var modul_preview = false 
var se_tine_apasat_a = false
var se_tine_apasat_b = false
var asteapta_ridicare_deget = false 

# ================= FUNCTII DE BAZA =================
func _ready():
	$TextConsecinta.text = ""
	update_ui()
	$LiftInchis.hide()
	$TextDialog.text = "Guide: Hello, are you the new tenant? Welcome to the building!"
	seteaza_butoane("Yes", "Who's asking?", "Start conversation", "Question him")
	story_step = 1

func update_ui():
	hp = clamp(hp, 0, 100)
	swag = clamp(swag, 0, 100)
	iq = clamp(iq, 0, 100)
	
	var text_acadea = "\nLollipop: YES" if are_acadea else "\nLollipop: NO"
	$Label.text = "FLOOR " + str(floor_level)
	$StatsStanga.text = "HP: " + str(hp) + "\nCash: $" + str(cash)
	$StatsDreapta.text = "Swag: " + str(swag) + "\nIQ: " + str(iq) + text_acadea

func aplica_efect_item(nume_item):
	if "Book" in nume_item: iq += 20
	elif "Pill" in nume_item: hp += 10
	elif "Sunglasses" in nume_item: swag += 20
	elif "Lollipop" in nume_item: are_acadea = true

func seteaza_butoane(txt_a, txt_b, prev_a = "", prev_b = ""):
	modul_preview = false
	asteapta_ridicare_deget = false
	$ButtonA.disabled = false
	$ButtonB.disabled = false
	$TextConsecinta.text = ""
	$ButtonA.text = txt_a
	$ButtonA.show()
	preview_text_a = prev_a
	if txt_b == "":
		$ButtonB.hide()
		preview_text_b = ""
	else:
		$ButtonB.text = txt_b
		$ButtonB.show()
		preview_text_b = prev_b

# ================= INPUT (HOLD) =================
func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if modul_preview:
			get_viewport().set_input_as_handled() 
			if event.pressed:
				$TextConsecinta.text = ""
				modul_preview = false
				asteapta_ridicare_deget = true 
		elif asteapta_ridicare_deget and not event.pressed:
			get_viewport().set_input_as_handled()
			asteapta_ridicare_deget = false
			await get_tree().create_timer(0.05).timeout
			$ButtonA.disabled = false
			$ButtonB.disabled = false

func _on_button_a_button_down():
	if modul_preview or preview_text_a == "": return 
	se_tine_apasat_a = true
	await get_tree().create_timer(0.3).timeout 
	if se_tine_apasat_a: 
		se_tine_apasat_a = false
		modul_preview = true
		$TextConsecinta.text = preview_text_a
		$ButtonA.disabled = true
		$ButtonB.disabled = true

func _on_button_a_button_up(): se_tine_apasat_a = false 
func _on_button_b_button_down():
	if modul_preview or preview_text_b == "": return
	se_tine_apasat_b = true
	await get_tree().create_timer(0.3).timeout
	if se_tine_apasat_b:
		se_tine_apasat_b = false
		modul_preview = true
		$TextConsecinta.text = preview_text_b
		$ButtonA.disabled = true
		$ButtonB.disabled = true
func _on_button_b_button_up(): se_tine_apasat_b = false

# ================= GENERAREA NPC-URILOR =================
func ajunge_la_etaj_nou():
	$TextConsecinta.text = ""
	$LiftInchis.hide()
	$ImagineNPC.show()
	$ImagineNPC.scale = Vector2(1, 1)
	story_step = 1
	
	var zar = randi_range(1, 6) 
	while zar in istoric_npc: zar = randi_range(1, 6)
	istoric_npc.append(zar)
	if istoric_npc.size() > 4: istoric_npc.pop_front()
	
	if zar == 1:
		npc_curent = "Karen"
		karen_etaje = randi_range(1, 5)
		if floor_level - karen_etaje < 0: karen_etaje = floor_level if floor_level > 0 else 1
		karen_extra_etaje = randi_range(1, 3)
		$ImagineNPC.texture = imagine_karen
		var nec = (karen_etaje * 10) + 5
		$TextDialog.text = "Karen: This is unacceptable! I need to go DOWN " + str(karen_etaje) + " floors right now!"
		seteaza_butoane("Sorry...", "Shut doors", "No risk", "Cost: " + str(nec) + " Swag\n(No stats? 35% Luck)")
	elif zar == 2:
		npc_curent = "Vanzator"
		$ImagineNPC.texture = imagine_vanzator
		$TextDialog.text = "Merchant: Psst... want to buy some completely legal items?"
		seteaza_butoane("See Items", "Leave")
		var zi = randi_range(1, 3)
		if zi == 1: item1_nume = "Book"; item1_pret = 5; item2_nume = "Lollipop"; item2_pret = 3
		elif zi == 2: item1_nume = "Sunglasses"; item1_pret = 8; item2_nume = "Pill"; item2_pret = 10
		else: item1_nume = "Lollipop"; item1_pret = 3; item2_nume = "Book"; item2_pret = 5
	elif zar == 3:
		npc_curent = "Curier"
		$ImagineNPC.texture = imagine_curier
		curier_etaje = randi_range(-5, 5)
		if floor_level + curier_etaje < 0: curier_etaje = -floor_level
		if curier_etaje == 0: curier_etaje = 1 
		var dir = "UP" if curier_etaje > 0 else "DOWN"
		$TextDialog.text = "Courier: Hey, can you press the button? I need to go " + dir + " " + str(abs(curier_etaje)) + " floors."
		seteaza_butoane("Sure", "Refuse", "Risk: Change floors\nGet Item", "Safe: +1 floor")
	elif zar == 4:
		npc_curent = "Femeie"
		$ImagineNPC.texture = imagine_femeie
		$TextDialog.text = "Janitor: Careful! I just mopped. The floor is very wet."
		seteaza_butoane("Help her", "Wait", "Need: 70 IQ (+10 Swag)\n(Low IQ? 50% Luck)", "100% Safe")
	elif zar == 5:
		npc_curent = "Fantoma"
		$ImagineNPC.texture = imagine_fantoma
		$TextDialog.text = "Ghost: WOOoooOOO! *The lights start flickering wildly!*"
		seteaza_butoane("Stare back", "Hide", "Need: 80 IQ (+15 Swag)\n(Low IQ? 50% Luck)", "Safe: -5 Swag")
	elif zar == 6:
		npc_curent = "Copil"
		$ImagineNPC.texture = imagine_copil
		copil_etaje_jos = randi_range(1, 3)
		if floor_level - copil_etaje_jos < 0: copil_etaje_jos = floor_level
		$TextDialog.text = "Kid: ARE WE THERE YET?! I want to push all the buttons! WE GO DOWN!"
		var opt_b = "Give Lollipop" if are_acadea else "Do what he wants"
		var prev_b = "Use item\n100% Safe (+1 floor)" if are_acadea else "Go DOWN " + str(copil_etaje_jos) + " floors\n(No risk)"
		seteaza_butoane("Calm him", opt_b, "Cost: 20 IQ\n(No stats? 50% Luck)", prev_b)

# ================= INTERACTIUNE =================
func _on_button_a_pressed():
	if modul_preview: return
	if story_step == 4: ajunge_la_etaj_nou(); return
	if story_step == 3:
		$TextDialog.text = "*The doors close. The elevator moves... Ding!*"; $LiftInchis.show(); $ImagineNPC.hide()
		seteaza_butoane("Open Doors", ""); story_step = 4; return

	if npc_curent == "Ghid":
		if story_step == 1:
			$TextDialog.text = "Guide: In this building, you'll meet all kinds of neighbors... Good luck!"; story_step = 2
			seteaza_butoane("Next Floor", "")
		else:
			$TextDialog.text = "*The doors close. The elevator goes up... Ding!*"; $LiftInchis.show(); $ImagineNPC.hide()
			floor_level += 1; update_ui(); seteaza_butoane("Open Doors", ""); story_step = 4
			
	elif npc_curent == "Karen":
		$TextDialog.text = "Karen: Hmph! At least someone here has some manners! *She gets in*"; floor_level -= karen_etaje; update_ui()
		seteaza_butoane("Close Doors", ""); story_step = 3
		
	elif npc_curent == "Vanzator":
		if story_step == 1:
			var pr_a = "Cost: $" + str(item1_pret) + ( "\n+20 IQ" if "Book" in item1_nume else "\n+10 HP" if "Pill" in item1_nume else "\n+20 Swag" if "Sunglasses" in item1_nume else "\nSave for Kid")
			var pr_b = "Cost: $" + str(item2_pret) + ( "\n+20 IQ" if "Book" in item2_nume else "\n+10 HP" if "Pill" in item2_nume else "\n+20 Swag" if "Sunglasses" in item2_nume else "\nSave for Kid")
			seteaza_butoane(item1_nume, item2_nume, pr_a, pr_b); story_step = 2
		elif story_step == 2:
			var poate_cumpara = true
			# --- VERIFICARE PLAFONARE ---
			if item1_nume == "Book" and iq >= 100: poate_cumpara = false
			elif item1_nume == "Pill" and hp >= 100: poate_cumpara = false
			elif item1_nume == "Sunglasses" and swag >= 100: poate_cumpara = false
			
			if not poate_cumpara:
				$TextDialog.text = "Merchant: You don't need this, you're already at your limit! Goodbye."
			elif cash >= item1_pret: 
				cash -= item1_pret; aplica_efect_item(item1_nume); 
				$TextDialog.text = "Merchant: Good choice! Enjoy your " + item1_nume + "."
			else: 
				$TextDialog.text = "Merchant: Sorry, I don't make discounts."
			
			update_ui(); seteaza_butoane("Close Doors", ""); story_step = 3
			
	elif npc_curent == "Curier":
		floor_level += curier_etaje
		var pachet = ["Book","Pill","Sunglasses","Lollipop"][randi() % 4]
		aplica_efect_item(pachet)
		$TextDialog.text = "Courier: Thanks! Wait, I have a package for you too! *You got " + pachet + "!*"; update_ui()
		seteaza_butoane("Close Doors", ""); story_step = 3
	elif npc_curent == "Femeie":
		var succes = true
		if iq < 70 and randi() % 2 != 0: succes = false 
		if succes: $TextDialog.text = "Janitor: Thanks for helping! You stepped carefully. (+10 Swag)"; swag += 10
		else: hp -= 5; swag += 10; $TextDialog.text = "Janitor: Thanks for helping! Oh no, you slipped! (-5 HP, +10 Swag)"
		update_ui(); seteaza_butoane("Close Doors", ""); story_step = 3
	elif npc_curent == "Fantoma":
		var succes = true
		if iq < 80 and randi() % 2 != 0: succes = false 
		if succes: swag += 15; $TextDialog.text = "You stared the ghost down without flinching. That's cool. (+15 Swag)"
		else: hp -= 10; swag -= 10; $TextDialog.text = "Ghost: BOO! *You got scared and bumped your head!* (-10 HP, -10 Swag)"
		update_ui(); seteaza_butoane("Close Doors", ""); story_step = 3
	elif npc_curent == "Copil":
		var succes = true
		if iq >= 20: iq -= 20
		elif randi() % 2 != 0: succes = false
		if succes: $TextDialog.text = "You explained things calmly. He's quiet now. *He presses the UP button*"; floor_level += 1
		else: iq -= 15; $TextDialog.text = "He screamed louder! You're losing your mind... *He pushes some buttons* (-15 IQ)"; floor_level += 1
		update_ui(); seteaza_butoane("Close Doors", ""); story_step = 3

func _on_button_b_pressed():
	if modul_preview or story_step >= 3: return
	if npc_curent == "Ghid": $TextDialog.text = "Guide: Too late! *The doors close suddenly... Ding!*"; floor_level += 1; iq -= 5; update_ui(); seteaza_butoane("Open Doors", ""); story_step = 4
	elif npc_curent == "Karen":
		var nec = (karen_etaje * 10) + 5
		var succes = true
		if swag >= nec: swag -= nec 
		elif randi_range(1, 100) > 35: succes = false 
		if succes: $TextDialog.text = "Karen: Hey! You can't just-- *Doors close in her face*"; floor_level += 1
		else: $TextDialog.text = "Karen: *Stops the door with her foot* How dare you?! Now we're going down even further!"; floor_level -= (karen_etaje + karen_extra_etaje)
		if floor_level < 0: floor_level = 0
		update_ui(); seteaza_butoane("Close Doors", ""); story_step = 3
	elif npc_curent == "Vanzator":
		if story_step == 1: $TextDialog.text = "Merchant: Your loss, friend. See you around."; seteaza_butoane("Close Doors", ""); story_step = 3
		elif story_step == 2:
			var poate_cumpara = true
			if item2_nume == "Book" and iq >= 100: poate_cumpara = false
			elif item2_nume == "Pill" and hp >= 100: poate_cumpara = false
			elif item2_nume == "Sunglasses" and swag >= 100: poate_cumpara = false
			
			if not poate_cumpara:
				$TextDialog.text = "Merchant: You don't need this, you're already at your limit! Goodbye."
			elif cash >= item2_pret: 
				cash -= item2_pret; aplica_efect_item(item2_nume); 
				$TextDialog.text = "Merchant: Good choice! Enjoy your " + item2_nume + "."
			else: $TextDialog.text = "Merchant: Sorry, I don't make discounts."
			
			update_ui(); seteaza_butoane("Close Doors", ""); story_step = 3
	elif npc_curent == "Curier": $TextDialog.text = "Courier: Man, whatever... I'll take the stairs or wait."; floor_level += 1; update_ui(); seteaza_butoane("Close Doors", ""); story_step = 3
	elif npc_curent == "Femeie": $TextDialog.text = "You waited patiently for the floor to dry. No risks taken."; floor_level += 1; update_ui(); seteaza_butoane("Close Doors", ""); story_step = 3
	elif npc_curent == "Fantoma": swag -= 5; $TextDialog.text = "You cowered in the corner until it disappeared. Not very cool. (-5 Swag)"; floor_level += 1; update_ui(); seteaza_butoane("Close Doors", ""); story_step = 3
	elif npc_curent == "Copil":
		if are_acadea:
			are_acadea = false
			$TextDialog.text = "You gave him the lollipop. He pushes the UP button for you! (+1 floor)"
			floor_level += 1
		else:
			$TextDialog.text = "You let him push the buttons... He pushes the lowest ones. (-" + str(copil_etaje_jos) + " floors)"
			floor_level -= copil_etaje_jos
		update_ui(); seteaza_butoane("Close Doors", ""); story_step = 3
