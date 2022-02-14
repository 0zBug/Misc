
return {
    new = function()
        return {
            Connections = {},
            Connect = function(self, f)
                table.insert(self.Connections, f)
            end,
            Disconnect = function(self)
                table.clear(self.Connections)
            end,
            Fire = function(self, ...)
            	for _,f in pairs(self.Connections) do
            		f(...)
            	end
            end
        }
    end
}
