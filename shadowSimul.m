function simulated = shadowSimul(logd, data, sigma, rc)
	simulated = zeros(size(logd));
	fback = 0;
	deltaT = 60*(data(end,2) - data(1,2))+data(end,3) - data(1,3);
	T = deltaT/length(logd)
	v = (10^logd(end) - 10^logd(1))/deltaT
	a = exp(-v*T*25/rc);
	mulOut = 10*log10(sigma)*sqrt(1-a^2);
	i = 1;
	for igs = randn(size(logd))
		interm = igs + a * fback;
		simulated(i) = mulOut * interm;
		fback = interm;
		i = i + 1;
	end