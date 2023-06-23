include('shared.lua')

SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModelFOV		= 58
SWEP.ViewModelFlip		= false
SWEP.CSMuzzleFlashes	= false

SWEP.Category 		= "FractureRP"
SWEP.PrintName			= "Иммолятор"			
SWEP.Author				= "Valve"
SWEP.Slot				= 3
SWEP.SlotPos			= 3

SWEP.WepSelectIcon = surface.GetTextureID("HUD/swepicons/weapon_immolator") 
SWEP.BounceWeaponIcon = false 	
SWEP.DrawWeaponInfoBox	= false

//This is how clients can adjust SFX performance rate
CreateClientConVar( "flamethrower_fx", 2, false, false )