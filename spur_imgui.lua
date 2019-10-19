script_name('spur-imgui')
script_author('imring')
script_version('11.0')
script_url('https://fishlake-scripts.ru/resources/8/')

require 'deps' {
	'fyp:mimgui'
}

local imgui = require 'mimgui'
local ffi = require 'ffi'
local folder = require 'folder'
local encoding = require 'encoding'

local cp1251 = encoding.CP1251
encoding.default = 'UTF-8'

local bold, iranges, welcome

local lower, sub, char, upper = string.lower, string.sub, string.char, string.upper
local concat = table.concat

-- initialization table
local lu_rus, ul_rus = {}, {}
for i = 192, 223 do
	local A, a = char(i), char(i + 32)
	ul_rus[A] = a
	lu_rus[a] = A
end
local E, e = char(168), char(184)
ul_rus[E] = e
lu_rus[e] = E

imgui.OnInitialize(function()

	local igio = imgui.GetIO()
	igio.ConfigFlags = ffi.C.ImGuiConfigFlags_NavEnableKeyboard + igio.ConfigFlags

	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 4

	-- From https://github.com/procedural/gpulib/blob/master/gpulib_imgui.h
	local function imgui_easy_theming(color_for_text, color_for_head, color_for_area, color_for_body, color_for_pops)
		local style = imgui.GetStyle()
		local ImVec4 = imgui.ImVec4

		style.Colors[ffi.C.ImGuiCol_Text] = ImVec4( color_for_text.x, color_for_text.y, color_for_text.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_TextDisabled] = ImVec4( color_for_text.x, color_for_text.y, color_for_text.z, 0.58 )
		style.Colors[ffi.C.ImGuiCol_WindowBg] = ImVec4( color_for_body.x, color_for_body.y, color_for_body.z, 0.95 )
		-- style.Colors[ffi.C.ImGuiCol_ChildWindowBg] = ImVec4( color_for_area.x, color_for_area.y, color_for_area.z, 0.58 )
		style.Colors[ffi.C.ImGuiCol_Border] = ImVec4( color_for_body.x, color_for_body.y, color_for_body.z, 0.00 )
		style.Colors[ffi.C.ImGuiCol_BorderShadow] = ImVec4( color_for_body.x, color_for_body.y, color_for_body.z, 0.00 )
		style.Colors[ffi.C.ImGuiCol_FrameBg] = ImVec4( color_for_area.x, color_for_area.y, color_for_area.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_FrameBgHovered] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.78 )
		style.Colors[ffi.C.ImGuiCol_FrameBgActive] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_TitleBg] = ImVec4( color_for_area.x, color_for_area.y, color_for_area.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_TitleBgCollapsed] = ImVec4( color_for_area.x, color_for_area.y, color_for_area.z, 0.75 )
		style.Colors[ffi.C.ImGuiCol_TitleBgActive] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_MenuBarBg] = ImVec4( color_for_area.x, color_for_area.y, color_for_area.z, 0.47 )
		style.Colors[ffi.C.ImGuiCol_ScrollbarBg] = ImVec4( color_for_area.x, color_for_area.y, color_for_area.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_ScrollbarGrab] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.21 )
		style.Colors[ffi.C.ImGuiCol_ScrollbarGrabHovered] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.78 )
		style.Colors[ffi.C.ImGuiCol_ScrollbarGrabActive] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 )
		-- style.Colors[ffi.C.ImGuiCol_ComboBg] = ImVec4( color_for_area.x, color_for_area.y, color_for_area.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_CheckMark] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.80 )
		style.Colors[ffi.C.ImGuiCol_SliderGrab] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.50 )
		style.Colors[ffi.C.ImGuiCol_SliderGrabActive] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_Button] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.50 )
		style.Colors[ffi.C.ImGuiCol_ButtonHovered] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.86 )
		style.Colors[ffi.C.ImGuiCol_ButtonActive] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_Header] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.76 )
		style.Colors[ffi.C.ImGuiCol_HeaderHovered] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.86 )
		style.Colors[ffi.C.ImGuiCol_HeaderActive] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 )
		-- style.Colors[ffi.C.ImGuiCol_Column] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.32 )
		-- style.Colors[ffi.C.ImGuiCol_ColumnHovered] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.78 )
		-- style.Colors[ffi.C.ImGuiCol_ColumnActive] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_ResizeGrip] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.15 )
		style.Colors[ffi.C.ImGuiCol_ResizeGripHovered] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.78 )
		style.Colors[ffi.C.ImGuiCol_ResizeGripActive] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 )
		-- style.Colors[ffi.C.ImGuiCol_CloseButton] = ImVec4( color_for_text.x, color_for_text.y, color_for_text.z, 0.16 )
		-- style.Colors[ffi.C.ImGuiCol_CloseButtonHovered] = ImVec4( color_for_text.x, color_for_text.y, color_for_text.z, 0.39 )
		-- style.Colors[ffi.C.ImGuiCol_CloseButtonActive] = ImVec4( color_for_text.x, color_for_text.y, color_for_text.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_PlotLines] = ImVec4( color_for_text.x, color_for_text.y, color_for_text.z, 0.63 )
		style.Colors[ffi.C.ImGuiCol_PlotLinesHovered] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_PlotHistogram] = ImVec4( color_for_text.x, color_for_text.y, color_for_text.z, 0.63 )
		style.Colors[ffi.C.ImGuiCol_PlotHistogramHovered] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 )
		style.Colors[ffi.C.ImGuiCol_TextSelectedBg] = ImVec4( color_for_head.x, color_for_head.y, color_for_head.z, 0.43 )
		style.Colors[ffi.C.ImGuiCol_PopupBg] = ImVec4( color_for_pops.x, color_for_pops.y, color_for_pops.z, 0.92 )
		-- style.Colors[ffi.C.ImGuiCol_ModalWindowDarkening] = ImVec4( color_for_area.x, color_for_area.y, color_for_area.z, 0.73 )
	end

	local function SetupImGuiStyle2()
		local color_for_text = { x = 236 / 255, y = 240 / 255, z = 241 / 255 }
		local color_for_head = { x = 41 / 255, y = 128 / 255, z = 185 / 255 }
		local color_for_area = { x = 57 / 255, y = 79 / 255, z = 105 / 255 }
		local color_for_body = { x = 44 / 255, y = 62 / 255, z = 80 / 255 }
		local color_for_pops = { x = 33 / 255, y = 46 / 255, z = 60 / 255 }
		imgui_easy_theming(color_for_text, color_for_head, color_for_area, color_for_body, color_for_pops)
	end

	SetupImGuiStyle2()

	local ranges = {
		0x0020, 0x00FF,
		0x0400, 0x052F,
		0x2DE0, 0x2DFF,
		0xA640, 0xA69F,
		0x2013, 0x2122,
		0,
	}

	local fonts = imgui.GetIO().Fonts
	fonts:Clear()
	iranges = ffi.new('ImWchar[?]', #ranges, ranges)
	fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\consola.ttf', 12, nil, iranges)
	bold = fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\consolab.ttf', 12, nil, iranges)
	welcome = fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\consolab.ttf', 14, nil, iranges)

end)

