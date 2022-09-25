--[[
Too add custom flashes to your weapon without broke it when RMS-3 its disabled just use the next line in your weapon lua:

SWEP.MuzzleFlashEffect = ( TFA and TFA.YanKys_Realistic_Muzzleflashes ) and "Custom Muzzleflash" or "Default Muzzlefash"

Or can use too:

function SWEP:Think2(...)	
	if ( TFA_YanKys_Realistic_Muzzleflashes == true ) and ( self.Silenced != true ) then
	    self.MuzzleFlashEffect = "Custom Muzzleflash" 
	else
	    self.MuzzleFlashEffect = "Default Muzzleflash" 
	end
	
	return BaseClass.Think2( self, ... )
end

Muzzleflash Types:

"tfa_muzzleflash_pistol"       : Standart Pistol Muzzleflash for non Muzzle Braked, Hidded or Compensated Pistols ( Recommended Calibers: 9x19mm to 9x21mm )
"tfa_muzzleflash_revolver"     : Standart Revolver Muzzleflash for any .357 Magnum, .44 Magnum, .454 Casull, .455 Webley, .500 S&W or any other Hight Caliber Revolver Weapon ( Recommended Calibers: .357 Magnum, .44 Magnum, .454 Casull, .455 Webley, .500 S&W )
"tfa_muzzleflash_g17"          : Variant with Different Glow and Parcially Different Muzzleflash for Glock-17s, Glock-19s, Glock-20s Pistols ( Recommended Calibers: 9x19mm ).
"tfa_muzzleflash_g21c"         : Variant with Different Glow, Parcially Different Muzzleflash and Compensator Split for Glock-18Cs, Glock-21Cs or any other Compensated Pistol ( Recommended Calibers: 9x19mm ).
"tfa_muzzleflash_m1911"        : Variant with Bigger Muzzleflash for Colt M1911s, Colt M45s or any other Hight Caliber Pistol ( Recommended Calibers: .40 S&W to .45 ACP ).
"tfa_muzzleflash_makarov"      : Variant with Different Glow and Parcially Different Muzzleflash for Makarov PM, Makarov PMM or any other 9x18mm Pistol ( Recommended Calibers: 9x18mm ).
"tfa_muzzleflash_ots"          : Variant with Smaller Muzzleflash and Glow for KPBs OTs-X Pistols or SMGs, Tokarev TT-33s, or any other Low Caliber Weapon or Muzzle Hidded Weapon ( Recommended Calibers: .22 LR, 5.8x21mm, 7.62x17mm, 7.62x25mm, 7.65x17mm, 7.65x22mm, 7.65x25mm, 9x18mm ).
"tfa_muzzleflash_ots_pernach"  : Variant with Smaller Muzzleflash, Glow and Compensator Splits for KPBs OTs-33s Pistols or any other Low Caliber Compensated Weapon ( Recommended Calibers: 9x18mm ).
"tfa_muzzleflash_deagle"       : Variant with Bigger Muzzleflash, Glow, and Deagle Rings in form of "O" for .50 AE Desert Eagles ( Recommended Calibers: .50 AE ).

"tfa_muzzleflash_smg"          : Standart SMG Muzzleflash for non Muzzle Braked, Hidded or Compensated SMGs ( Recommended Calibers: 9x19mm, .40 S&W, .45 ACP)
"tfa_muzzleflash_mp5"          : Variant with Smaller Muzzleflash for H&K MP5s or any other Low Profile Muzzleflash Weapon without Muzzle Hidder or Muzzle Brake ( Recommended Calibers: 9x19mm ).
"tfa_muzzleflash_mpx"          : Variant with Smaller Muzzleflash and Muzzle Hidder Splits for SIG MPXs, Colt M4s 9MM, H&K MP7s or any other Muzzle Hidded SMG ( Recommended Calibers: 4.6x30mm, 9x19mm ).
"tfa_muzzleflash_bizon"        : Variant with Different Muzzleflash, Glow and Muzzle Hidder Splits for Izhmash PP-19s or any other Russian Muzzle Hidded SMG ( Recommended Calibers: 9x18mm, 9x19mm, 9x21mm ).
"tfa_muzzleflash_ppsh"         : Variant with Different Muzzleflash, Glow and Splits for Shpagin PPSHs or any other Compensated SMG ( Recommended Calibers: 7.62x25mm ).
"tfa_muzzleflash_p90"          : Variant with Different Muzzleflash, Glow and Compensator Splits in form of "V" for FN P90s or any other "V" Compensated SMG ( Recommended Calibers: 5.7x28mm ).

"tfa_muzzleflash_hmg"          : Variant with Bigger Muzzleflash, Glow and Tracer for Heavy NATO Machineguns like FN M240s ( Recommended Calibers: 7.62x51mm ).
"tfa_muzzleflash_lmg"          : Variant with Smaller Muzzleflash, Glow and Tracer for Light NATO Machineguns like FN M249s ( Recommended Calibers: 5.56x45mm ).
"tfa_muzzleflash_pkm"          : Variant with Bigger Muzzleflash, Glow and Tracer for Heavy Russian Machineguns like Izhmash PKM ( Recommended Calibers: 7.62x54mmR ).

"tfa_muzzleflash_rifle"        : Standart Rifle Muzzleflash for non Muzzle Braked, Hidded or Compensated Weapons( Recommended Calibers: 5.45x39mm, 5.56x45mm)
"tfa_muzzleflash_generic"      : Standart Generic Muzzleflash for non Muzzle Braked, Hidded or Compensated Weapons( Recommended Calibers: 5.56x45mm, 7.62x39mm, 7.62x51mm, 7.62x54mmR)
"tfa_muzzleflash_famas"        : Variant with Parcially Different Muzzleflash with M16 Muzzle Hidder Splits for GIAT FAMAS, GIAT FAMAS FELIN, GIAT FAMAS VALORISE, FN F2000s, IWI TAR-21s or any other Bullpup Muzzle Hidded 5.56x45mm Weapon ( Recommended Calibers: 5.56x45mm ).
"tfa_muzzleflash_aug"          : Variant with Parcially Different Muzzleflash with Muzzle Hidder Splits in form of "+" for Steyr AUGs or any other "+" Bullpup Muzzle Hidded 5.56x45mm Weapon ( Recommended Calibers: 5.56x45mm ).
"tfa_muzzleflash_m16"          : Variant with Muzzle Hidder Splits for Colt M16s, Colt M4s, Armalite AR-15s, H&K 416s, or any other AR Muzzle Hidded 5.56x45mm Weapon ( Recommended Calibers: 5.56x45mm ).
"tfa_muzzleflash_acr"          : Variant with Muzzle Hidder Splits in form of "Y" for Remington ACRs, or any other "Y" Muzzle Hidded 5.56x45mm Weapon ( Recommended Calibers: 5.56x45mm ).
"tfa_muzzleflash_ar15"         : Variant with Muzzle Hidder Splits for Colt M16s, Colt M4s, Armalite AR-15s, H&K 416s, or any other AR Muzzle Hidded 5.56x45mm Weapon ( Recommended Calibers: 5.56x45mm ).
"tfa_muzzleflash_g36e"         : Variant with Muzzle Hidder Splits in form of "Inverted Y" for H&K G36E, H&K G36K, or any other "inverted Y" Muzzle Hidded 5.56x45mm Weapon ( Recommended Calibers: 5.56x45mm ).
"tfa_muzzleflash_g36c"         : Variant with Muzzle Hidder Splits in form of "X" for H&K G36C, or any other "X" Muzzle Hidded 5.56x45mm Weapon ( Recommended Calibers: 5.56x45mm ).
"tfa_muzzleflash_m14"          : Variant with Bigger Muzzleflash, Glow and Muzzle Hidder Splits in form of "X" for Springfield M14s, Springfield Mk.14s, Springfield M21s, Springfield M39s or any other "X" Muzzle Hidded 7.62x51mm Weapon ( Recommended Calibers: 7.62x51mm ).
"tfa_muzzleflash_fal"          : Variant with Bigger Muzzleflash, Glow and Muzzle Hidder Splits for FN FALs, Enfield L1A1s or any other Muzzle Hidded 7.62x51mm Battle Rifle ( Recommended Calibers: 7.62x51mm ).
"tfa_muzzleflash_g3"           : Variant with Bigger Muzzleflash, Glow and Muzzle Hidder Splits for H&K G3s, H&K G3SGs, H&K PSGs or any other Muzzle Hidded 7.62x51mm Rifle ( Recommended Calibers: 7.62x51mm ).
"tfa_muzzleflash_scarl"        : Variant with Parcially Different Muzzleflash, Glow and Muzzle Hidder Splits in form of "+" for FN SCAR-Ls or any other "+" Muzzle Hidded 5.56x45mm Assault Rifle ( Recommended Calibers: 5.56x45mm ).
"tfa_muzzleflash_scarh"        : Variant with Bigger Muzzleflash, Glow and Muzzle Hidder Splits in form of "+" for FN SCAR-Hs or any other "inverted Y" Muzzle Hidded 7.62x51mm Battle Rifle ( Recommended Calibers: 7.62x51mm ).
"tfa_muzzleflash_ak74"         : Variant with Different Muzzleflash, Glow and Muzzle Brake Splits for Izhmash AK-74s, Izhmash AKs-74Us, Izhmash RPK-74s or any other Muzzle Braked 5.45x39mm, 5.56x45mm Weapon ( Recommended Calibers: 5.45x39mm, 5.56x45mm ).
"tfa_muzzleflash_ak12"         : Variant with Different Muzzleflash, Glow and Muzzle Brake Splits for Izhmash AK-12s, Izhmash AK-400s, Izhmash RPK-12s or any other Modern Muzzle Braked 5.45x39mm, 5.56x45mm Weapon ( Recommended Calibers: 5.45x39mm, 5.56x45mm ).
"tfa_muzzleflash_ak47"         : Variant with Bigger Muzzleflash and Glow for Izhmash AK-47s, Izhmash AKMs Degtyaryov RPDs or any other 7.62x39mm non Muzzle Braked, Hidded or Compensated Weapon ( Recommended Calibers: 7.62x39mm ).
"tfa_muzzleflash_ak103"        : Variant with Bigger Muzzleflash, Glow and Muzzle Brake Splits for Izhmash AK-103s or any other Muzzle Braked 7.62x39mm, 7.62x51mm, 7.62x54mmR Weapon ( Recommended Calibers: 7.62x39mm, 7.62x51mm, 7.62x54mmR ).
"tfa_muzzleflash_an94"         : Variant with Smaller Muzzleflash, Glow and Compensator Splits for Izhmash AN-94s or any other Compensated 5.45x39mm, 5.56x45mm Weapon ( Recommended Calibers: 5.45x39mm, 5.56x45mm ).
"tfa_muzzleflash_ash12"        : Variant with Bigger Muzzleflash, Glow and Muzzle Brake Splits for Izhmash ASh-12 or any other Muzzle Braked Hight Caliber Weapon ( Recommended Calibers: 12.7x55mm ).

"tfa_muzzleflash_shotgun"      : Standart Shotgun Muzzleflash for non Muzzle Braked, Hidded or Compensated Shotguns ( Recommended Calibers: 12 Gauge to 20 Gauge ).
"tfa_muzzleflash_shotgun_slug" : Variant with less Sparks for One Pellet Shotguns ( Recommended Calibers: 10 Gauge, 12 Gauge to 20 Gauge Slugs ).
"tfa_muzzleflash_m3"           : Variant with less Smoke, Muzzleflash and Sparks for Less Power or Muzzle Braked Shotguns ( Recommended Calibers: 10 Gauge, 12 Gauge to 20 Gauge ).

"tfa_muzzleflash_sniper"       : Standart Sniper Rifle Muzzleflash for non Muzzle Braked, Hidded or Compensated Sniper Rifles ( Recommended Calibers: 7.62x51mm, 7.62x54mm, .300 Winchester, .308 Winchester ).
"tfa_muzzleflash_awm"          : Variant with Bigger Muzzleflash, Glow, Smoke and Sparks for AI AWMs, Cheytac M200s, Orsis T-5000s, Remington MSRs or any other High Caliber Bolt-Action Sniper Rifle ( Recommended Calibers: .338 Lapua Magnum, .408 Cheytac ).
"tfa_muzzleflash_m24"          : Variant with Different Muzzleflash and Glow for Remington R700s, Remington M24s, Remington M40s or any other NATO non Muzzle Braked, Hidded or Compensated Bolt-Action Sniper Rifle ( Recommended Calibers: 7.62x51mm, .300 Winchester, .308 Winchester ).
"tfa_muzzleflash_sr25"         : Variant with Different Muzzleflash, Glow and Muzzle Hidder Splits for KAC SR-25s or any other NATO Muzzle Hidded Marksman Rifle ( Recommended Calibers: 7.62x51mm, .300 Winchester, .308 Winchester ).
"tfa_muzzleflash_svd"          : Variant with Different Muzzleflash, Glow and Muzzle Hidder Splits for Dragunov SVDs, Izhmash SV-98s, Izhmash PKMs, Izhmash PKPs or any other Russian 7.62x54mmR Muzzle Hidded Weapon ( Recommended Calibers: 7.62x54mmR ).
"tfa_muzzleflash_sv98"         : Variant with Different Muzzleflash and Glow for Izhmash SV-98s or any other Russian 7.62x54mmR Non Muzzle Hidded or Compensated Weapon ( Recommended Calibers: 7.62x54mmR ).
"tfa_muzzleflash_m82"          : Variant with Bigger Muzzleflash, Glow, Smoke, Sparks and Muzzle Brake Splits for Browning M2s, Degtyaryov DShKs, Barrett M82s, Barrett M95s, Barrett M99s, Barrett M107s, Barrett XM-109s, AI AS-50s, AMP DSR-50s, Gepard GM6 Lynxs, PGM Hecate Ultimas or any other Muzzle Braked Anti-Material Weapon ( Recommended Calibers: 12.7x108mm, 14mm, 25x59mm, .50 BMG, .950 JDJ ).

"tfa_muzzleflash_m79"          : Variant with Shotgun Smoke, Different Sparks and Smaller Muzzleflash for Grenade Launchers and Launchers Without Recoil.
--]]