function vetor_erros = erro_relativo(vetor1,vetor2)
    
    vetor_erros = [];
    
    for i = 1 : numel(vetor1)

        elemento1 = vetor1(i);
        elemento2 = vetor2(i);

        erro = 100*abs((elemento1 - elemento2)/(elemento1));

        vetor_erros = [vetor_erros,erro];

end
