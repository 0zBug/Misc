
--https://raw.githubusercontent.com/sapphyrus/table_gen.lua/master/table_gen.lua

local a = {}
local b, c, d, e, f = table.insert, table.concat, string.rep, string.len, string.sub
local g, h, i = math.max, math.floor, math.ceil

local function j(k)
    local l, m = string.gsub(tostring(k), "[^\128-\193]", "")
    return m
end

local n = {
    ["ASCII"] = {"-", "|", "+"},
    ["Compact"] = {"-", " ", " ", " ", " ", " ", " ", " "},
    ["ASCII (Girder)"] = {"=", "||", "//", "[]", "\\\\", "|]", "[]", "[|", "\\\\", "[]", "//"},
    ["Unicode"] = {"═", "║", "╔", "╦", "╗", "╠", "╬", "╣", "╚", "╩", "╝"},
    ["Unicode (Single Line)"] = {"─", "│", "┌", "┬", "┐", "├", "┼", "┤", "└", "┴", "┘"},
    ["Markdown (Github)"] = {"-", "|", "|"}
}

for l, o in pairs(n) do
    if #o == 3 then
        for p = 4, 11 do
            o[p] = o[3]
        end
    end
end

local function q(r, s)
    r = f(r, 1, s)
    local t = j(r)
    return d(" ", h(s / 2 - t / 2)) .. r .. d(" ", i(s / 2 - t / 2))
end

local function u(r, s)
    r = f(r, 1, s)
    return r .. d(" ", s - j(r))
end

function a.generate_table(v, w, x)
    if type(x) == "string" or x == nil then
        x = {style = x or "ASCII"}
    end
    if x.top_line == nil then
        x.top_line = x.style ~= "Markdown (Github)"
    end
    if x.bottom_line == nil then
        x.bottom_line = x.style ~= "Markdown (Github)"
    end
    if x.header_seperator_line == nil then
        x.header_seperator_line = true
    end
    local y = n[x.style] or n["ASCII"]
    local z, A, B = {}, {}, 0
    local C = w ~= nil and #w > 0
    if C then
        for D = 1, #w do
            A[D] = j(w[D]) + 2
        end
        B = #w
    else
        for D = 1, #v do
            B = g(B, #v[D])
        end
    end
    for D = 1, #v do
        local E = v[D]
        for F = 1, B do
            A[F] = g(A[F] or 2, j(E[F]) + 2)
        end
    end
    local G = {}
    for D = 1, B do
        b(G, d(y[1], A[D]))
    end
    if x.top_line then
        b(z, y[3] .. c(G, y[4]) .. y[5])
    end
    if C then
        local H = {}
        for D = 1, B do
            H[D] = q(w[D], A[D])
        end
        b(z, y[2] .. c(H, y[2]) .. y[2])
        if x.header_seperator_line then
            b(z, y[6] .. c(G, y[7]) .. y[8])
        end
    end
    for D = 1, #v do
        local E, I = v[D], {}
        if #E == 0 then
            b(z, y[6] .. c(G, y[7]) .. y[8])
        else
            for p = 1, B do
                local J = x.value_justify == "center" and q(E[p] or "", A[p] - 2) or u(E[p] or "", A[p] - 2)
                I[p] = " " .. J .. " "
            end
            b(z, y[2] .. c(I, y[2]) .. y[2])
        end
    end
    if x.bottom_line and y[9] then
        b(z, y[9] .. c(G, y[10]) .. y[11])
    end
    return c(z, "\n")
end

return setmetatable(a, {
	__call = function(l, ...)
        return a.generate_table(...)
	end
})
