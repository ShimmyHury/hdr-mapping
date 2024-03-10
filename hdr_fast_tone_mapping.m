function [Iout] = hdr_fast_tone_mapping(hdrImg,alpha,beta,gamma,nbins)

Dmax = 1; Dmin = 0;
Lin =  0.299*hdrImg(:,:,1)+0.587*hdrImg(:,:,2)+0.114*hdrImg(:,:,3);
Imax = max(Lin(:));
Imin = min(Lin(:));
tau = alpha*(Imax - Imin);
DI = (Dmax-Dmin).*((log10(Lin+tau)-log10(Imin+tau))./(log10(Imax+tau)-log10(Imin+tau))) + Dmin;

N=nbins;
B=sort(DI(:));
ii = 1:(length(B)/N):length(B);
e = B(round(ii))';
l = linspace(Dmin,Dmax,N+1);l=l(2:end);
le = l + beta.*(e-l);
le=unique(le);

Lout = DI;
val  = linspace((Dmax-Dmin)/length(le),Dmax-Dmin,length(le)+1)';
Lout = imquantize(Lout,le,val');

Rout = ((hdrImg(:,:,1)./Lin).^gamma).*Lout;
Gout = ((hdrImg(:,:,2)./Lin).^gamma).*Lout;
Bout = ((hdrImg(:,:,3)./Lin).^gamma).*Lout;
Iout = cat(3, Rout, Gout, Bout);
end

