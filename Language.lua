local Module = {}

function CheckValidString(String)
	local Check = true

	for Character in string.gmatch(String, ".") do
		if string.match(Character, "%W") and Character ~= "_" then
			Check = false
		end
	end

	if string.match(String, "^%d") or string.match(String, "%s") then
		Check = false
	end

	return Check
end

function CheckInvalidString(String)
	local Check = true

	for Character in string.gmatch(String, ".") do
		if string.match(Character, "%w") or Character == "_" then
			Check = false
		end
	end

	if string.match(String, "^%d") or string.match(String, "%s") then
		Check = false
	end

	return Check
end

function CreateSpecialTable(...)
	local Table = {
		Length = #{...} + 1,
		Elements = {...}
	}
	
	table.insert(Table.Elements, "ExtraString")
	
	return Table
end

function CreateVariablesTable(Value)
	return {
		Elements = {Value, "ExtraString"}
	}
end

function NewPairs(Table)
	return function(Sequence, Index)
		Index += 1
		
		if Index <= Sequence.Length then
			return Index, Sequence.Elements[Index]
		end
	end, Table, 0
end

function Module:AddNewLanguage(Name)
	if typeof(Name) ~= "string" then
		return error("language name has to be a string")
	end
	if self[Name] then
		return error("you can't create an already existing language")
	end
	if not CheckValidString(Name) then
		return error("language name is not a valid string")
	end
	
	self[Name] = {}
	self[Name]["Functions"] = {}
	self[Name]["Libraries"] = {}
	
	local Language = self[Name]
	local Functions = Language["Functions"]
	local Libraries = Language["Libraries"]
	
	local MagicCharacters = {
		"$",
		"%",
		"^",
		"*",
		"(",
		")",
		".",
		"[",
		"]",
		"+",
		"-",
		"?"
	}
	local MathOperators = {
		"^",
		"%",
		"*",
		"/",
		"+",
		"-"
	}
	
	Language.Start = "%("
	Language.End = "%)"
	Language.TableStart = "{"
	Language.TableEnd = "}"
	Language.Separator = ","
	Language.Connecter = "%."
	Language.Variable = "local"
	
	function Language:ChangeHolders(Start, End)
		if typeof(Start) ~= "string" then
			return error("start holder has to be a string")
		end
		if typeof(End) ~= "string" then
			return error("end holder has to be a string")
		end
		if not CheckInvalidString(Start) then
			return error("start holder is not a valid string")
		end
		if not CheckInvalidString(End) then
			return error("end holder is not a valid string")
		end
		
		self.Start = table.find(MagicCharacters, Start) and "%"..Start or Start
		self.End = table.find(MagicCharacters, End) and "%"..End or End
		
		return self
	end
	
	function Language:ChangeTable(Start, End)
		if typeof(Start) ~= "string" then
			return error("start holder has to be a string")
		end
		if typeof(End) ~= "string" then
			return error("end holder has to be a string")
		end
		if not CheckInvalidString(Start) then
			return error("start holder is not a valid string")
		end
		if not CheckInvalidString(End) then
			return error("end holder is not a valid string")
		end

		self.TableStart = table.find(MagicCharacters, Start) and "%"..Start or Start
		self.TableEnd = table.find(MagicCharacters, End) and "%"..End or End

		return self
	end
	
	function Language:ChangeSeparator(Separator)
		if typeof(Separator) ~= "string" then
			return error("separator has to be a string")
		end
		if not CheckInvalidString(Separator) then
			return error("separator is not a valid string")
		end
		
		self.Separator = Separator
		
		return self
	end
	
	function Language:ChangeConnecter(Connecter)
		if typeof(Connecter) ~= "string" then
			return error("connecter has to be a string")
		end
		if not CheckInvalidString(Connecter) then
			return error("connecter is not a valid string")
		end

		self.Connecter = table.find(MagicCharacters, Connecter) and "%"..Connecter or Connecter

		return self
	end
	
	function Language:ChangeVariable(Variable)
		if typeof(Variable) ~= "string" then
			return error("variable has to be a string")
		end
		if not CheckValidString(Variable) then
			return error("variable is not a valid string")
		end
		
		self.Variable = Variable

		return self
	end
	
	function Language:AddNewFunction(FunctionName, Function)
		if typeof(FunctionName) ~= "string" then
			return error("function name has to be a string")
		end
		if typeof(Function) ~= "function" then
			return error("function has to be a function")
		end
		if Functions[FunctionName] then
			return error("you can't create an already existing function")
		end
		if not CheckValidString(FunctionName) then
			return error("function name is not a valid string")
		end
		
		Functions[FunctionName] = Function
		
		return self
	end
	
	function Language:AddNewLibrary(LibraryName)
		if typeof(LibraryName) ~= "string" then
			return error("library name has to be a string")
		end
		if Libraries[LibraryName] then
			return error("you can't create an already existing library")
		end
		if not CheckValidString(LibraryName) then
			return error("library name is not a valid string")
		end
		
		Libraries[LibraryName] = {}
		Libraries[LibraryName]["Functions"] = {}
		
		local Library = Libraries[LibraryName]
		local LibraryFunctions = Library["Functions"]
		
		function Library:AddNewFunction(LibraryFunctionName, Function)
			if typeof(LibraryFunctionName) ~= "string" then
				return error("function name has to be a string")
			end
			if typeof(Function) ~= "function" then
				return error("function has to be a function")
			end
			if LibraryFunctions[LibraryFunctionName] then
				return error("you can't create an already existing library function")
			end
			if not CheckValidString(LibraryFunctionName) then
				return error("function name is not a valid string")
			end

			LibraryFunctions[LibraryName..Language.Connecter..LibraryFunctionName] = Function

			return self
		end
		
		return Library
	end
	
	function Language:RunCode(Code)
		if typeof(Code) ~= "string" then
			return error("language name has to be a string")
		end
		
		local GetArguments = {["Unpack"] = nil}
		
		local function FixMainTable(MainTable)
			local MissingContainers = {0, 0}
			local CombinedString = ""
			local NewMainTable = {}

			for i, v in ipairs(MainTable) do
				local _, Starts = string.gsub(v, self.Start, "")
				local _, Ends = string.gsub(v, self.End, "")
				local _, TableStarts = string.gsub(v, self.TableStart, "")
				local _, TableEnds = string.gsub(v, self.TableEnd, "")

				Starts += TableStarts
				Ends += TableEnds

				if Starts ~= Ends or MissingContainers[1] ~= MissingContainers[2] then
					MissingContainers[1] += Starts
					MissingContainers[2] += Ends
					CombinedString ..= v

					if MissingContainers[1] == MissingContainers[2] then
						table.insert(NewMainTable, CombinedString)
						CombinedString = ""
					end
				else
					table.insert(NewMainTable, v)
				end
			end

			return NewMainTable
		end
		
		local function FixOperationTable(OperationTable)
			local MissingContainers = {0, 0, false}
			local CombinedString = ""
			local NewOperationTable = {}

			for i, v in ipairs(OperationTable) do
				local _, Starts = string.gsub(v, self.Start, "")
				local _, Ends = string.gsub(v, self.End, "")
				local _, TableStarts = string.gsub(v, self.TableStart, "")
				local _, TableEnds = string.gsub(v, self.TableEnd, "")
				local _, ParenthesesStarts = string.gsub(v, "%(", "")
				local _, ParenthesesEnds = string.gsub(v, "%)", "")

				Starts += TableStarts + ParenthesesStarts
				Ends += TableEnds + ParenthesesEnds
				
				if string.match(v, "%a") or string.match(v, self.Connecter) then
					MissingContainers[3] = true
				end
				
				if Starts ~= Ends or MissingContainers[1] ~= MissingContainers[2] or MissingContainers[3] == true then
					MissingContainers[1] += Starts
					MissingContainers[2] += Ends
					CombinedString ..= v
					
					if MissingContainers[1] == MissingContainers[2] and MissingContainers[3] == false then
						table.insert(NewOperationTable, CombinedString)
						CombinedString = ""
					end
				else
					table.insert(NewOperationTable, v)
				end
				
				MissingContainers[3] = false
			end

			return NewOperationTable
		end
		
		local function FixArgumentTable(ArgumentsTable)
			local MissingContainers = {0, 0}
			local CombinedString = ""
			local NewArgumentsTable = {}

			for i, v in ipairs(ArgumentsTable) do
				local _, Starts = string.gsub(v, self.Start, "")
				local _, Ends = string.gsub(v, self.End, "")
				local _, TableStarts = string.gsub(v, self.TableStart, "")
				local _, TableEnds = string.gsub(v, self.TableEnd, "")

				Starts += TableStarts
				Ends += TableEnds

				if Starts ~= Ends or MissingContainers[1] ~= MissingContainers[2] then
					MissingContainers[1] += Starts
					MissingContainers[2] += Ends
					CombinedString ..= (CombinedString ~= "" and self.Separator or "")..v

					if MissingContainers[1] == MissingContainers[2] then
						table.insert(NewArgumentsTable, CombinedString)
						CombinedString = ""
					end
				else
					table.insert(NewArgumentsTable, v)
				end
			end

			return NewArgumentsTable
		end
		
		local function Calculator(CalculatorTable)
			local OperatorFunctions = {}
			
			OperatorFunctions["+"] = function(Number1, Number2)
				return Number1 + Number2
			end
			
			OperatorFunctions["*"] = function(Number1, Number2)
				return Number1 * Number2
			end
			
			OperatorFunctions["/"] = function(Number1, Number2)
				return Number1 / Number2
			end
			
			OperatorFunctions["%"] = function(Number1, Number2)
				return Number1 % Number2
			end
			
			OperatorFunctions["^"] = function(Number1, Number2)
				return Number1^Number2
			end
			
			local function CloneTable(OldTable)
				local NewTable = {}

				for _, Value in ipairs(OldTable) do
					if NewTable[#NewTable] == "-" then
						table.insert(NewTable, -Value)
						NewTable[#NewTable - 1] = "+"
					else
						if typeof(NewTable[#NewTable]) == "number" and typeof(Value) == "number" then
							NewTable[#NewTable] *= 10
							NewTable[#NewTable] += Value
						else
							table.insert(NewTable, Value)
						end
					end
				end

				return NewTable
			end
			
			local function GetNextOperation(NextTable, Operators)
				local Check = false
				
				if typeof(NextTable) == "table" then
					for Index, Value in ipairs(NextTable) do
						for _, Operator in ipairs(Operators) do
							if Value == Operator then
								Check = true
								NextTable[Index] = OperatorFunctions[Operator](NextTable[Index - 1], NextTable[Index + 1])
								table.remove(NextTable, Index - 1)
								table.remove(NextTable, Index)

								GetNextOperation(NextTable, Operators)

								break
							end
						end

						if Check then
							break
						end
					end
				end
				
				return NextTable
			end
			
			local First = GetNextOperation(CloneTable(CalculatorTable), {"^"})
			local Second = GetNextOperation(CloneTable(First), {"%", "*", "/"})
			local Third = GetNextOperation(CloneTable(Second), {"+"})
			
			return Third[1]
		end

		local function GetUpdatedOperation(Operation)
			local OperationTable = {}
			
			for Character in string.gmatch(Operation, ".") do
				if Character:match("^%s*(.-)%s*$") == "" then
					continue
				end
				
				table.insert(OperationTable, Character)
			end
			
			OperationTable = FixOperationTable(OperationTable)
			
			for Index, Value in ipairs(OperationTable) do
				local Library = Libraries[string.match(Value, "^(.+)"..self.Connecter..".+")]
				
				if table.find(MathOperators, Value) then
					continue
				end
				
				if string.match(Value, "%a") and string.match(Value, self.Start) and string.match(Value, self.End) then
					if Library then
						for ii, vv in pairs(Library["Functions"]) do
							if string.match(Value, "^"..ii) then
								Value = vv(GetArguments["Unpack"](Value, ii))
							end
						end
					else
						for ii, vv in pairs(Functions) do
							if string.match(Value, "^"..ii) then
								Value = vv(GetArguments["Unpack"](Value, ii))
							end
						end
					end
				end
				
				if string.match(Value, "^%(") and string.match(Value, "%)$") then
					Value = Calculator(GetUpdatedOperation(string.sub(Value, 2, -2)))
				end
				
				if not tonumber(Value) then
					return error("can't perform math with "..Value)
				end
				
				OperationTable[Index] = tonumber(Value)
			end
			
			return OperationTable
		end
		
		local Table = FixMainTable(string.split(Code, "\n"))
		local Variables = {}
		
		GetArguments["Unpack"] = function(Value, Function)
			local Arguments = nil

			if Function then
				Arguments = string.match(Value, Function.."%s*"..self.Start.."%s*(.+)%s*"..self.End)
			else
				Arguments = string.match(Value, self.TableStart.."%s*(.+)%s*"..self.TableEnd)
			end

			if Arguments == nil then
				return error("can't find "..Value:match("^%s*(.+)"))
			end

			local ArgumentsTable = CreateSpecialTable(table.unpack(FixArgumentTable(string.split(Arguments, self.Separator))))

			local function SetArguments(Index, Argument)
				local Library = Libraries[string.match(Argument:match("^%s*(.-)%s*$"), "^(.+)"..self.Connecter..".+")]
				local Check = true

				ArgumentsTable.Elements[Index] = Argument:match("^%s*(.-)%s*$")
				
				if string.match(ArgumentsTable.Elements[Index], [[^"(.+)"$]]) or string.match(ArgumentsTable.Elements[Index], [[^'(.+)'$]]) then
					Check = false
					ArgumentsTable.Elements[Index] = string.sub(ArgumentsTable.Elements[Index], 2, -2)
				end
				if ArgumentsTable.Elements[Index] == Argument:match("^%s*(.-)%s*$") then
					for ii, vv in pairs(Functions) do
						if string.match(ArgumentsTable.Elements[Index], "^"..ii) then
							Check = false
							ArgumentsTable.Elements[Index] = vv(GetArguments["Unpack"](ArgumentsTable.Elements[Index], ii))
						end
					end
				end
				if Library then
					if ArgumentsTable.Elements[Index] == Argument:match("^%s*(.-)%s*$") then
						for ii, vv in pairs(Library["Functions"]) do
							if string.match(ArgumentsTable.Elements[Index], "^"..ii) then
								Check = false
								ArgumentsTable.Elements[Index] = vv(GetArguments["Unpack"](ArgumentsTable.Elements[Index], ii))
							end
						end
					end
				end
				if string.match(ArgumentsTable.Elements[Index], "^"..self.TableStart) and string.match(ArgumentsTable.Elements[Index], self.TableEnd.."$") then
					Check = false
					ArgumentsTable.Elements[Index] = {GetArguments["Unpack"](ArgumentsTable.Elements[Index])}
				end
				for _, Operator in ipairs(MathOperators) do
					if typeof(ArgumentsTable.Elements[Index]) == "string" then
						if string.match(ArgumentsTable.Elements[Index], ".+%s*"..Operator.."%s*.+") then
							Check = false
							ArgumentsTable.Elements[Index] = Calculator(GetUpdatedOperation(ArgumentsTable.Elements[Index]))
							break
						end						
					end
				end
				if Variables[ArgumentsTable.Elements[Index]] ~= nil then
					Check = false
					ArgumentsTable.Elements[Index] = Variables[ArgumentsTable.Elements[Index]].Elements[1]
				end
				if tonumber(ArgumentsTable.Elements[Index]) then
					Check = false
					ArgumentsTable.Elements[Index] = tonumber(ArgumentsTable.Elements[Index])
				end
				if ArgumentsTable.Elements[Index] == "true" then
					Check = false
					ArgumentsTable.Elements[Index] = true
				end
				if ArgumentsTable.Elements[Index] == "false" then
					Check = false
					ArgumentsTable.Elements[Index] = false
				end
				if ArgumentsTable.Elements[Index] == "nil" then
					Check = false
					ArgumentsTable.Elements[Index] = nil
				end

				return Check
			end

			for i, v in NewPairs(ArgumentsTable) do
				if i ~= ArgumentsTable.Length then
					if v:match("^%s*(.-)%s*$") == "" then
						return error("can't have a nil argument in "..Value:match("^%s*(.+)"))
					end
					if SetArguments(i, v) then
						return error("can't find "..Value:match("^%s*(.+)"))
					end					
				end
			end

			return table.unpack(ArgumentsTable.Elements, 1, ArgumentsTable.Length - 1)
		end
		
		for i, v in pairs(Table) do
			if v:match("^%s*(.-)%s*$") == "" then
				continue
			end
			
			local function CallFunction(FunctionName, Function, Line, Custom)
				if Custom then
					Function(GetArguments["Unpack"](Line, FunctionName))
				else
					if string.find(v, FunctionName) and string.find(v, self.Start) and string.find(v, self.End) then
						if string.match(v:match("(.-)%s*$"), FunctionName.."%s*"..self.Start.."%s*.+%s*"..self.End) == v:match("^%s*(.-)%s*$") then
							Function(GetArguments["Unpack"](v, FunctionName))
						end
					end					
				end
			end

			local function CallVariable(ExtraString, VariableName, VariableValue, Library)
				if string.match(VariableValue, [[^"(.+)"$]]) or string.match(VariableValue, [[^'(.+)'$]]) then
					VariableValue = string.sub(VariableValue, 2, -2)
				end
				if ExtraString:match("^%s*(.-)%s*$") == self.End or ExtraString:match("^%s*(.-)%s*$") == "" then
					for ii, vv in pairs(Functions) do
						if string.match(VariableValue, "^"..ii) then
							VariableValue = vv(GetArguments["Unpack"](VariableValue, ii))
						end
					end
				end
				if Library then
					if ExtraString:match("^%s*(.-)%s*$") == self.End or ExtraString:match("^%s*(.-)%s*$") == "" then
						for ii, vv in pairs(Library["Functions"]) do
							if string.match(VariableValue, "^"..ii) then
								VariableValue = vv(GetArguments["Unpack"](VariableValue, ii))
							end
						end
					end
				end
				if string.match(VariableValue, "^"..self.TableStart) and string.match(VariableValue, self.TableEnd.."$") then
					VariableValue = {GetArguments["Unpack"](VariableValue)}
				end
				for _, Operator in ipairs(MathOperators) do
					if typeof(VariableValue) == "string" then
						if string.match(VariableValue, ".+%s*"..Operator.."%s*.+") then
							VariableValue = Calculator(GetUpdatedOperation(VariableValue))
							break
						end
					end
				end
				if Variables[VariableValue] ~= nil then
					VariableValue = Variables[VariableValue].Elements[1]
				end
				if tonumber(VariableValue) then
					VariableValue = tonumber(VariableValue)
				end
				if VariableValue == "true" then
					VariableValue = true
				end
				if VariableValue == "false" then
					VariableValue = false
				end
				if VariableValue == "nil" then
					VariableValue = nil
				end
				
				Variables[VariableName] = CreateVariablesTable(VariableValue)
			end
			
			local function CheckValidFunction(Functions)
				local FunctionFound = 0
				local Check = false
				
				for ii, vv in pairs(Functions) do				
					if string.find(v, ii) and string.find(v, self.Start) and string.find(v, self.End) then
						if not string.match(v:match("^%s*(.-)%s*$"), "^"..self.Variable.."%s*.+%s*=%s*.+") then
							Check = true
						end
						local ParameterString = string.match(v:match("(.-)%s*$"), ii.."%s*"..self.Start.."%s*(.+)%s*"..self.End) or ""
						local ExtraString = string.match(v:match("(.-)%s*$"), ii.."%s*"..self.Start.."%s*"..ParameterString.."%s*"..self.End.."(.+)") or ""
						local CheckString = string.match(v:match("(.-)%s*$"), ii.."%s*"..self.Start.."%s*"..ParameterString.."%s*"..self.End) ~= v:match("^%s*(.-)%s*$")
						local Count1 = 0
						local Count2 = 1

						for iii, vvv in pairs(Functions) do
							if string.find(v, iii) and string.find(v, self.Start) and string.find(v, self.End) then
								local _, Count3 = string.gsub(ParameterString, iii, "")
								local _, Count4 = string.gsub(ExtraString, iii, "")
								local _, Count5 = string.gsub(v, iii, "")

								Count1 += Count5

								if not CheckString then
									Count2 += Count3 - Count4
								else
									Count2 = Count1
								end
							end
						end

						FunctionFound += Count1
						FunctionFound -= Count2

						if CheckString and FunctionFound ~= 0 or ExtraString:match("^%s*(.-)%s*$") ~= self.End and ExtraString:match("^%s*(.-)%s*$") ~= "" then
							return false
						end
					end
				end
				
				return Check and FunctionFound == 0
			end
			
			local function CheckValidVariable(ExtraString, VariableValue, Library)
				local Check = false
				
				if string.match(VariableValue, [[^"(.+)"$]]) or string.match(VariableValue, [[^'(.+)'$]]) then
					Check = true
				end
				if ExtraString:match("^%s*(.-)%s*$") == self.End or ExtraString:match("^%s*(.-)%s*$") == "" then
					for ii, vv in pairs(Functions) do
						if string.match(VariableValue, "^"..ii) then
							Check = true
						end
					end
				end
				if Library then
					if ExtraString:match("^%s*(.-)%s*$") == self.End or ExtraString:match("^%s*(.-)%s*$") == "" then
						for ii, vv in pairs(Library["Functions"]) do
							if string.match(VariableValue, "^"..ii) then
								Check = true
							end
						end
					end
				end
				if string.match(VariableValue, "^"..self.TableStart) and string.match(VariableValue, self.TableEnd.."$") then
					Check = true
				end
				for _, Operator in ipairs(MathOperators) do
					if typeof(VariableValue) == "string" then
						if string.match(VariableValue, ".+%s*"..Operator.."%s*.+") then
							Check = true
						end
					end
				end
				if Variables[VariableValue] ~= nil then
					Check = true
				end
				if tonumber(VariableValue) then
					Check = true
				end
				if VariableValue == "true" then
					Check = true
				end
				if VariableValue == "false" then
					Check = true
				end
				if VariableValue == "nil" then
					Check = true
				end

				return Check
			end
			
			local function CheckVariable()
				if string.match(v:match("^%s*(.-)%s*$"), "^"..self.Variable.."%s*.+%s*=%s*.+") then
					local ParameterString = string.match(v:match("(.-)%s*$"), ".+%s*"..self.Start.."%s*(.+)%s*"..self.End) or ""
					local ExtraString = string.match(v:match("(.-)%s*$"), ".+%s*"..self.Start.."%s*"..ParameterString.."%s*"..self.End.."(.+)") or ""
					local VariableValue = string.match(v:match("^%s*(.-)%s*$"), "^"..self.Variable.."%s*.+%s*=%s*(.+)")
					local Library = Libraries[string.match(VariableValue:match("^%s*(.-)%s*$"), "^(.+)"..self.Connecter..".+")]

					return CheckValidVariable(ExtraString, VariableValue, Library)
				end
				
				return false
			end
			
			local function CheckVariableChange()
				if string.match(v:match("^%s*(.-)%s*$"), "^%s*.+%s*=%s*.+") and not string.match(v:match("^%s*(.-)%s*$"), "^"..self.Variable.."%s*.+%s*=%s*.+") then
					local ParameterString = string.match(v:match("(.-)%s*$"), ".+%s*"..self.Start.."%s*(.+)%s*"..self.End) or ""
					local ExtraString = string.match(v:match("(.-)%s*$"), ".+%s*"..self.Start.."%s*"..ParameterString.."%s*"..self.End.."(.+)") or ""
					local VariableName = string.match(v:match("^%s*(.-)%s*$"), "^(.+)%s*=%s*.+")
					local VariableValue = string.match(v:match("^%s*(.-)%s*$"), "^.+%s*=%s*(.+)")
					local Library = Libraries[string.match(VariableValue:match("^%s*(.-)%s*$"), "^(.+)"..self.Connecter..".+")]

					return CheckValidVariable(ExtraString, VariableValue, Library) and Variables[VariableName] ~= nil
				end

				return false
			end
			
			local function CheckFunction()
				return CheckValidFunction(Functions)
			end	
			
			local function CheckLibraryFunction()
				local Library = Libraries[string.match(v:match("^%s*(.-)%s*$"), "^(.+)"..self.Connecter..".+")]
				
				if Library then
					return CheckValidFunction(Library["Functions"])
				else
					return false
				end
			end
			
			if CheckVariable() then
				local ParameterString = string.match(v:match("(.-)%s*$"), ".+%s*"..self.Start.."%s*(.+)%s*"..self.End) or ""
				local ExtraString = string.match(v:match("(.-)%s*$"), ".+%s*"..self.Start.."%s*"..ParameterString.."%s*"..self.End.."(.+)") or ""
				local VariableName = string.match(v:match("^%s*(.-)%s*$"), "^"..self.Variable.."%s*(.+)%s*=%s*.+")
				local VariableValue = string.match(v:match("^%s*(.-)%s*$"), "^"..self.Variable.."%s*.+%s*=%s*(.+)")
				local Library = Libraries[string.match(VariableValue:match("^%s*(.-)%s*$"), "^(.+)"..self.Connecter..".+")]
				
				VariableName = VariableName:match("^%s*(.-)%s*$")
				VariableValue = VariableValue:match("^%s*(.-)%s*$")			
				
				CallVariable(ExtraString, VariableName, VariableValue, Library)
				
				continue
			end
			
			if CheckVariableChange() then
				local ParameterString = string.match(v:match("(.-)%s*$"), ".+%s*"..self.Start.."%s*(.+)%s*"..self.End) or ""
				local ExtraString = string.match(v:match("(.-)%s*$"), ".+%s*"..self.Start.."%s*"..ParameterString.."%s*"..self.End.."(.+)") or ""
				local VariableName = string.match(v:match("^%s*(.-)%s*$"), "^(.+)%s*=%s*.+")
				local VariableValue = string.match(v:match("^%s*(.-)%s*$"), "^.+%s*=%s*(.+)")
				local Library = Libraries[string.match(VariableValue:match("^%s*(.-)%s*$"), "^(.+)"..self.Connecter..".+")]
				
				VariableName = VariableName:match("^%s*(.-)%s*$")
				VariableValue = VariableValue:match("^%s*(.-)%s*$")
				
				CallVariable(ExtraString, VariableName, VariableValue, Library)
				
				continue
			end
			
			if CheckFunction() then
				for ii, vv in pairs(Functions) do
					CallFunction(ii, vv)
				end

				continue
			end
			
			if CheckLibraryFunction() then
				local Library = Libraries[string.match(v:match("^%s*(.-)%s*$"), "^(.+)"..self.Connecter..".+")]

				for ii, vv in pairs(Library["Functions"]) do
					CallFunction(ii, vv)
				end

				continue
			end
			
			return error("can't find "..v:match("^%s*(.+)"))
		end
		
		return self
	end
	
	return self[Name]
end

return Module
