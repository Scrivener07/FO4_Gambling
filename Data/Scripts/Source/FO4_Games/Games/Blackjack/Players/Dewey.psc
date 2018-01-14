ScriptName Games:Blackjack:Players:Dewey extends Games:Blackjack:Player

;/ Personality
	none, simple AI
/;

; FSM - Finite State Machine
;---------------------------------------------

State Starting
	MarkerValue Function IMarkers()
		MarkerValue marker = new MarkerValue
		marker.Card01 = Games_Blackjack_P5C01
		marker.Card02 = Games_Blackjack_P5C02
		marker.Card03 = Games_Blackjack_P5C03
		marker.Card04 = Games_Blackjack_P5C04
		marker.Card05 = Games_Blackjack_P5C05
		marker.Card06 = Games_Blackjack_P5C06
		marker.Card07 = Games_Blackjack_P5C07
		marker.Card08 = Games_Blackjack_P5C08
		marker.Card09 = Games_Blackjack_P5C09
		marker.Card10 = Games_Blackjack_P5C10
		marker.Card11 = Games_Blackjack_P5C11
		return marker
	EndFunction
EndState


; Requests
;---------------------------------------------

MarkerValue Function IMarkers()
	; Required for type-check return because function is not on object.
	return parent.IMarkers()
EndFunction

int Function IWager()
	; Required for type-check return because function is not on object.
	return parent.IWager()
EndFunction

int Function IChoice()
	; Required for type-check return because function is not on object.
	return parent.IChoice()
EndFunction


; Properties
;---------------------------------------------

Group Markers
	ObjectReference Property Games_Blackjack_P5C01 Auto Const Mandatory
	ObjectReference Property Games_Blackjack_P5C02 Auto Const Mandatory
	ObjectReference Property Games_Blackjack_P5C03 Auto Const Mandatory
	ObjectReference Property Games_Blackjack_P5C04 Auto Const Mandatory
	ObjectReference Property Games_Blackjack_P5C05 Auto Const Mandatory
	ObjectReference Property Games_Blackjack_P5C06 Auto Const Mandatory
	ObjectReference Property Games_Blackjack_P5C07 Auto Const Mandatory
	ObjectReference Property Games_Blackjack_P5C08 Auto Const Mandatory
	ObjectReference Property Games_Blackjack_P5C09 Auto Const Mandatory
	ObjectReference Property Games_Blackjack_P5C10 Auto Const Mandatory
	ObjectReference Property Games_Blackjack_P5C11 Auto Const Mandatory
EndGroup
