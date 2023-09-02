function Y_p = edo_linear(t,Y)

global massa constante_elastica constante_amortecimento forca_externa frequencia_angular_forcada

F = forca_externa*sin(frequencia_angular_forcada*t);

Y_p = [0 1;-constante_elastica/massa -constante_amortecimento/massa]*Y + [0;F/massa];
end
