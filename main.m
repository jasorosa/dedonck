close all; clear all;

data = read_results('group7.asc');

F = 952.8e6;
C = 3e8;

clean_data = [];
for i=2:length(data)
   if data(i,4)~=data(i-1,4) || data(i,5)  ~= data(i-1,5)
      clean_data(end+1,:)=data(i,:);
   end
end

%% Path Loss
%power_map(clean_data);
f1 = figure;
d = plot_powa(clean_data);

d=log10(d);
power = clean_data(:,6);
P = polyfit(d,power',1);
hold on
dfit = [d linspace(2.98,3.4,100)];
plot(dfit,P(1)*dfit+P(2),'r')
legend('Power','Path loss')

% the plot is the power received not the path loss but path loss = power
% emitted - power received so slope is the same
% n is P(1)/10 = -6.8945 so very strong attenuation (~indoor)

% empirical model of the path loss
% it's mainly the slope n

%-102dBm : maximum cell radius without shadowing: 1877m

%% shadowing

figure;
shadowing = average_filter(clean_data(:,6)' - (P(1)*d+P(2)), d, 1, F);

plot(shadowing);

% with dfittool we can see the normal shape and check that
sigma = 6.30

figure;
autocorr(shadowing, 1400);
 % rho < 0.37 at sample = 767
 
rc = 767*(10^d(end) - 10^d(1))/length(d)
 
d90 = shinv(0.9,sigma,P(1),P(2))
d95 = shinv(.95,sigma,P(1),P(2))

shimulated = shadowSimul(d, clean_data, sigma, rc);
figure;
plot(shimulated);

thimulated = P(1)*d + P(2) + shimulated;
figure(f1);
plot(d, thimulated, 'g');

%% Fast Fading

ffading = clean_data(:,6)' - (P(1)*d+P(2)) - shadowing;


figure;

offset = 1000;

area = cut(ffading, d, 10, F, offset);
plot(area);

dfittool(10.^(area./10));
LCR = [];
AFD=[];
threshold = linspace(-10,10,100);
for t = threshold 
	LCR(end+1)=0;
	AFD(end+1)=0;
	for i=2:length(area)
		if area(i) > t && area(i-1) <= t
			LCR(end) = LCR(end)+1;
		end
		if area(i)<t
			AFD(end) = AFD(end)+1;
		end	
	end
end


deltaT = 60*(clean_data(offset+length(area), 2) - clean_data(offset, 2)) + clean_data(offset+length(area), 3) - clean_data(offset, 3);

deltaTc = C/(F*(10^d(offset+length(area)) - 10^d(offset))/ deltaT)

figure;
plot(threshold,AFD./length(area).*deltaT);

figure;
plot(threshold, LCR./deltaT);



 


