
		local function set_alpha()
			C.png_set_alpha_mode(png_ptr, C.PNG_ALPHA_OPTIMIZED, t.gamma or 2.2) --> premultiply alpha
		end

		local function strip_alpha()
			local my_background = ffi.new('png_color_16', 0, 0xffff, 0xffff, 0xffff, 0xffff)
			local image_background = ffi.new'png_color_16'
			local image_background_p = ffi.new('png_color_16p[1]', image_background)
			if C.png_get_bKGD(png_ptr, info_ptr, image_background_p) then
				C.png_set_background(png_ptr, image_background, C.PNG_BACKGROUND_GAMMA_FILE, 1, 1.0)
			else
				C.png_set_background(png_ptr, my_background, PNG_BACKGROUND_GAMMA_SCREEN, 0, 1.0)
			end
		end

		--request more conversions based on accept options.
		if t.accept and false then
			if img.pixel == 'g' then
				if t.accept.g then
					--we're good
				elseif t.accept.ga then
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_AFTER)
					img.pixel = 'ga'
				elseif t.accept.ag then
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_BEFORE)
					img.pixel = 'ag'
				elseif t.accept.rgb then
					C.png_set_gray_to_rgb(png_ptr)
					img.pixel = 'rgb'
				elseif t.accept.bgr then
					C.png_set_gray_to_rgb(png_ptr)
					C.png_set_bgr(png_ptr)
					img.pixel = 'bgr'
				elseif t.accept.rgba then
					C.png_set_gray_to_rgb(png_ptr)
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_AFTER)
					img.pixel = 'rgba'
				elseif t.accept.argb then
					C.png_set_gray_to_rgb(png_ptr)
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_BEFORE)
					img.pixel = 'argb'
				elseif t.accept.bgra then
					C.png_set_gray_to_rgb(png_ptr)
					C.png_set_bgr(png_ptr)
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_AFTER)
					img.pixel = 'bgra'
				elseif t.accept.abgr then
					C.png_set_gray_to_rgb(png_ptr)
					C.png_set_bgr(png_ptr)
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_BEFORE)
					img.pixel = 'abgr'
				end
			elseif img.pixel == 'ga' then
				if t.accept.ga then
					set_alpha()
				elseif t.accept.ag then
					C.png_set_swap_alpha(png_ptr)
					set_alpha()
					img.pixel = 'ag'
				elseif t.accept.rgba then
					C.png_set_gray_to_rgb(png_ptr)
					set_alpha()
					img.pixel = 'rgba'
				elseif t.accept.argb then
					C.png_set_gray_to_rgb(png_ptr)
					C.png_set_swap_alpha(png_ptr)
					set_alpha()
					img.pixel = 'argb'
				elseif t.accept.bgra then
					C.png_set_gray_to_rgb(png_ptr)
					C.png_set_bgr(png_ptr)
					set_alpha()
					img.pixel = 'bgra'
				elseif t.accept.abgr then
					C.png_set_gray_to_rgb(png_ptr)
					C.png_set_bgr(png_ptr)
					C.png_set_swap_alpha(png_ptr)
					set_alpha()
					img.pixel = 'abgr'
				elseif t.accept.g then
					strip_alpha()
					img.pixel = 'g'
				elseif t.accept.rgb then
					C.png_set_gray_to_rgb(png_ptr)
					strip_alpha()
					img.pixel = 'rgb'
				elseif t.accept.bgr then
					C.png_set_gray_to_rgb(png_ptr)
					C.png_set_bgr(png_ptr)
					strip_alpha()
					img.pixel = 'bgr'
				else
					set_alpha()
				end
			elseif img.pixel == 'rgb' then
				if t.accept.rgb then
					--we're good
				elseif t.accept.bgr then
					C.png_set_bgr(png_ptr)
					img.pixel = 'bgr'
				elseif t.accept.rgba then
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_AFTER)
					img.pixel = 'rgba'
				elseif t.accept.argb then
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_BEFORE)
					img.pixel = 'argb'
				elseif t.accept.bgra then
					C.png_set_bgr(png_ptr)
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_AFTER)
					img.pixel = 'bgra'
				elseif t.accept.abgr then
					C.png_set_bgr(png_ptr)
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_BEFORE)
					img.pixel = 'abgr'
				elseif t.accept.g then
					C.png_set_rgb_to_gray_fixed(png_ptr, 1, -1, -1)
					img.pixel = 'g'
				elseif t.accept.ga then
					C.png_set_rgb_to_gray_fixed(png_ptr, 1, -1, -1)
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_AFTER)
					img.pixel = 'ga'
				elseif t.accept.ag then
					C.png_set_rgb_to_gray_fixed(png_ptr, 1, -1, -1)
					C.png_set_add_alpha(png_ptr, 0xff, C.PNG_FILLER_BEFORE)
					img.pixel = 'ag'
				end
			elseif img.pixel == 'rgba' then
				if t.accept.rgba then
					set_alpha()
				elseif t.accept.argb then
					C.png_set_swap_alpha(png_ptr)
					set_alpha()
					img.pixel = 'argb'
				elseif t.accept.bgra then
					C.png_set_bgr(png_ptr)
					set_alpha()
					img.pixel = 'bgra'
				elseif t.accept.abgr then
					C.png_set_bgr(png_ptr)
					C.png_set_swap_alpha(png_ptr)
					set_alpha()
					img.pixel = 'abgr'
				elseif t.accept.rgb then
					strip_alpha()
					img.pixel = 'rgb'
				elseif t.accept.bgr then
					C.png_set_bgr(png_ptr)
					strip_alpha()
					img.pixel = 'bgr'
				elseif t.accept.ga then
					C.png_set_rgb_to_gray_fixed(png_ptr, 1, -1, -1)
					img.pixel = 'ga'
				elseif t.accept.ag then
					C.png_set_rgb_to_gray_fixed(png_ptr, 1, -1, -1)
					C.png_set_swap_alpha(png_ptr)
					img.pixel = 'ag'
				elseif t.accept.g then
					C.png_set_rgb_to_gray_fixed(png_ptr, 1, -1, -1)
					strip_alpha()
					img.pixel = 'g'
				else
					set_alpha()
				end
			else
				assert(false)
			end


		end --if t.accept

