-- led_sweep = coroutine.wrap( function()
-- 	for i=1,255 do
-- 		for j=1,255 do
-- 			for k=1,255 do
-- 				out = string.char(31, i, j, k)
-- 				apa102.write(7,6,out)
-- 				coroutine.yield()
-- 			end
-- 		end
-- 	end
-- end)

function mod(a ,b)
	m=a-(a/b)*b
	return m
end

function normal(a)
	if a < 0 then
		return 0
	elseif a > 255 then
		return mod(a, 256)
	else
		return a
	end
end

function make_sweep()
	inc_channel = 1
	channel = 2
	dec_channel =3
	channels = { 255; 255; 255 }
	return function()
		channels[inc_channel] = normal(channels[inc_channel] + 1)
		channels[dec_channel] = normal(channels[dec_channel] - 1)
		if channels[dec_channel] == 1 then
			inc_channel = mod(inc_channel+1,3)+1
			channel = mod(channel+1,3)+1
			dec_channel = mod(dec_channel+1,3)+1
		end
		
		out = string.rep(string.char(31, channels[1], channels[2], channels[3]), 4)
		apa102.write(7,6,out)
	end
end

tmr.alarm(0, 10, tmr.ALARM_AUTO, make_sweep())
