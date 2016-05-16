function d=plot_powa(data)
    d=[];
    for j=1:length(data)
        d(end+1)=distance(data(j,4),data(j,5));
	end
    plot(log10(d), data(:,6))
    title('Power signal in function of the distance to the base station');
    xlabel('Distance(log)');
    ylabel('Power received (dBm)');
end