clear all; close all;

global FS;

FS = 10e6;

NSYM = 1e2;

BETA = 0.3;
FM = 1e6;
NTAPS = 20;

h = rrcosfilter(BETA, FM, NTAPS);

f = figure;

K = 0:10;
bps = 2;
ebn0 = -10:2.5:25;
bers = zeros(length(K),length(ebn0));
nbits = bps*NSYM;
sent = bitGenerator(nbits);
N = length(awgn(conv(h, upsample(mapping(sent, bps, 'qam'),FS/FM)), 0, ebn0(1),nbits));
for k=1:length(K)
    fprintf('K: %d/%d\n', k, length(K));
    sigma = 1.19297; % RANDOM
    V = Rice(N,K(k),sigma);
    bersTmp = zeros(length(V),length(ebn0));
    for i=1:length(V)
        for j = 1:length(ebn0)
            modulated = mapping(sent, bps, 'qam');

            upsampled = upsample(modulated,FS/FM);
            out = conv(h, upsampled); % len = len(h_rrc)+len(upsampledMes)-1

            signal = awgn(out, V, ebn0(j), nbits);

            signal = conv(signal,V(i));

            oversampled = conv(signal, h); % len = len(h_rrc)+len(upsampledMes)-1
            oversampled = oversampled(NTAPS*FS/FM+1:end-(NTAPS*FS/FM)); % to get the right length after convolution we discard the RRCtaps-1 first samples
            modulated = oversampled(1:FS/FM:end);

            modulated = modulated/sqrt(sum(abs(modulated).^2)/NSYM);
            received = demapping(modulated,bps,'qam'); % send message to demodulator function
            bersTmp(i,j) = sum(abs(received-sent))/nbits;
        end
    end
    avg = mean(bersTmp,1); %mean over all Rice elements to get 1 averaged BER curve
    bers(k,:) = avg(:);
    semilogy(ebn0,bers(k,:),'-o','DisplayName',sprintf('K = %d', K(k)), 'LineWidth',2);hold all;grid on; 
end
title('BER curves for different K');
xlabel('E_b/N_0[dB]');
ylabel('BER');
legend('-DynamicLegend');
set(findall(f,'-property','FontSize'),'FontSize',17);
set(findall(f,'-property','FontName'),'FontName', 'Helvetica');
