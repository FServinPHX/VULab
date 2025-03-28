



% Given values
density_liver_tissue = 1.05; % Average density of liver tissue in g/cm³, considering the range provided.
volume_box_cm3 = 10 * 10 * 10; % Volume in cubic centimeters calculated from the dimensions of the box.

% Calculate the weight of the liver tissue in grams
weight_liver_tissue_grams = density_liver_tissue * volume_box_cm3;
disp(weight_liver_tissue_grams);

% Conversion factor from grams to ounces
grams_to_ounces = 0.035274;

% Calculate the weight in ounces
weight_liver_tissue_ounces = weight_liver_tissue_grams * grams_to_ounces;
disp(weight_liver_tissue_ounces);




% Conversion factors
kg_to_lbs = 2.20462;
lbs_to_oz = 16;

% Minimum and maximum cow liver weight in kg
min_cow_liver_kg = 5;
max_cow_liver_kg = 10;

% Convert min and max weights to ounces
min_cow_liver_oz = min_cow_liver_kg * kg_to_lbs * lbs_to_oz;
max_cow_liver_oz = max_cow_liver_kg * kg_to_lbs * lbs_to_oz;

% Display the results
disp(['Min cow liver weight in ounces: ', num2str(min_cow_liver_oz)]);
disp(['Max cow liver weight in ounces: ', num2str(max_cow_liver_oz)]);
