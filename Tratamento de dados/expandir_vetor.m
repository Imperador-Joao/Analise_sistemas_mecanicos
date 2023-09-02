function y2 = expandir_vetor(x1,y1,x2)

equacoes_retas = [];

for i = 1:numel(x1)-1

    

    reta_que_conecta = polyfit(x1(i:i+1),y1(i:i+1),1);
    equacoes_retas = [equacoes_retas;x1(i+1),reta_que_conecta];

end

y2 = [];
for x = x2
    
    for linha = 1:length(equacoes_retas)

        limite = equacoes_retas(linha,1);
        if  x <= limite
            equacao = equacoes_retas(linha,[2,3]);
            y = polyval(equacao,x);
            y2 = [y2,y];
            break

        end

    end

end

end