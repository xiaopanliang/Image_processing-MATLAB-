fid = fopen('lena.raw', 'r'); 
lena = fread(fid, [512, 512]); 
lena = lena' / 255; 

lena_g = imnoise(lena, 'gaussian'); 
A = lena_g-lena;
lena_s = imnoise(lena, 'salt & pepper');

h_gauss = fspecial ('gaussian', 5, 0.5); 
h_log = fspecial ('log', 5, 0.5);

lena_g_logged = filter2 (h_log, lena_g); 
lena_s_logged = filter2 (h_log, lena_s);

%imshow(lena_g_logged);
imshow(lena_s_logged)