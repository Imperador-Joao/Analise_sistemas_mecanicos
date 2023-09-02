clc
clear all
close all

addpath("Equações","Tratamento de dados")

TAMANHO_TITULO = 15;
TAMANHO_LEGENDA = 15;


global MASSA K_MOLA ALPHA FORCA_EXT FREQUECIA_ANGULAR_FORCADA

MASSA = 1;
K_MOLA = 1;
ALPHA = 1;
FORCA_EXT = 1;
FREQUECIA_ANGULAR_FORCADA = 2*pi*sqrt(10);
CONDICOES_INICIAIS = [1;0];



limite = 102;

intervalo_referencia = 0:1/limite:20;
[instantes_referencia,matriz_pos_vel] = ode45(@edo_vdp, intervalo_referencia, CONDICOES_INICIAIS);


posicoes_referencia = matriz_pos_vel(:,1)';
velocidades_referencia = matriz_pos_vel(:,2)';

erros = [];
qtds_passos = [];
tempos_execucao = [];


for i = limite - 1: -5 :1

passo = 1/i;
intervalo = 0:passo:20;

tic
[instantes,matriz_pos_vel] = ode45(@edo_vdp, intervalo, CONDICOES_INICIAIS);
tempo_calculo = toc;


posicoes = matriz_pos_vel(:,1);
velocidades = matriz_pos_vel(:,2);

posicoes_expandidas = expandir_vetor(instantes,posicoes,intervalo_referencia);

erro = erro_relativo(posicoes_referencia,posicoes_expandidas');
erro_medio = mean(erro(~isinf(erro)));

n_passos = numel(instantes);


qtds_passos = [qtds_passos,n_passos];
erros = [erros,erro_medio];
tempos_execucao = [tempos_execucao,tempo_calculo];


if i == 1 || i == 11 || i == 51 || i == limite - 1
    
        figure
        plot(instantes,posicoes)

        [tamanho_titulo,~] = title("Resposta para um \Deltat de " + sprintf("%.0f ms",1000*passo));
        tamanho_titulo.FontSize = TAMANHO_TITULO;

        tamanho_legenda_horizontal = xlabel("Tempo (s)");
        tamanho_legenda_vertical = ylabel("Posição (m)");
        tamanho_legenda_horizontal.FontSize = TAMANHO_LEGENDA;
        tamanho_legenda_vertical.FontSize = TAMANHO_LEGENDA;

        figure
        plot(posicoes,velocidades)

        [tamanho_titulo,~] = title("Diagrama de fase para um \Deltat de " + sprintf("%.0f ms",1000*passo));
        tamanho_titulo.FontSize = TAMANHO_TITULO;

        tamanho_legenda_horizontal = xlabel("Posição (m)");
        tamanho_legenda_vertical = ylabel("Velocidade (m/s)");
        tamanho_legenda_horizontal.FontSize = TAMANHO_LEGENDA;
        tamanho_legenda_vertical.FontSize = TAMANHO_LEGENDA;


    end


end




figure
loglog(qtds_passos,erros)

[tamanho_titulo,~] = title("Erros percentuais para diferentes passos");
tamanho_titulo.FontSize = TAMANHO_TITULO;

tamanho_legenda_horizontal = xlabel("Qtd. de passos");
tamanho_legenda_vertical = ylabel("Erro percentual (%)");
tamanho_legenda_horizontal.FontSize = TAMANHO_LEGENDA;
tamanho_legenda_vertical.FontSize = TAMANHO_LEGENDA;


figure

plot(qtds_passos,1000*tempos_execucao)      %Converter para ms
xlim([0,numel(intervalo_referencia)])


[tamanho_titulo,~] = title("Tempo para calcular cada aproximação");
tamanho_titulo.FontSize = TAMANHO_TITULO;

tamanho_legenda_horizontal = xlabel("Qtd. de passos");
tamanho_legenda_vertical = ylabel("Tempo (ms)");
tamanho_legenda_horizontal.FontSize = TAMANHO_LEGENDA;
tamanho_legenda_vertical.FontSize = TAMANHO_LEGENDA;