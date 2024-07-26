% INSTRUCCIONES DE USO
% - Oprima el boton Run ubicado en la parte superior
% - Una vez seleccione el boton de Run, se le desplegara una ventana con diferentes opciones 
% en ella encontrara:
% 1) ISO - Metamateriales (La correlación de los metamateriales de acuerdo a la metodología ISO)
% 2) DOC - Metamateriales (La correlación de los metamateriales de acuerdo a la metodología del documento base)
% 3) DOC - Metamateriales en 50 HZ (La correlación de los metamateriales de acuerdo a la metodología del documento en frecuencias cercanas a 50 Hz)
% 4) ISO - Todas las muestras (La correlación de todos los materiales de acuerdo a la metodología ISO)
% 5) DOC - Todas las muestras (La correlación de todos los materiales de acuerdo a la metodología del documento base)

val_t = false;
    while ~val_t
        t = input("Ingrese una opcion\n 1) ISO - Metamateriales\n 2) DOC - Metamateriales\n 3) DOC - Metamateriales en 50 Hz\n 4) ISO - Todas las muestras\n 5) DOC - Todas las muestras\n");
        if any(t == [1, 2, 3, 4, 5])
            val_t = true;
        else
            disp('Opcion no valida, intente de nuevo');
        end
    end

if t == 1 % 1) ISO - META
    PLA = [0.90, 0.85, 0.89, 0.72, 0.45, 0.05, 0.81, 0.39, 0.18, 0.07];
    PETG = [0.91, 0.87, 0.83, 0.71, 0.46, 0.00, 0.64, 0.30, 0.21, 0.00];
    ABS = [0.94, 0.88, 0.87, 0.75, 0.42, 0.44, 0.66, 0.28, 0.25, 0.11];
    
    [corr_PETG, lags_PETG] = xcorr(PLA, PETG,'coeff');

    [corr_ABS, lags_ABS] = xcorr(PLA, ABS,'coeff');

    figure;
    plot(lags_PETG, corr_PETG);
    hold on
    plot(lags_ABS, corr_ABS);
    xlabel('Desfase', 'FontSize', 26, 'FontName', 'Times New Roman');
    ylabel('Correlación Cruzada', 'FontSize', 26, 'FontName', 'Times New Roman');
    title('Correlación Cruzada (ISO - Metamateriales)', 'FontSize', 30, 'FontName', 'Times New Roman');
    legend("PLA - PETG","PLA - ABS", 'FontSize', 16, 'FontName', 'Times New Roman');
    grid on;
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
end

if t == 2 % 2) DOC - META
    PLA = [0.61, 0.83, 0.00, 0.00, 0.64, 0.32, 0.41];
    PETG = [0.60, 0.82, 0.00, 0.57, 0.77, 0.00, 0.00];
    ABS = [0.60, 0.79, 0.00, 0.00, 0.68, 0.31, 0.00];
    
    [corr_PETG, lags_PETG] = xcorr(PLA, PETG,'coeff');

    [corr_ABS, lags_ABS] = xcorr(PLA, ABS,'coeff');

    figure;
    plot(lags_PETG, corr_PETG);
    hold on
    plot(lags_ABS, corr_ABS);
    xlabel('Desfase', 'FontSize', 26, 'FontName', 'Times New Roman');
    ylabel('Correlación Cruzada', 'FontSize', 26, 'FontName', 'Times New Roman');
    title('Correlación Cruzada (DOC - Metamateriales)', 'FontSize', 30, 'FontName', 'Times New Roman');
    legend("PLA - PETG","PLA - ABS", 'FontSize', 16, 'FontName', 'Times New Roman');
    grid on;
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    
end

