ScriptName Games:Shared:UI:ButtonHint extends Games:Shared:UI:Display Default
import Games
import Games:Papyrus:Log
import Games:Papyrus:Script
import Games:Shared

Button[] Buttons
Button selectedLast
CustomEvent OnShown
CustomEvent OnSelected


bool AutoHide = false
int Invalid = -1 const


Struct Button
	string Text = ""
	{The button text label.}
	int KeyCode = -1
	{The keyboard scancode.}
EndStruct


; Display
;---------------------------------------------

Event OnGameReload()
	Data()
EndEvent


Event OnDisplayData(DisplayData display)
	; TODO: Try loading into fader menu by using vanilla papyrus to show the menu.
	display.Menu = "FaderMenu"
	display.Asset = "ButtonHint.swf"
	Buttons = new Button[0]
EndEvent


; Methods
;---------------------------------------------

bool Function Show()
	{Begin the shown task.}
	return TaskAwait(self, "Shown")
EndFunction


bool Function Hide()
	{End any running task.}
	return TaskEnd(self)
EndFunction


;---------------------------------------------


bool Function Add(Button value)
	{Adds a button to the collection.}
	If (value)
		If (Contains(value) == false)
			If (ContainsKeyCode(value.KeyCode) == false)
				Buttons.Add(value)
				return true
			Else
				InvalidOperationException(self, "Add", "The button array already contains a button with keycode '"+value.KeyCode+"'.")
				return false
			EndIf
		Else
			InvalidOperationException(self, "Add", "The button array already contains '"+value+"'.")
			return false
		EndIf
	Else
		ArgumentNoneException(self, "Add", "value", "Cannot add a none value to button array.")
		return false
	EndIf
EndFunction


bool Function Remove(Button value)
	{Removes the first occurrence of a button from the collection.}
	If (value)
		If (Contains(value))
			Buttons.Remove(IndexOf(value))
			return true
		Else
			InvalidOperationException(self, "Remove", "The button array does not contain '"+value+"'.")
			return false
		EndIf
	Else
		ArgumentNoneException(self, "Remove", "value", "Cannot remove a none value from button array.")
		return false
	EndIf
EndFunction


bool Function Clear()
	{Clears all buttons from the collection.}
	selectedLast = none
	If (Buttons.Length > 0)
		Buttons.Clear()
		return true
	Else
		InvalidOperationException(self, "Clear", "The button array is already cleared.")
		return false
	EndIf
EndFunction


int Function FindByKeyCode(int value)
	{Determines the index of a button with the given key code.}
	return Buttons.FindStruct("KeyCode", value)
EndFunction


bool Function ContainsKeyCode(int value)
	{Determines whether a button with the given key code is in the collection.}
	return FindByKeyCode(value) > Invalid
EndFunction


bool Function Contains(Button value)
	{Determines whether a button is in the collection.}
	return IndexOf(value) > Invalid
EndFunction


int Function IndexOf(Button value)
	{Determines the index of a specific button in the collection.}
	If (value)
		return Buttons.Find(value)
	Else
		return Invalid
	EndIf
EndFunction


;---------------------------------------------


bool Function RegisterForSelectedEvent(ScriptObject script)
	If (script)
		script.RegisterForCustomEvent(self, "OnSelected")
		return true
	Else
		ArgumentNoneException(self, "RegisterForSelectedEvent", "script", "Cannot register a none script for selection events.")
		return false
	EndIf
EndFunction


bool Function UnregisterForSelectedEvent(ScriptObject script)
	If (script)
		script.UnregisterForCustomEvent(self, "OnSelected")
		return true
	Else
		ArgumentNoneException(self, "UnregisterForSelectedEvent", "script", "Cannot register a none script for selection events.")
		return false
	EndIf
EndFunction


Button Function GetSelectedEventArgs(var[] arguments)
	If (arguments)
		return arguments[0] as Button
	Else
		ArgumentNoneException(self, "GetSelectedEventArgs", "arguments", "The selection event arguments are empty or none.")
		return none
	EndIf
EndFunction


;---------------------------------------------


Struct ShownEventArgs
	bool Showing = false
EndStruct


bool Function RegisterForShownEvent(ScriptObject script)
	If (script)
		script.RegisterForCustomEvent(self, "OnShown")
		return true
	Else
		ArgumentNoneException(self, "RegisterForShownEvent", "script", "Cannot register a none script for shown events.")
		return false
	EndIf
