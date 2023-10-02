function Q = calc_flow_rate(dt, c_l)
    % this version of the function IS MODIFIED to give kg/min rather than
    % mlps
    
    %now calculate flow rate
    phi = 38*pi/180; %wedge angle
    c_w = 2470; %speed of sound in wedge
    D = 13.7*10^-3; %interior diameter of pipe
    
    Area = pi*(D/2)^2; %x-sec area of pipe
    
    FPCF = 1; %flow profile correction factor
    
    theta = asin( sin(phi)*c_l/c_w ); %refraction angle into water
    alpha_liq = pi/2-theta; %angle between flow and ray
    L = 2*D/cos(theta); %path length in water for 1V
    
    Q = Area*c_l^2*dt/( 2*L*cos(alpha_liq))*1E6*FPCF;
    
    %Q = Q*60/1000; %per min rather than per sec, L rather than ml
end