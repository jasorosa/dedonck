function donnees_fin = read_results(file_name)

[fichier, message] = fopen(file_name, 'r');
scan = textscan(fichier, '%f;%f;%f;%f;%f;%f;%f');
fclose(fichier);

w = waitbar(0, 'Reading results');
for i = 1:length(scan)
    w = waitbar(i/length(scan), w);
    donnees2(i, :) = scan{i}(:);
end
close(w);

donnees2 = donnees2';

donnees_fin = NaN(size(donnees2, 1), size(donnees2, 2) - 1);

donnees_fin(:, 1) = donnees2(:, 1);
donnees_fin(:, 2) = donnees2(:, 2);
donnees_fin(:, 3) = donnees2(:, 3) + (.001*donnees2(:, 4));
donnees_fin(:, 4:size(donnees2, 2)-1) = donnees2(:, 5:size(donnees2, 2));

end