function power_map(donnees)

figure
scatter(donnees(:,5), donnees(:,4), 10, donnees(:,6), 'filled');
colorbar;
colormap jet;
colormap('default');
plot_google_map('maptype', 'hybrid', 'APIKey', 'AIzaSyCIMKDsk_O_W3MyvexlR4GD4bTyetR2yBg');

end