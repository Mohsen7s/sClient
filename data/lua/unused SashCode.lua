

 
function bearing(a1, a2, b1, b2) 
	local TWOPI = 6.2831853071795865
	local RAD2DEG = 57.2957795130823209
	--if (a1 = b1 and a2 = b2) throw an error 
	
	local theta = math.atan2(b1 - a1, a2 - b2)
	if (theta < 0.0) then theta = theta + TWOPI end
	local degRes =  (RAD2DEG * theta) + 90
	if(degRes >= 360) then degRes = degRes - 360 end
	
	return degRes
	
end


function intersection (s1, e1, s2, e2)
    local a1 = e1.y - s1.y;
    local b1 = s1.x - e1.x;
    local c1 = a1 * s1.x + b1 * s1.y;
     
    local a2 = e2.y - s2.y;
    local b2 = s2.x - e2.x;
    local c2 = a2 * s2.x + b2 * s2.y;
     
    local delta = a1 * b2 - a2 * b1;
	return delta
		
end
 


function doLinesIntersect( a, b, c, d )
    -- parameter conversion
    local L1 = {X1=a.x,Y1=a.y,X2=b.x,Y2=b.y}
    local L2 = {X1=c.x,Y1=c.y,X2=d.x,Y2=d.y}

    -- Denominator for ua and ub are the same, so store this calculation
    local _d = (L2.Y2 - L2.Y1) * (L1.X2 - L1.X1) - (L2.X2 - L2.X1) * (L1.Y2 - L1.Y1)

    -- Make sure there is not a division by zero - this also indicates that the lines are parallel.
    -- If n_a and n_b were both equal to zero the lines would be on top of each
    -- other (coincidental).  This check is not done because it is not
    -- necessary for this implementation (the parallel check accounts for this).
    if (_d == 0) then
        return false
    end

    -- n_a and n_b are calculated as seperate values for readability
    local n_a = (L2.X2 - L2.X1) * (L1.Y1 - L2.Y1) - (L2.Y2 - L2.Y1) * (L1.X1 - L2.X1)
    local n_b = (L1.X2 - L1.X1) * (L1.Y1 - L2.Y1) - (L1.Y2 - L1.Y1) * (L1.X1 - L2.X1)

    -- Calculate the intermediate fractional point that the lines potentially intersect.
    local ua = n_a / _d
    local ub = n_b / _d

    -- The fractional point will be between 0 and 1 inclusive if the lines
    -- intersect.  If the fractional calculation is larger than 1 or smaller
    -- than 0 the lines would need to be longer to intersect.
    if (ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1) then
        local x = L1.X1 + (ua * (L1.X2 - L1.X1))
        local y = L1.Y1 + (ua * (L1.Y2 - L1.Y1))
        return {x=x, y=y}
    end

    return false
end

			
--function intersection (s1, e1, s2, e2)
--  local d = (s1.x - e1.x) * (s2.y - e2.y) - (s1.y - e1.y) * (s2.x - e2.x)
--  local a = s1.x * e1.y - s1.y * e1.x
--  local b = s2.x * e2.y - s2.y * e2.x
--  local x = (a * (s2.x - e2.x) - (s1.x - e1.x) * b) / d
--  local y = (a * (s2.y - e2.y) - (s1.y - e1.y) * b) / d
--  return x, y
--end

--local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789~%' -- You will need this for encoding/decoding
---- encoding
--function encodeString(data)
--    return ((data:gsub('.', function(x) 
--        local r,b='',x:byte()
--        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
--        return r;
--    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
--        if (#x < 6) then return '' end
--        local c=0
--        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
--        return b:sub(c+1,c+1)
--    end)..({ '', '==', '=' })[#data%3+1])
--end
--
---- decoding
--function decodeString(data)
--    data = string.gsub(data, '[^'..b..'=]', '')
--    return (data:gsub('.', function(x)
--        if (x == '=') then return '' end
--        local r,f='',(b:find(x)-1)
--        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
--        return r;
--    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
--        if (#x ~= 8) then return '' end
--        local c=0
--        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
--            return string.char(c)
--    end))
--end


--function decodeString(str)
--   str = str:gsub("+", " ")
--   str = str:gsub("%%(%x%x)", function(h)
--      return string.char(tonumber(h,16))
--   end)
--   str = str:gsub("\r\n", "\n")
--   return str
--end
--
--function encodeString(str)
--   if str then
--      str = str:gsub("\n", "\r\n")
--      str = str:gsub("([^%w %-%_%.%~])", function(c)
--         return ("%%%02X"):format(string.byte(c))
--      end)
--      str = str:gsub(" ", "+")
--   end
--   return str	
--end


function GetFreezeTeeLine(inPlayerId, inPos, inDir, inCurv)
	local Lines = {}

	local IntersectedID = -1
	
	
	nDir = inDir
	LastLinePos = CalcPos(inPos, nDir, inCurv, 1000, 0)
	local Lifetime = TuneGetLifetime(WEAPON_GRENADE)
	for it = 0, Lifetime, 0.02 do
		local nres = CalcPos(inPos, nDir, inCurv, 1000, it)
		nres = vec2(nres.x, nres.y-32)
		table.insert(Lines, LineItem(LastLinePos.x, LastLinePos.y, nres.x, nres.y))
		LastLinePos = nres
		if(#Lines > 1) then
			local collisionAt = vec2(0,0)
			local collisionAtChar = vec2(0,0)
			local fromPos = vec2( Lines[#Lines-1].x1, Lines[#Lines-1].y1)
			local intesectRes = Game.Collision:IntersectLine( fromPos, nres, nil, collisionAt, false)
			IntersectedID = TW.Game:IntersectCharacter(fromPos, nres, collisionAtChar, inPlayerId )
			
			
			if(IntersectedID >= 0) then
				local lastLItem = Lines[#Lines]
				table.remove(Lines)
				table.insert(Lines, LineItem(lastLItem.x1, lastLItem.y1, collisionAtChar.x, collisionAtChar.y))
				break
			end
			
			if(intesectRes ~= 0) then
				local lastLItem = Lines[#Lines]
				table.remove(Lines)
				table.insert(Lines, LineItem(lastLItem.x1, lastLItem.y1, collisionAt.x, collisionAt.y))
				break
			end
			
			
		end
	end
	
	return Lines
end

--local char_to_hex = function(c)
--  return string.format("%%%02X", string.byte(c))
--end
--
--local function encodeString(url)
--  if url == nil then
--    return
--  end
--  url = url:gsub("\n", "\r\n")
--  url = url:gsub("([^%w ])", char_to_hex)
--  url = url:gsub(" ", "+")
--  return url
--end
--
--local hex_to_char = function(x)
--  return string.char(tonumber(x, 16))
--end
--
--local decodeString = function(url)
--  if url == nil then
--    return
--  end
--  url = url:gsub("+", " ")
--  url = url:gsub("%%(%x%x)", hex_to_char)
--  return url
--end
--