EndFunction


bool Function UnregisterForShownEvent(ScriptObject script)
	If (script)
		script.UnregisterForCustomEvent(self, "OnShown")
		return true
	Else
		ArgumentNoneException(self, "UnregisterForShownEvent", "script", "Cannot register a none script for shown events.")
		return false
	EndIf
EndFunction


ShownEventArgs Function GetShownEventArgs(var[] arguments)
	If (arguments)
		return arguments[0] as ShownEventArgs
	Else
		ArgumentNoneException(self, "GetShownEventArgs", "arguments", "The shown event arguments are empty or none.")
		return none
	EndIf
EndFunction


; Tasks
;---------------------------------------------

State Shown
	Event OnBeginState(string asOldState)
		bool abFadingOut = true const
		bool abBlackFade = false const
		float afSecsBeforeFade = 6.0
		float afFadeDuration = 6.0
		bool abStayFaded = true
		Game.FadeOutGame(abFadingOut, abBlackFade, afSecsBeforeFade, afFadeDuration, abStayFaded)

		UI.Invoke(Menu, Root+".Menu_mc.ShowDisplay")

		If (Load())
			If (Buttons)
				var[] arguments = new var[0]
				int index = 0
				While (index < Buttons.Length)
					arguments.Add(Buttons[index])
					RegisterForKey(Buttons[index].KeyCode)
					index += 1
				EndWhile

				string member = GetMember("SetButtons")
				UI.Invoke(Menu, member, arguments)
				Visible = true ; TODO: Stack too deep (infinite recursion likely) - aborting call and returning None


				ShownEventArgs e = new ShownEventArgs
				e.Showing = true
				var[] shownArguments = new var[1]
				shownArguments[0] = e
				SendCustomEvent("OnShown", shownArguments)



				WriteLine(self, "Showing button press hints. Invoke: "+Menu+"."+member+"("+arguments+")")
			Else
				InvalidOperationException(self, "Shown.OnBeginState", "The button array is none or empty.")
				TaskEnd(self)
			EndIf
		Else
			InvalidOperationException(self, "Shown.OnBeginState", "Could not load menu for '"+GetState()+"'' state.")
			TaskEnd(self)
		EndIf
	EndEvent


	Event OnKeyDown(int keyCode)
		selectedLast = Buttons[FindByKeyCode(keyCode)]

		var[] arguments = new var[1]
		arguments[0] = selectedLast
		SendCustomEvent("OnSelected", arguments)

		If (AutoHide)
			WriteLine(self, "Automatically hiding for first selection.")
			TaskEnd(self)
		EndIf
	EndEvent


	bool Function Show()
		{EMPTY}
		NotImplementedException(self, "Show", "Not implemented in the '"+GetState()+"' state.")
		return false
	EndFunction


	bool Function Add(Button value)
		{EMPTY}
		NotImplementedException(self, "Add", "Not implemented in the '"+GetState()+"' state.")
		return false
	EndFunction


	bool Function Remove(Button value)
		{EMPTY}
		NotImplementedException(self, "Remove", "Not implemented in the '"+GetState()+"' state.")
		return false
	EndFunction


	bool Function Clear()
		{EMPTY}
		NotImplementedException(self, "Clear", "Not implemented in the '"+GetState()+"' state.")
		return false
	EndFunction


	Event OnEndState(string asNewState)
		WriteLine(self, "Ending the '"+GetState()+"' state.")

		Visible = false
		UI.Invoke(Menu, Root+".Menu_mc.HideDisplay")

		int index = 0
		While (index < Buttons.Length)
			UnregisterForKey(Buttons[index].KeyCode)
			index += 1
		EndWhile

		ShownEventArgs e = new ShownEventArgs
		e.Showing = false
		var[] arguments = new var[1]
		arguments[0] = e
		SendCustomEvent("OnShown", arguments)
	EndEvent
EndState


; Properties
;---------------------------------------------

Group ButtonHint
	int Property Count Hidden
		int Function Get()
			return Buttons.Length
		EndFunction
	EndProperty

	Button Property Selected Hidden
		Button Function Get()
			return selectedLast
		EndFunction
	EndProperty

	bool Property SelectOnce Hidden
		bool Function Get()
			return AutoHide
		EndFunction
		Function Set(bool value)
			AutoHide = value
		EndFunction
	EndProperty
EndGroup