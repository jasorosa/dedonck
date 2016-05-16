function d = distance(lat2,long2)
	R = 6371000;
	lat1 = 50.796679;
	long1 = 4.401703;
	d = 2.*R.*asin(sqrt(sind((lat2-lat1)./2).^2+cosd(lat1).*cosd(lat2).*sind((long2-long1)./2).^2));
end