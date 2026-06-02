![Image Alt](https://raw.githubusercontent.com/dyxreign/main/refs/heads/main/177%20Sem%20T%C3%ADtulo_20260602022358.png)

# Documation
## Loader
```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dyxreign/Luanny-UI/refs/heads/main/src/Luanny.lua"))()
```
# Window
```lua
local Window = UI:CreateWindow({
    Title = "Lua Hub",
    Author = "by dyx",
    Transparent = false,
    Theme = "Dark",
    ShowWindow = true
})
```
# Tabs
```lua
local Tab = Window:Tab({
    Title = "Combat",
    Icon = "sword",
    Height = 250,
    Color = Color3.fromRGB(0, 150, 255)
})
```
# Selection (Divisor)
```lua
Tab:Section({ 
    Title = "Section Title",
})
```
# Button
```lua
Tab:Button({
    Title = "Button Title",
    Desc = "Button Description",
    Icon = "bird",
    Callback = function()

        print("Button clicked") 
    end
})
```
## Set Title
```lua
Button:SetTitle("Title Example")
```
## Set Description
```lua
Button:SetDesc("Description Example")
```
## Lock Button
```lua
Button:Lock()
```
## Unlock Button
```lua
Button:Unlock()
```
## Destroy Button
```lua
Button:Destroy()
```
# Toggle
```lua
Tab:Toggle({
    Title = "Toggle Title",
    Desc = "Toggle Description",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        print("State: " .. tostring(state))
    end
})
```
## Set Title
```lua
Toggle:SetTitle("Title Example")
```
## Set Description 
```lua
Toggle:SetDesc("Description Example")
```
## Set Value
```lua
Toggle:SetValue(...)
```
## Lock Toggle
```lua
Toggle:Lock()
``` 
## Unlock Toggle
```lua
Toggle:Unlock()
```
## Destroy Toggle
```lua
Toggle:Destroy()
```
# Dropdown
```lua
local Dropdown = Tab:Dropdown({
    Title = "Dropdown Title",
    Desc = "Dropdown Description",
    Icon = "list",
    Options = {"Option 1", "Option 2", "Option 3"},
    Value = "Option 1",
    Callback = function(selected)
        print(selected)
    end
})
```
## Set Title
```lua
Dropdown:SetTitle("Title Example")
```
## Set Option
```lua
Dropdown:Set("Option 2")
```
## Destroy Dropdown
```lua
Dropdown:Destroy()
```
# Set a Custom Font
```lua
UI:SetFont("rbxasset://...")
```
[![Luanny Ui](https://uibin.orqan.xyz/api/card?id=09669d82-2171-4559-9126-9d0fcefdbdc4&theme=purple)](https://uibin.orqan.xyz/library/09669d82-2171-4559-9126-9d0fcefdbdc4)

## I would appreciate it if you used it; more things will be added soon. :)
