ScriptName Games:Blackjack:Actors extends Games:Blackjack:Type
import Games
import Games:Shared
import Games:Shared:Log
import Games:Shared:Papyrus

Blackjack:Player[] Players


; Events
;---------------------------------------------

Event OnInit()
	Players = new Player[0]
EndEvent

; States
;---------------------------------------------

State Starting
	Event OnState()
		{Starting}
		Add(Human)
		Add(Dealer)
		For(Players)
	EndEvent

	Function Each(Blackjack:Player player)
		StartState(player, StartingState)
	EndFunction
EndState


State Wagering
	Event OnState()
		{Wagering}
		For(Players)
	EndEvent

	Function Each(Blackjack:Player player)
		StartState(player, WageringState)
	EndFunction
EndState


State Dealing
	Event OnState()
		{Dealing}
		For(Players)
	EndEvent

	bool Function For(Blackjack:Player[] array)
		; TODO: Should I draw two cards in the player's dealing task instead?
		If (array)
			int index = 0
			While (index < array.Length)
				Each(array[index])
				index += 1
			EndWhile

			index = 0
			While (index < array.Length)
				Each(array[index])
				index += 1
			EndWhile
			return true
		Else
			WriteUnexpectedValue(self, "For", "array", "The array cannot be empty or none.")
			return false
		EndIf
	EndFunction


	Function Each(Blackjack:Player player)
		AwaitState(player, DealingState)
	EndFunction
EndState


State Playing
	Event OnState()
		{Playing}
		For(Players)
	EndEvent

	Function Each(Blackjack:Player player)
		AwaitState(player, PlayingState)
	EndFunction
EndState


State Scoring
	Event OnState()
		{Scoring}
		For(Players)
	EndEvent

	Function Each(Blackjack:Player player)
		AwaitState(player, ScoringState)
		Cards.CollectFrom(player)
	EndFunction
EndState


State Exiting
	Event OnState()
		{Exiting}
		For(Players)
		Clear()
	EndEvent

	Function Each(Blackjack:Player player)
		AwaitState(player, ExitingState)
	EndFunction
EndState


; Functions
;---------------------------------------------

int Function Score(Blackjack:Player player)
	int score = 0
	int index = 0
	While (index < player.Hand.Length)
		Deck:Card card = player.Hand[index]

		If (card.Rank == Deck.Ace)
			score += 11
		ElseIf (Deck.IsFaceCard(card))
			score += 10
		Else
			score += card.Rank
		EndIf

		index += 1
	EndWhile

	index = 0
	While (index < player.Hand.Length)
		Deck:Card card = player.Hand[index]

		If (card.Rank == Deck.Ace)
			If (player.IsBust(score))
				score -= 10
			EndIf
		EndIf

		index += 1
	EndWhile

	return score
EndFunction


int Function IndexOf(Blackjack:Player player)
	{Determines the index of a specific player in the collection.}
	If (player)
		return Players.Find(player)
	Else
		return Invalid
	EndIf
EndFunction


bool Function Contains(Blackjack:Player player)
	{Determines whether a player is in the collection.}
	return IndexOf(player) > Invalid
EndFunction


bool Function Add(Blackjack:Player player)
	{Adds a player to the collection.}
	If (player)
		If (Contains(player) == false)
			Players.Add(player)
			return true
		Else
			WriteUnexpectedValue(self, "Add", "player", "The player array already contains '"+player+"'.")
			return false
		EndIf
	Else
		WriteUnexpectedValue(self, "Add", "player", "Cannot add a none value to player array.")
		return false
	EndIf
EndFunction


Function Clear()
	{Removes all players from the collection.}
	If (Players)
		Players.Clear()
	Else
		WriteUnexpectedValue(self, "Clear", "Players", "Cannot clear empty or none player array.")
	EndIf
EndFunction


bool Function For(Blackjack:Player[] array)
	If (array)
		int index = 0
		While (index < array.Length)
			Each(array[index])
			index += 1
		EndWhile
		return true
	Else
		WriteUnexpectedValue(self, "For", "array", "Cannot iterate an empty or none array.")
		return false
	EndIf
EndFunction


Function Each(Blackjack:Player player)
	{EMPTY}
	WriteNotImplemented(self, "Each", "The member is not implemented in the empty state.")
EndFunction


; Properties
;---------------------------------------------

Group Properties
	int Property Count Hidden
		int Function Get()
			return Players.Length
		EndFunction
	EndProperty
EndGroup

Group Scripts
	Blackjack:Players:Human Property Human Auto Const Mandatory
	Blackjack:Players:Dealer Property Dealer Auto Const Mandatory
	Blackjack:Cards Property Cards Auto Const Mandatory
	Shared:Deck Property Deck Auto Const Mandatory
EndGroup