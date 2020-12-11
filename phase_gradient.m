function Gmag3 = phase_gradient(A)
% find phase map gradient magnitude Gmag
[Gmag, Gdir] = imgradient(A,'prewitt');
% apply +pi/2 phase shift to the phasemap A, so the edge of circular color wheel changes to a different position 
A2 = A+pi/2;
A2(A2(:)>=pi) = A2(A2(:)>=pi)-2*pi;
[Gmag2, Gdir2] = imgradient(A2,'prewitt');
%%
% discount the large phase change due to the edge of the color wheel by
% taking the miminum of Gmag and Gmag2.
Gmag3 = min(Gmag,Gmag2);
% figure;
% imagesc(Gmag3)
% colorbar
[a,b] = find(Gmag3(:)>=1);
[inda,indb] = ind2sub(size(Gmag3),a);
end
