local rng = Random.new()

local charset = {}

for i = 48, 57 do
	table.insert(charset, string.char(i))
end

for i = 65, 90 do
	table.insert(charset, string.char(i))
end

for i = 97, 122 do
	table.insert(charset, string.char(i))
end

local function RandomCharacters(length)
	if length > 0 then
		return RandomCharacters(length - 1) .. charset[rng:NextInteger(1, #charset)]
	else
		return ""
	end
end

local DEX = game:GetObjects("rbxassetid://11399583017")[1]
DEX.Name = RandomCharacters(rng:NextInteger(5, 20))
DEX.Parent = game.CoreGui

local function Load(Object, URL)
	local function GiveOwnGlobals(Function, Script)

		local Fenv = {}

		local RealFenv = {script = Script}

		local Fenvv = {}

		Fenvv.__index = function(a, b)

			if RealFenv[b] == nil then
				return getfenv()[b]
			else
				return RealFenv[b]
			end
		end

		Fenvv.__newindex = function(a, b, c)
			if RealFenv[b] == nil then
				getfenv()[b] = c
			else
				RealFenv[b] = c
			end
		end

		setmetatable(Fenv, Fenvv)
		setfenv(Function, Fenv)

		return Function
	end

	local function LoadScripts(Script)
		if Script.ClassName == "Script" or Script.ClassName == "LocalScript" then
			spawn(function()
				GiveOwnGlobals(loadstring(Script.Source, "=" .. Script:GetFullName()), Script)()
			end)
		end

		for i,v in pairs(Script:GetChildren()) do
			LoadScripts(v)
		end
	end

	LoadScripts(Object)
end

Load(DEX)