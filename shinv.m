function distance = shinv(p,sigma,aPath,bPath)
	gamma = erfcinv(2*p)*sigma*sqrt(2);
	distance = 10^((-102 - bPath - gamma) / aPath);
end