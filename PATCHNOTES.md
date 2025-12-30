# December 29th, 2025 (12/29/25)
**>QOL & BUG FIXES**   
- Fixed non-Titanmod maps with different spawn entities from base sandbox maps not working as intended



# December 21st, 2025 (12/21/25)
**>QOL & BUG FIXES**   
- Quick weapon switching is now properly client sided and players will no longer experience a delay when switching between weapons because of their ping

- Lens Flare no longer renders through viewmodels

- Fixed broken prediction on client sided keybinds

- Fixed the menu keybind not working if weapon quick switching was disabled

- Fixed lua errors caused by lens flare



# September 27th, 2025 (9/27/25)
**>GAMEPLAY**   
*NEW WEAPONS*
- **Coonan .357** (Secondary, Pistol)
- **Flamethrower** (Primary, Special)
- **G3A3** (Primary, Rifle)
- **HK416** (Primary, Rifle)
- **Stoner LMG A1** (Primary, LMG)

*AMMO CONVERSIONS*
- Added new attachment types to the **AR-57** and **HK416** that rework their gun stats

*WEAPON FEEL*
- Added a new viewmodel inertia system (does not take effect when ADSing)

**>QOL & BUG FIXES**   
- Added the "tm_unlockall" ConVar that allows players to equip cosmetic items (models/cards/melees) that they do not meet the unlock req. for



# April 23rd, 2025 (4/23/25)
**>GAMEPLAY**   
*RECOIL OVERHAUL*
- Recoil across all weapons are now seeded and pattern based
- Each weapon now has a unique recoil pattern
- Weapons are now either left-drifting or right-drifting, meaning recoil will mainly drift to the left or right instead of picking a left or right direction at random

**>BALANCE**    
*FN 2000*
- Reduced vertical recoil to 25 (previously 40)
- Reduced horizontal recoil to 10 (previously 25)

*Honey Badger*
- Reduced horizontal recoil to 14 (previously 20)

*P90*
- Reduced vertical recoil to 20 (previously 25)
- Reduced horizontal recoil to 10 (previously 20)

*SR-2M*
- Reduced vertical recoil to 24 (previously 30)
- Reduced horizontal recoil to 12 (previously 20)

**>QOL & BUG FIXES**   
- Fixed over 100+ instances of specific weapon sights being misaligned from a weapons point of fire



# April 21st, 2025 (4/21/25)
**>GAMEPLAY**   
*SIGHTS & SCOPES*
- Added the RUSAK, Coyote and HD-33 sights
- Reworked most sight and scope reticles to improve clarity
- Reworked reticle rendering to improve visibility throughout different lighting situations
- All optics now take the players "Optic Reticle Setting" into account
- Heavily reduced scope edge shadows across all scopes
- Optic and scope shortnames are now the sights magnification
- Fixed all instances of sights varying in height across different weapons

**>QOL & BUG FIXES**   
- Replaced "SAS" and "Winter SAS" models with "Elite" and "Cloaker" models due to height differences between other models

- Added 12 new leveling calling cards (every 5 levels of prestige 4)

- Decals are now cleared on player spawn instead of every 15 seconds

- Fixed numerous errors based on models, materials and particles

- Fixed all instances of error textures



# April 16th, 2025 (4/16/25)
**>QOL & BUG FIXES**   
- Overhauled file precaching system

- Fixed console errors when using certain weapons (notably Riot Shield)



# April 15th, 2025 (4/15/25)
**>GAMEPLAY**   
*AMMO CONVERSIONS*
- Added new attachment types to the **ASh-12** and **OTs-33 Pernach** that rework their gun stats

*END OF MATCH ADJUSTMENTS*
- Three maps are now available in the map voting pool instead of two

*NEW SETTINGS*  
- Sprinting FOV Increase
- Lens Flare

**>MAPS**   
*RETURNING MAPS*
- Grid

**>BALANCE**    
*M14*
- Increased damage to 50 (previously 40)
- Reduced vertical recoil to 50 (previously 80)

*M79*
- Increased draw and holster speed significantly
- Increased reload speed significantly
- Reduced animation lock time after firing a grenade

*MK 14 EBR*
- Now fires in Full Auto with 600 RPM
- Reduced vertical recoil to 40 (previously 50)

*OTs-33 Pernach*
- Increased magazine capacity to 33 (previously 27)

*RPG-7*
- Rocket projectile now slows down during flight and proceeds to drop after being in the air for too long
- Increased draw and holster speed significantly
- Increased reload speed significantly

*Stevens 620*
- Increased damage to 18x7 (previously 16x7)

**>QOL & BUG FIXES**   
- Player ragdolls are now synced across clients and will look the same for all players

- All snipers now have higher auto-switch weight compared to shotguns, making them always the equipped weapon when spawning in the Shotty Snipers gamemode

- Player POV in the death camera now shows your own FOV instead of the other players

- Updated the Jacket player model

- Added 51 new pride calling cards (assorted countries)

- Added new gamemode main menu backgrounds

- Fixed all known instances of weapons spawning unloaded

- Fixed some weapons from spawning with attachments that were not previously equipped by the player

- Fixed death camera flickering when the spectated player performed specific actions

- Fixed the selected melee weapon not having save file corruption mitigation

- Fixed the fiesta timer counting down during intermission

- Fixed the grappling hook being usable during intermission

- Fixed many match time related interface values being one second ahead of actual match time

- Fixed fiesta timer interface being 500ms behind of actual fiesta time

- Fixed being unable to open weapon attachment menu when sprinting

- Fixed weapons being able to switch fire modes and go into safety

- Fixed some weapons still having damage fall off at extremely long ranges

- Fixed dynamic crosshair spread not taking sliding into account

- Fixed dynamic crosshair still taking hip fire spread into account while using the point firing attachment and ADSing

- Fixed dynamic crosshair still taking player velocity into account while crouching and sliding



# April 12th, 2025 (4/12/25)
**>GAMEPLAY**   
*CUSTOMIZATION*
- Added 8 new player models

**>MAPS**   
*RETURNING MAPS*
- Station

**>QOL & BUG FIXES**   
- Improved fluidity with weapon firing and ADSing while sprinting and sliding

- Added subtle camera flinch when being hit (more obvious that you are being hit by bullets and whatnot)

- Player ragdolls now transfer over any active decals applied to the player before death

- Sprinting no longer locks you out of the weapon attachment menu

- Crosshair now fades out while in the weapon attachment menu

- Updated gamemode key art

- Fixed leveling panel on the scoreboard from not displaying when 6 or more players are connected on a server

- "Bones" player model is now changed to be more visible



# April 11th, 2025 (4/11/25)
**>MAPS**   
*Arctic*
- Added additional player spawns
- Removed various props
- Reduced HDR brightness
- Added sun to the skybox
- Resolved texture errors
- Added missing cubemaps

*Bridge*
- Added additional player spawns
- Reduced HDR brightness
- Removed fog (still persists in the 3D skybox)

*Corrugated*
- Removed various props
- Various optimizations
- Various geometry tweaks to help with movement fluidity
- Resolved texture errors

*Disequilibrium*
- Added additional player spawns
- Reduced brightness of the sun
- Added missing cubemaps

*Initial*
- Overhauled map layout and geometry
- Added additional player spawns
- Removed various props
- Added missing cubemaps
- Lowered skybox height
- Resolved out of bound spots

*Legacy*
- Additional rooftops can now be accessed
- Added additional player spawns
- Reduced brightness of the sun

*Liminal Pool*
- Added additional player spawns
- Added missing cubemaps
- Various optimizations
- Resolved texture errors

*Mall*
- Can no longer exit the interior of the mall
- Light switch now has a 20 second cooldown after being actuated
- Added additional player spawns

*Mephitic*
- Added additional player spawns
- Removed various props
- Increased map brightness
- Added missing cubemaps
- Various optimizations
- Fixed stuck spots

*Nuketown*
- Added additional player spawns
- Removed player spawns that conflicted with the KOTH location

*Oxide*
- Added additional player spawns
- Various optimizations
- Fixed stuck spots

*Rig*
- Added additional player spawns
- "The Container" is now forcefully server-sided
- Removed player spawns that conflicted with the KOTH location

*Rust*
- Added additional player spawns
- Added missing cubemaps

*Sanctuary*
- Added additional player spawns
- Added missing cubemaps
- Various geometry tweaks to help with movement fluidity
- Reduced HDR brightness

*Shipment*
- Added additional player spawns
- Reduced brightness of the sun

*Shoot House*
- Added additional player spawns

*Villa*
- Added additional player spawns

*Wreck*
- Added additional player spawns

**>QOL & BUG FIXES**   
- Adjusted visuals of player flashlights to make the player easier to see

- Skulls in the kill UI now stack

- Fixed potential overlapping of the kill and death UI



# April 10th, 2025 (4/10/25)
**>GAMEPLAY**   
*AMMO CONVERSIONS*
- Added new attachment types to the **FN FAL** and **MP5K** that rework their gun stats

*SHOTGUN CHANGES*
- Some shotguns received a 10-25% spread reduction to help them perform better at further ranges

**>BALANCE**    
*Dragon's Breath Shells*
- Reduced extra spread to +66% (previously +100%)
- Reduced damage reduction to -40% (previously -50%)
- Reduced extra pellets bonus to +6 (previously +8)

*Flechette Shells*
- Increased damage reduction to -60% (previously -50%)

*AA-12*
- Reduced vertical recoil to 75 (previously 100)

*AR-57*
- Reduced vertical recoil to 35 (previously 45)
- Reduced horizontal recoil to 12 (previously 15)

*Beretta Mx4*
- Reduced damage to 25 (previously 27)
- Reworked recoil but no recoil values were tweaked

*Colt 9mm*
- Increased mobility to 94% (previously 87.5%)

*CZ 75*
- Reduced vertical recoil to 20 (previously 40)

*Desert Eagle*
- Increased horizontal recoil to 60 (previously 40)
- Reduced vertical recoil to 80 (previously 120)

*Dual Mac 10s*
- Reduced vertical recoil to 50 (previously 55.5)

*Dual Skorpions*
- Reduced spread to 28.5 (previously 33.5)
- Reduced vertical recoil to 30 (previously 37.5)
- Reduced horizontal recoil to 20 (previously 25)

*FAMAS*
- Reduced vertical recoil to 50 (previously 62.5)

*Fiveseven*
- Reduced vertical recoil to 50 (previously 62.5)

*FNP-45*
- Reduced vertical recoil to 70 (previously 100)
- Reduced horizontal recoil to 15 (previously 50)

*G36A1*
- Reduced vertical recoil to 33 (previously 43)
- Reduced horizontal recoil to 11 (previously 16)

*M134 Minigun*
- Reduced spread to 50 (previously 77.5)

*M249*
- Reduced damage to 25 (previously 26)
- Reduced vertical recoil to 28 (previously 38)
- Reduced horizontal recoil to 8 (previously 20)

*M45A1*
- Reduced vertical recoil to 60 (previously 98)
- Reduced horizontal recoil to 20 (previously 58)

*M9*
- Reduced vertical recoil to 25 (previously 30)
- Reduced horizontal recoil to 10 (previously 15)

*Makarov*
- Increased damage to 35 (previously 33)
- Reduced horizontal recoil to 4 (previously 18)

*Model 10*
- Reduced vertical recoil to 80 (previously 120)

*MP40*
- Increased damage to 32 (previously 30)

*MP-443*
- Reduced vertical recoil to 40 (previously 60)
- Reduced horizontal recoil to 20 (previously 30)

*MP5*
- Reduced damage to 27 (previously 28)
- Reduced vertical recoil to 25 (previously 30)
- Reduced horizontal recoil to 7.5 (previously 15)

*MP7*
- Reduced damage to 26 (previously 27)
- Reduced vertical recoil to 20 (previously 22)
- Reduced horizontal recoil to 10 (previously 12.5)

*MP9*
- Reduced vertical recoil to 20 (previously 22.5)
- Reduced horizontal recoil to 5 (previously 9)

*MPX*
- Reduced damage to 28 (previously 30)
- Increased iron sight recoil multiplier to 0.75 (previously 0.50)
- Reduced horizontal recoil to 10 (previously 15)

*MR-96*
- Reduced vertical recoil to 95 (previously 120)
- Reduced horizontal recoil to 42 (previously 72)

*OSP-18*
- Reduced vertical recoil to 55 (previously 70)
- Reduced horizontal recoil to 20 (previously 25)

