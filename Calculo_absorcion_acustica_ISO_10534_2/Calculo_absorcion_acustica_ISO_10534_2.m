% INSTRUCCIONES DE USO
% #1 Oprima el boton de Run ubicado en la parte superior, se le desplegara un mensaje en la ventana de comandos 
% #2 Ingrese la metodologia, eliga entre la opcion 1) ISO o 2) DOC
% #3 Ingrese el tipo de calibracion, eliga entre la opcion 1) 3 muestras o 2) 8 muestras
% #4 Ingresar el material a caracterizar, escoja entre los 5 tipos de materiales disponibles 
% 1) PLA    2) PETG    3) ABS    4) CONVENCIONAL    5) PHONOFLOOR  
% #5 Despues de ingresar los parametros anteriores, Se le desplegara un menu con varias opciones:
% 1º Tiempo y frecuencia (muestra una gráfica del microfono C en el dominio del tiempo y frecuencia)
% 2º Funcion de transferencia (muestra la comparacion de la FT calculada y la FT del software Smaart)
% 3º Coeficiente de reflexion (muestra el coeficiente de reflexion del material seleccionado)
% 4º Coeficiente de absorcion (muestra el coeficiente de absorcion del material seleccionado)
% 5º Comparar / Cargar audio (si selecciona esta opcion, el programa lo devolvera al inicio y podra 
% escoger de nuevo la metodologia, el tipo de calibracion y la muestra a caracterizar. Ademas, si
% selecciona la opcion 4º y 5º podra observar la grafica anterior y la nueva grafica)
% 6. Reiniciar (si desea reiniciar las graficas, seleccione esta opcion)
% 7. Salir (si selecciona esta opcion, se cerrara el programa)

