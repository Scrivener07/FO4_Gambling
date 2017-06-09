ScriptName Gambling:BlackJack:Components:GUI extends Gambling:BlackJack:Component
import Gambling
import Gambling:Shared:Common


int OptionExit = 0 const
int OptionStart = 1 const


; Methods
;---------------------------------------------

bool Function PromptPlay()
	int selected = Gambling_BlackJack_MessagePlay.Show()

	If (selected == OptionStart)
		return true

	ElseIf (selected == OptionExit || selected == Invalid)
		WriteLine(self, "Chose not to play Black Jack.")
		return false
	Else
		WriteLine(self, "The option '"+selected+"' is unhandled.")
		return false
	EndIf
EndFunction


bool Function PromptPlayAgain()
	return Gambling_BlackJack_MessagePlayAgain.Show() == 1
EndFunction


int Function PromptWager()
	int selected = Gambling_BlackJack_MessageWager.Show()
	int OptionWager1 = 1 const
	int OptionWager5 = 2 const
	int OptionWager10 = 3 const
	int OptionWager20 = 4 const
	int OptionWager50 = 5 const
	int OptionWager100 = 6 const

	If (selected == OptionExit || selected == Invalid)
		return Invalid
	ElseIf (selected == OptionWager1)
		return 1
	ElseIf (selected == OptionWager5)
		return 5
	ElseIf (selected == OptionWager10)
		return 10
	ElseIf (selected == OptionWager20)
		return 20
	ElseIf (selected == OptionWager50)
		return 50
	ElseIf (selected == OptionWager100)
		return 100
	Else
		WriteLine(self, "The option '"+selected+"' is unhandled.")
		return Invalid
	EndIf
EndFunction


int Function ShowDealt(float card1, float card2, float score)
	return Gambling_BlackJack_MessageDealt.Show(card1, card2, score)
EndFunction


int Function ShowTurn(float card, float score)
	return Gambling_BlackJack_MessageTurn.Show(card, score)
EndFunction


Function ShowWinner(float score)
	Gambling_BlackJack_MessageWinNatural.Show(score)
EndFunction


Function ShowLoser(float score)
	Gambling_BlackJack_MessageWinNatural.Show(score)
EndFunction


; Properties
;---------------------------------------------

Group Messages
	Message Property Gambling_BlackJack_MessageWager Auto Const Mandatory
	Message Property Gambling_BlackJack_MessageDealt Auto Const Mandatory
	Message Property Gambling_BlackJack_MessageTurn Auto Const Mandatory
	Message Property Gambling_BlackJack_MessagePlay Auto Const Mandatory
	Message Property Gambling_BlackJack_MessagePlayAgain Auto Const Mandatory
	Message Property Gambling_BlackJack_MessageWin Auto Const Mandatory
	Message Property Gambling_BlackJack_MessageWinNatural Auto Const Mandatory
	Message Property Gambling_BlackJack_MessageBust Auto Const Mandatory
EndGroup
