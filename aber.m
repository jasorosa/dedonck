clear all; close all;

global FS;

FS = 4e6;

NSYM = 1e4;

BETA = 0.3;
FM = 1e6;
NTAPS = 20;

h = rrcosfilter(BETA, FM, NTAPS);

f = figure;

K = [0 1 2 5 10 30 -1];
bps = 1;
ebn0 = 0:.5:14;
bers = zeros(length(K),length(ebn0));
nbits = bps*NSYM;
sent = bitGenerator(nbits);
N = 1000;
for k=1:length(K)
    fprintf('K: %d/%d\n', k, length(K));
    sigma = 1.19297; % RANDOM
    V = Rice(N,K(k),sigma);
    bersTmp = zeros(length(V),length(ebn0));
    for i=1:length(V)
        for j = 1:length(ebn0)
            modulated = mapping(sent, bps, 'pam');

            upsampled = upsample(modulated,FS/FM);
            out = conv(h, upsampled); % len = len(h_rrc)+len(upsampledMes)-1

            if K(k) == -1
                E_b = trapz(abs(out).^2) / (FS*nbits*2);
                N_0 = E_b / 10^(ebn0(j)/10);

                NoisePower = 2*N_0*FS;
                signal = out + sqrt(NoisePower/2).* (randn(size(out)) + 1i*randn(size(out)));
            else
                E_b = trapz(abs(out).^2) / (FS*nbits*2) * mean(abs(V))^2;

                out = conv(out,V(i));

                N_0 = E_b / 10^(ebn0(j)/10);

                NoisePower = 2*N_0*FS;
                signal = out + sqrt(NoisePower/2).* (randn(size(out)) + 1i*randn(size(out)));
            end
            oversampled = conv(signal, h); % len = len(h_rrc)+len(upsampledMes)-1
            oversampled = oversampled(NTAPS*FS/FM+1:end-(NTAPS*FS/FM)); % to get the right length after convolution we discard the RRCtaps-1 first samples
            modulated = oversampled(1:FS/FM:end);

            received = demapping(modulated,bps,'pam'); % send message to demodulator function
            bersTmp(i,j) = sum(abs(received-sent))/nbits;
        end
    end
    avg = mean(bersTmp,1); %mean over all Rice elements to get 1 averaged BER curve
    bers(k,:) = avg;
    semilogy(ebn0,bers(k,:),'-o','DisplayName',sprintf('K = %d', K(k)), 'LineWidth',2);hold all;grid on; 
end
title('BER curves for different K');
xlabel('E_b/N_0[dB]');
ylabel('BER');
legend('-DynamicLegend');
set(findall(f,'-property','FontSize'),'FontSize',17);
set(findall(f,'-property','FontName'),'FontName', 'Helvetica');
