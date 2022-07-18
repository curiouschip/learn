gamelib = {}

local nextID = 1

local screenRect = {
	shape = 'rect',
	position = {x = 0, y = 0},
	size = {width = 800, height = 480}
}

function gamelib.entity(entity)
	entity.id = nextID
	nextID = nextID + 1
	return entity
end

function gamelib.cull(entityList)
	local culled = 0
	entityList:forEach(function(e, ix)
		if not gamelib.collideOne(e, screenRect) then
			entityList:removeAt(ix)
			culled = culled + 1
		end
	end)
	return culled
end

function getIterator(thing)
	if getmetatable(thing) == EntityList then
		return function()
			return thing:iter()
		end
	elseif type(as) == "table" then
		return function()
			return ipairs(thing)
		end
	else
		return function()
			return ipairs({thing})
		end
	end
end

function gamelib.collide(as, bs, cb)
	ia = getIterator(as)
	ib = getIterator(bs)
	collisionCount = 0
	for aix, av in ia() do
   		for bix, bv in ib() do
    		if gamelib.collideOne(av, bv) then
    			collisionCount = collisionCount + 1
    			if cb ~= nil then
    				cb(av, bv)
    			end
    		end
		end 	
	end
	return collisionCount > 0
end

function gamelib.collideOne(a, b)
	if a.shape == 'rect' and b.shape == 'rect' then
		return collideRects(a.position, a.size, b.position, b.size)
	else
		return false
	end
end

function collideRects(p1, s1, p2, s2)
	if p2.x + s2.width < p1.x then return false end
	if p2.x > p1.x + s1.width then return false end
	if p2.y + s2.height < p1.y then return false end
	if p2.y > p1.y + s1.height then return false end
	return true
end

--
-- EntityList
--

FREE = 0
OCCUPIED = 1
REMOVED = 2

EntityList = {}
NoEntity = {}

function EntityList:new()
	el = {
		_entities = {},
		_states = {},
		_free = {},
		count = 0
	}
 	setmetatable(el, self)
  	self.__index = self
  	return el
end

function EntityList:isEmpty()
	return self.count == 0
end

function EntityList:add(entity)
	if table.getn(self._free) > 0 then
		i = table.remove(self._free)
		self._entities[i] = entity
		self._states[i] = OCCUPIED
	else
		table.insert(self._entities, entity)
		table.insert(self._states, OCCUPIED)
	end
	self.count = self.count + 1
end

function EntityList:indexOf(entity)
	for i, e in ipairs(self._entities) do
		if e ~= nil and e == entity then
			return i
		end
	end
	return -1
end

function EntityList:remove(entity)
	return self:removeAt(self:indexOf(entity))
end

function EntityList:removeAt(i)
	if i < 1 or i > table.getn(self._entities) then return false end
	if self._states[i] ~= OCCUPIED then return nil end
	e = self._entities[i]
	self._states[i] = REMOVED
	self.count = self.count - 1
	return e
end

function EntityList:purge()
	for i, e in ipairs(self._entities) do
		if self._states[i] == REMOVED then
			self._states[i] = FREE
			self._entities[i] = NoEntity
			table.insert(self._free, i)
		end
	end
end

function EntityList:forEach(cb)
	for i, e in ipairs(self._entities) do
		if e ~= NoEntity then
			cb(e, i, self._states[i])
		end
	end
end

function EntityList:iter()
	local i = 0
	return function()
		while true do
			i = i + 1
			ent = self._entities[i]
			if ent == nil then
				return nil, nil
			elseif ent ~= NoEntity then
				return i, ent
			end
		end
	end
end

gamelib.EntityList = EntityList

local currentFont = nil
local currentFontVariant = nil

function gamelib.setFont(font, variant)
	currentFont = font
	if currentFont ~= nil then
		currentFontVariant = currentFont:getVariant(variant or 0)
	else
		currentFontVariant = nil
	end
end

function gamelib.print(x, y, text)
	if not currentFont then
		return
	end
	local cw = currentFont.characterWidth
	local ch = currentFont.characterHeight
	local so = currentFont.startOffset
	local pos = 1
	while pos <= string.len(text) do
		local quad = currentFontVariant[string.byte(text, pos) - so + 1]
		if quad ~= nil then
			love.graphics.draw(currentFont._tex, quad, x, y)
		end
		x = x + cw
		pos = pos + 1
	end
end

Font = {}

--
--
-- Font

-- o must include:
--   lines
--   charactersPerLine
--   characterCount
--   startOffset
--   characterWidth
--   characterHeight
--   variants
function Font:new(tex, o)
	o._tex = tex
	o._variants = {}
	
	local globalLine = 1
	for i, v in ipairs(o.variants or {'default'}) do
		local char = 1
		local variant = {}
		for line = 1,o.lines do
			for col = 1,o.charactersPerLine do
				variant[char] = love.graphics.newQuad((col-1) * o.characterWidth, (globalLine-1) * o.characterHeight, o.characterWidth, o.characterHeight, tex:getDimensions())
				char = char + 1
			end
			globalLine = globalLine + 1
		end
		print(table.getn(variant))
		o._variants[i] = variant
	end

	setmetatable(o, self)
	self.__index = self
	return o
end

function Font:getVariant(variant)
	return self._variants[variant]
end

gamelib.Font = Font

return gamelib