*OTs-33 Pernach*
- Reduced vertical recoil to 32 (previously 37)
- Reduced horizontal recoil to 12 (previously 18)

*Owen Gun*
- Reworked recoil but no recoil values were tweaked

*P320*
- Reduced vertical recoil to 40 (previously 60)

*PM-9*
- Increased damage to 22 (previously 21)
- Reduced vertical recoil to 32 (previously 35)
- Reduced horizontal recoil to 10 (previously 13)

*Scorpion Evo*
- Reduced vertical recoil to 20 (previously 30)

*Spike X1S*
- Reduced vertical recoil to 120 (previously 200)

*Typhoon F12*
- Reduced vertical recoil to 50 (previously 150)

*USP*
- Reduced vertical recoil to 30 (previously 40)
- Reduced horizontal recoil to 15 (previously 20)

*Walther P99*
- Reduced vertical recoil to 37 (previously 42)
- Reduced horizontal recoil to 12 (previously 15)

*Webley*
- Reduced vertical recoil to 60 (previously 80)
- Reduced horizontal recoil to 25 (previously 50)

**>QOL & BUG FIXES**   
- Overhauled save file system that is 175x faster on average

- Improved load times when switching to a new map and gamemode

- Added new view animation while sliding and while using/retracting the grappling hook

- Updated various attachment descriptions

- Fixed view animations not playing in singleplayer (for people who like playing with themselves)

- Fixed kills and deaths still awarding score and affecting stats after a match has ended

- Fixed the M45A1 from not appearing in loadouts

- Fixed several HUD and menu related issues when playing on a resolution higher than 2560x1440



# April 2nd, 2025 (4/2/25)
**>GAMEPLAY**   
*NEW SETTINGS*  
- HUD Scale

*ANIMATIONS*  
- Disabled all first deploy animations for all weapons

**>BALANCE**    
*AK-12*
- Reduced vertical recoil to 55 (previously 70)
- Reduced horizontal recoil to 10 (previously 20)

*AK-400*
- Reduced vertical recoil to 45 (previously 55)
- Reduced horizontal recoil to 20 (previously 25)

*AK-47*
- Reduced vertical recoil to 62 (previously 82)
- Reduced horizontal recoil to 25 (previously 35)
- Readjusted iron sights to better match aiming point

*AKS-74U*
- Reduced vertical recoil to 40 (previously 67)
- Reduced horizontal recoil to 20 (previously 30)

*AN-94*
- Reduced horizontal recoil to 20 (previously 30)

*AVT-40*
- Reduced vertical recoil to 55 (previously 95)

*Galil*
- Reduced vertical recoil to 40 (previously 60)

*Honey Badger*
- Reduced vertical recoil to 35 (previously 45)
- Reduced horizontal recoil to 20 (previously 25)

*LR-300*
- Reduced vertical recoil to 40 (previously 43)
- Reduced horizontal recoil to 5 (previously 15)

*MK18*
- Reduced vertical recoil to 48 (previously 53)
- Reduced horizontal recoil to 20 (previously 25)

*Pindad SS2*
- Reduced horizontal recoil to 10 (previously 20)

*PKP*
- Reduced vertical recoil to 47.5 (previously 52.5)
- Reduced horizontal recoil to 25 (previously 37.5)

*RPK-74M*
- Reduced vertical recoil to 60 (previously 88)
- Reduced horizontal recoil to 25 (previously 45)

*SCAR-H*
- Reduced vertical recoil to 65 (previously 115)

*Spectre M4*
- Reduced vertical recoil to 20 (previously 22.5)
- Adjusted ADS firing animation to better match aiming point

*SR-25*
- Reduced vertical recoil to 50 (previously 70)
- Reduced horizontal recoil to 20 (previously 47)

*VHS-D2*
- Reduced vertical recoil to 37 (previously 45)
- Reduced horizontal recoil to 20 (previously 47)

*XM8*
- Reduced vertical recoil to 25 (previously 30)
- Reduced horizontal recoil to 5 (previously 10)

**>QOL & BUG FIXES**   
- All interfaces and UI elements are now scaled by the users resolution to look identical no matter the resolution used

- Replaced tinnitus sound effect with a less drastic effect

- Removed unnecessary parameters from fonts created by the gamemode

- Loadout notification now uses the users HUD font



# March 30th, 2025 (3/30/25)
**>BALANCE**    
*Melee*
- Thrown melee will now despawn instantly upon colliding with a surface
- Melee kills will no longer advance a player in the Gun Game ladder if they are not on the final weapon

**>QOL & BUG FIXES**   
- Added viewmodel animation when opening doors

- Adjusted sliding viewmodel animation

- Fixed reload cancelling

- Fixed the SR-25 having an incorrect weapon slot on the HL2 UI

- Fixed broken scoreboard post processing

- Potential fix for erroring world models while holding the WA-2000



# March 29th, 2025 (3/29/25)
**>QOL & BUG FIXES**   
- Fixed the Overkill gamemode from not fucking working

- Fixed melee throw checks not being ran when using the numeric ammo style

- Fixed certain melees doing more damage than intended



# March 29th, 2025 (3/29/25)
**>GAMEPLAY**  
*NEW SETTINGS*
- Headshot Kill SFX Style
- Sensitivity Transition Style (Gradual and Instant)
- Show Crosshair When Sprinting

**>BALANCE**    
*M134 Minigun*
- Can now be fired while sprinting

**>QOL & BUG FIXES**   
- Strafing inputs can now be inputted while sliding to very slightly redirect your sliding angle

- Fixed players spawning abnormally if no suitable spawn points were fonud on the map

- Fixed inconsistent scoreboard visuals

- Refactored prestiging system to hopefully fix bugs related to progression

- Cleaned up info that is seen when changing weapon attachments

- Grappling hook cooldown timer is now more accurate

- Melee throw indicators no longer appear in gamemodes that disable melee throwing

- Resolved some server console errors

- Improved spawning systems detection for suitable spawns



# March 28th, 2025 (3/28/25)  
**>GAMEPLAY**  
*NEW GAMEMODE*
- **Fisticuffs**, typical FFA but with only melee weapons

**>BALANCE**    
*Grappling Hook*
- Cooldown reduced to 15 seconds (previously 20)
- Players now spawn with 3 seconds on the cooldown (previously 5)
- Players now reduce the cooldown by 10 seconds for each kill (previously 20)

*Melee*
- Both swings now reach 1.25 meters / 65 hammer units

**>QOL & BUG FIXES**   
- Fixed multiple bugs introduced in the last major update



# March 28th, 2025 (3/28/25)  
**>GAMEPLAY**  
*MELEE OVER-OVERHAUL*
- Melee damage is now identical no matter the limb hit
- Both swing types now do 75 damage
- Both swings now reach 0.75 meters / 39.15 hammer units
- Heavy swings can now backstab, one shotting the enemy if hit in the back (180 degrees from the back)

**>BALANCE**    
*Shotguns*
- Spread has been reduced by 20-30% across all shotguns

*Grappling Hook*
- Cooldown increased to 20 seconds (previously 15)
- Players now spawn with 5 seconds on the cooldown (previously 0)
- Players now reduce the cooldown by 10 seconds for each kill (previously 20)

**>QOL & BUG FIXES**   
- Fixed multiple bugs introduced in the last major update

- Melees can no longer be thrown in the Gun Game gamemode



# March 27th, 2025 (3/27/25)  
**>GAMEPLAY**  
*NEW WEAPONS*
- **American-180** (Primary, SMG)
- **AVT-40** (Primary, Rifle)
- **Bowie Knife** (Melee)
- **Butterfly Knife** (Melee)
- **Carver** (Melee)
- **Dagger** (Melee)
- **Dual Mac 10s** (Primary, SMG)
- **Fire Axe** (Melee)
- **Fists** (Melee)
- **Galil** (Primary, Rifle)
- **Kar98k** (Primary, Sniper)
- **Karambit** (Melee)
- **KS-23** (Primary, Shotgun)
- **Kukri** (Melee)
- **M134 Minigun** (Primary, LMG)
- **M9 Bayonet** (Melee)
- **Nailgun** (Secondary, Pistol)
- **Nunchucks** (Melee)
- **Red Rebel** (Melee)
- **SR-25** (Primary, Rifle)
- **Tri-Dagger** (Melee)
- **WA-2000** (Primary, Sniper)

*NEW GAMEMODE*
- **Overkill**, typical FFA but with no weapon restrictions (ramdonly receive two weapons instead of one primary and one secondary)

*SCOPES AND SIGHTS OVERHAUL*
- All sights in the game now share the same FOV value
- Every weapon has had its available sites and position of sites updated
- All low magnification sights have had their magnification unified (this includes every weapons iron sights)
- All high magnification scopes have had thier magnification reduced by an average of 25%
- Removed all 3x scopes
- Fixed inconsistent sight magnification across weapons

*GRAPPLING HOOK OVERHAUL*
- Grappling Hook is now always available in every gamemode
- 25% increase to hook travel speed
- Seperated grappling hook from the melee slot, allowing for both to be in a loadout
- New first person animations when using the grappling hook
- Improved visual effects when grappling
- New grappling related sound effects
- Optimized various aspects of grappling hooks

*MELEE OVERHAUL*
- All melee weapons now have consistent swing distance values
- Light swings (LMB) now always do 50 damage and reach 1 meter / 52 hammer units
- Heavy swings (RMB) now always do 100 damage and reach 1.5 meters / 78 hammer units
- Heavy swings have double the cooldown of light swings
- Thrown melee weapons damage is now determined by the velocity, now being able to one shot if fast enough
- Thrown melee kills now count as a kill for your equipped melee
- Adjusted melee animations to better account for the delay between a swings start and finish

*MELEE PROGRESSION*
- Players can now equip their perferred melee weapon and they will always receive it (unless playing Gun Game or Fiesta)
- A brand new melee weapon is unlocked every 100 melee kills OR every prestige, only one needs to be fulfilled

*FALL DAMAGE*
- Removed all sources of fall damage

*GRAPHICAL IMPROVMENTS*
- Added Lens Flare effect
- Added dynamic lighting when a player fires their weapon, when an explosion triggers, etc
- Removed bullet tracers due to being redundant

*NEW SETTINGS*
- Auto Sprint
- Auto Sprint Interaction Delay
- Inspect Bind
- Attachments Bind (overrides default context key to open attachments menu)

**>BALANCE**    
*Shotguns*
- Spread has been tripled to quadrupled across all shotguns
- ADS spread now matches the hip fire spread on all shotguns
- Slug Ammunition now makes shotguns completely accurate while ADSing

*GSH-18*
- Increased damage to 28 (previously 25)

*Makarov*
- Increased damage to 33 (previously 26)

*Mas 38*
- Decreased vertical recoil to 25 (previously 45)
- Decreased horizontal recoil to 10 (previously 15)

*KRISS Vector*
- Decreased vertical recoil to -15 (previously -25)
- Decreased horizontal recoil to 10 (previously 15)

*Point Shooting Attachment*
- Added Point Shooting to the many new weapons
- Aiming down sights while using the attachment will no longer make your crosshair fade out

**>QOL & BUG FIXES**   
- Brand new spawn logic that should avoid spawns with other players nearby and should fix instances of spawning inside other players

- Brand new derma skin ported from EFGMR, improving visuals on all default Garry's Mod UI assets

- Extensive micro-optimization throughout the gamemode

- The maximum FOV for the custom FOV system has been increased to 144 (previously 125)

- Weapon Viewmodel FOV is now persistent across all FOV values (this includes FOV while aiming down sights)

- Changed 8x sensitivity setting to 6x sensitivity setting

- Default sensitivity values have been changed

- Overhauled player model and player card selection menus

- Ammo text while using melee weapons now displays the keybind to throw the melee weapon

- Bullet penetration decals are now properly synced between clients

- Adjusted view model for the Riot Shield

- Removed post processing when exiting a body of water

- The melee at the end of a gun game ladder is now randomized

- Added patch notes button to the main menu

- Renamed the Lewis to the Lewis Gun

- Fixed AA-12 being considered a rifle instead of a shotgun

- Fixed HK53 being considered a LMG instead of a rifle

- Fixed Tariq being considered a "9x19" instead of a pistol (2023 Penial was on crack fucking cocaine)

- Fixed issues caused by recent TFA Base updates

- Fixed instances of iron sights clipping inside of scopes

- Fixed instances of scopes being misaligned from the center of the screen

- Fixed manual value input not updating the optic reticle color preview

- Fixed inconsistency with reload canceling

