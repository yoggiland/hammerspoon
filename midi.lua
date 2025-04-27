-- Controller script for use with Ableton Live (LiveDJ templet)
-- Ableton Live track 1 and 2 (Deck A and Deck B) needs to be key mapped to '1' and '2'

-- MIDI Controller connected
-- local myDeviceName = 'Hercules P32 DJ'
local myDeviceName = 'NEON'

MidiDevice = hs.midi.new(myDeviceName)

if not MidiDevice then
	print("No midi device found, returning")

	return
else
	print("MIDI device found: " .. myDeviceName)

	hs.alert.show("MIDI device found: " .. myDeviceName)
end

-- for debugging
-- print('map: ' .. hs.inspect(hs.keycodes.map))

-- Select Ableton Live's Browser
-- sends Alt + 5 (Ableton Live's menu, Navigate -> Browser)
function access_browser()
	-- print('Live browser focus')

	hs.eventtap.keyStroke({"alt"}, "5") -- send alt + 5
end

-- Show Track Display Status for 'Deck A' (3) or 'Deck B' (4)
function showTrackStatus(value)
    -- print('Show Track Status ' .. value)

	hs.eventtap.keyStroke({}, value) -- 3 or 4 (Needs to be key mapped in Ableton Live)
end

-- Load Ableton Live Clip Pack into 'Deck A' or 'Deck B'
function load_track(track_number)
	-- Keyboard keys to send: Ctrl + C, 1, Ctrl + V or Ctrl + C, 2 and Ctrl + V

	-- Copy selected Clip Pack from Ableton Live's Browser
	hs.eventtap.keyStroke({"cmd"}, "c", 0)

	-- Select track, 'Deck A' or 'Deck B' (Deck A key mapped '1' and Deck B key mapped '2' in Ableton)
	hs.eventtap.keyStroke({}, track_number)

	-- Paste Clip Pack into Ableton selected track Session View (top Clip Slot)
	hs.eventtap.keyStroke({"cmd"}, "v", 0)
end

-- Callback function
MidiDevice:callback(function(object, deviceName, commandType, description, metadata)

-- for debugging
-- print('description: ' .. description)

-- Check if Ableton Live has focus
local frontmostApp = hs.application.frontmostApplication()

-- Ableton 'Live' frontmost application, if Live has focus
if frontmostApp and frontmostApp:name() == "Live" then

	-- Receive Note On
	if commandType == 'noteOn' then
		-- print('Receive Note On')

		-- Receive Midi Channel 1
		if metadata.channel == 0 then
			-- print('Receiving Note On, Channel 1')
				
			-- Focus Browser, Hercules P32 DJ
			if metadata.note == 1 and metadata.velocity == 127 then -- 'BROWSE_BTN' button (Rotary Encoder press) -- (Note/1/1)
				-- print('Receiving Note On, Channel 1, Hercules P32 DJ, Encoder 3 Pressed')

				access_browser()
			end
		end

		-- Receive Midi Channel 2
		if metadata.channel == 1 then
			-- print('Receiving Note On, Channel 2')

			-- Show Track Status Deck A, Hercules P32 DJ
			if metadata.note == 8 and metadata.velocity == 127 then -- 'SYNC_A' button
				-- print('Receiving Note On, Channel 2, Hercules P32 DJ, Show Track Status Deck A')

				showTrackStatus('3')
			end

			-- Load Deck A, Hercules P32 DJ
			if metadata.note == 15 and metadata.velocity == 127 then -- 'LOAD_A' button
				-- print('Receiving Note On, Channel 2, Hercules P32 DJ, Load Deck A')

				load_track("1")
			end
		end

		-- Receive Midi Channel 3
		if metadata.channel == 2 then
			-- print('Receiving Note On, Channel 3')

			-- Encoder 5 Pressed, Hercules P32 DJ
			if metadata.note == 1 and metadata.velocity == 127 then
				print('Receiving Note On, Channel 3, Hercules P32 DJ, ') -- 'FILTER_B' (Rotary Encoder press)
			end
				
			-- Encoder 4 Pressed, Hercules P32 DJ
			if metadata.note == 2 and metadata.velocity == 127 then -- 'LOOP_ENC_B' (Rotary Encoder press)
				print('Receiving Note On, Channel 3, Hercules P32 DJ, Encoder 4 Pressed')
			end

			-- Show Track Status Deck B, Hercules P32 DJ
			if metadata.note == 8 and metadata.velocity == 127 then -- 'SYNC_B' button
				-- print('Receiving Note On, Channel 3, Hercules P32 DJ, Show Track Status Deck B')

				showTrackStatus('4')
			end

			-- Load Deck B, Hercules P32 DJ
			if metadata.note == 15 and metadata.velocity == 127 then -- 'LOAD_B' button
				-- print('Receiving Note On, Channel 3, Hercules P32 DJ, Load Deck B')

				load_track("2")
			end
		end

		-- Receive Midi Channel 4
		if metadata.channel == 3 then
			-- print('Receiving Note On, Channel 4')

			-- Focus Live Browser, Reloop Neon
			if metadata.note == 68 and metadata.velocity == 127 then
				-- print('Receiving Note On, Channel 4, Reloop Neon, HOT CUE Long press') -- (Note/4/68)

				access_browser()
			end

			-- load Deck A, Reloop Neon
			if metadata.note == 70 and metadata.velocity == 127 then
				-- print('Receiving Note On, Channel 4, Reloop Neon, load Deck A')

				load_track("1")
			end
		end

		-- Receive Midi Channel 5
		if metadata.channel == 4 then
			-- print('Receiving Note On, Channel 5')

			-- load Deck B, Reloop Neon
			if metadata.note == 70 and metadata.velocity == 127 then
				-- print('Receiving Note On, Channel 5, Reloop Neon, load Deck B')

				load_track("2")
			end
		end

		-- Receive Midi Channel 6
		if metadata.channel == 5 then
			-- print('Receiving Note On, Channel 6')
		end

		-- Receive Midi Channel 7
		if metadata.channel == 6 then
			-- print('Receiving Note On, Channel 7')

			-- Encoder 1 Pressed, Reloop Neon
			if metadata.note == 32 and metadata.velocity == 127 then -- 'ENC 1 BTN'
				-- print('Receiving Note On, Channel 7, Reloop Neon, Encoder 1 Pressed')
			end
		end
	end

	-- Receive Control Change (CC)
	if commandType == 'controlChange' then
		print('Receiving Control Change')

		--  Receive Midi Channel 1
		if metadata.channel == 0 then
			-- print('Receiving Control Channel 1, Control Change received')

			-- if metadata.controllerNumber == 2 then
			-- navigate_up_down_browser(metadata.controllerValue)
			-- end
		end
	end

	-- Receive Note Off
	if commandType == 'noteOff' then
		print('Receiving Note Off')
	end

end
end)