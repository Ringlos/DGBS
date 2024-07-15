local h = game:GetService("HttpService")
local p = game:GetService("Players")

local b_url = "https://raw.githubusercontent.com/Ringlos/DGBS/main/Blacklisted"
local u_url = "https://raw.githubusercontent.com/Ringlos/DGBS/main/Unbanlist"

local b, u

function getusers()
	local a = 0
	b = h:JSONDecode(h:GetAsync(b_url))
	u = h:JSONDecode(h:GetAsync(u_url))
	
	if type(b) ~= "table" then
		a = 0
		repeat 
			task.wait(1)
			a += 1
			b = h:JSONDecode(h:GetAsync(b_url))
		until type(b) == "table" or a == 10
	end
	
	if type(u) ~= "table" then
		a = 0
		repeat 
			task.wait(1)
			a += 1
			u = h:JSONDecode(h:GetAsync(u_url))
		until type(u) == "table" or a == 10
	end
	
	if type(u) ~= "table" or type(b) ~= "table" then
		return false
	else
		return true
	end
end

function BanUser(u: number,reason: string)
	local s,e = pcall(function()
		p:BanAsync({
			UserIds = {u},
			Duration = -1,
			DisplayReason = "[Dexel Global Blacklist System] You are blacklisted. Reason: "..reason,
			PrivateReason = "[DGBS] User blacklisted",
			ExcludeAltAccounts = false,
			ApplyToUniverse = true
		})
	end)
	if not s then
		return e
	else 
		return true
	end
end

function unban(u: number)
	local s,e = pcall(function()
		p:UnbanAsync({UserIds = {u}})
	end)
	if not s then
		return e
	else
		return true
	end
end

if not getusers() then
	error("[DGBS] Failed to load users.")
end

for _,v:string in pairs(b) do
	local f = v:split(":")
	local id = tonumber(f[2])
	local name = p:GetNameFromUserIdAsync(id)
	local reason = f[3]:gsub("_"," ")
	local res = BanUser(id,reason)
	if type(res) ~= "boolean" then
		print("[DGBS] "..res)
	end
end

for _,v in pairs(u) do
	local id = tonumber(v)
	local res = unban(id)
	if type(res) ~= "boolean" then
		print("[DGBS] "..res)
	end
end