- Fixed instances where spawning in triggered a players cranked countdown if they killed themselves

- Removed sound when switching weapons via quick weapon switching

- New end of match quotes from community members

- Removed an end of match quote that was created by a pdf file (lmao)



# February 1st, 2025 (2/1/25)  
**>GAMEPLAY**  
*MOVEMENT CHANGES*
- Wall Running now carries over the players previous forward momentum if it exceeds the base wall run momentum
- Wall Running minimum velocity increase reduced by 20% to compensate for momentum conservation
- Wall Jumping no longer stalls a players forward momentum, instead slowing said momentum by 25%
- Base crouching/uncrouching speeds increased by 25%, speed following a slide is unchanged

**>QOL & BUG FIXES**   
- Removed sight bobbing while mid-air

- Numerous menu and HUD improvements, redesigns, optimizations and fixes



# August 1st, 2024 (8/1/24)  
**>GAMEPLAY**  
*CAMERA SHAKE*
- Firing a weapon now causes a slight amount of camera shake to be applied
- This was done because Titanmod's recoil tends to have very little shake, making the firing feel bland
- A weapons camera shake value is determined by its recoil, RPM and it is affected by recoil/RPM reducing attachments

*MOVEMENT CHANGES*
- Player acceleration is now 60% faster (moving from a complete stop or changing direction will be quicker)


**>QOL & BUG FIXES**   
- Optimized array usage

- Added reticle previews while editing the Optic Reticle Color setting

- Walking now affects dynamic crosshairs

- Improved loading times for customization menus on first launch

- Fixed client precahcer error when connecting to a server



# August 1st, 2024 (8/1/24)  
**>GAMEPLAY**  
*CAMERA SHAKE*
- Firing a weapon now causes a slight amount of camera shake to be applied
- This was done because Titanmod's recoil tends to have very little shake, making the firing feel bland
- A weapons camera shake value is determined by its recoil, RPM and it is affected by recoil/RPM reducing attachments

*MOVEMENT CHANGES*
- Player acceleration is now 60% faster (moving from a complete stop or changing direction will be quicker)


**>QOL & BUG FIXES**   
- Optimized array usage

- Added reticle previews while editing the Optic Reticle Color setting

- Walking now affects dynamic crosshairs

- Improved loading times for customization menus on first launch

- Fixed client precahcer error when connecting to a server



# April 13th, 2024 (4/13/24)  
**>GAMEPLAY**   
*NEW SETTING*
- Precache Gamemode Files

**>QOL & BUG FIXES**   
- The setting above is a fix for users experiencing a CVEngineServer overflow when joining a Titanmod server, players with mechanical hard drives will also experience much faster load times with this setting disabled (while experiencing more in game stutters)



# March 31th, 2024 (3/31/24)  
**>GAMEPLAY**  
*NEW SETTING*
- Render Hands

**>QOL & BUG FIXES**   
- Decreased gamemode file size by 500 MB~

- Player hands are now rendered during the death cam

- Added mute/unmute player buttons when interacting with a player through the scoreboard

- Added ability to interact with a player through the end or round scoreboard

- Added player tags for steam friends and muted players

- Improved responsiveness of map/gamemode voting completion

- Cleaned up Holosun 510C sight lens

- Cleaned up EOTech XPS 3 sight lens

- Fixed incorrect description for the VIP gamemode

- Fixed info panel being visible when selecting the MPX from the HL2 weapon selector



# March 27th, 2024 (3/27/24)  
**>GAMEPLAY**  
*RELOADING QUALITY OF LIFE* 
- All reloads can now be started while aiming down sights (reload canceling is still only possible from the hip)
- Players can now aim down sights during a reload

**>BALANCE**    
*Point Shooting Attachment*
- Added ADS spread (50% to the weapons hip fire spread)
- Increased ADS time decrease to 50% (previously 25%)

**>QOL & BUG FIXES**   
- Added interchangable map and gamemode votes, allowing players to now change which item they vote for during the voting period

- Added a notification when entering spectator mode

- Added text for when the player is on a leaderboard switching cooldown

- Added "tm_addmatchtime" and "tm_reducematchtime" commands, allowing admins to add or remove seconds to the remaining match time

- Added the "sv_tm_matchvoting" ConVar that can forcefully enable/disable map and gamemode voting at the end of matches

- Renamed "Tactical Point Shooting" attachment to "Point Shooting"

- Prestige button text is now rainbow to help visibility

- Spectating is no longer possible if you are on a respawn timer

- Fixed incorrect attachment description for the QBZ-97 5.56 conversion

- New end of match quotes from community members



# March 5th, 2024 (3/5/24)  
**>GAMEPLAY**   
*AMMO CONVERSIONS*
- Added new attachment types to the **AA-12**, **AK-47**, **AKS-74U**, **Bren**, **Colt 9mm**, **CZ 75**, **FG 42**, **G28**, **Groza**, **HK53**, **Honey Badger**, **Howa Type 64**, **Imbel IA2**, **L85**, **Lewis**, **M1911**, **M1918**, **M1919**, **M3 Grease Gun**, **Mare's Leg**, **MG 34**, **MG 42**, **MP-443**, **MP5**, **OSP-18**, **PPSH**, **RFB**, **Spike X1S**, **StG 44** and **Webley** that rework their gun stats

*NEW HITSOUND OPTIONS*
- Overwatch

*NEW KILLSOUND OPTIONS*
- Overwatch

**>BALANCE**    
*G28*
- Decreased damage to 49 (previously 57)

*RFB*
- Decreased damage to 40 (previously 45)

*Thompson M1928*
- Decreased damage to 31 (previously 36)

*Thompson M1A1*
- Decreased damage to 32 (previously 36)

**>QOL & BUG FIXES**   
- Adjusted the firing sound effects for various weapons

- Fixed HUD code importing not working

- Fixed loading notice not appearing for players with high ping

- Fixed duplicate barrel attachments on the AA-12

- Fixed reload speed being longer than intended when using the RFB with the Foregrip attachment

- Fixed firing sound being delayed when firing the Webley



# February 3rd, 2024 (2/3/24)    
**>GAMEPLAY**   
*NEW WEAPON*
- **ASh-12** (Primary, Rifle)
- **MPX** (Primary, SMG)

*AMMO CONVERSIONS*
- Added new attachment types to the **AK-400**, **AUG A2**, **FNP-45**, **Lee Enfield**, **M9**, **M45A1**, **MK18**, **MP9**, **Owen Gun**, **Pindad SS2**, **P90**, **PP-19 Bizon**, **PPSH**, **QBZ-97**, **QSZ-92**, **SCAR-H**, **Sten** and **UMP** that rework their gun stats
- All ammo conversions now alter the weapons firing sounds

*ATTACHMENT REWORK*
- Added Compensator attachment (muzzle brake but helps with horizontal control instead of vertical)
- All muzzle attachments have been rebalanced for more diversity when creating weapon builds
- Almost every weapon has now received muzzle attachments
- Added foregrip to various weapons

*HITMARKER OVERHAUL*
- A brand new hitmarker system to replace the default TFA one, allowing for more customization and better performance

*CUSTOMIZATION*
- Added 12 new player models

*NEW SETTINGS*
- Hitmarker Length
- Hitmarker Thickness
- Hitmarker Gap
- Hitmarker Opacity
- Hitmarker Duration
- Hitmarker Headshot Color

*WEAPON NAME ADJUSTMENTS*
- Renamed SA80 to L85
- Renamed Sten Gun to Sten
- Renamed UMP .45 to UMP

**>MAPS**   
*NEW MAPS*
- Rust

*Arctic*
- Smoothened out staircases with clip brushes
- Expanded the dark staircase room

*Initial*
- Reduced amount of props

*Mephitic*
- Reduced amount of props
- Removed excess doors

*Oxide*
- Reduced amount of props

*Villa*
- Reduced amount of props
- Increased gap size of multiple doorways

*Wreck*
- Reduced amount of props

**>BALANCE**    
- Crouching/sliding recoil reduction is now a flat 20% on every weapon
- Crouching/sliding spread reduction is now a flat 30% on every weapon

*AAC Silencer*
- Added vertical recoil increase of 5%
- Removed damage decrease
- Removed vertical recoil decrease
- Removed spread increase

*Heavy Barrel Attachment*
- Added horizontal recoil decrease of 5%
- Added ADS time increase of 10%
- Removed mobility decrease

*Muzzle Brake Attachment*
- Added ADS time increase of 5%
- Reduced vertical recoil decrease to 10% (previously 25%)
- Reduced spread increase to 5% (previously 25%)

*Osprey Suppressor Attachment*
- Added ADS time increase of 5%
- Removed vertical recoil decrease

*Foregrip Attachment*
- Added ADS time increase of 20%
- Reduced vertical recoil reduction to 25% (previously 35%)
- Increased mobility reduction to 5% (previously 4%)

*AEK-971*
- Decreased damage to 25 (previously 28)

*AUG A2*
- Increased damage to 29 (previously 28)

*Bow*
- Can now be shot while sprinting and sliding
- Increased ADS FOV to allow for easier use

*L85*
- Increased RPM to 675 (previously 650)
- Reduced horizontal recoil to 15 (previously 22)

*Groza*
- Reduced horizontal recoil to 10 (previously 20)

*M4A1*
- Reduced horizontal recoil to 12 (previously 20)
- Reduced RPM to 800 (previously 850)

*MK18*
- Increased damage to 33 (previously 32)
- Reduced RPM to 700 (previously 800)

*MP9*
- Reduced damage to 23 (previously 26)

*PP-19 Bizon*
- Increased damage to 29 (previously 28)

**>QOL & BUG FIXES**   
- Leaderboard is now dynamically sized depending on the number of players/entries being shown

- Added variations to the victory/defeat music on match end

- Crosshair preview in the settings menu is now affected by the dynamic and static crosshair styles

- All scroll bars have been revamped visually

- Added four new crosshair preview images

- Added opacity slider for the crosshair preview image

- Added coloring effect when hovering over social media links in the Main Menu

- Added loading notice while server is busy setting up next match

- Optimized kill popup

- Updated YouTube social link in Main Menu

- Updated text in the tutorial

- Fixed reloads getting "stuck" with a foregrip equipped (TFA grips SUCK, and there is going to be inconsistency when doing vanilla and foregrip reloads, specifically when it comes to locking reload cancels, there is nothing I can do about it)

- Fixed various hitboxes for player models

- Fixed some player models not receiving proper damage in specific hit boxes

- Fixed knives not always one hitting despite having the required damage to do so

- Fixed "Matches Played" and "Matches Won" calling cards from not being able to be applied

- Fixed crosshair preview image not cycling properly on certain occasions

- Fixed end of round chat messages sending if the chat box contained no text

- Fixed missing ammo count text when using a weapon with no magazine on the text ammo style

- Fixed missing ammo bar when using a weapon with no magazine on the bar ammo style

- Fixed freecam spectate being selectable during intermission period

- Fixed the discord join button at the end of match not functioning

- Fixed client sided bindings (grenade throwing) not functioning in single player

- Removed UMP9 weapon, was converted into a UMP .45 conversion

- Removed Slide Cancel Type setting (led to many movement exploits that would keep popping back up after being fixed)



# January 3rd, 2024 (1/3/24)    
**>GAMEPLAY**   
*AMMO CONVERSIONS*
- Added new attachment types to the **MP 40**, **MP18** and **Uzi** that rework their gun stats

*LEADERBOARDS*
- Leaderboards now show the top 100 players in any given category (previously showed top 50)

**>BALANCE**    
*FAMAS*
- Reduced damage to 25 (previously 27)
- Reduced vertical recoil to 35 (previously 80)
- Reduced horizontal recoil to 20 (previously 30)

*FN FAL*
- Reduced vertical recoil to 55 (previously 90)

*Spike X1S*
- Increased range to 131m (previously 31m)

**>QOL & BUG FIXES**   
- Fixed no player being assigned VIP status in the VIP gamemode

- Fixed players being able to secure the hill during intermission in the KOTH gamemode

- Fixed gamemode information popup from not displaying at the end of intermission

- Fixed death cam still playing despite being disabled by the user or the server

- Fixed AWM mastery calling card not being unlockable   



# January 1st, 2024 (1/1/24)   
**>QOL & BUG FIXES**   
- Text displaying a players keybind now shows the letter as a capital letter

- Fixed Main Menu requiring a forced delay before showing up after connecting to a server, should now be close to instant

- Fixed gamemode information popup from not displaying at the proper time if joining a match already in progress

