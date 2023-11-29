	#Requires Autohotkey v2.0

	;	Hue Lights Integration
	WinHTTP := ComObject("WinHTTP.WinHttpRequest.5.1")
	lightsOn := 1
	grpOn:=1
	group1 := [5,3,1]    ;    Please find the number associated with your light as per tutorials how to use CLIP API
	group2 := [3]
	group3 := [1]
	group4 := [5]
	groups:=[group1,group2,group3,group4]    ;    For toggling through groups
	indx:=1
	curgroup := groups[indx]
	;	/Hue Lights Integration

	;	Hue Lights Functions
	hue_allLights(){
	WinHTTP.Open("PUT", "http://<device_ip_address>/api/<user_id>/groups/0/action", 0)
	if (lightsOn > 0)
		bodytext:=('{ "on" : false}')
	else
		bodytext:=('{"on" : true}')
	WinHTTP.Send(bodytext)
	global lightsOn := 1 - lightsOn
	return
	}
	hue_curLights(light){
		WinHTTP.Open("PUT", "http://<device_ip_address>/api/<user_id>/lights/" . light . "/state", 0)
		if (grpOn)
			bodytext:=('{ "on" : false}')
		else
			bodytext:=('{"on" : true}')
		WinHTTP.Send(bodytext)
		return
	}
	hue_modBright(light, amount){
		WinHTTP.Open("PUT", "http://<device_ip_address>/api/<user_id>/lights/" . light . "/state", 0)
		bodytext := '{"bri_inc" : ' amount ', "transitiontime" : 2}'
		WinHTTP.Send(bodytext)
	}
	hue_modct(light, amount){
		WinHTTP.Open("PUT", "http://<device_ip_address>/api/<user_id>/lights/" . light . "/state", 0)
		bodytext := '{"ct_inc" : ' amount ', "transitiontime" : 2}'
		WinHTTP.Send(bodytext)
	}
	hue_toggleGroup(var){
		if var == groups.Length{
			indx:=0
		}
		global indx:=indx+1
		global curgroup:=groups[indx]
		
	}
	hue_allOff(){
		WinHTTP.Open("PUT", "http://<device_ip_address>/api/<user_id>/groups/0/action", 0)
		WinHTTP.Send('{"on" : false}')
		global lightsOn:=0
	}

	;	/Hue Lights Functions
		
		
	;        Hotkeys
		
	;    ^-ctrl, !-alt. Used keys: L, O, P, I, UP, DOWN, LEFT, RIGHT
	;    Usage of CAPITAL letters is not possible since that would become +{key}. +-Shift key
	^!l::{ ; All lights toggle
	hue_allLights()	
	}

	^!o::{ ; All lights OFF
		hue_allOff()
	}

	^!p::{ ; Lights in current group toggle
		for light in curgroup
			hue_curLights(light)
		if (grpOn)
			global grpOn:=0
		else
			global grpOn:=1
		return
	}
	^!i::{ ;Change current group
		hue_toggleGroup(indx)
	}
	^!UP::{
		for light in curgroup
			hue_modBright(light, 26)
		return
	}
	^!DOWN::{
		for light in curgroup
			hue_modBright(light, -26)
		return
	}
	^!LEFT::{
		for light in curgroup
			hue_modct(light, -26)
		return
	}
	^!RIGHT::{
		for light in curgroup
			hue_modct(light, 26)
		return
	}
	;        /Hotkeys