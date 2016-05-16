data = read_results('group7.asc');

clean_data=[];
for i=2:length(data)
	if ((data(i,4)~=data(i-1,4)) || (data(i,5)~=data(i-1,5))) 
		clean_data(end+1,:)=data(i,:);
	end
end

d = distance(clean_data(:,4),clean_data(:,5));
logd = log10(d);



F = 952.8e6;
lambda = 3e8/F;
%10*lambda = 3.1486m for this distance we have like 4 samples -> 4*20=80
%(20 is the factor between #samples of data and clean_data

window = data(1000:2000,:);

power = window(:,6);

meanPower = mean(power);

power=power-meanPower;
power_norm = power;
power_norm = power_norm/max(abs(power));

blackman_win = blackman(length(power_norm));

autocorr = xcorr(power_norm.*blackman_win);

%eval of Fs
Ts = mean(data(10001:11001,3)-data(10000:11000,3));
Fs = 1/Ts;

freqResp = fftshift(fft(autocorr));
figure
plot(linspace(-Fs/2,Fs/2,length(freqResp)),abs(freqResp));

vr=3.6*10.31*lambda; %radial speed km/h

lat_base = 50.796679;
long_base = 4.401703;

lat_init = window(1,4);
long_init = window(1,5);

lat_end = window(end,4);
long_end = window(end,5);

vect1 = [lat_init-lat_base, long_init-long_base];
vect2 = [lat_end-lat_init, long_end-long_init];

costheta = sum(vect2.*vect1)/(norm(vect1)*norm(vect2)); 

v = vr/costheta; % true speed

%% 



