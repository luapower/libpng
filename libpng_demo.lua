local player = require'cplayer'
local libpng = require'libpng'
local glue = require'glue'
local ffi = require'ffi'
local stdio = require'stdio'
require'unit' --dir

local good_files = dir'media/png/good/*.png'
local bad_files = dir'media/png/bad/*.png'

local source_type = 'path'
local files = good_files
local bottom_up = false
local padded = false
local max_cut_size = 1024 * 6
local cut_size = max_cut_size
local pixel_format = 'rgb'
local source_filter = {all = true}
local format_filter_values = {'rgb', 'rgba', 'g', 'ga'}
local format_filter = glue.index(format_filter_values)
local bpc_filter_values = {'1b', '2b', '4b', '8b', '16b'}
local bpc_filter = glue.index(bpc_filter_values)
local pass_only = 7
local sparkle = false

function player:on_render(cr)

	--self.theme = self.themes.light

	files = self:mbutton{id = 'files', x = 10, y = 10, w = 180, h = 24,
						values = {good_files, bad_files}, texts = {[good_files] = 'good files', [bad_files] = 'bad files'},
						multiselect = false,
						selected = files}

	source_type = self:mbutton{id = 'source_type', x = 200, y = 10, w = 490, h = 24,
						values = {'path',  'stream', 'cdata', 'string', 'read cdata', 'read string'},
						selected = source_type}

	sparkle = self:togglebutton{id = 'sparkle', x = 700, y = 10, w = 90, h = 24, text = 'sparkle', selected = sparkle}

	bottom_up = self:togglebutton{id = 'bottom_up', x = 800, y = 10, w = 90, h = 24, text = 'bottom_up', selected = bottom_up}
	padded = self:togglebutton{id = 'padded', x = 900, y = 10, w = 90, h = 24, text = 'padded', selected = padded}

	if source_type ~= 'path' and source_type ~= 'stream' then
		cut_size = self:slider{id = 'cut_size', x = 1000, y = 10, w = self.w - 1000 - 10, h = 24,
										i0 = 0, i1 = max_cut_size, step = 1, i = cut_size, text = 'file cut'}
	end

	pixel_format = self:mbutton{id = 'pixel', x = 10, y = 40, w = 380, h = 24,
						values = {'rgb', 'bgr', 'rgba', 'bgra', 'argb', 'abgr', 'g', 'ga', 'ag'}, selected = pixel_format}

	source_filter = self:mbutton{id = 'source_filter', x = 400, y = 40, w = 190, h = 24,
						values = {'all', 'interlaced', 'paletted'}, selected = source_filter}
	format_filter = self:mbutton{id = 'format_filter', x = 600, y = 40, w = 190, h = 24,
						values = format_filter_values, selected = format_filter}
	bpc_filter = self:mbutton{id = 'bpc_filter', x = 800, y = 40, w = 190, h = 24,
						values = bpc_filter_values, selected = bpc_filter}
	pass_only = self:slider{id = 'pass_only', x = 1000, y = 40, w = 90, h = 24, i0 = 1, i1 = 7, i = pass_only, text = 'pass'}

	local function filter_image(image)
		--if source_filter.all then return true end
		if source_filter.interlaced and not image.file.interlaced then return end
		if source_filter.paletted and not image.file.paletted then return end
		if not bpc_filter[tostring(image.file.bit_depth)..'b'] then return end
		if not format_filter[image.file.pixel] then return end
		return true
	end

	local cy = 80
	local cx = 10

	for i,filename in ipairs(files) do

		local t = {}
		if source_type == 'path' then
			t.path = filename
		elseif source_type == 'stream' then
			t.stream = stdio.fopen(filename, 'rb')
		else
			local s = glue.readfile(filename)
			s = s:sub(1, cut_size)
			local cdata = ffi.new('uint8_t[?]', #s+1, s)
			if source_type == 'cdata' then
				t.cdata = cdata
				t.size = #s
			elseif source_type == 'string' then
				t.string = s
			elseif source_type:match'^read' then
				local function one_shot_reader(buf, sz)
					local done
					return function()
						if done then return end
						done = true
						return buf, sz
					end
				end
				if source_type:find'string' then
					t.read = one_shot_reader(s)
				else
					t.read = one_shot_reader(cdata, #s)
				end
			end
		end

		local w, h = 32, 32

		t.accept = {[pixel_format] = true, bottom_up = bottom_up, top_down = not bottom_up, padded = padded}
		t.sparkle = sparkle

		function t.render_scan(image, last_scan, scan_number, err)

			if scan_number ~= pass_only and not (pass_only > 1 and scan_number == 1 and last_scan) then return end

			if cx + w + 10 > self.w then
				cx = 10
				cy = cy + h + 10
			end

			if image then
				self:image{x = cx, y = cy, image = image}
			else
				w = (w + 10) * 8 - 10

				self:rect(cx, cy, w, h, 'error_bg')
				self:text(string.format('%s', err:match('^(.-)\n'):match(': ([^:]-)$')), 14,
													'normal_fg', 'center', 'center',
													cx, cy, w, h)
			end

			cx = cx + w + 10
		end

		pcall(function()
			t.header_only = true
			local image = libpng.load(t)
			if filter_image(image) then
				t.header_only = false
				local ok, err = pcall(function()
					libpng.load(t)
				end)
				if not ok then t.render_scan(nil, true, 1, err) end
			end
		end)

		if t.stream then
			t.stream:close()
		end
	end
end

player:play()

