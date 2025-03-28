%%
%FRoC : Find Relationship of centers
FRoC.LiverCenterMassall = [125.2672 185.8650 127.3692 ; 168.3582 177.6981 119.2505...
    ;136.2125 150.4844 102.1210 ; 140.1025 144.7304 120.8133];

FRoC.ImageCenterMassfinal = [192.0404 201.9642 119.3792; 205.2351 212.0259 116.2913 ;...
    177.2258 172.3384 109.9103; 176.4365 161.1938 111.9205];

FRoC.DiffCenter =  [66.7731 12.0993 -7.9900; 40.8769 33.3278 -2.9592 ; ...
    37.0133 22.8540 7.7893; 33.3341 20.4634 -8.8928 ] ;


FRoC.meanDiff = mean( FRoC.DiffCenter );
FroC.std = std(FRoC.DiffCenter)


