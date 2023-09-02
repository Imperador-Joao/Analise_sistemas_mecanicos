clc
clear all
close all

addpath("Equações","Tratamento de dados")


TAMANHO_TITULO = 15;
TAMANHO_LEGENDA = 15;


global massa constante_elastica constante_amortecimento forca_externa frequencia_angular_forcada

massa = 1;
constante_elastica = 10;
constante_amortecimento = 5;

wn = sqrt(constante_elastica/massa) /(2*pi);
forca_externa = 1;
Hz = 1.5;
frequencia_angular_forcada = Hz * 2 * pi;


%erro_relativo = @(x,y) 100*abs((x-y)./x);

y_0 = 0;
dy_0 = 0;



limite = 102;
passo = 1/limite;
intervalo_referencia = 0:passo:20;

    
    
[t,Y] = ode45(@edo_linear,intervalo_referencia,[y_0;dy_0]);

x_referencia = Y(:,1)';
dx_referencia = Y(:,2)';

qtd_passos = [];
erros = [];
tempos_execucao = [];


for i = limite - 1: -5 :1


    passo = 1/i;
    intervalo = 0:passo:20;
    
    tic
    
    [t,Y] = ode45(@edo_linear,intervalo,[y_0;dy_0]);
    
    tempo_execucao = toc;
    
    x = Y(:,1);
    dx = Y(:,2);

    x_expandido = expandir_vetor(t,x,intervalo_referencia);


    erro = erro_relativo(x_referencia,x_expandido);
    erro_medio = mean(erro(~isinf(erro)));       %Exclui valores infinitos     

    qtd_passos = [qtd_passos,numel(x)];
    erros = [erros,erro_medio];
    tempos_execucao = [tempos_execucao,tempo_execucao];
    

   
    if i == 1 || i == 11 || i == 51 || i == limite - 1
    
        figure
        plot(t,x)

        [tamanho_titulo,~] = title("Resposta para um \Deltat de " + sprintf("%.0f ms",1000*passo));
        tamanho_titulo.FontSize = TAMANHO_TITULO;

        tamanho_legenda_horizontal = xlabel("Tempo (s)");
        tamanho_legenda_vertical = ylabel("Posição (m)");
        tamanho_legenda_horizontal.FontSize = TAMANHO_LEGENDA;
        tamanho_legenda_vertical.FontSize = TAMANHO_LEGENDA;




        figure
        plot(x,dx)

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