- Fixed hit sounds being sent to a nil entity if killed by a car/cranked self destruction

- Removed Voice chat indicator from the HUD editor preview



# December 31th, 2023 (12/31/23)   
**>GAMEPLAY**   
*MATCH INTERMISSION*
- By default, players will be frozen for the first 30 seconds of a match to allow other players to connect in time

*MOVEMENT CHANGES*
- The perks of sliding at a downward angle are now more effective on shorter slopes
- Sliding at a downward angle will now set your sliding duration to 0.4 seconds if it was below 0.4 seconds when beginning the downward slide
- Slide fatigue now affects your sliding duration

*NEW SETTINGS*  
- 2x ADS Sensitivity
- 4x ADS Sensitivity
- 8x ADS Sensitivity
- Death Cam toggle
- Voice Chat Indicator toggle

*NEW KILLSOUND OPTIONS*
- Counter Strike

*AMMO CONVERSIONS*
- Added new attachment types to the **ACR**, **AS Val**, **Desert Eagle** and **Glock 18** that rework their gun stats

*WEAPON NAME ADJUSTMENTS*
- Renamed ACR-R to ACR
- Renamed AUG A3 to AUG A2
- Renamed CheyTac M200 to Intervention
- Renamed Colt M1911 to M1911
- Renamed Colt M45A1 to M45A1
- Renamed DSR-1 Veresk to DSR-50
- Renamed OTs-14 Groza Veresk to Groza
- Renamed SIG P320 Veresk to P320
- Renamed UZK-BR99 Veresk to BR99

**>BALANCE**    
- All melee weapons have been standardized stat-wise and will all deal the same damage and have the same swing cooldown
- Increased reload, empty reload, and rechambering speeds across almost every weapon (typically a 15-30% improvement)
- Reduced visual recoil across all shotguns
- Rebalanced foregrip attachment
- Removed foregrip from various weapons

*Melee*
- Increased damage to 150 (previously 75-100)
- Both types of swings now function identically, but still differ in animation

*Foregrip Attachment*
- Reduced vertical recoil reduction to 35% (previously 60%)
- Increased horizontal recoil reduction to 25% (previously 20%)
- Increased mobility reduction to 4% (previously 2.5%)

*ACR*
- Increased damage to 32 (previously 30)
- Reduced RPM to 650 (previously 800)
- Reduced vertical recoil to 20 (previously 30)

*FN FAL*
- Reduced vertical recoil to 90 (previously 200)

*Honey Badger*
- Reduced vertical recoil to 45 (previously 65)
- Reduced horizontal recoil to 25 (previously 30)

*KAC ChainSAW*
- Reduced vertical recoil to 40 (previously 64)
- Reduced horizontal recoil to 15 (previously 28)

*KSG*
- Reduced damage per pellet to 12 (previously 13)

*PP-19 Bizon*
- Reduced magazine capacity to 44 (previously 64)

*SCAR-H*
- Reduced RPM to 500 (previously 550)

*SKS*
- Reduced RPM to 400 (previously 500)

*SPAS-12*
- Increased pellets per shot to 15 (previously 12)

*Stevens 620*
- Increased magazine capacity to 6 (previously 5)
- Reduced vertical recoil to 150 (previously 200)

*Typhoon F12*
- Reduced vertical recoil to 150 (previously 200)

**>QOL & BUG FIXES**   
- Players can now send and read chat messages during map/gamemode voting

- Overhauled the playermodel customization screen

- Overhauled the scoreboard layout and animations

- Added Steam Profile buttons to the leaderboard

- Added a notification when importing HUD codes and resetting HUD settings to default

- Added two new Pride calling cards

- Bender is now the default HUD font for new players (previously Arial)

- Voice chat indicator is now affected by HUD bounds

- Voice chat indicator added to the HUD editor preview

- Added the "sv_tm_deathcam" ConVar that can forcefully enable/disable the death camera system

- Adjusted the text of various hints

- Adjusted the images of various calling cards

- Fixed "Open Steam Profile" button not working on scoreboard

- Fixed a movement speed exploit when landing on the ground while crouched after a slide

- Fixed weapon quick switching not functioning when playing the Gun Game gamemode

- Fixed various naming errors in calling cards

- Fixed alphabetical sorting for weapon arrays and calling card arrays

- Fixed missing descriptions for player level related calling cards

- Fixed Lua errors when firing the AN-94

- Fixed RFB reload animation

- Fixed Scoreboard level UI when player is max level

- Fixed HUD Reset not applying all of the default settings

- Fixed End Of Game UI not triggering for a player if said player was in the Main Menu at the end of a match

- Fixed Level Up notification from triggering an error if the player has not spawned in yet

- Fixed very rare occurance of sub-menus opening twice if clicked too many times during loading



# November 26th, 2023 (11/26/23)    
**>GAMEPLAY**   
*RELOAD CANCELING*
- Most reloads can now be canceled by left clicking if you have ammo left in the magazine, this can not be done while sprinting/aiming down sights

*ADS SENSITIVITY PARITY*
- All weapons now have the same ADS sensitivity, no matter the weapons mobility (your sensitivity might feel a bit high, especially with scopes, you can lower this in the Titanmod settings)

**>BALANCE**    
*Barrett M98B*
- Reduced mobility to 75% (previously 80%)
- Reduced rechambering speed slightly

*DSR-1*
- Reduced rechambering speed slightly

*Spike X1S*
- Increased RPM to 175 (previously 115)

*SV-98*
- Doubled rechambering speed

*Mosin Nagant*
- Doubled rechambering speed

**>QOL & BUG FIXES**   
- Server ConVars are now properly replicated for players, fixing a variety of visual bugs

- Fixed "'Player' is on the Knife" notifications on Gun Game only being sent to the player that is now on the knife

- Potentially fixed the wrong player receiving the win on Gun Game

- Fixed PPSH not having ammo loaded on first deploy



# November 25th, 2023 (11/25/23)    
**>QOL & BUG FIXES**   
- Corrupted player saves are now fixed accordingly upon joining a server running the gamemode



# November 24th, 2023 (11/24/23)
**>GAMEPLAY**   
*CLIENT SIDED MOVEMENT*
- Wall running, wall jumping, and sliding are now all done on the client, this means that no matter your ping, there will be no delay or stutters

*SLIDE FATIGUE*
- Instead of the traditional sliding cooldown, you are now able to spam slides, but if you are sliding too frequently, your slide velocity will be lower (only applies if slides are less than 1 seconds apart)

*SLIDE ACCELERATION AND TIME*
- Time spent sliding at an downward angle will no longer count towards your slide duration
- Sliding at a downward angle will now add extra velocity to the slide

**>MAPS**   
*Arctic*
- Added access to the roofs of buildings
- Improved the atmosphere of the unreachable areas
- Reduced amount of falling snow particles
- Added snowmen :)

*Shoot House*
- Increased the gap of all doorways
- Removed most on-ground props
- Improved map geometry consistency

**>QOL & BUG FIXES**   
- Overhauled the notification system for things like match time warning, level up notifications, and more

- Overhauled the card customization screen

- Added 19 new calling cards

- Throwing a grenade is now handled client side

- Added a notification if a player self destructs on Cranked that explains why they blew up

- Removed motion blur that would be triggered while sliding

- New HUD icons for the grappling hook and the grenade

- Added the "sv_tm_player_custommovement" ConVar that can enable/disable wall running/jumping, sliding, and vaulting

- Unlocked calling cards now appear at the top of calling card pages

- Adjusted visibility of the exit button across menus

- Adjusted various calling card art, unlock requirments, names and descriptions

- Fixed "Dead Slides" when inputting a slide input within 200 miliseconds of a previous slide



# November 8th, 2023 (11/8/23)
**>GAMEPLAY**   
- Reverted new custom bullet tracers due to visual bugs, will return in the future

**>QOL & BUG FIXES**    
- Fixed locked mastery cards not showing progress bars

- Adjusted various menu UI objects that wouldn't trigger a UI sound

- Slightly adjusted death and level popup text



# November 4th, 2023 (11/4/23)
**>GAMEPLAY**   
*MOVEMENT ADDITIONS/CHANGES*    
- Added Slide Cancelling (new settings determines which input cancels a slide)
- Sliding speed is now affected by velocity (if the player is moving at a decent speed)
- Canceling a Slide will dynamically impact the Slide cooldown
- Your character will no longer lose velocity at the end of a Slide
- Landing on the ground while inputting a SPRINT and a CROUCH will initiate a Slide immediately upon landing
- Crouch transition speed increased by 20%
- Slide duration increased by 25%
- Removed Jump Sliding (was very powerful, but was only used by a handful of players, giving them a big advantage)

*GUN TRACERS OVERHAUL*  
- Tracers have been completely redesigned and are now gun dependent (a SMG will have a smaller and less visible tracer compared to a Sniper)

*AMMO CONVERSIONS*  
- Added experimental attachment options to the **KRISS Vector** and the **Mac 10** that rework the guns stats

*NEW SETTINGS*  
- Slide Cancel type (Release, Jump, or Sprint)
- Dynamic Crosshair type

