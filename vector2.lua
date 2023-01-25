vector2 = {}

function vector2.new(px, py)
    return {x = px, y = py}
end

function vector2.add(vec1, vec2)
    local result = vector2.new(0, 0)
    result.x = vec1.x + vec2.x
    result.y = vec1.y + vec2.y
    return result
end

function vector2.sub(vec1, vec2)
    local result = vector2.new(0, 0)
    result.x = vec1.x - vec2.x
    result.y = vec1.y - vec2.y
    return result
end

function vector2.mult(vec1, scalar)
    local result = vector2.new(0, 0)
    result.x = vec1.x * scalar
    result.y = vec1.y * scalar
    return result
end

function vector2.div(vec1, scalar)
    local result = vector2.new(0, 0)
    result.x = vec1.x / scalar
    result.y = vec1.y / scalar
    return result
end

function vector2.magnitude(vec1)
    return math.sqrt((vec1.x * vec1.x) + (vec1.y * vec1.y))
end

function vector2.normalize(vec1)
    local mag = vector2.magnitude(vec1)
    if mag ~= 0 then
        return vector2.div(vec1, mag)
    end
    return vec1
end