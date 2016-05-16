function area = cut(power, logd, n, f, offset)
	area = [];
	i = offset;
	c = 3e8;
	d0 = 10^logd(offset);
	while 10^logd(i) - d0 < n*c/f
		area(end+1) = power(i);
		i = i + 1;
	end
end