**>BALANCE**    
- Removed **Magnum Ammunition** from all weapons (was a free damage upgrade, couldn't tell when it was being used, new players who didn't learn to equip it were at a big disadvantage)
- Removed **Match Ammunition** from all weapons (wasn't very useful, was basically a free recoil reduction)
- All Secondaries (excluding hand cannons/revolvers) now have point fire as an attachment option
- Point Fire no longer requires a laser sight to be attached to a weapon

*FN 2000*   
- Reduced damage to 27 (previously 31)

*M249*  
- Increased spread to 50 (previously 40)

*M3 Grease Gun* 
- Reduced damage to 30 (previously 32)
- Reduced vertical recoil to 20 (previously 32)
- Reduced horizontal recoil to 5 (previously 12)

*PKP*   
- Increased spread to 59 (previously 29)

*PM-9*  
- Gas Port Adjustment now decreases recoil by 50% and increases damage by 10%

*Sten Gun*  
- Increased damage to 32 (previously 30)

*StG 44*    
- Reduced damage to 35 (previously 40)
- Increased vertical recoil to 45 (previously 32)
- Increased horizontal recoil to 20 (previously 12)

*VHS-D2*    
- Reduced vertical recoil to 45 (previously 65)
- Reduced horizontal recoil to 20 (previously 30)

**>QOL & BUG FIXES**    
- Official Servers now run on 60hz again (previously 30hz) (will monitor server performance to see if this runs smoothly)

- All sniper scopes are now set to the same FOV

- Health and Ammo bars now smoothly scale instead of instantly changing size

- Crosshair now fades away while sprinting

- Added progress bars to player models/cards that you do not have unlocked in the customization menu

- Heavy optimization for many movement related functions

- Decreased volume of sliding related sound effects

- The pitch of sliding related sound effects now slightly vary on each slide

- Adjusted visual effect of mantling

- Adjusted default crosshair settings for new players

- Adjusted penetration system to stop bullet after passing 3 objects

- Fixed some secondaries not firing underwater

- Fixed health bar color not correctly updating on a customized player health

- Fixed PKP having spread while aiming down sights

- Fixed PzB 39 ADS sensitivity

- Removed Gun Chambering

- Removed Show Crosshair while aimed down sights setting due to it being powerful when used with point firing



# October 25th, 2023 (10/25/23)
**>QOL & BUG FIXES**    
- Fixed KOTH from, literally not functioning at all

- New end of match quotes from community members



# October 19th, 2023 (10/19/23)
**>GAMEPLAY**   
*CROSSHAIR OVERHAUL*    
- I ditched the TFA crosshair and created my own crosshair system with even more customization options, a preview while editing the settings, and more

*HUD CODES* 
- You can now export your HUD customization settings as a code and can import other codes sent to you in the HUD editor

*NEW SETTING*   
- Render Body toggle

**>QOL & BUG FIXES**    
- All text color based HUD settings were combined into one universal setting

- Added various crosshair settings

- Adjusted animation for the kill notification

- Fixed the first kill feed entry always being inaccurate in size

- Fixed XP Multiplier not affecting XP granted from match end bonuses

- Potential fix for gamemode desync between server and clients

- Various improvements to the look and feel of the UI and menus

- Removed obsolete fonts to improve performance



# October 16th, 2023 (10/16/23)
**>QOL & BUG FIXES**    
- Added Score as a leaderboard category

- Increased strength of the Main Menu background gradient

- Adjusted transparency values across different Main Menu screens

- Leaderboard cooldown is no longer applied until you manually switch categories

- Fixed lua error when exiting the Main Menu after recently switching a Leaderboard category

- Main Menu gradient can now flip coloring randomly



# October 8th, 2023 (10/8/23)
**DISCLAIMER!!!**   
- Default HUD settings now differ GREATLY as of this update, I recommend reverting to default through the HUD Editor, or at the very least, resetting all of your 'offset' settings due to the new HUD edge bound settings.

**>GAMEPLAY**   
*NEW SETTINGS*  
- HUD Edge Bounds X
- HUD Edge Bounds Y
- Damage Indicator toggle
- Damage Indicator color
- Damage indicator opacity

**>MAPS**   
*Legacy*    
- Added additional player spawns
- Fixed missing tree model

**>BALANCE**    
*Beretta Mx4*
- Reduced damage to 27 (previously 28)
- Increased vertical recoil to 35 (previously 30)
*Gun was very powerful, even beyond CQC, this should put it in a healthy spot.*

*Dual Skorpions*
- Increased RPM to 2400 (previously 1800)

*FAMAS*
- Now fires in Full Auto with 1100 RPM
- Reduced damage to 27 (previously 31)
*I get it, you guys aren't fans of a burst fire mode being forced.*

*Glock 18*
- Increased Burst RPM to 1200 (previously 900)
- Renamed to 'Glock 18' (previously 'Glock 17') as the weapon better fits this firearm IRL

*KRISS Vector*
- Recoil has been flipped, requiring you to now pull up to control the weapon

*Mac 10*
- Increased damage to 22 (previously 21)
*The Mac 10 can be seen as being 1:1 with the Uzi, but due to it being much harder to control, this change should make it more diverse.*

*MTs255*
- Increased RPM to 190 (previously 130)

*Stevens 620*
- Increased rechambering speed by 50%
*The Stevens has been seen as the weakest shotgun for quite a while, this should make it much more capable of killing targets.*

*UMP9*
- Reduced vertical recoil to 17 (previously 25)
- Reduced horizontal recoil to 7 (previously 15)
*While the gun was never hard to control, its DPS is still pretty low, this change should help it stand out.*

**>QOL & BUG FIXES**    
- Garry's Mod Pause Menu/Console is now accessible while in the Titanmod Main Menu/EOR Menu

- Added gamemode specific HUD elements to the HUD editor preview

- Added Gravity font as a option in the HUD editor

- Added subtle gradient to the background of the Main Menu

- Increased the speed of hint text fly-by in the Main Menu

- Cranked HUD element now is colored using the OBJ Contested color setting

- Fixed 'User Interface' setting not disabling the HUD when toggled off

- Fixed rounded edges on scoreboard

- Fixed HUD still rendering while in the Main Menu

- Fixed missing textures on Hunk player model

- Fixed potential errors due to KOTH/VIP HUD elements being initialized early

- Optimized HUD, Main Menu, and damage indicators

- Increased responsiveness of KOTH/VIP HUD elements

- Removed Astolfo player model (replaced by Homelander)

- Removed Font Scale setting

- Removed most Menu tooltips

- Removed the PAUSE MENU and LEAVE GAME buttons across the Main Menu/EOR Menu as they are now useless

- New end of match quotes from community members



# September 24th, 2023 (9/24/23)
**>GAMEPLAY**   
*HUD IMPROVMENTS*
- Many HUD elements like the match time, kill feed, and gamemode specific information are now shown while waiting to respawn

**>QOL & BUG FIXES**    
- Potential fix for Engine Error crashes related to model preloading

- Complete icon overhaul across the Menu/UI for more consistency and a cleaner look

- New order for categories in settings

- Renamed many settings to improve naming consistency across said settings

- Improved loading speed across various menu subsections

- Changed the style of locked calling cards in the menu (it doesn't look very good but I plan on revamping the menu)

- Adjusted art on a few calling cards

- Decreased gamemode file size



# September 3rd, 2023 (9/3/23)
**>BALANCE**    
*Webley*
- Increased damage to 80 (previously 75)

**>QOL & BUG FIXES**    
- Removed TCo Stim Pistol from Quickdraw rotation

- Removed XP from objective based score (was too easy to farm lmao)

- Fixed HUD displaying while dead

- Fixed Kill Tracker not displaying

- Fixed various Lua errors

- Explosive Jumping is now possible with grenades (if they don't one shot you lol)

- Optimized various server-related functions

- Removed FPS/Ping counter and related options (most people already have FPS counters through GMOD or external means, this was kinda useless)

- Temporarily removed Level, K/D Ratio, and W/L Ratio leaderboard options due to extreme server lag



# September 2nd, 2023 (9/2/23)
**>GAMEPLAY**   
*NEW WEAPONS*
- **KAC ChainSAW** (Primary, LMG)
- **PKP** (Primary, LMG)

*NEW GAMEMODES*
- **KOTH**, fight for control over a specific part of the map to gain score
- **VIP**, typical FFA but one player is designated as a VIP and gets gains score every second, kill them to take the status for yourself
- **Quickdraw**, typical FFA but with only secondary weapons

*MOVEMENT CHANGES*
- Wall running no longer requires the player to be holding a forward input
- Wall running cooldown was lowered to 1.25s (previously 1.5s)

*QUICK WEAPON SWITCHING*
- A new setting (that is **ON** by default) that allows you to change to your Primary, Secondary, and Melee weapons with keybinds that you can set in Settings

*CUSTOM FOV SYSTEM*
- A new setting (that is **OFF** by default) that allows you to change your FOV beyond the 100 FOV maximum in Garry's Mod, with the max being **125 FOV** with this setting enabled.

*MAP VOTING REWORK*
- Map and mode voting has been rewritten to have more variety and to be more applicable to player counts
- The first map will always be a map suitable for the player count (small map if less than 6 players are playing, large if more than 6)
- The second map can be any map in the game, allowing for small maps to rarely be playable on full lobbies (chaotic but fun)
- Votes are now shown in percentages instead of amount of votes on said map/mode

*MODE VOTING REWORK*
- The first mode will always be a simplistic gamemode (FFA, FFA with loadout variations, etc.)
- The second mode will always be a complicated gamemode (Objective modes, gun game, etc.)

*NEW HITSOUND OPTIONS*
- Apex Legends
- Call Of Duty

*NEW KILLSOUND OPTIONS*
- Apex Legends

**>MAPS**   
*NEW MAPS*
- Shoot House

**>QOL & BUG FIXES**    
- The order of weapons on the weapon selector have been reversed to better represent the new quick switch setting (Primary > Secondary > Melee)

- Gun Game weapon ladder has been increased to 26 weapons (previously 24)

- Increased health regeneration speed by 20%

- Added Mute button to the Post Game UI that disables the voice chat

- Added HUD indicator when transmitting your microphone

- Main Menu has brand new sound and visual effects

- Added Enable Menu Sounds option

- Added various HUD editor options related to the new gamemodes

- Music Volume setting now affects End Of Match music

- New end of match quotes from community members

- Fixed Cranked self destruct not triggering an explosion

- Optimized HUD, gamemode checks, FPS/Ping counter, main menu, voice chat, leaderboards, health regeneration, and ConVar updating

- Removed HL2 suit zoom (was not intended)

- Removed Main Menu music (was disliked by players)

- Removed custom font options for Kill/Death UI, they are now both on by default

- Removed ADS Vignette option

- Removed obsolete gamemode code

- Adjusted various ConVar descriptions

- Players save data can no longer be wiped via the console while not in Main Menu

- Adjusted order of gamemodes when changing the gamemode ConVar



# August 7th, 2023 (8/7/23)
**>QOL & BUG FIXES**    
- Added player cards for levels 185 - 240

- Reduced strength of weapon bobbing while jumping/mid air

- Slightly increased breathing animation while walking and aimed down sights

- Grenades now explode prematurely after taking damage (allows for chain reactions and shooting grenades)

- Fixed Titanmod Content Packs not working properly on gamemodes other than Titanmod



# August 6th, 2023 (8/6/23)
**>GAMEPLAY**   
*WEAPON BOB/SWAY*
- Weapon bob and weapon sway have been completely redesigned to be much more consistent and more grounded

**>MAPS**   
*Disequilibrium*
- Reduced brightness of the sun

*Mall*
- Removed outdoor spawns
- Added additional interior spawns

*Mephitic*
- Removed spawn that was exposed to acid
- Added additional player spawns

**>BALANCE**    
*Crossbow*
- Increased reload speed

*FAMAS*
- Improved burst consistency

*Glock 17*
- Improved burst consistency

*Howa Type 64*
- Increased reload speed

*M1 Garand*
- Increased reload speed

*M1918*
- Increased reload speed

*XM8*
- Reduced damage to 29 (previously 31)
- Increased mobility to 85% (previously 84%)

**>QOL & BUG FIXES**
- Tightened firing animations across multiple weapons

- Player cards for levels 155 - 180

- Removed Spike X1S from Shotty Snipers weapon rotation

- Adjusted some Leveling player cards

- Precacher is now skipped if Developer Mode is on



# August 5th, 2023 (8/5/23)
**>GAMEPLAY**   
*KNOCKBACK ADDITION*
- Sawed Off now has an attachment (Gust) that allows you to shotgun jump (may be added to more shotguns in the future)
- RPG-7 now knocks the player back after shooting, performing a rocket jump also has extra upwards velocity due to this change

*GRENADE CHANGES*
- Grenades now do **significantly** more damage, being able to one shot if a player is close enough to the impact
- The animation for throwing a grenade has been improved

*ANIMATION CHANGES*
- Increased reload speed across many different weapons (mostly on secondaries)
- Reduced bounciness on certain guns when being fired with iron sights (mostly on secondaries)

**>BALANCE**    
*CZ 75*
- Now fires in automatic
- Reduced damage to 30 (previously 31)

*FN 2000*
- Reduced damage to 31 (previously 32)

*MP5*
- Reduced damage to 28 (previously 33)

*MP5K*
- Reduced vertical recoil to 30 (previously 40)

*PM-9*
- Moved weapon to the Secondary weapons category
- Reduced damage to 21 (previously 24)

*Spike X1S*
- Now is classified as a Sniper (previously a Shotgun)
- Added high magnification optics

*Tariq*
- Removed Extended Magazine attachment

**>QOL & BUG FIXES**    
- Adjusted text on the Velocity counter

- Fixed Health Bar coloring not matching the proper color settings

- Added Flechette attachment to every shotgun that did not have it

- Removed Shotgun Ammunition attachments that closely matched already existing attachments



# August 1st, 2023 (8/1/23)
**>QOL & BUG FIXES**    
- Server ConVars for every Config option is now available ("sv_tm" with 30+ changeable options available)

- Removed obsolete Config values



# July 31st, 2023 (7/31/23)
**>QOL & BUG FIXES**    
- Added a visual progress bar that counts down the players Cranked timer

- Players now explode once their Cranked timer ends

- Removed Bow and Crossbow from Gun Game weapon rotation

- Fixed bug with player levels not being calculated on match end



# July 22nd, 2023 (7/22/23)
**>BALANCE**    
- Increased reload speed across all revolver-based weapons

**>QOL & BUG FIXES**    
- On match end, the played gamemode will no longer appear in the next gamemode vote

- HUD functions have been refactored

- Optimized hit and kill sounds

- Reset HUD To Default now resets new HUD element settings

- New end of match quotes from community members



# July 20th, 2023 (7/20/23)
**>GAMEPLAY**   
*ANIMATION CHANGES*
- Deploy animations sped up on all weapons by 200-400%
- Draw/switching animations sped up on all secondaries by 150-250%

*MOVEMENT CHANGES*
- Grapple cooldown reduced to 15 seconds (previously 18)

**>BALANCE**    
*AUG A3*
- Increased mobility to 93% (previously 87%)

*Barrett M98B*
- Increased mobility to 80% (previously 60%)

*FAMAS*
- Increased damage to 31 (previously 28)

*Glock 17*
- Increased mobility to 95% (previously 85%)

*OTs-14 Groza*
- Reduced horizontal recoil to 20 (previously 30)

*PzB 39*
- Gun now has perfect hip fire accuracy
- Drastically increased rechambering speed
- Drastically increased reload speed

**>QOL & BUG FIXES**    
- 7 new Accolade unlock-able player models (1 per accolade)

- Leveling calling cards are now unlocked every 5 levels (previously 10)

- Adjusted unlock requirements for Accolade player models

- Added Velocity Counter setting

- Added Velocity Counter X offset, Y offset, and RGB HUD settings

- Added Compensate Sensitivity w/ FOV setting

- New end of match quotes from community members

- c_hands on CS:S player models have been changed to c_hands of higher fidelity

- Fixed ADS sensitivity scaling on AUG A3, Barrett M98B, M249 and PzB 39

- Optimized HUD

- Replaced some leveling calling cards

- Increased radius of spawn point checks by 128 units

- Adjusted XP requirement curve on player levels 55-60



# July 17th, 2023 (7/17/23)
**>QOL & BUG FIXES**    
- Added Precaching on models, materials, sounds, and particles (slightly longer load times, but far less stuttering)

- Fixed Cranked time on the HUD not resetting properly on death

- Optimized functions related to player spawning/kills/deaths

- Fixed Scoring and match result desync on client when playing the Cranked gamemode

- Fixed S&W 500 Bore Ammunition spawning unloaded



# July 15th, 2023 (7/15/23)
**>GAMEPLAY**   
*NEW GAMEMODE*
- Cranked is now in Titanmod! Once getting a kill, you will receive a 30% buff to your mobility, but at a cost, if you do not kill another player within 25 seconds, you will die. Getting a kill resets this timer back to 25 seconds.

*WEAPON ADJUSTMENTS*
- Renamed Japanese Ararebo to Mace

**>BALANCE**    
*FN FAL*
- Removed 30 round magazine attachment

*M249*
- Reduced damage to 26 (previously 28)
- Reduced mobility to 70% (previously 80%)

*Mare's Leg*
- Gun now has perfect hip fire accuracy

*Mk 14 EBR*
- Removed 30 round magazine attachment

*Nova*
- Increased damage to 13 (previously 12)

*SCAR-H*
- Reduced horizontal recoil to 33 (previously 60)

*Scorpion Evo*
- Reduced damage to 19 (previously 20)

**>QOL & BUG FIXES**    
- Reduced volume of sliding

- Fixed rare cases where certain guns w/ specific attachments would not come loaded when first equipped

- Adjusted name for the Titanmod dedicated server

- Fixed reload animation on AS-VAL while having the foregrip equipped

- Removed YOU / FOE counter from death UI (reducing clutter)



# July 14th, 2023 (7/14/23)
**>GAMEPLAY**   
*GUNPLAY CHANGES*
- Mechanical and visual recoil has been reduced by 5% across all weapons

*MOVEMENT CHANGES*
- Mantling can now be performed while crouching

**>MAPS**   
*Initial*
- Added additional player spawns
- Adjusted lighting
- Removed fog

*Rig*
- Increased the speed of the elevator by 400%
- Increased map brightness
- Removed fog
- Halved the amount of rain particles
- Improved performance

**>BALANCE**    
*AS-VAL*
- Increased default magazine capacity to 30 (previously 20)
- Reduced horizontal recoil to 15 (previously 18)
- Removed 10 & 40 Round Magazine attachments

*Bow*
- Increased damage to 200 (previously 85)

*Crossbow*
- Increased damage to 200 (previously 105)

*MTs225*
- Increased damage to 12 (previously 11.5)
- Reduced vertical recoil to 75 (previously 125)
- Reduced intensity of visual kick when firing

*P90*
- Reduced horizontal recoil to 20 (previously 30)

*PP-19 Bizon*
- Reduced damage to 28 (previously 29)
- Reduced vertical recoil to 30 (previously 42)

*PPSH*
- Reduced damage to 27 (previously 29)
- Reduced vertical recoil to 18 (previously 42)
- Increased horizontal recoil to 12 (previously 7)

*Sawed Off*
- Increased vertical recoil to 370 (previously 270)
- Reduced intensity of visual kick when firing

*UZK-BR99*
- Reduced vertical recoil to 115 (previously 255)
- Reduced intensity of visual kick when firing

**>QOL & BUG FIXES**    
- Optimized HUD

- Added Credits button on the Main Menu

- Player models are now pre-cached

- Removed weapons from the Gun Game ladder generation that have bugged sounds while playing Gun Game

- Fixed oddities in weapon priority (no longer spawning with melee equipped instead of a weapon) 

- Pause Menu button now properly stops the Menu Music

- Kill Feed Item Limit is now 6 for new players (previously 4)

- Default Menu Music volume is now 66% for new players (previously 100%)

- Fixed console errors when launching Garry's Mod with the gamemode installed



# July 11th, 2023 (7/11/23) (Steam Workshop Release)
**>GAMEPLAY**   
*WEAPON ADJUSTMENTS*
- Renamed MTs225-12 to MTs225
- Renamed PINDAD SS2-V1 to PINDAD SS2
- Renamed PPSH-41 to PPSH
- Renamed SR-2M Veresk to SR-2

**>QOL & BUG FIXES**    
- Max Player Count is now 12 on official dedicated servers

- 14 new Accolade unlockable calling cards (2 per accolade)

- Adjusted unlock requirements for Accolade calling cards

- Reordered the categories in the calling card menu

- Renamed some calling cards

- Horizontally flipped some calling cards for better visibility when equipped

- Added button SFX to randomize card/model buttons

- Updated Workshop ID/Links



# July 1st, 2023 (7/1/23)
**>GAMEPLAY**   
*GUNPLAY CHANGES*
- Hip fire spread has been reduced globally by 20%
- Standardized knife damage profiles (read **BALANCE** for more details)

*MOVEMENT CHANGES*
- Sliding now has a cooldown of 0.9 seconds, said player not being grounded will remove this cooldown, allowing for consecutive jump slides
- Reduced crouch enter/exit time by 7.5%

*LEADERBOARD ADJUSTMENT*
- Added all Accolades as selectable options
- Visual overhaul of the Leaderboard menu

**>MAPS**   
*NEW MAPS*
- Legacy
- Oxide

*REMOVED MAPS*
- Devtown

**>BALANCE**    
*Colt 9mm*
- Reduced vertical recoil to 20 (previously 35)
- Reduced horizontal recoil to 8 (previously 16)

*Glock 17*
- Reduced spread to 6 (previously 15)

*SCAR-H*
- Reduced damage to 45 (previously 52)

*KM-2000 & Tanto*
- Both knifes now have the same stats, and have both seen a buff to their damage (66 primary, 125 secondary)

**>QOL & BUG FIXES**    
- A player will now always spawn with their primary equipped

- A player will now always spawn with their sniper equipped when playing the Shotty Snipers gamemode

- Canceling a Grappling Hook shot now resets your cooldown

- Playermodel and Playercard menus have been improved visually

- Improved visual for scroll bars

- Reduced intensity of sliding blur when Motion Blur is enabled

- Fixed End Of Game stage breaking if a player leaves the match before the voting phase begins

- Actually fixed players steam names not being correctly set in the save database, resulting in player names being NULL on the Leaderboard

- NULL names on Leaderboards are now shown as the players SteamID

- Decreased Depth Of Field strength on scoreboard

- Fixed various bugs with Grappling Hook



# June 24st, 2023 (6/24/23)
**>GAMEPLAY**   
*MOVEMENT*
- A missed grapple shot will no longer trigger a grappling hook cooldown

**>MAPS**   
*NEW MAPS*
- Wreck

*REMOVED MAPS*
- Hydro

**>BALANCE**    
*Mac 10*
- Reduced horizontal recoil to 10 (previously 30)

*Mare's Leg*
- Increased damage to 99 (previously 95)
- Removed Ammunition attachments

**>QOL & BUG FIXES**    
*END OF MATCH REWORK*
- The end of match and voting process has been overhauled to be more visually appealing and to provide more functionality

*MUSIC REWORK*
- The backend for music in the Main Menu has been completely overhauled
- Music will now be paused and resumed when toggling the setting in the menu
- Music now dynamically changes volume when navigating to different parts of the menu
- Music now properly loops again

*OTHER ADJUSTMENTS*
- A bunch of optimization has been implemented, expect more consistent frame rates

- Added SFX after a successful prestige

- Added new gamemode backgrounds

- Menu Music Volume setting now maxes out at a 2x multiplier (previously 1x)

- Fixed ammo bar going out of bounds when chambering a extra round into a weapon

- Players who are on a respawn timer when the End Of Game phase begin no longer respawn

- Servers with hibernation enabled no longer get stuck on the same map and gamemode if all players disconnect during the End Of Match phase

- Players that connect to the server during the End Of Game phase will now have a disclaimer shown on their HUD

- Potentially fixed players steam names not being correctly set in the save database, resulting in player names being NULL on the Leaderboard

- Functions that gather all player entities no longer grab bots (I don't know why bots would be on a Titanmod server but this is just in case someone does something funky)

- Removed Firing Range map and the special functions that accompanied it

- A Hatsune Miku player model is no longer installed when joining a server running the gamemode (lmao)



# June 20th, 2023 (6/20/23)
**>GAMEPLAY**   
*LEADERBOARD ADJUSTMENTS*
- Three new stats are now viewable from the Leaderboard menu
- Level, K/D Ratio, and W/L Ratio are now selectable options

*WEAPON ADJUSTMENTS*
- Renamed CZ 75 B to CZ 75
- Renamed FAMAS F1 to FAMAS

**>MAPS**   
*Disequilibrium*
- Complete rework of the map layout
- Improved performance
- Reduced overall brightness
- Fixed skybox bug when CS:GO is not mounted
- Updated map thumbnail

*Mall*
- Removed fog
- Improved performance

*Mephitic*
- Removed player spawns that are prone to acid
- Adjusted range of fog

*Villa*
- Removed fog
- Fixed invisible walls in some interiors
- Restricted out-of-bounds areas from being accessed (for real this time)

**>BALANCE**    
*FAMAS*
- Now fires in a forced 3 Round Burst with 1100 RPM
- Increased vertical recoil to 80 (previously 50)
- Increased horizontal recoil to 30 (previously 15)

*HK53*
- Reduced spread to 21 (previously 45)
- Reduced spread multiplier to 3x (previously 3.5x)

*M14*
- Reduced vertical recoil to 60 (previously 100)
- Removed Extended Magazine attachment

*M1918*
- Reduced damage to 45 (previously 50)

*M1919*
- Reduced damage to 40 (previously 45)
- Increased horizontal recoil to 35 (previously 25)

*M249*
- Increased damage to 28 (previously 26)
- Reduced vertical recoil to 38 (previously 50)
- Reduced horizontal recoil to 20 (previously 50)

*Mk 14 EBR*
- Reduced vertical recoil to 80 (previously 100)

*Colt M1911*
- Increased damage to 41 (previously 38)

*Colt M45A1*
- Reduced damage to 40 (previously 45)
- Removed Magnum Ammunition attachment

*CZ 75*
- Increased damage to 31 (previously 28)
- Reduced vertical recoil to 40 (previously 60)

*FNP-45*
- Removed Magnum Ammunition attachment
- Removed Extended Magazine attachment

*Glock 17*
- Now fires in a forced 3 Round Burst with 900 RPM
- Reduced damage to 25 (previously 26)
- Increased vertical recoil to 28 (previously 20)

*GSH-18*
- Reduced spread to 12 (previously 16)
- Reduced vertical recoil to 26 (previously 43)

*M9*
- Reduced vertical recoil to 30 (previously 35)

*Model 10*
- Increased vertical recoil to 120 (previously 80)
- Removed Speed Loader attachment
- Snub Nose attachment has increased vertical recoil by 100% (previously 15%)

*MR-96*
- Removed Speed Loader attachment

*OSP-18*
- Increased damage to 38 (previously 33)

*OTs-33 Pernach*
- Reduced damage to 24 (previously 25)
- Increased vertical recoil to 37 (previously 32)

**>QOL & BUG FIXES**    
- Hints are now shown in the Main Menu via a bar that slowly scrolls through all available hints

- Removed built-in flashlights from all weapons due to interference with the custom server-side flashlight system

- Matches played and Matches won are no longer updates on player saves if there is only 1 player logged onto a server

- Disabling the Screen Flashing Effects setting now actually disables screen flashes



# June 11th, 2023 (6/11/23)
**>GAMEPLAY**   
*LEADERBOARDS*
- There are now Leaderboards for all basic statistics + kills on specific weapons
- Leaderboards can be accessed from the Main Menu via the button on the top left and will show the top 50 players of a selected stat
- Players that are offline can still be seen on Leaderboards
- K/D, W/L%, and Player Level will have Leaderboards in the near future

*GUNPLAY CHANGES*
- Recoil has been reduced globally by 20%
- Hip fire spread has been increased globally by 30%

*SNIPER REWORK*
- Snipers now consist of two damage profile categories, 1 shot, and 1 shot torso/head with 2 shot limb
- Removed Ammunition attachments from snipers
- Snipers have been given view punch again when firing to be more satisfying to use

**>BALANCE**    
*AWM*
- Reduced damage to 117 (previously 165)

*AX-308*
- Reduced damage to 115 (previously 134)

*Barrett M98B*
- Reduced damage to 175 (previously 180)
- Reduced mobility to 64% (previously 90%)
- Increased vertical recoil to 275 (previously 75)

*CheyTac M200*
- Reduced damage to 170 (previously 250)
- Increased vertical recoil to 200 (previously 169)

*DSR-1*
- Reduced damage to 139 (previously 172)

*Lee Enfield*
- Reduced damage to 102 (previously 125)

*Mosin Nagant*
- Reduced damage to 111 (previously 145)

*Remington MSR*
- Reduced damage to 113 (previously 184)

*SV-98*
- Increased damage to 110 (previously 94)

*T-5000*
- Reduced damage to 116 (previously 180)

**>QOL & BUG FIXES**    
- Voice chat is now available in the map/mode voting menu (players can push a button to enable/disable their microphone input, a prompt will be shown asking for microphone permission when pressing it for the first time)

- Proximity voice chat range increased by 25%

- Added Source Sans Pro Semibold as a built-in custom HUD Font option

- Fixed Highest Kill Game only updating on a match win

- Separated Color and Pride calling cards into seperate categorires

- Fixed mastery calling card panel size

- Fixed T-5000 mastery calling card texture

- Tweaked Zedo pride calling card description

- Reduced time on button conformations to deter accidental confirmations

- Removed dynamic panel sizing for calling card categories that come pre-unlocked

- Removed Toggle ADS setting (was on by default due to TFA base default settings and it confused new players)



# June 8th, 2023 (6/8/23)
**>DISCLAIMER** 
- All player data/stats/unlocks/levels have been **RESET** as of this update, this is a massive inconvenience, but it was required in order to switch to a safer and stable saving system, a data wipe should never have to occur ever again, and I am sorry for doing this so suddenly.

**>QOL & BUG FIXES**    
- Player statistics and how they are saved after playing have been completely reworked to avoid future problems

- New player statistics have been added (Highest Kill Game and W/L Ratio)

- Removed some player statistics that were not necessary and bloated the database (Times killed by specific weapon and Times you have used a specific weapon)

- Another attempt at fixing the Main Menu not always opening up on server connect

- Correctly named some incorrect calling card names

- Updated text of some statistics when viewing player stats through the scoreboard

- Removed the function of the Main Menu statistics button, will be replaced with Leaderboards soon



# June 7th, 2023 (6/7/23)
**>GAMEPLAY**   
*COMPLETE GUNPLAY OVERHAUL*
- Gunplay as a whole has been completely altered for a much more consistent and skill based experience, here are a few notable changes:
- Weapons no longer have any spread when aiming down sights and bullets will always follow your reticle
- Visual recoil is now much less floaty, and bullets no longer fire under/above the sight
- Shotguns now have view punch, it looks really satisfying

*WEAPON ADJUSTMENTS*
- Renamed AKMS to AK-47
- Renamed B&T MP9 to MP9
- Renamed MP7A1 to MP7
- Renamed Lee-Enfield No. 4 to Lee Enfield
- Renamed Orsis T-5000 to T-5000
- Renamed Owen Mk.I to Owen Gun
- Renamed Sten Mk.II to Sten Gun
- Removed the DDM4V5, FB MSBS-B, KSVK 12.7, RK62, and the Type 81 from the weapon pool (either similar to other, more prominent weapons, or too low quality)

**>MAPS**   
*Nuketown*
- Fixed players spawning into brushes

*Shipment*
- Reduced amount of vegetation
- Improved lighting and shadows
- Added additional player spawns

*Villa*
- Added additional player spawns
- Improved performance
- Restricted access to unintended parts of the map

**>BALANCE**    
*Bow*
- Increased projectile velocity to 6000 (previously 3000)

*Crossbow*
- Increased projectile velocity to 8000 (previously 4000)
- Can no longer be fired while underwater

*Dual Skorpions*
- Reduced damage to 18 (previously 23)

*KRISS Vector*
- Reduced damage to 21 (previously 24)
- Increased horizontal recoil to 15 (previously 10)

*MP9*
- Reduced damage to 26 (previously 30)
- Reduced horizontal recoil to 9.5 (previously 13.5)

*Remington MSR*
- Aim down sight time reduced to 0.23 (previously 0.43)

*Scorpion Evo*
- Reduced damage to 20 (previously 22)

**>QOL & BUG FIXES**    
- Weapons now properly deal their intended damage to specific limbs

- Three new music tracks, two of which being tracks suggested or created by the community

- Adjusted the OPTIONS button to function similarly to the CUSTOMIZE button, having two drop down options for Settings and for HUD settings

- Adjusted the leveling text on the Main Menu

- Switched Steam profile links from vanity URLs to permanent SteamID URLs

- Decluttered death UI to be more readable

- Fixed faults in the alphabetical sorting for cosmetics

- Removed VM FOV multiplier setting

- Removed various HUD related settings and combined them into already existing settings



# May 27th, 2023 (5/27/23)
**>GAMEPLAY**   
*NEW GAMEMODE*
- Shotty Snipers is now in Titanmod! Players will always spawn with a sniper and a shotgun when playing on this gamemode.

**>QOL & BUG FIXES**    
- New logo and banner art

- Reduced gamemode size by 150~ MB

- Added match status above the Spawn Button in the Main Menu

- Added gamemode tooltips when hovering over a selection in the gamemode vote

- Added brand new music tracks, while removing a few old ones

- Added a music link button beside the quick mute button that opens a YouTube link to the song being played

- Suiciding now demotes your level in Gun Game

- Changed default value of music volume from 0.9 to 1

- Standardized and increased amplitude globally across all music tracks

- Added additional tooltips to Main Menu buttons

- Fixed suicides not randomizing loadouts on FFA

- Fixed bug when quick muting or unmuting music from the Main Menu

- Fixed the keypress overlay Y offset being affected by the X offset convar

- Removed unused/obsolete PData entries

- Removed Main Menu side panel

- Removed Map thumbnail preview from Main Menu



# May 19th, 2023 (5/19/23)
**>GAMEPLAY**   
*NEW GAMEMODE*
- Fiesta is the third Titanmod gamemode. Every player has the same shuffled loadout, and this loadout is changed every 30 seconds.

*TUTORIAL*
- Players who join a server running Titanmod for the first time will be shown a basic Tutorial. This is meant to improve the new-player experience. The tutorial can be opened up by anyone through a new button in the Main Menu

**>BALANCE**    
*KRISS Vector*
- Reduced aim spread to 20 (previously 50)
- Reduced spread growth to 3 (previously 4)

*Uzi*
- Increased damage to 20 (previously 18)

*G28*
- Increased vertical recoil to 114 (previously 44)

**>QOL & BUG FIXES**    
- Changing your calling card now updates the calling card in the Main Menu instantly

- Fixed a error when unmuting Main Menu music through the quick mute button

- Fixed centering on the XP counter on the scoreboard

- Fixed gamemode desync between server and client

- Potential fix for the Main Menu not always opening on server connect



# April 30th, 2023 (4/30/23)
**>QOL & BUG FIXES**    
- Players can no longer get soft locked if they get demoted without getting a kill first in Gun Game

- Gun audio should no longer loop on rare occasions in Gun Game

- Scoreboard scaling has been fixed



# April 29th, 2023 (4/29/23)
**>GAMEPLAY**   
*NEW GAMEMODE*
- Gun Game is now in Titanmod! Players can now vote for a gamemode during the usual map vote, expect more gamemodes to come in the future

**>MAPS**   
*NEW MAPS*
- Corrugated

*REMOVED MAPS*
- Station

**>BALANCE**    
- **Muzzle Brake** has a spread penalty of 25% (previously 30%)
- Removed **Flash Hider** from all weapons
- Removed **Heavy Barrel** from all weapons
- Removed **GIB Ammo** from all weapons
- Removed **Flashlight** from all weapons (was useless)

*ARC-C*
- Reduced damage to 30 (previously 32)

*AEK-971*
- Increased vertical recoil to 33 (previously 25)

*AK-12*
- Reduced damage to 34 (previously 35)
- Increased vertical recoil to 70 (previously 40)

*AK-400*
- Reduced damage to 34 (previously 36)
- Increased vertical recoil to 55 (previously 35)
- Increased horizontal recoil to 25 (previously 20)

*FN 2000*
- Reduced damage to 32 (previously 35)
- Increased vertical recoil to 50 (previously 30)
- Increased horizontal recoil to 25 (previously 15)

*Honey Badger*
- Increased vertical recoil to 65 (previously 50)
- Increased horizontal recoil to 30 (previously 15)

*SA80*
- Increased vertical recoil to 44 (previously 37)

*AR-57*
- Smoothened recoil pattern

*KRISS Vector*
- Reduced damage to 24 (previously 27)
- Reduced aim spread to 5 (previously 10)

*MP5*
- Recoil pattern more accurately follows the sight

*P90*
- Increased mobility to 90% (previously 85%)
- Reduced aim spread to 54.5 (previously 69.5)
- Increased vertical recoil to 25 (previously 22.5)
- Increased horizontal recoil to 30 (previously 15)

*Scorpion Evo*
- Reduced damage to 22 (previously 24)

*AA-12*
- Reduced damage to 9x10 (previously 11x10)

*Remington M870*
- Reduced damage to 11x12 (previously 15x12)

*SPAS-12*
- Reduced damage to 9x12 (previously 12x12)
- Increased vertical recoil to 160 (previously 80)

*Stevens 620*
- Increased damage to 16x7 (previously 13x7)

*Typhoon F12*
- Reduced damage to 12x10 (previously 13x10)
- Reduced magazine size to 12 (previously 15)

*Desert Eagle*
- Removed Extended Magazine
- Removed Magnum ammo

*MR-96*
- Removed Magnum ammo

*S&W 500*
- Increased vertical recoil to 272 (previously 232)

*MG 34*
- Reduced damage to 27 (previously 32)

*MG 42*
- Reduced damage to 27 (previously 32)

*RPK-74M*
- Reduced damage to 33 (previously 40)

*RPG-7*
- Removed all attachments from the RPG-7
- Drastically increased RPG-7 recoil

*Bow*
- Increased damage to 85 (previously 65)

*Crossbow*
- Increased damage to 105 (previously 85)

**>QOL & BUG FIXES**    
- Health regeneration begins instantly upon getting a kill

- Disabled default HL2 ammo and weapon pickup notifications

- Removed 'tm_endless' server option due to incompatibility with new gamemode

- Being hit by a syringe now flashes your screen green instead of blue

- Laser attachments that also triggered a flashlight no longer trigger a flashlight (just like the standalone flashlight attachment, this is useless bc of Titanmod's custom lights)



# April 26th, 2023 (4/26/23)
**>GAMEPLAY**   
*NEW WEAPONS*
- **USP** (Secondary, Pistol)
- **Webley** (Secondary, Pistol)

*NEW SETTINGS*
- Keypress Overlay
- FPS and Ping counter

**>QOL & BUG FIXES**    
- Added countless HUD options for both of the new settings

- Added audio cues for match time warnings

- Optimized UI

- Removed the kill streak notification when a player only has 1 kill

- Under the hood work for new future gamemodes



# April 15th, 2023 (4/15/23)
**>GAMEPLAY**   
*MATCH TIME WARNING*
- Warnings show up periodically throughout matches (5:00, 1:00, and 0:10) that remind the player of the remaining match time

**>MAPS**   
*NEW MAPS*
- Hydro
- Villa

**>QOL & BUG FIXES**    
- Refactored how proximity voice chat is handled to eventually allow global voice chat during map voting

- Replaced most of the gamemode backgrounds for new ones



# April 10th, 2023 (4/10/23)
**>MAPS**   
*NEW MAPS*
- Mephitic (adjusted since removal for better visibility and performance)
- Sanctuary

**>BALANCE**    
*G36A1*
- Reduced damage to 31 (previously 33)
    
*PM-9*
- Reduced damage to 24 (previously 25)

*AEK-971*
- Reduced damage to 28 (previously 30)

*CZ 805*
- Reduced damage to 31 (previously 32)

*OTs-33 Pernach*
- Reduced damagae to 25 (previously 27)

*SCAR-H*
- Increased vertical recoil to 115 (previously 95)
- Increased horizontal recoil to 60 (previously 45)

*Dual Skorpions*
- Reduced damage to 27 (previously 33)
- Increased horizontal recoil to 25 (previously 10)

*Honey Badger*
- Reduced damage to 30 (previously 31)
- Increased vertical recoil to 50 (previously 30)

*FNP-45*
- Reduced damage to 38 (previously 42)

*OTs-14 Groza*
- Reduced hip spread to 11 (previously 14)
- Reduced aim spread to 3 (previously 5)

*SR-2M Veresk*
- Increased vertical recoil to 30 (previously 22)

**>QOL & BUG FIXES**    
- Added player tags to the scoreboard (shows if a player is a Developer, Moderator, etc)



# April 9th, 2023 (4/9/23)
**>GAMEPLAY**   
*DAMAGE ADJUSTMENT*
- Headshot damage multiplier reduced to 130% (previously 140%)

**>QOL & BUG FIXES**    
- Fixed players not properly installing the required content automatically upon joining for the first time

- Pick Random option in the model and card customization menus

- 4 new, free calling cards

- Preparation for a new map



# April 8th, 2023 (4/8/23)
**>QOL & BUG FIXES**    
- Fixed softlock in main menu after a level change



# April 7th, 2023 (4/7/23)
**>GAMEPLAY**   
*NEW WEAPONS*
- **Bow** (Secondary, Sniper)
- **Crossbow** (Primary, Sniper)

**>QOL & BUG FIXES**    
- Added 7 new unlockable playermodels (one new model for each accolade)

- Adjusted unlock requirements for certain playermodels to be more consistent

- Removed playermodel and calling card descriptions (they were kinda cheesy and im too stupid to make nice sounding ones)

- Added a spawn countdown to the spawn button on the main menu

- Replaced the Exit Game button with a button to open the Garry's Mod main menu.

- Fixed applying new playermodels and calling cards



# April 6th, 2023 (4/6/23)
**>GAMEPLAY**   
*ANIMATION CHANGES*
- Other than for a few exceptions, all animations have been increased in speed by 40% (this applies to reloads, switching to and from weapons, bolting/pumping, and more)

**>BALANCE**    
- Removed UBGLs (underbarrel grenade launchers) from being equipped on weapons

**>QOL & BUG FIXES**    
- Removed muzzle flash (improved visibilty and FPS)



# April 4th, 2023 (4/4/23)
**>GAMEPLAY**   
*DAMAGE ADJUSTMENTS*
- Updated Damage multiplers (Head = 140%, Torso/Stomach = 100%, Arms/Legs = 80%)
- Wallbang/penetration damage increased by 25%

*SPAWN PROTECTION*
- Players can no longer spawn if near another player in a 1024 unit radius

*MOVEMENT CHANGES*
- Increased crouch transition speed by 7.5%
- Increased crouch movement speed by 10%

**>BALANCE**    
*AUG A3*
- Increased mobility to 87% (previously 80%)
- Reduced hip spread to 16 (previously 20)

*MP18*
- Reduced ADS spread to 54 (previously 74)

*M4A1*
- Reduced damage to 32 (previously 35)
        
*MP40*
- Reduced ADS spread to 20 (previously 25)

*UMP .45*
- Reduced damage to 33 (previously 34)
    
*SCAR-H*
- Reduced damage to 57 (previously 61)



# April 3rd, 2023 (4/3/23) (Public Playtest/BETA Began)
**>GAMEPLAY**   
*MAP VOTE ADJUSTMENTS*
- Small maps no longer appear in the map vote when there are more than 5 players connected (this applies to Nuketown, Shipment, and the new Initial map)

**>MAPS**   
*NEW MAPS*
- Devtown
- Initial

*REMOVED MAPS*
- Mephetic (will return after adjustments)

**>BALANCE**    
*Dual Skorpions*
- Reduced damage to 24 (previously 25)

*RFB*
- Reduced horizontal recoil

- Adjusted reload speed on the AS Val and M4A1

**>QOL & BUG FIXES**    
- Mute button beside music name to quickly disable/enable menu music without navigating to options

- Discord button added to the social tray in the Main Menu

- Fixed main menu net msg error

- Fixed "transmitting voice" showing up while other users were using proximity voice chat nearby

- Fixed jamming on RFB reload



# January 25th, 2022 (1/25/23) - April 2nd, 2022 (4/2/23) (Every update within this time frame was undocumented, here is a roundup)
- Added over 8 new and revamped weapons

- Added Match system

- Added various new HUD editor options

- Added VOIP indicator

- Added in-game chat filtering (and then removed said filter)

- Added various new hit and kill SFX options

- Added farthest kill stat

- Added new main menu music tracks

- Added customizable main menu keybind option

- Added new config file entries

- Completely revamped and overhauled map voting system

- Moved many systems to the net messages system

- Scoreboard size now dynamically changes based on player count

- Refactored the spectating system

- Overhauled player model and player card customization menus

- Fixed auto downloading of gamemode addons when mounted to server



# January 23rd, 2022 (1/23/23)
- Drastic gunplay refinments

- Added HK53 primary weapon

- Added SIG P320 secondary weapon

- Rebalancing across all weapons

- Multiple weapon revamps/remodels

- Added More trackable statistics

- Added Weapon kill tracking HUD option

- Various Scoreboard improvments

- Moved many systems to the net messages system

- Added Config option to disable map vote skip

- Map framework changes

- Fixed bugs introduced with the new GMOD update

- Updated credit entries

- Removed Galil primary weapon

- Removed SIG P260 secondary weapon


# December 5th, 2022 (12/5/22)
- Added G28, G36A1, Dual Skorpions, AK-12 and M4A1 primary weapons

- Added Skorpion secondary weapon

- Added File Compression

- Added Option tooltips

- Added Account and Privacy options category

- Added Credits menu

- Added Level 200-300 and Pride Player Cards

- Added Config File

- Added Killstrak notifications in kill feed

- Added Hints

- Added Loadout Hints option

- Added Match tracking

- Added Match win XP bonus

- Added HUD Editing and recoloring

- Added Custom font support

- Added Hide Locked option in cuztomization menus

- Added Clan tags

- New UI animations

- More UI SFX

- Optimized UI

- Optimized score calculation

- Optimized kill cams

- Optimized player leveling

- Optimized arrays

- Fixed incorrect score distribution

- Faster loading on model and card menus

- Fixed overlapping menu SFX

- Added DOF for main menu and scoreboard

- Primaries no longer fire underwater

- Secondaries and melee now fire underwater

- Buffed Mac 10, Beretta Mx4, MP7

- Nerfed AKS-74U, Imbel IA2, SCAR-H

- Updated many weapon names

- Smoothened level up animation

- Lowered volume of level up SFX

- Improved statistics menu

- Improved map voting algorithm

- Fixed death cooldown check every frame

- Fixed manually voting on unvotable maps

- Added errors during manual map voting

- Added caliber information for weapons

- Removed unused weapon files

- Removed hooks that run exclusively in Sandbox

- Kill/Death UI now scale properly

- Added Smooth scrolling across all UI

- Updated and improved ASh-12 model

- Fixed ammo bar being 1 pixel too high

- Fixed ammo bar text while using melee

- Fixed UI elements when player disconnects

- Fixed desync related to kill info and streaks

- Removed WA-2000, H&K MG36, AK-12 RPK and AR-15 primary weapons

- Removed Groves and Rooftops maps

- Removed Revenge accolade

- Removed Lee-Enfield stripper clip attachment

- Removed Profile Picture Offset option



# November 21st, 2022 (11/21/22)
- Added Arctic, Rig, and Station map

- Added Grenades

- Added Rocket/M79 Jumping

- Added UI SFX

- Added Slight scoreboard coloring on player states

- Improved explosion FX

- Small scale optimization

- Fixed conflicting files



# November 14th, 2022 (11/14/22)
- Added Player Leveling and Prestiging

- Added dynamic weapon spread

- Added 50+ new player cards

- Buffed RFB, Makarov, Mare's Leg and Honey Badger

- Various Scoreboard improvments

- Suicides no longer give accolades

- Updated some fonts

- Updated some weapon names

- Fixed Firing Range appearing in map vote

- Various efforts towards optimization

- Reduced recoil by 10% due to spread addition

- Streamlined new content creation



# November 10th, 2022 (11/10/22)
- Added Shipment and Firing Range map

- Added Colt 9mm, FN 2000 and LR-300 primary weapons

- Added Mare's Leg and MP-443 Grach secondary weapons

- Added Firing Range Weapon Spawning

- Added Hit/Kill sound type options

- Updated card and model menus

- Shortened some weapon names

- Fixed YouTube link



# November 8th, 2022 (11/8/22)
- Map updates and optimizations

- Added Accolade player models

- Scope Shadows are now forced off

- Many bug fixes


# November 4th, 2022 (11/4/22)
- Added Mall and Bridge map

- Added Honey Badger, RK62, PzB 39 and WA-2000 primary weapons

- Added OSP-18 secondary weapon

- Added Match end UI

- Revamped stats/model menus

- Added New community music track

- Added Beta participation rewards

- Buffed Glock 17 and Steyr AUG

- Nerfed FG 42, KRISS Vector, Scropion Evo 3, PP-Bizon and Desert Eagle

- Added Map Vote Time command

- Fixed Rooftops map

- Fixed Kill UI updating incorrectly

- Optimized headshot tracking

- Flashlights are now rendered serverside

- Added Flashlight customization options

- Scoreboard is now sorted by player score

- Removed full auto from Mk. 14 EBR and M14



# November 2nd, 2022 (11/2/22)
- Added Map voting

- Added Player cards and card options

- Revamped scoreboard

- Added Weapon mastery

- Added Revenge and Copycat accolade

- Added 5 new optics

- Buffed Stevens 620

- Nerfed Minimi Para

- Improved options and customize menus

- Added map information to main menu

- Added Loadout notification on player spawn

- Added Endless mode as a server option

- Maps are now included in the addon

- AR-15 now defaults to full auto

- Players now climb ladders 10% faster

- Grapple Hook now refreshes on player kill

- Wallrun velocity slightly increased

- Death info now shows on a players suicide

- Optimized Kill UI

- Fixed poor hit registration

- Fixed new weapons not spawning after death

- Fixed error on player suicide

- Fixed error on players first death

- Fixed error for loading player cards

- Removed Player specific spectating due to bug



# October 22nd, 2022 (10/22/22)
- Added M1919, MG 34 and Thompson M1928 primary weapons

- Revamped and optimized Main Menu

- Added Dedicated Stats page

- Added Spectating system

- Added Patch Notes page

- Added Developer Mode

- Buffed Colt M1911 and Walther P99

- Nerfed Minimi Para, SCAR-H SSR, OTs-14 Groza, Beretta Mx4 Storm, Imbel IA2, XM8, MP7A1, FNP-45, PM-9, Colt M45A1, MK18 and AEK-971

- Added Fancy animations across the main menu

- Fixed Clutch Accolade not being awarded

- Rounded played K/D on statistics

- KIllcam no longer ends until player spawn

- Backend changes for future playercard support

- tm_forcesave now saves Accolades

- Alphabetically sorted weapon arrays

- Removed Intro splash screen



# October 15th, 2022 (10/15/22)
- Added Kill Cam

- Added Clutch accolade

- Health based HUD values can no longer go below 0

- Changable Grappling Hook keybind in options

- Reload Hints toggle added to options

- ADS Vignette toggle added to options

- Centered Numeric added as an Ammo Style in options

- Viewmodel FOV Multiplier and Centered Viewmodel options now save upon leaving a game

- Kill/Death UI anchoring added to options

- Weapon Bobbing Multiplier added to options

- Invert Weapon Bobbing added to options



# October 14th, 2022 (10/14/22) (First documentation of patch notes)
- Added Intro Screen, can be disabled in options

- New default menu song to replace Chillwave

- Added new community music track

- Equalized audio between all music tracks

- Added Below Crosshair anchoring for health and ammo

- Updated KRISS Vector model

- Added new primarys (KSVK 12.7, UMP9, Type-81)

- Added new secondary (TCo Stim Pistol)

- Increased Grappling Hook cooldown (15 > 18s)

- Buffed UMP-45

- Nerfed M14, Mk. 14 EBR

- KM-2000 now applies the Smackdown Accolade

- Velocity Counter added to options

- Show Kill UI Accolades added to options

- Added 3 new default PMs

- Replaced Super Soilder PM with GMan PM