-- https://blast.hk/threads/13380/post-231049
local function split(str, delim, plain)
	local tokens, pos, i, plain = {}, 1, 1, not (plain == false)
	repeat
		local npos, epos = string.find(str, delim, pos, plain)
		tokens[i] = string.sub(str, pos, npos and npos - 1)
		pos = epos and epos + 1
		i = i + 1
	until not pos
	return tokens
end

-- https://github.com/juliettef/imgui_markdown/blob/master/imgui_markdown.h#L230
local function imgui_text_wrapped(clr, text)
	if clr then imgui.PushStyleColor(ffi.C.ImGuiCol_Text, clr) end

	text = ffi.new('char[?]', #text + 1, text)
	local text_end = text + ffi.sizeof(text) - 1
	local pFont = imgui.GetFont()

	local scale = 1.0
	local endPrevLine = pFont:CalcWordWrapPositionA(scale, text, text_end, imgui.GetContentRegionAvail().x)
	imgui.TextUnformatted(text, endPrevLine)

	while endPrevLine < text_end do
		text = endPrevLine
		if text[0] == 32 then text = text + 1 end
		endPrevLine = pFont:CalcWordWrapPositionA(scale, text, text_end, imgui.GetContentRegionAvail().x)
		if text == endPrevLine then
			endPrevLine = endPrevLine + 1
		end
		imgui.TextUnformatted(text, endPrevLine)
	end

	if clr then imgui.PopStyleColor() end
end

-- https://fishlake-scripts.ru/threads/8/post-24
local function imgui_text_color(text, wrapped)
	local style = imgui.GetStyle()
	local colors = style.Colors

	text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')
	local render_func = wrapped and imgui_text_wrapped or function(clr, text)
		if clr then imgui.PushStyleColor(ffi.C.ImGuiCol_Text, clr) end
		imgui.TextUnformatted(text)
		if clr then imgui.PopStyleColor() end
	end

	local color = colors[ffi.C.ImGuiCol_Text]
	for _, w in ipairs(split(text, '\n')) do
		local start = 1
		local a, b = w:find('{........}', start)
		while a do
			local t = w:sub(start, a - 1)
			if #t > 0 then
				render_func(color, t)
				imgui.SameLine(nil, 0)
			end

			local clr = w:sub(a + 1, b - 1)
			if clr:upper() == 'STANDART' then color = colors[ffi.C.ImGuiCol_Text]
			else
				clr = tonumber(clr, 16)
				if clr then
					local r = bit.band(bit.rshift(clr, 24), 0xFF)
					local g = bit.band(bit.rshift(clr, 16), 0xFF)
					local b = bit.band(bit.rshift(clr, 8), 0xFF)
					local a = bit.band(clr, 0xFF)
					color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
				end
			end

			start = b + 1
			a, b = w:find('{........}', start)
		end
		imgui.NewLine()
		if #w >= start then
			imgui.SameLine(nil, 0)
			render_func(color, w:sub(start))
		end
	end
end

-- http://mydc.ru/ptopic334.html
function string.lower(s)
	s = lower(s)
	local len, res = #s, {}
	for i = 1, len do
		local ch = sub(s, i, i)
		res[i] = ul_rus[ch] or ch
	end
	return concat(res)
end

function string.upper(s)
	s = upper(s)
	local len, res = #s, {}
	for i = 1, len do
		local ch = sub(s, i, i)
		res[i] = lu_rus[ch] or ch
	end
	return concat(res)
end

local current_dir = getWorkingDirectory() .. '\\spurs'
createDirectory(current_dir)

local spurs = folder.new(current_dir)
spurs:submit('*.txt')

local menu = ffi.new('bool[1]', false)
local cindex = -1
local overview = ffi.new('int[1]', 0)
local buffer = ffi.new('char[?]', 0x10000)
local is_find, find_text = false, false
local find_buffer = ffi.new('char[?]', 0x10000)
local name_spur = ffi.new('char[?]', 0x40)

local res, user = pcall(os.getenv, 'USERNAME')
local test_buffer = 'Hello, {FF0000}' .. (res and user or 'user') .. '{STANDART}!\n{FFFFFF55}How are {FFFF0055}you{FFFFFF55}?'
test_buffer = ffi.new('char[?]', #test_buffer + 1, test_buffer)

local error_text = ''

-- Search
local _imguitextunformatted = imgui.TextUnformatted
local cury, curx, alltext = 0, 0, ''
function imgui.TextUnformatted(text)
	local info = cp1251:decode(cp1251(ffi.string(find_buffer)):lower())
	local posx, start = imgui.GetCursorPosX(), 1
	if is_find and find_text and info ~= '' then
		local cy = imgui.GetCursorPosY()
		local ttext = cp1251:decode(cp1251(type(text) == 'cdata' and ffi.string(text) or text):lower())
		if cury ~= cy then
			cury = cy
			alltext = ''
			curx = imgui.GetCursorScreenPos().x
		end
		alltext = alltext .. ttext
		local st, en = alltext:find(info, start, true)
		local cur = imgui.GetCursorScreenPos()

		while st do
			local offset_start = imgui.CalcTextSize(alltext:sub(1, st - 1))
			local offset_end = imgui.CalcTextSize(info)
			local cx = curx + offset_start.x
			imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(cx, cur.y), imgui.ImVec2(cx + offset_end.x, cur.y + offset_end.y),
				imgui.ColorConvertFloat4ToU32(imgui.ImVec4(1, 1, 0.4, 0.3)), 1)
			start = en + 1
			st, en = alltext:find(info, start, true)
		end
		curx = curx + imgui.CalcTextSize(alltext:sub(1, start - 1)).x
		alltext = alltext:sub(start)
	else cury = 0 end
	_imguitextunformatted(text)
end

imgui.OnFrame(function () return menu[0] end,
function()
    local style = imgui.GetStyle()

	imgui.SetNextWindowSize(imgui.ImVec2(650, 350), ffi.C.ImGuiCond_FirstUseEver)

	imgui.Begin('Spur ImGui 2', menu)

	local size_files = imgui.GetWindowWidth() / 4
	imgui.Columns(2)
	imgui.SetColumnWidth(imgui.GetColumnIndex(), size_files)
	imgui.BeginChild('##files', imgui.ImVec2(size_files - style.ItemSpacing.x * 2, 0))
	if imgui.Selectable('New spur') then
		imgui.OpenPopup('New spur')
		error_text = ''
		ffi.fill(name_spur, ffi.sizeof(name_spur), 0)
	end
	if imgui.Selectable('Update files') then
		spurs:submit('*.txt')
	end
	imgui.Separator()
	local files = spurs:files()
	for i = 0, #files do
		local file = files[i]
		if file and file:type() == 'file' then
			if imgui.Selectable(cp1251:decode(file:get_name():match('(.*)%.txt$'))) then
				if i == cindex then cindex = -1
				else
					local f = file:open('r')
					if f then
						local text = cp1251:decode(f:read'*a')
						ffi.fill(buffer, ffi.sizeof(buffer), 0)
						ffi.fill(find_buffer, ffi.sizeof(find_buffer), 0)
						is_find = false
						ffi.copy(buffer, text, math.min(#text, ffi.sizeof(buffer)))
						f:close()
						cindex = i
						overview[0] = 0
					end
				end
			end
		end
	end
	
	if imgui.BeginPopupModal('New spur', nil, ffi.C.ImGuiWindowFlags_AlwaysAutoResize) then
		if #error_text > 0 then
			imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0), error_text)
			imgui.Separator()
		end
		imgui.Text('Enter name of new spur:')
		imgui.InputText('##name', name_spur, ffi.sizeof(name_spur) - 1)
		imgui.Separator()
		if imgui.Button('Create', imgui.ImVec2(120, 0)) then
			local path = current_dir .. '\\' .. cp1251(ffi.string(name_spur)) .. '.txt'
			local f = io.open(path)
			if f then
				error_text = 'This spur already created.'
				f:close()
			else
				f = io.open(path, 'w')
				f:write('')
				f:close()
				spurs:submit('*.txt')
				imgui.CloseCurrentPopup()
			end
		end
		imgui.SameLine()
		if imgui.Button('Cancel', imgui.ImVec2(120, 0)) then
			imgui.CloseCurrentPopup()
		end
		imgui.EndPopup()
	end

	imgui.EndChild()
	imgui.NextColumn()
	imgui.BeginChild('##info')

	local cfile = files[cindex]
	if cindex ~= -1 and cfile then
		imgui.PushFont(bold)
		imgui.Text(cp1251:decode(cfile:get_name():match('(.*)%.txt$')))
		imgui.PopFont()
		imgui.SameLine()
		-- crutch
		imgui.BeginChild('##options', imgui.ImVec2(imgui.CalcTextSize('Options >').x + style.ItemSpacing.x, imgui.GetFontSize() + style.ItemSpacing.y))
		local status = 0
		if imgui.BeginMenu('Options') then
			if imgui.MenuItemBool('Edit name') then
				ffi.fill(name_spur, ffi.sizeof(name_spur), 0)
				status = 1
			elseif imgui.MenuItemBool('Delete spur') then
				status = 2
			elseif imgui.MenuItemBool('Search') then is_find = true
			elseif imgui.MenuItemBool('Close') then cindex = -1 end
			imgui.EndMenu()
		end
		imgui.EndChild()
		imgui.Separator()
		local f = cfile:open('r')
		if f and imgui.BeginTabBar('##file' .. cfile:get_name()) then
			f:close()
			if imgui.BeginTabItem('Overview') then
				if is_find then
					imgui.InputText('Search', find_buffer, ffi.sizeof(find_buffer) - 1)
					imgui.SameLine()
					if imgui.Button('Close') then is_find = false end
				end
				local all = ffi.string(buffer)
				find_text = true
				imgui_text_color(all, true)
				find_text = false
				cury = 0
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem('Edit') then
				if imgui.InputTextMultiline('##buffer' .. cfile:get_name(), buffer, ffi.sizeof(buffer) - 1, imgui.ImVec2(-0.1, -0.1)) then
					f = cfile:open('w')
					f:write(cp1251(ffi.string(buffer)))
					f:close()
				end
				imgui.EndTabItem()
			end
			imgui.EndTabBar()
		end

		if status == 1 then imgui.OpenPopup('Name spur')
		elseif status == 2 then imgui.OpenPopup('Delete spur') end
		if imgui.BeginPopupModal('Name spur', nil, ffi.C.ImGuiWindowFlags_AlwaysAutoResize) then
			if #error_text > 0 then
				imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0), error_text)
				imgui.Separator()
			end
			imgui.Text('Enter new name of spur:')
			imgui.InputText('##name', name_spur, ffi.sizeof(name_spur) - 1)
			imgui.Separator()
			if imgui.Button('Edit', imgui.ImVec2(120, 0)) then
				local path = current_dir .. '\\' .. cp1251(ffi.string(name_spur)) .. '.txt'
				local f = io.open(path)
				if f then
					error_text = 'This spur already created.'
					f:close()
				else
					os.rename(cfile:full_path_name(), current_dir .. '\\' .. cp1251(ffi.string(name_spur)) .. '.txt')
					spurs:submit('*.txt')
					cindex = -1
					imgui.CloseCurrentPopup()
				end
			end
			imgui.SameLine()
			if imgui.Button('Cancel', imgui.ImVec2(120, 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.EndPopup()
		elseif imgui.BeginPopupModal('Delete spur', nil, ffi.C.ImGuiWindowFlags_AlwaysAutoResize) then
			imgui.Text('Are you sure you want to delete the spur "' .. cp1251:decode(cfile:get_name():match('(.*)%.txt$')) .. '"?')
			imgui.Separator()
			if imgui.Button('Yes', imgui.ImVec2(135, 0)) then
				os.remove(cfile:full_path_name())
				cindex = -1
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button('No', imgui.ImVec2(135, 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.EndPopup()
		end
	else
		cindex = -1
		imgui.PushFont(welcome)
		imgui.Text('Spur ImGui 2')
		imgui.PopFont()
		imgui.Separator()
		imgui_text_color([[
This is a script that allows you to enter or view information directly in the game.
Current version: v11.0 (19.10.19).
Author: imring.]], true)
		imgui.NewLine()
		if imgui.BeginTabBar('##info') then
			if imgui.BeginTabItem('Overview') then
				imgui_text_color(ffi.string(test_buffer), true)
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem('Edit (read only)') then
				imgui.InputTextMultiline('##testbuffer', test_buffer, ffi.sizeof(test_buffer) - 1, imgui.ImVec2(-0.1, -0.1), ffi.C.ImGuiInputTextFlags_ReadOnly)
				imgui.EndTabItem()
			end
			imgui.EndTabBar()
		end
	end

	imgui.EndChild()

	imgui.End()
end)

function main()
	if isSampLoaded() and isSampfuncsLoaded() then
		sampRegisterChatCommand('spur', function()
			menu[0] = not menu[0]
		end)
		wait(-1)
	else
		while true do wait(0)
			if testCheat('SPUR') then
				menu[0] = not menu[0]
			end
		end
	end
end