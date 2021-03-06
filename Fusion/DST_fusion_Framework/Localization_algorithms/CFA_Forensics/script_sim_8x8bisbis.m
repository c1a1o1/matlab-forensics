%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Calcolo ROC per dimensioni della statistica 4x4
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

datasets=dir('/users/ferrara/Desktop/Simulazioni/Dataset'); %%% INSERIRE IL PATH ESATTO
cartelle={datasets.name};

% dimensione del tampering per dataset. l'ordinamento dipende da come sono
% ordinate le cartelle nel path

tamper_size=[0,0,128,32,64,128,32,64,128,32,64,128,32,64,128,32,64,128,32,64,128,32,64];


% Inizializzazione di parametri che sono funzione della dimensione dei
% blocchi
Nb = [2,4,8];
TOL = 1e-3;
MAX_ITER = 500;

% Generazione dei dati sui quali effettuare le misure
for j =1:1
    for i=16:20
         %failures = main_dataset_v2(char(cartelle(i)),['/users/ferrara/Desktop/Simulazioni/Simulazioni8x8/',char(cartelle(i))],Nb(j),TOL,MAX_ITER);
         %verosimiglianza(['/users/ferrara/Desktop/Simulazioni/Simulazioni8x8/',char(cartelle(i))]);
         ROC_verosimiglianza2x2(['/users/ferrara/Desktop/Simulazioni/Simulazioni2x2/',char(cartelle(i))],tamper_size(i));
    end
end
