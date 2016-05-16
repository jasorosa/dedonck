function [outPower] = average_filter(data, logd, n, f)
    c = 3*10^8;
    outPower = zeros(size(logd));
    for i = 1:length(data)
		j = i;
		count = 0;
		avg = 0;
		while j <= length(data) && (10^logd(j) - 10^logd(i) < n*c/f)
			avg = avg + data(j);
			count = count + 1;
			j = j + 1;
		end
		outPower(i) = avg/count;
    end  
end