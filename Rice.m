function V = Rice(N,K,sigma)
    S=sqrt(K*2*sigma^2);
    a = (randn(N,1)*sigma) + S;
    b = (randn(N,1)*sigma);
    V = abs(a+1j*b);
end