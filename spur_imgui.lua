script_name 'spur_imgui'
script_author 'imring'
script_version '9.0'

inicfg							= require 'inicfg'
imgui							= require 'imgui'
encoding						= require 'encoding'
encoding.default				= 'CP1251'
u8								= encoding.UTF8
files							= {}
window_file						= {}
languages						= {}
images							= {}
menu_spur						= imgui.ImBool(false)
example_menu					= imgui.ImBool(false)
name_add_spur					= imgui.ImBuffer(256)
name_edit_spur					= imgui.ImBuffer(256)
edit_text_spur					= imgui.ImBuffer(65536)
find_name_spur					= imgui.ImBuffer(256)
find_text_spur					= imgui.ImBuffer(256)
edit_pos_x						= imgui.ImInt(-1)
edit_pos_y						= imgui.ImInt(-1)
edit_size_x						= imgui.ImInt(-1)
edit_size_y						= imgui.ImInt(-1)
number_languages				= imgui.ImInt(0)
russian_characters				= { [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я' }
magicChar						= { '\\', '/', ':', '*', '?', '"', '>', '<', '|' }

local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4

style.WindowRounding = 1.5

colors[clr.TitleBg] = ImVec4(0.0, 0.0, 0.0, 0.6)
colors[clr.TitleBgActive] = ImVec4(0.0, 0.0, 0.0, 0.7)
colors[clr.TitleBgCollapsed] = ImVec4(0.0, 0.0, 0.0, 0.8)

colors[clr.CloseButton] = ImVec4(0.41, 0.41, 0.41, 0.50)
colors[clr.CloseButtonHovered] = ImVec4(0.98, 0.39, 0.36, 1.00)
colors[clr.CloseButtonActive] = ImVec4(0.98, 0.39, 0.36, 1.00)

colors[clr.WindowBg] = ImVec4(0.0, 0.0, 0.0, 0.5)

colors[clr.ScrollbarBg] = ImVec4(0.0, 0.0, 0.0, 0.2)

colors[clr.ScrollbarGrab] = ImVec4(0.8, 0.8, 0.8, 0.3)
colors[clr.ScrollbarGrabHovered] = ImVec4(0.8, 0.8, 0.8, 0.4)
colors[clr.ScrollbarGrabActive] = ImVec4(0.8, 0.8, 0.8, 0.5)

colors[clr.Header] = ImVec4(0.8, 0.8, 0.8, 0.3)
colors[clr.HeaderHovered] = ImVec4(0.8, 0.8, 0.8, 0.4)
colors[clr.HeaderActive] = ImVec4(0.8, 0.8, 0.8, 0.5)

colors[clr.Button] = ImVec4(0.8, 0.8, 0.8, 0.3)
colors[clr.ButtonHovered] = ImVec4(0.8, 0.8, 0.8, 0.4)
colors[clr.ButtonActive] = ImVec4(0.8, 0.8, 0.8, 0.5)

colors[clr.SliderGrabActive] = ImVec4(0.8, 0.8, 0.8, 0.3)

function imgui.OnDrawFrame()
	local x, y = getScreenResolution()
	if menu_spur.v then
		local t_find_text = {}
		imgui.SetNextWindowPos(imgui.ImVec2((config.pos.x == -1) and x/2 or config.pos.x, (config.pos.y == -1) and y/2 or config.pos.y), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(config.size.x, config.size.y), imgui.Cond.FirstUseEver)
		imgui.Begin(u8(language.names[1]), menu_spur)
		imgui.BeginChild(1, imgui.ImVec2(imgui.GetWindowWidth()/5, 0), true)
		imgui.InputText(u8(language.names[2]), find_name_spur)
		imgui.InputText(u8(language.names[3]), find_text_spur)
		if imgui.Selectable(u8(language.names[4])) then add_spur = true end
		if imgui.Selectable(u8(language.names[18])) then 
			edit_pos_x.v = config.pos.x
			edit_pos_y.v = config.pos.y
			edit_size_x.v = config.size.x
			edit_size_y.v = config.size.y
			for i, k in pairs(languages) do
				if k == config.language.path then number_languages.v = i end	
			end
			setting_spur = true 
		end
		if imgui.Selectable(u8(language.names[25])) then files, window_file, languages, images = getFilesSpur() end
		imgui.Separator()
		for i, k in pairs(files) do
			find_name_spur.v = find_name_spur.v:gsub('%[', '')
			find_name_spur.v = find_name_spur.v:gsub('%(', '')
			find_text_spur.v = find_text_spur.v:gsub('%[', '')
			find_text_spur.v = find_text_spur.v:gsub('%(', '')
			if k then
				local nameFileOpen = k:match('(.*).txt')
				if find_text_spur.v:find('%S') then
					local file = io.open('moonloader/filesSpur/'..k, 'r')
					while not file do file = io.open('moonloader/filesSpur/'..k, 'r') end
					local fileText = file:read('*a')
					fileText = fileText:gsub('{......}', '')
					if string.rlower(fileText):find(string.rlower(u8:decode(find_text_spur.v))) then
						t_find_text[#t_find_text+1] = k
						if imgui.Selectable(u8(nameFileOpen)) then
							find_text_spur.v = ''
							text_spur = true
							id_spur = i
						end
					end
					file:close()
				elseif string.rlower(nameFileOpen):find(string.rlower(u8:decode(find_name_spur.v))) and imgui.Selectable(u8(nameFileOpen)) then
					text_spur = true
					id_spur = i
				end
			end
		end
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild(2, imgui.ImVec2(0, 0), false)
		if setting_spur then
			imgui.InputInt(u8(language.names[19]..' X'), edit_pos_x)
			imgui.InputInt(u8(language.names[19]..' Y'), edit_pos_y)
			imgui.InputInt(u8(language.names[23]), edit_size_x)
			imgui.InputInt(u8(language.names[24]), edit_size_y)
			if imgui.CollapsingHeader(u8(language.names[20])) then
				for i, k in pairs(languages) do
					local file = inicfg.load(nil, 'moonloader/filesSpur/language/'..k)
					while not file do file = inicfg.load(nil, 'moonloader/filesSpur/language/'..k) end
					imgui.RadioButton(u8(file.names.name), number_languages, i)
				end
			end
			imgui.NewLine()
			if imgui.Button(u8(language.names[21])) then
				example_menu.v = not example_menu.v
			end
			imgui.SameLine()
			if imgui.Button(u8(language.names[6])) then
				config.pos.x = edit_pos_x.v
				config.pos.y = edit_pos_y.v
				config.size.x = edit_size_x.v
				config.size.y = edit_size_y.v
				config.language.path = languages[number_languages.v]
				inicfg.save(config, 'moonloader/filesSpur/config.ini')
				thisScript():reload()
			end
			imgui.SameLine()
			if imgui.Button(u8(language.names[7])) then
				setting_spur = false
			end
		elseif t_find_text[1] then
			for i = 1, #t_find_text do
				local file = io.open('moonloader/filesSpur/'..t_find_text[i], 'r')
				while not file do file = io.open('moonloader/filesSpur/'..t_find_text[i], 'r') end
				local nameFileOpen = t_find_text[i]:match('(.*).txt')
				imgui.BeginChild(i+50, imgui.ImVec2(0, 100), true)
				imgui.Text(u8(nameFileOpen))
				imgui.SameLine()
				if imgui.Button(u8(language.names[17])..'№'..i) then
					find_text_spur.v = ''
					text_spur = true
					id_spur = i
				end
				imgui.Separator()
				local fileText = file:read('*a')
				for w in fileText:gmatch('[^\r\n]+') do
					imgui.TextColoredRGB(w, imgui.GetMaxWidthByText(fileText))
				end
				imgui.EndChild()
				file:close()
			end
		elseif add_spur then
			imgui.InputText(u8(language.names[5]), name_add_spur)
			imgui.SameLine()
			if imgui.Button(u8(language.names[6])) then
				name_add_spur.v = u8(removeMagicChar(u8:decode(name_add_spur.v)))
				local namedublicate = false
				for i, k in pairs(files) do
					if k == u8:decode(name_add_spur.v) or not u8:decode(name_add_spur.v):find('%S') then namedublicate = true end
				end
				if not namedublicate then
					local index, boolindex = 0, false
					while not boolindex do
						index = index + 1
						send = true
						if not files[index] then boolindex = true end
					end
					local file = io.open('moonloader/filesSpur/'..u8:decode(name_add_spur.v)..'.txt', 'a')
					file:write('')
					file:flush()
					file:close()
					window_file[#window_file+1] = imgui.ImBool(false)
					files[#files+1] = u8:decode(name_add_spur.v)..'.txt'
					add_spur = false
				end
			end
			imgui.SameLine()
			if imgui.Button(u8(language.names[7])) then add_spur = false end
		elseif edit_nspur then
			imgui.InputText(u8(language.names[5]), name_edit_spur)
			imgui.SameLine()
			if imgui.Button(u8(language.names[6])) then
				name_edit_spur.v = u8(removeMagicChar(u8:decode(name_edit_spur.v)))
				local namedublicate = false
				for i, k in pairs(files) do
					if k == u8:decode(name_edit_spur.v) or not u8:decode(name_edit_spur.v):find('%S') then namedublicate = true end
				end
				if not namedublicate then
					local file = io.open('moonloader/filesSpur/'..files[id_spur], 'r')
					while not file do file = io.open('moonloader/filesSpur/'..files[id_spur], 'r') end
					local fileText = file:read('*a')
					file:close()
					os.remove('moonloader/filesSpur/'..files[id_spur])
					local file = io.open('moonloader/filesSpur/'..u8:decode(name_edit_spur.v)..'.txt', 'w')
					file:write(fileText)
					file:flush()
					file:close()
					files[id_spur] = u8:decode(name_edit_spur.v)..'.txt'
					edit_nspur = false
				end
			end
			imgui.SameLine()
			if imgui.Button(u8(language.names[7])) then edit_nspur = false end
			imgui.Separator()
			local file = io.open('moonloader/filesSpur/'..files[id_spur], 'r')
			while not file do file = io.open('moonloader/filesSpur/'..files[id_spur], 'r') end
			local fileText = file:read('*a')
			fileText = fileText:gsub('\n\n', '\n \n')
			for w in fileText:gmatch('[^\r\n]+') do
				imgui.TextColoredRGB(w, imgui.GetMaxWidthByText(fileText))
			end
			file:close()
		elseif id_spur then
			if not window_file[id_spur].v then
				if not text_spur then
					if edit_spur then
						imgui.Text(u8(files[id_spur]:match('(.*).txt')))
						imgui.SameLine()
						if imgui.Button(u8(language.names[8])) then
							edit_text_spur.v = edit_text_spur.v:gsub('\n\n', '\n \n')
							local file = io.open('moonloader/filesSpur/'..files[id_spur], 'w')
							file:write(u8:decode(edit_text_spur.v))
							file:flush()
							file:close()
							text_spur = true
							edit_spur = false
						end
						imgui.SameLine()
						if imgui.Button(u8(language.names[7])) then
							text_spur = true
							edit_spur = false
						end
						imgui.Separator()
						imgui.InputTextMultiline('', edit_text_spur, imgui.ImVec2(-0.1, -0.1))
					end
					if copy_spur then
						imgui.Text(u8(files[id_spur]:match('(.*).txt')))
						imgui.SameLine()
						if imgui.Button(u8(language.names[9])) then
							local text = ''
							for i , _ in pairs(table_text_spur.text) do
								if table_text_spur.text[i] and table_text_spur.enable[i].v then
									text = text..u8:decode(table_text_spur.text[i])..' '
								end
							end
							sampSetChatInputText(text)
							text_spur = true
							copy_spur = false
						end
						imgui.SameLine()
						if imgui.Button(u8(language.names[10])) then
							local text = ''
							for i = 1, #table_text_spur.text + 1 do
								if table_text_spur.text[i] then 
									text = text..u8:decode(table_text_spur.text[i])..' '
								end
							end
							sampSetChatInputText(text)
							text_spur = true
							copy_spur = false
						end
						imgui.SameLine()
						if imgui.Button(u8(language.names[7])) then
							text_spur = true
							copy_spur = false
						end
						imgui.Separator()
						for i , _ in pairs(table_text_spur.text) do
							if table_text_spur.text[i] then 
								imgui.Checkbox(table_text_spur.text[i]..'№'..i, table_text_spur.enable[i])
							end
						end
					end
				else
					local file = io.open('moonloader/filesSpur/'..files[id_spur], 'r')
					while not file do file = io.open('moonloader/filesSpur/'..files[id_spur], 'r') end
					local fileText = file:read('*a')
					fileText = fileText:gsub('\n\n', '\n \n')
					edit_spur = false
					copy_spur = false
					imgui.Text(u8(files[id_spur]:match('(.*).txt')))
					file:close()
					imgui.SameLine()
					if imgui.Button(u8(language.names[11])) then
						window_file[id_spur].v = true
					end
					if imgui.Button(u8(language.names[12])) then
						text_spur = false
						edit_spur = true
						edit_text_spur.v = u8(fileText)
					end
					imgui.SameLine()
					if imgui.Button(u8(language.names[13])) then
						edit_nspur = true
						name_edit_spur.v = u8(files[id_spur]:match('(.*).txt'))
					end
					imgui.SameLine()
					if imgui.Button(u8(language.names[14])) then
						text_spur = false
						copy_spur = true
						table_text_spur = { enable = {}, text = {} }
						for w in fileText:gmatch('[^\r\n]+') do
							w = w:gsub('{......}', '')
							w = w:gsub('{........}', '')
							w = w:gsub('%[center%]', '')
							w = w:gsub('%[right%]', '')
							table_text_spur.text[#table_text_spur.text+1] = u8(w)
							table_text_spur.enable[#table_text_spur.enable+1] = imgui.ImBool(false)
						end
					end
					imgui.SameLine()
					if imgui.Button(u8(language.names[15])) then
						os.remove('moonloader/filesSpur/'..files[id_spur])
						while doesFileExist('moonloader/filesSpur/'..files[id_spur]) do os.remove('moonloader/filesSpur/'..files[id_spur]) end
						window_file[id_spur] = nil
						files[id_spur] = nil
						id_spur = nil
						text_spur = false
					end
					imgui.Separator()
					for w in fileText:gmatch('[^\r\n]+') do
						imgui.TextColoredRGB(w, imgui.GetMaxWidthByText(fileText))
					end
				end
			else
				if imgui.Button(u8(language.names[16])) then
					window_file[id_spur].v = false
				end
			end
		end
		imgui.EndChild()
		imgui.End()
		if example_menu.v then
			local file = inicfg.load(nil, 'moonloader/filesSpur/language/'..languages[number_languages.v])
			while not file do file = inicfg.load(nil, 'moonloader/filesSpur/language/'..languages[number_languages.v]) end
			imgui.Begin(u8(file.names[1])..'№1', example_menu.v, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
			imgui.SetWindowSize(u8(file.names[1])..'№1', imgui.ImVec2(edit_size_x.v, edit_size_y.v))
			imgui.SetWindowPos(u8(file.names[1])..'№1', imgui.ImVec2((edit_pos_x.v == -1) and (x/2)-(imgui.GetWindowWidth()/2) or edit_pos_x.v-(edit_pos_x.v/2), (edit_pos_y.v == -1) and (y/2)-(imgui.GetWindowHeight()/2) or edit_pos_y.v-(edit_pos_y.v/2)))
			imgui.BeginChild(15, imgui.ImVec2(imgui.GetWindowWidth()/5, 0), true)
			if imgui.Selectable(u8(file.names[22])) then example_menu.v = false end
			imgui.EndChild()
			imgui.End()
		end
	end
	for i, k in pairs(files) do
		if k then
			if window_file[i].v then
				local flags = (not imgui.ShowCursor) and imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize or 0
				imgui.SetNextWindowPos(imgui.ImVec2(x/2-100, y/2-100), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
				imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver)
				imgui.Begin(u8(k:match('(.*).txt')), window_file[i], flags)
				local file = io.open('moonloader/filesSpur/'..k, 'r')
				while not file do file = io.open('moonloader/filesSpur/'..k, 'r') end
				local fileText = file:read('*a')
				for w in fileText:gmatch('[^\r\n]+') do
					imgui.TextColoredRGB(w, imgui.GetMaxWidthByText(fileText) - 15)
				end
				file:close()
				imgui.End()
			end
		end
	end
end

function main()
	while not isSampAvailable() do wait(0) end
	sampRegisterChatCommand('spur', function() menu_spur.v = not menu_spur.v end)
	if not doesDirectoryExist('moonloader/filesSpur') then 
		createDirectory('moonloader/filesSpur') 
		local file = io.open('moonloader/filesSpur/Help.txt', 'a')
		file:write('[center]{CCCCCC}Spur ImGui by {2A79E0}imring{CCCCCC}\n \nThis script is created on ImGui.\nIn this script you can enter some information that you can copy into the chat.\n \n[right]Version: 8.0\n[right]Last update: 13 April 2018.\n[right]Special for {DDDDDD}blast{FFFFFF}.{0693C7}hk')
		file:flush()
		file:close()
		local file = io.open('moonloader/filesSpur/config.ini', 'a')
		file:write('[pos]\nx=-1\ny=-1\n[size]\nx=850\ny=700\n[language]\npath=english.ini')
		file:flush()
		file:close()

		createDirectory('moonloader/filesSpur/language') 
		local file = io.open('moonloader/filesSpur/language/english.ini', 'a')
		file:write('[names]\nname=English\n1=ImGui Spur\n2=Name\n3=Text\n4=Add spur\n5=Name spur\n6=Save\n7=Cancel\n8=Save text spur\n9=Copy\n10=Copy all\n11=To separate into separate window\n12=Edit text spur\n13=Edit name spur\n14=Copy text spur in chat input\n15=Delete spur\n16=Attach to main window\n17=Open spur\n18=Settings spur\n19=Position spur\n20=Translates\n21=Example\n22=Close window\n23=Width window\n24=Height window\n25=Update files')
		file:flush()
		file:close()
		local file = io.open('moonloader/filesSpur/language/russian.ini', 'a')
		file:write('[names]\nname=Русский\n1=ImGui Шпора\n2=Имя\n3=Текст\n4=Добавить шпору\n5=Имя шпоры\n6=Сохранить\n7=Отмена\n8=Сохранить текст шпоры\n9=Скопировать\n10=Скопировать всё\n11=Открепить в отдельное окно\n12=Изменить текст шпоры\n13=Изменить имя шпоры\n14=Скопировать текст шпоры в чат\n15=Удалить шпору\n16=Присоединить к главному окну\n17=Открыть шпору\n18=Настройка шпоры\n19=Позиция шпоры\n20=Переводы\n21=Пример\n22=Закрыть окно\n23=Ширина окна\n24=Высота окна\n25=Обновить файлы')
		file:flush()
		file:close()
	end
	if not doesDirectoryExist('moonloader/filesSpur/img') then
		createDirectory('moonloader/filesSpur/img')
	end
	config = inicfg.load(nil, 'moonloader/filesSpur/config.ini')
	while not config do config = inicfg.load(nil, 'moonloader/filesSpur/config.ini') end
	language = inicfg.load(nil, 'moonloader/filesSpur/language/'..config.language.path)
	while not language do language = inicfg.load(nil, 'moonloader/filesSpur/language/'..config.language.path) end
	files, window_file, languages, images = getFilesSpur()
	while true do wait(0) 
		if files[1] then
			for i, k in pairs(files) do
				if k and not imgui.Process then imgui.Process = menu_spur.v or window_file[i].v end
			end
		else imgui.Process = menu_spur.v end
		imgui.LockPlayer = menu_spur.v
		imgui.ShowCursor = menu_spur.v
		--if not imgui.ShowCursor then imgui.SetMouseCursor(-1) end
	end
end

function string.rlower(s)
	s = s:lower()
	local strlen = s:len()
	if strlen == 0 then return s end
	s = s:lower()
	local output = ''
	for i = 1, strlen do
		local ch = s:byte(i)
		if ch >= 192 and ch <= 223 then
			output = output .. russian_characters[ch + 32]
		elseif ch == 168 then
			output = output .. russian_characters[184]
		else
			output = output .. string.char(ch)
		end
	end
	return output
end

function string.rupper(s)
	s = s:upper()
	local strlen = s:len()
	if strlen == 0 then return s end
	s = s:upper()
	local output = ''
	for i = 1, strlen do
		local ch = s:byte(i)
		if ch >= 224 and ch <= 255 then
			output = output .. russian_characters[ch - 32]
		elseif ch == 184 then
			output = output .. russian_characters[168]
		else
			output = output .. string.char(ch)
		end
	end
	return output
end

function imgui.TextColoredRGB(string, max_float)
	imgui.BeginChild(3, imgui.ImVec2(0, 0), false, imgui.WindowFlags.HorizontalScrollbar)

	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local u8 = require 'encoding'.UTF8

	local function color_imvec4(color)
		if color:upper():sub(1, 6) == 'SSSSSS' then return imgui.ImVec4(colors[clr.Text].x, colors[clr.Text].y, colors[clr.Text].z, tonumber(color:sub(7, 8), 16) and tonumber(color:sub(7, 8), 16)/255 or colors[clr.Text].w) end
		local color = type(color) == 'number' and ('%X'):format(color):upper() or color:upper()
		local rgb = {}
		for i = 1, #color/2 do rgb[#rgb+1] = tonumber(color:sub(2*i-1, 2*i), 16) end
		return imgui.ImVec4(rgb[1]/255, rgb[2]/255, rgb[3]/255, rgb[4] and rgb[4]/255 or colors[clr.Text].w)
	end

	local function render_text(string)
		for w in string:gmatch('[^\r\n]+') do
			if w:sub(1, 5) == '[img]' then
				local name = w:sub(6)
				if w:match('%[img%].+%[size%](%d+)%-(%d+)') then
					name = w:match('%[img%](.*)%[size%].+')
				end
				local path = 'moonloader/filesSpur/img/'..name
				if doesFileExist(path) then
					for i, k in ipairs(images) do
						if k[2] == path then
							local width, height = GetImageWidthHeight(k[2])
							if w:match('%[img%].+%[size%](%d+)%-(%d+)') then
								local w, h = w:match('%[img%].+%[size%](%d+)%-(%d+)')
								width, height = tonumber(w), tonumber(h)
							end
							imgui.Image(k[1], imgui.ImVec2(width, height))
							w = ''
							imgui.SameLine()
						end
					end
				end
			end
			local text, color = {}, {}
			local render_text = 1
			local m = 1
			if w:sub(1, 8) == '[center]' then
				render_text = 2
				w = w:sub(9)
			elseif w:sub(1, 7) == '[right]' then
				render_text = 3
				w = w:sub(8)
			end
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				if tonumber(w:sub(n+1, k-1), 16) or (w:sub(n+1, k-3):upper() == 'SSSSSS' and tonumber(w:sub(k-2, k-1), 16) or w:sub(k-2, k-1):upper() == 'SS') then
					text[#text], text[#text+1] = w:sub(m, n-1), w:sub(k+1, #w)
					color[#color+1] = color_imvec4(w:sub(n+1, k-1))
					w = w:sub(1, n-1)..w:sub(k+1, #w)
					m = n
				else w = w:sub(1, n-1)..w:sub(n, k-3)..'}'..w:sub(k+1, #w) end
			end
			local length = imgui.CalcTextSize(u8(w))
			if render_text == 2 then
				imgui.NewLine()
				imgui.SameLine(max_float / 2 - ( length.x / 2 ))
			elseif render_text == 3 then
				imgui.NewLine()
				imgui.SameLine(max_float - length.x - 5 )
			end
			if text[0] then
				for i, k in pairs(text) do
					imgui.TextColored(color[i] or colors[clr.Text], u8(k))
					imgui.SameLine(nil, 0)
				end
				imgui.NewLine()
			else imgui.Text(u8(w)) end
		end
	end

	render_text(string)

	imgui.EndChild()
end

function removeMagicChar(text)
	for i = 1, #magicChar do text = text:gsub(magicChar[i], '') end
	return text
end

function onWindowMessage(msg, wparam, lparam)
	if msg == 0x100 or msg == 0x101 then
		if wparam == 0x1B then imgui.Process = false end
	end
end

function imgui.GetMaxWidthByText(text)
	local max = imgui.GetWindowWidth()
	for w in text:gmatch('[^\r\n]+') do
		local size = imgui.CalcTextSize(w)
		if size.x > max then max = size.x end
	end
	return max - 15
end

function GetImageWidthHeight(file)
	local fileinfo=type(file)
	if type(file)=='string' then
		file=assert(io.open(file,'rb'))
	else
		fileinfo=file:seek('cur')
	end
	local function refresh()
		if type(fileinfo)=='number' then
			file:seek('set',fileinfo)
		else
			file:close()
		end
	end
	local width,height=0,0
	file:seek('set',1)
	if file:read(3)=='PNG' then
		file:seek('set',16)
		local widthstr,heightstr=file:read(4),file:read(4)
		if type(fileinfo)=='number' then
			file:seek('set',fileinfo)
		else
			file:close()
		end
		width=widthstr:sub(1,1):byte()*16777216+widthstr:sub(2,2):byte()*65536+widthstr:sub(3,3):byte()*256+widthstr:sub(4,4):byte()
		height=heightstr:sub(1,1):byte()*16777216+heightstr:sub(2,2):byte()*65536+heightstr:sub(3,3):byte()*256+heightstr:sub(4,4):byte()
		return width,height
	end
	file:seek('set')
	if file:read(2)=='BM' then
		file:seek('set',18)
		local widthstr,heightstr=file:read(4),file:read(4)
		refresh()
		width=widthstr:sub(4,4):byte()*16777216+widthstr:sub(3,3):byte()*65536+widthstr:sub(2,2):byte()*256+widthstr:sub(1,1):byte()
		height=heightstr:sub(4,4):byte()*16777216+heightstr:sub(3,3):byte()*65536+heightstr:sub(2,2):byte()*256+heightstr:sub(1,1):byte()
		return width,height
	end
	file:seek('set')
	if file:read(2)=='\255\216' then
		local lastb,curb=0,0
		local xylist={}
		local sstr=file:read(1)
		while sstr~=nil do
			lastb=curb
			curb=sstr:byte()
			if (curb==194 or curb==192) and lastb==255 then
				file:seek('cur',3)
				local sizestr=file:read(4)
				local h=sizestr:sub(1,1):byte()*256+sizestr:sub(2,2):byte()
				local w=sizestr:sub(3,3):byte()*256+sizestr:sub(4,4):byte()
				if w>width and h>height then
					width=w
					height=h
				end
			end
			sstr=file:read(1)
		end
		if width>0 and height>0 then
			refresh()
			return width,height
		end
	end
	file:seek('set')
	if file:read(4)=='GIF8' then
		file:seek('set',6)
		width,height=file:read(1):byte()+file:read(1):byte()*256,file:read(1):byte()+file:read(1):byte()*256
		refresh()
		return width,height
	end
	file:seek('set')
	if file:read(4)=='8BPS' then
		file:seek('set',14)
		local heightstr,widthstr=file:read(4),file:read(4)
		refresh()
		width=widthstr:sub(1,1):byte()*16777216+widthstr:sub(2,2):byte()*65536+widthstr:sub(3,3):byte()*256+widthstr:sub(4,4):byte()
		height=heightstr:sub(1,1):byte()*16777216+heightstr:sub(2,2):byte()*65536+heightstr:sub(3,3):byte()*256+heightstr:sub(4,4):byte()
		return width,height
	end
	file:seek('end',-18)
	if file:read(10)=='TRUEVISION' then
		file:seek('set',12)
		width=file:read(1):byte()+file:read(1):byte()*256
		height=file:read(1):byte()+file:read(1):byte()*256
		refresh()
		return width,height
	end
	file:seek('set')
	if file:read(2)=='II' then
		temp=file:read('*a')
		btomlong={temp:find('Btomlong')}
		rghtlong={temp:find('Rghtlong')}
		if #btomlong==2 and #rghtlong==2 then
			heightstr=temp:sub(btomlong[2]+1,btomlong[2]+5)
			widthstr=temp:sub(rghtlong[2]+1,rghtlong[2]+5)
			refresh()
			width=widthstr:sub(1,1):byte()*16777216+widthstr:sub(2,2):byte()*65536+widthstr:sub(3,3):byte()*256+widthstr:sub(4,4):byte()
			height=heightstr:sub(1,1):byte()*16777216+heightstr:sub(2,2):byte()*65536+heightstr:sub(3,3):byte()*256+heightstr:sub(4,4):byte()
			return width,height
		end
	end
	file:seek('set',4)
	if file:read(7)=='ftypmp4' then
		file:seek('set',0xFB)
		local widthstr,heightstr=file:read(4),file:read(4)
		refresh()
		width=widthstr:sub(1,1):byte()*16777216+widthstr:sub(2,2):byte()*65536+widthstr:sub(3,3):byte()*256+widthstr:sub(4,4):byte()
		height=heightstr:sub(1,1):byte()*16777216+heightstr:sub(2,2):byte()*65536+heightstr:sub(3,3):byte()*256+heightstr:sub(4,4):byte()
		return width,height
	end
	file:seek('set',8)
	if file:read(3)=='AVI' then
		file:seek('set',0x40)
		width=file:read(1):byte()+file:read(1):byte()*256+file:read(1):byte()*65536+file:read(1):byte()*16777216
		height=file:read(1):byte()+file:read(1):byte()*256+file:read(1):byte()*65536+file:read(1):byte()*16777216
		refresh()
		return width,height
	end
	refresh()
	return nil
end

function getFilesSpur()
	local files, window_file, languages, images = {}, {}, {}, {}
	local handleFile, nameFile = findFirstFile('moonloader/filesSpur/*.txt')
	local handleFile_l, nameFile_l = findFirstFile('moonloader/filesSpur/language/*.ini')
	local handleImg, nameImg = findFirstFile('moonloader/filesSpur/img/*.*')
	while nameFile or nameFile_l or nameImg do
		if handleFile_l then
			if not nameFile_l then
				findClose(handleFile_l)
			else 
				languages[#languages+1] = nameFile_l
				nameFile_l = findNextFile(handleFile_l)
			end
		end
		if handleFile then
			if not nameFile then 
				findClose(handleFile)
			else
				window_file[#window_file+1] = imgui.ImBool(false)
				files[#files+1] = nameFile
				nameFile = findNextFile(handleFile)
			end
		end
		if handleImg then
			if not nameImg then 
				findClose(handleImg)
			else
				local path = 'moonloader/filesSpur/img/'..nameImg
				images[#images+1] = { imgui.CreateTextureFromFile(path), path }
				nameImg = findNextFile(handleImg)
			end
		end
	end
	return files, window_file, languages, images
end