if t == 3 % 3) DOC - 50Hz
    PLA = [0.00, 0.55, 0.48, 0.00];
    PETG = [0.00, 0.54, 0.46, 0.00];
    ABS = [0.00, 0.54, 0.46, 0.00];
    
    [corr_PETG, lags_PETG] = xcorr(PLA, PETG,'coeff');

    [corr_ABS, lags_ABS] = xcorr(PLA, ABS,'coeff');

    figure;
    plot(lags_PETG, corr_PETG);
    hold on
    plot(lags_ABS, corr_ABS);
    xlabel('Desfase', 'FontSize', 26, 'FontName', 'Times New Roman');
    ylabel('Correlación Cruzada', 'FontSize', 26, 'FontName', 'Times New Roman');
    title('Correlación Cruzada (DOC - Metamateriales en 50 Hz)', 'FontSize', 30, 'FontName', 'Times New Roman');
    legend("PLA - PETG","PLA - ABS", 'FontSize', 16, 'FontName', 'Times New Roman');
    grid on;
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
end

if t == 4 % 4) ISO - TODAS
    PLA = [0.90, 0.85, 0.89, 0.72, 0.45, 0.05, 0.81, 0.39, 0.18, 0.07];
    PETG = [0.91, 0.87, 0.83, 0.71, 0.46, 0.00, 0.64, 0.30, 0.21, 0.00];
    ABS = [0.94, 0.88, 0.87, 0.75, 0.42, 0.44, 0.66, 0.28, 0.25, 0.11];
    CONV = [0.86, 0.65, 0.80, 0.82, 0.84, 0.30, 0.60, 0.26, 0.19, 0.60];
    PHONO = [0.92, 0.84, 0.84, 0.73, 0.43, 0.05, 0.62, 0.29, 0.25, 0.13];
    
    [corr_PETG, lags_PETG] = xcorr(PLA, PETG,'coeff');

    [corr_ABS, lags_ABS] = xcorr(PLA, ABS,'coeff');
    
    [corr_CONV, lags_CONV] = xcorr(PLA, CONV,'coeff');

    [corr_PHONO, lags_PHONO] = xcorr(PLA, PHONO,'coeff');

    figure;
    plot(lags_PETG, corr_PETG);
    hold on
    plot(lags_ABS, corr_ABS);
    hold on
    plot(lags_CONV, corr_CONV);
    hold on
    plot(lags_PHONO, corr_PHONO);
    xlabel('Desfase', 'FontSize', 26, 'FontName', 'Times New Roman');
    ylabel('Correlación Cruzada', 'FontSize', 26, 'FontName', 'Times New Roman');
    title('Correlación Cruzada (ISO - Todas las muestras)', 'FontSize', 30, 'FontName', 'Times New Roman');
    legend("PLA - PETG","PLA - ABS","PLA - CONV","PLA - PHONO", 'FontSize', 16, 'FontName', 'Times New Roman');
    grid on;
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
end

if t == 5 % 5) DOC - TODAS
    PLA = [0.61, 0.83, 0.00, 0.00, 0.64, 0.32, 0.41];
    PETG = [0.60, 0.82, 0.00, 0.57, 0.77, 0.00, 0.00];
    ABS = [0.60, 0.79, 0.00, 0.00, 0.68, 0.31, 0.00];
    CONV = [0.60, 0.81, 0.00, 0.00, 0.51, 0.29, 0.21];
    PHONO = [0.59, 0.77, 0.00, 0.67, 0.84, 0.67, 0.00];
    
    [corr_PETG, lags_PETG] = xcorr(PLA, PETG,'coeff');

    [corr_ABS, lags_ABS] = xcorr(PLA, ABS,'coeff');
    
    [corr_CONV, lags_CONV] = xcorr(PLA, CONV,'coeff');

    [corr_PHONO, lags_PHONO] = xcorr(PLA, PHONO,'coeff');

    figure;
    plot(lags_PETG, corr_PETG);
    hold on
    plot(lags_ABS, corr_ABS);
    hold on
    plot(lags_CONV, corr_CONV);
    hold on
    plot(lags_PHONO, corr_PHONO);
    xlabel('Desfase', 'FontSize', 26, 'FontName', 'Times New Roman');
    ylabel('Correlación Cruzada', 'FontSize', 26, 'FontName', 'Times New Roman');
    title('Correlación Cruzada (DOC - Todas las muestras)', 'FontSize', 30, 'FontName', 'Times New Roman');
    legend("PLA - PETG","PLA - ABS","PLA - CONV","PLA - PHONO", 'FontSize', 16, 'FontName', 'Times New Roman');
    grid on;    
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
end