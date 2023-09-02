function Y_p = edo_vdp(t,Y)

global MASSA ALPHA FORCA_EXT FREQUECIA_ANGULAR_FORCADA


forca_instantanea = FORCA_EXT*sin(FREQUECIA_ANGULAR_FORCADA*t);

matriz_massas = [MASSA 0;0 MASSA];
matriz_rigidez = [0 -1;1 -ALPHA*(1 - (dot(Y,Y))^2)];

Y_p = inv(matriz_massas)*[0;forca_instantanea] - inv(matriz_massas)*matriz_rigidez*Y;

end