% OBSERVACIONES A TENER EN CUENTA
% - En las opciones a escoger (#1, #2, #3, #4 y #5), ingrese solamente el numero de la opcion que 
% desea seleccionar, si ingresa otro caracter como por ejemplo una letra o un simbolo o simplemente
% le da enter sin ingresar un numero, el programa le puede generar un error o puede detener el programa
% - Cada vez que escoja la opcion 5º (comparar / cargar audio), seleccione la misma metodologia y
% el tipo de calibracion que escogio antes, si escoge una metodologia distinta, el programa cargara
% los audios pero tendra una resolucion distinta en la comparativa
% - Antes de seleccionar la opcion 5º, digite la opcion 3º o 4º de acuerdo a la grafica que desea
% comparar, despues de que se le despliegue la grafica, puede seleccionar la opcion 5º y asi, cuando 
% se cargue un nuevo audio, podra ver la seleccion anterior y la nueva seleccion en una sola grafica
% - Si selecciona la opcion 6º, debera volver a presionar la opcion 5º para regresar al menu principal

%_____________________________________________________________________________________________________

% CONSTANTES
comp = true;
opt = 0;
fs = 44100; % frecuencia de muestreo (Todos los audios cargados deben estar en la misma frecuencia de muestreo)
c = 341; % velocidad del sonido de acuerdo a UNE EN ISO 10534-2
d = 0.1; % longitud maxima lateral de la muestra
nfft = 2^12; % resolucion de la transformada de fourier (aumentar el exponente para mayor resolucion)
S_ISO = 0.617; % distancia de separacion de los microfonos 1 y 3 de acuerdo a UNE EN ISO 10534-2
S_DOC = 0.05; % distancia de separacion de los microfonos 2 y 3 de acuerdo al artículo "Extreme low-frequency ultrathin acoustic absorbing metasurface"
x1_ISO = 0.936; % distancia de separacion del microfono 1 a la superficie de la muestra
x1_DOC = 0.369; % distancia de separacion del microfono 2 a la superficie de la muestra

while opt ~= 7
    
    if comp
        [metod, typecal, typemat] = INGRESAR_VARIABLES();
        comp = false;
    end
    
    opt = INGRESAR_MENU();
    [typemat, mat, MIC_1, MIC_2, MIC_3, RR_MUESTRA, MIC_CAL1I, MIC_CAL2I, MIC_CAL3I, RR_CAL_I, MIC_ISO_CAL1II, MIC_ISO_CAL3II, RR_ISO_CAL_II, MIC_DOC_CAL2II, MIC_DOC_CAL3II, RR_DOC_CAL_II] = CARGAR_AUDIO(typemat,typecal);
    [FREC_FT_SMAART,MAG_FT_SMAART, H12, freq, H12I, H12II] = FT(metod, fs, nfft, MIC_1, MIC_2, MIC_3, RR_MUESTRA, MIC_CAL1I, MIC_CAL2I, MIC_CAL3I, RR_CAL_I, MIC_ISO_CAL1II, MIC_ISO_CAL3II, RR_ISO_CAL_II, MIC_DOC_CAL2II, MIC_DOC_CAL3II, RR_DOC_CAL_II);
    [freqMin, freqMax, alpha, r] = COEF_ABS(H12I, H12II, H12, d, freq, c, S_ISO, S_DOC, x1_ISO, x1_DOC, metod);
    
    alpha = max(0, min(alpha, 1));
    r = max(0, min(r, 1));
    
    GRAFICAR(typemat, mat, metod, freqMin, freqMax, opt, fs, freq, FREC_FT_SMAART, MAG_FT_SMAART, MIC_3, H12, alpha, r);
    
    if opt == 5
        comp = true;
    end
    
end

function [metod, typecal, typemat] = INGRESAR_VARIABLES()
    val_metod = false;
    while ~val_metod
        metod = input("Ingrese la metodologia\n 1) ISO\n 2) DOC\n");
        if metod == 1 || metod == 2
            val_metod = true;
        else
            disp('Opcion no valida, intente de nuevo');
        end
    end

    val_typecal = false;
    while ~val_typecal
        typecal = input("Ingrese el tipo de calibracion\n 1) 3 muestras\n 2) 8 muestras\n");
        if typecal == 1 || typecal == 2
            val_typecal = true;
        else
            disp('Opcion no valida, intente de nuevo');
        end
    end

    val_typemat = false;
    while ~val_typemat
        typemat = input("Ingrese el material a caracterizar\n 1) PLA\n 2) PETG\n 3) ABS\n 4) CONVENCIONAL\n 5) PHONOFLOOR\n");
        if any(typemat == [1, 2, 3, 4, 5])
            val_typemat = true;
        else
            disp('Opcion no valida, intente de nuevo');
        end
    end
end

function opt = INGRESAR_MENU()
    val_opt = false;
    while ~val_opt
        opt = input("Ingrese una opcion\n 1) Tiempo y frecuencia\n 2) Función de transferencia\n 3) Coeficiente de reflexion\n 4) Coeficiente de absorcion\n 5) Comparar / Cargar audio\n 6) Reiniciar\n 7) Salir\n");
        if any(opt == [1, 2, 3, 4, 5, 6, 7])
            val_opt = true;
        else
            disp('Opcion no valida, intente de nuevo');
        end
    end
end

function [typemat, mat, MIC_1, MIC_2, MIC_3, RR_MUESTRA, MIC_CAL1I, MIC_CAL2I, MIC_CAL3I, RR_CAL_I, MIC_ISO_CAL1II, MIC_ISO_CAL3II, RR_ISO_CAL_II, MIC_DOC_CAL2II, MIC_DOC_CAL3II, RR_DOC_CAL_II] = CARGAR_AUDIO(typemat,typecal)
    
    if typemat == 1
        mat = "PLA_";
    elseif typemat == 2
        mat = "PETG_";
    elseif typemat == 3
        mat = "ABS_";
    elseif typemat == 4
        mat = "CONV_";
    elseif typemat == 5
        mat = "PHONO_";
    end 
    
    if typecal == 1
        cal = "3M_";
    elseif typecal == 2
        cal = "8M_";
    end

    [MIC_1,~] = audioread(strcat(mat,"MIC_1.wav")); % AUDIOS MUESTRAS
    [MIC_2,~] = audioread(strcat(mat,"MIC_2.wav")); % MIC_1 / 3 (ISO)
    [MIC_3,~] = audioread(strcat(mat,"MIC_3.wav")); % MIC_2 / 3 (DOC)
    [RR_MUESTRA,~] = audioread(strcat(mat,"RR.wav")); % RUIDO ROSA MUESTRA
    
    [MIC_CAL1I,~] = audioread(strcat(cal,"MIC_CAL1I.wav")); % AUDIOS CALIBRACION
    [MIC_CAL2I,~] = audioread(strcat(cal,"MIC_CAL2I.wav")); % MIC_CAL1I / MIC_CAL3I (ISO)
    [MIC_CAL3I,~] = audioread(strcat(cal,"MIC_CAL3I.wav")); % MIC_CAL1II / MIC_CAL3II (ISO)
    [RR_CAL_I,~] = audioread(strcat(cal,"RR_CAL_I.wav")); % RUIDO ROSA CALIBRACION I
    
    [MIC_ISO_CAL1II,~] = audioread(strcat(cal,"MIC_ISO_CAL1II.wav")); % MIC_CAL2I / MIC_CAL3I (DOC)
    [MIC_ISO_CAL3II,~] = audioread(strcat(cal,"MIC_ISO_CAL3II.wav")); % MIC_CAL2II / MIC_CAL3II (DOC)
    [RR_ISO_CAL_II,~] = audioread(strcat(cal,"RR_ISO_CAL_II.wav")); % RUIDO ROSA CALIBRACION II (ISO)
    
    [MIC_DOC_CAL2II,~] = audioread(strcat(cal,"MIC_DOC_CAL2II.wav")); 
    [MIC_DOC_CAL3II,~] = audioread(strcat(cal,"MIC_DOC_CAL3II.wav"));
    [RR_DOC_CAL_II,~] = audioread(strcat(cal,"RR_DOC_CAL_II.wav")); % RUIDO ROSA CALIBRACION II (DOC)
    
end

function [FREC_FT_SMAART,MAG_FT_SMAART, H12, freq, H12I, H12II] = FT(metod, fs, nfft, MIC_1, MIC_2, MIC_3, RR_MUESTRA, MIC_CAL1I, MIC_CAL2I, MIC_CAL3I, RR_CAL_I, MIC_ISO_CAL1II, MIC_ISO_CAL3II, RR_ISO_CAL_II, MIC_DOC_CAL2II, MIC_DOC_CAL3II, RR_DOC_CAL_II)

    if metod == 1 % ISO
        f = 1;
        m = 2;
        S1 = MIC_1;
        S1I = MIC_CAL1I;
        S1II = MIC_ISO_CAL1II;
        S2II = MIC_ISO_CAL3II;
        RR = RR_ISO_CAL_II;
        
    elseif metod == 2 % DOC
        f = 6;
        m = 7;
        nfft = 2^10;
        S1 = MIC_2;
        S1I = MIC_CAL2I;
        S1II = MIC_DOC_CAL2II;
        S2II = MIC_DOC_CAL3II;
        RR = RR_DOC_CAL_II;
    end

    T = readtable("FT_SMAART");
    
    FREC_FT_SMAART = T{1:330, f}; 
    
    MAG_FT_SMAART = T{1:330, m}; 
    MAG_FT_SMAART = str2double(MAG_FT_SMAART);
    
    IR_MIC_1  = impzest(RR_MUESTRA,S1);
    IR_MIC_2  = impzest(RR_MUESTRA,MIC_3);
    IR_MIC_CAL1I  = impzest(RR_CAL_I,S1I);
    IR_MIC_CAL2I  = impzest(RR_CAL_I,MIC_CAL3I);
    IR_MIC_CAL1II = impzest(RR,S1II);
    IR_MIC_CAL2II = impzest(RR,S2II);
    
    [H1,freq]  = freqz(IR_MIC_1,1,nfft,fs);
    H2  = freqz(IR_MIC_2,1,nfft,fs);
    H12 = H2 ./ H1;
    
    H1I  = freqz(IR_MIC_CAL1I,1,nfft,fs);
    H2I  = freqz(IR_MIC_CAL2I,1,nfft,fs);
    H1II = freqz(IR_MIC_CAL1II,1,nfft,fs);
    H2II = freqz(IR_MIC_CAL2II,1,nfft,fs);
    
    H12I = H1I ./ H2I;
    H12II = H1II ./ H2II;
    
end

function [freqMin, freqMax, alpha, r] = COEF_ABS(H12I, H12II, H12, d, freq, c, S_ISO, S_DOC, x1_ISO, x1_DOC, metod)

    if metod == 1
        s = S_ISO;
        x1 = x1_ISO;
    elseif metod == 2
        s = S_DOC;
        x1 = x1_DOC;
    end
    
    freqMin =  round((0.05 * c/s),1);
    freqMax = round((0.5 * c / d),1);

    Hc = (H12I .* H12II).^0.5;
    
    H12_CAL = H12 ./ Hc;
    
    d_sq = 4*d^2;
    katen = 1.94*10^-2 * sqrt(freq) / (c*d_sq);
    
    k  = (2*pi*freq/c);
    k0 = k - 1j*katen;
    
    HI = exp(-1j*k0*s);
    HR = exp(1j*k0*s);

    r = (H12_CAL - HI) ./ (HR - H12_CAL) .* exp(2.*1j.*k0.*x1);
    alpha = 1 - abs(r).^2;
end

function GRAFICAR(typemat, mat, metod, freqMin, freqMax, opt, fs, freq, FREC_FT_SMAART, MAG_FT_SMAART, MIC_3, H12, alpha, r)
    
    tamT = 20;
    tamE = 10;
    tamL = 15;
    N = 2^14;
    
    if metod == 1
        tt = 'ISO';
        fl = freqMin;
        fu = 250;
        xticks_values = [freqMin, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600 freqMax];
        xticklabels_values = {freqMin, '31.5', '40', '50', '63', '80', '100', '125', '160', '200', '250','315','400','500','630','800','1k','1.25k','1.6k',freqMax};
    end
    
    if metod == 2
        tt = 'DOC';
        fl = freqMin;
        fu = freqMax;
        xticks_values = [freqMin, 400, 500, 630, 800, 1000, 1250, 1600 freqMax];
        xticklabels_values = {freqMin,'400','500','630','800','1k','1.25k','1.6k',freqMax};
    end
    
     etiquetas = {};

    if typemat == 1
        etiqueta_actual = ['PLA ', char(tt)];
    elseif typemat == 2
        etiqueta_actual = ['PETG ', char(tt)];
    elseif typemat == 3
        etiqueta_actual = ['ABS ', char(tt)];
    elseif typemat == 4
        etiqueta_actual = ['CONVENCIONAL ', char(tt)];
    elseif typemat == 5
        etiqueta_actual = ['PHONOFLOOR ', char(tt)];
    end

    etiquetas = [etiquetas, etiqueta_actual];

    if opt == 1
        t_MIC_3 = (0:1/fs:(length(MIC_3)-1)/fs)'; % Vector de tiempo
        
        FFT_MIC_3 = fft(MIC_3, N);
        FREC_MIC_3 = (0:length(FFT_MIC_3)-1) * fs / length(FFT_MIC_3);
        FREC_MIC_3 = FREC_MIC_3(1:N/2);
        fft_magnitude_db = mag2db(abs(FFT_MIC_3(1:N/2)));
        fft_magnitude_db_normalized = fft_magnitude_db - max(fft_magnitude_db);
        
        figure(1)
        subplot(2,1,1); % t
        plot(t_MIC_3,MIC_3)
        t = title('Respuesta en tiempo', 'FontName', 'Times New Roman');
        xlabel('Tiempo (Segundos)', 'FontName', 'Times New Roman');
        ylabel('Amplitud', 'FontName', 'Times New Roman');
        xlim([0 max(t_MIC_3)])
        t.FontSize = tamT;
        xlabelHandle = get(gca, 'XLabel');
        ylabelHandle = get(gca, 'YLabel');
        xlabelHandle.FontSize = tamT;
        ylabelHandle.FontSize = tamT;
        set(gca, 'FontSize', tamE);
        grid on
        subplot(2,1,2); % frec
        semilogx(FREC_MIC_3, fft_magnitude_db_normalized);
        t = title('Respuesta en frecuencia', 'FontName', 'Times New Roman');
        xlabel('Frecuencia (Hz)', 'FontName', 'Times New Roman');
        ylabel('Amplitud (dB)', 'FontName', 'Times New Roman');
        legend(tt, 'FontName', 'Times New Roman')
        xlim([fl fu])
        ylim([min(fft_magnitude_db_normalized) 6])
        t.FontSize = tamT;
        xlabelHandle = get(gca, 'XLabel');
        ylabelHandle = get(gca, 'YLabel');
        xlabelHandle.FontSize = tamT;
        ylabelHandle.FontSize = tamT;
        set(gca, 'FontSize', tamE);
        xticks(xticks_values);
        xticklabels(xticklabels_values);
        grid on
        close ([figure(2) figure(3) figure(4) figure(5)])
    end

    if opt == 2
        figure(2)
        semilogx(freq,mag2db(abs(H12)));
        xlabel('Frecuencia (Hz)', 'FontName', 'Times New Roman');
        ylabel('Magnitud (dB)', 'FontName', 'Times New Roman');
        xlim([fl max(FREC_FT_SMAART)]);
        ylim([-30 30]);
        t.FontSize = tamT;
        xlabelHandle = get(gca, 'XLabel');
        ylabelHandle = get(gca, 'YLabel');
        xlabelHandle.FontSize = tamT;
        ylabelHandle.FontSize = tamT;
        set(gca, 'FontSize', tamE);
        xticks(xticks_values);
        xticklabels(xticklabels_values);
        grid on

        hold on 
        semilogx(FREC_FT_SMAART,MAG_FT_SMAART)
        xlabel('Frecuencia (Hz)', 'FontName', 'Times New Roman');
        ylabel('Magnitud (dB)', 'FontName', 'Times New Roman');
        title('Comparacion de la funcion de transferencia (FT)', 'FontName', 'Times New Roman');
        xlim([fl max(FREC_FT_SMAART)]);
        ylim([-30 30]);
        t.FontSize = tamT;
        xlabelHandle = get(gca, 'XLabel');
        ylabelHandle = get(gca, 'YLabel');
        xlabelHandle.FontSize = tamT;
        ylabelHandle.FontSize = tamT;
        set(gca, 'FontSize', tamE);
        xticks(xticks_values);
        xticklabels(xticklabels_values);
        grid on
        legend(['FT Matlab ' tt], ['FT Smaart ' tt], 'FontName', 'Times New Roman');
        hold off
        close ([figure(1) figure(3) figure(4) figure(5)])
    end
    
    if opt == 3
        figure(3)
        hold on
        h = legend('-DynamicLegend');  
        etiquetas_actuales = h.String;
        semilogx(freq,abs(r))
        xlabel('Frecuencia (Hz)', 'FontName', 'Times New Roman');
        ylabel('Magnitud', 'FontName', 'Times New Roman');
        title('Coeficiente de reflexion (r)', 'FontName', 'Times New Roman');
        legend([etiquetas_actuales, etiquetas], 'Location', 'best', 'FontSize', tamL, 'FontName', 'Times New Roman');
        xlim([fl fu])
        ylim([0,1])
        t.FontSize = tamT;
        xlabelHandle = get(gca, 'XLabel');
        ylabelHandle = get(gca, 'YLabel');
        xlabelHandle.FontSize = tamT;
        ylabelHandle.FontSize = tamT;
        set(gca, 'FontSize', tamE);
        xticks(xticks_values);
        xticklabels(xticklabels_values);
        grid on
        hold off
        close ([figure(1) figure(2) figure(5)])
    end
    
    if opt == 4
        figure(5)
        hold on
        h = legend('-DynamicLegend');  
        etiquetas_actuales = h.String;
        semilogx(freq,alpha)
        xlabel('Frecuencia (Hz)', 'FontName', 'Times New Roman');
        ylabel('Magnitud', 'FontName', 'Times New Roman');
        title(['Coeficiente de absorcion (' char(945),')'], 'FontName', 'Times New Roman');
        legend([etiquetas_actuales, etiquetas], 'Location', 'best', 'FontSize', tamL, 'FontName', 'Times New Roman');
        xlim([fl fu])
        ylim([0,1])
        t.FontSize = tamT;
        xlabelHandle = get(gca, 'XLabel');
        ylabelHandle = get(gca, 'YLabel');
        xlabelHandle.FontSize = tamT;
        ylabelHandle.FontSize = tamT;
        set(gca, 'FontSize', tamE);
        xticks(xticks_values);
        xticklabels(xticklabels_values);
        grid on
        x_line = 50;
        y_limits = ylim;
        plot([x_line x_line], y_limits, 'r--', 'HandleVisibility', 'off');
        hold off
        close ([figure(1) figure(2) figure(3) figure(4)])
    end
    
    if opt == 6 || opt == 7
        close all
    end

end