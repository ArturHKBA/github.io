function sendMessage(text)
	TriggerEvent(
		"chat:addMessage",
		{
			templateId = "feuer_dayrise",
			args = {
				("feuer_dayrise v%s"):format(Version),
				text
			}
		}
	)
end

function countElements(table)
	local count = 0
	if type(table) == "table" then
		for k, v in pairs(table) do
			count = count + 1
		end
	end
	return count
end

syncInProgress = false