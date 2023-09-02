clc
clear all
close all

addpath("Equações","Tratamento de dados")

TAMANHO_TITULO = 15;
TAMANHO_LEGENDA = 15;

global MASSA COMPRIMENTO_HASTE GRAVIDADE 
global FORCA_EXTERNA FREQUENCIA_ANGULAR_FORCAMENTO


MASSA = 1;
COMPRIMENTO_HASTE = 1;
GRAVIDADE = 9.81;

FORCA_EXTERNA = 5;
FREQUENCIA_ANGULAR_FORCAMENTO = 2*pi;
CONDICOES_INICIAIS = [-3;0];

limite = 102;
passo = 1/limite;
intervalo_referencia = 0:passo:20;


[instantes_referencia,vetor_theta_referencia] = ode45(@equacao_pendulo,intervalo_referencia,CONDICOES_INICIAIS);

posicoes_angulares_referencia = vetor_theta_referencia(:,1);
velocidades_angulares_referencia = vetor_theta_referencia(:,2);

qtd_passos = [];
erros = [];
tempos_execucao = [];

for i = limite - 1: -5 :1

    passo = 1/i;
    intervalo = 0:passo:20;

    tic
    [instantes,vetor_theta] = ode45(@equacao_pendulo,intervalo,CONDICOES_INICIAIS);
    tempo_calculo = toc;

    posicoes_angulares = vetor_theta(:,1);
    velocidades_angulares = vetor_theta(:,2);

    posicoes_angulares_expandidas = expandir_vetor(instantes,posicoes_angulares,intervalo_referencia);


    erro = erro_relativo(posicoes_angulares_referencia,posicoes_angulares_expandidas);
    erro_medio = mean(erro(~isinf(erro)));       %Exclui valores infinitos

    qtd_passos = [qtd_passos,numel(posicoes_angulares)];
    erros = [erros,erro_medio];
    tempos_execucao = [tempos_execucao,tempo_calculo];


    if i == 1 || i == 11 || i == 51 || i == limite - 1

        figure
        plot(instantes,posicoes_angulares)

        [tamanho_titulo,~] = title("Resposta para um \Deltat de " + sprintf("%.0f ms",1000*passo));
        tamanho_titulo.FontSize = TAMANHO_TITULO;

        tamanho_legenda_horizontal = xlabel("Tempo (s)");
        tamanho_legenda_vertical = ylabel("Posição (m)");
        tamanho_legenda_horizontal.FontSize = TAMANHO_LEGENDA;
        tamanho_legenda_vertical.FontSize = TAMANHO_LEGENDA;


        figure
        plot(posicoes_angulares,velocidades_angulares)

        [tamanho_titulo,~] = title("Diagrama de fase para um \Deltat de " + sprintf("%.0f ms",1000*passo));
        tamanho_titulo.FontSize = TAMANHO_TITULO;

        tamanho_legenda_horizontal = xlabel("Posição (m)");
        tamanho_legenda_vertical = ylabel("Velocidade (m/s)");
        tamanho_legenda_horizontal.FontSize = TAMANHO_LEGENDA;
        tamanho_legenda_vertical.FontSize = TAMANHO_LEGENDA;

    end

end

figure
loglog(qtd_passos,erros)
xlim([10,numel(intervalo_referencia)])

[tamanho_titulo,~] = title("Erros percentuais para diferentes passos");
tamanho_titulo.FontSize = TAMANHO_TITULO;

tamanho_legenda_horizontal = xlabel("Qtd. de passos");
tamanho_legenda_vertical = ylabel("Erro percentual (%)");
tamanho_legenda_horizontal.FontSize = TAMANHO_LEGENDA;
tamanho_legenda_vertical.FontSize = TAMANHO_LEGENDA;


figure

plot(qtd_passos,1000*tempos_execucao)      %Converter para ms
xlim([0,numel(intervalo_referencia)])


[tamanho_titulo,~] = title("Tempo para calcular cada aproximação");
tamanho_titulo.FontSize = TAMANHO_TITULO;

tamanho_legenda_horizontal = xlabel("Qtd. de passos");
tamanho_legenda_vertical = ylabel("Tempo (ms)");
tamanho_legenda_horizontal.FontSize = TAMANHO_LEGENDA;
tamanho_legenda_vertical.FontSize = TAMANHO_LEGENDA;