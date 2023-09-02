function Y_ponto = equacao_pendulo(t,Y)

global MASSA COMPRIMENTO_HASTE GRAVIDADE 
global FORCA_EXTERNA FREQUENCIA_ANGULAR_FORCAMENTO


forca_instantanea = FORCA_EXTERNA*sin(FREQUENCIA_ANGULAR_FORCAMENTO);

matriz_massas = [MASSA,0;0,MASSA];
matriz_gravidade = [0,-MASSA;0,0];
matriz_rotacao = [0,0;GRAVIDADE/COMPRIMENTO_HASTE,0];

Y_ponto = inv(matriz_massas)*(forca_instantanea - matriz_gravidade*Y - matriz_rotacao*sin(Y));


end