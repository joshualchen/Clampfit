function output = calculate_All_Depths(mV, N, tT, dT, tB, dB, DNA)
    % The structure of GURU device here is N SiNx pores on the bottom, 1
    % MoS2 pore on the top

    % I_Total: total open pore current
    % I_Tblocked: current when only top pore is blocked
    % I_Bblocked: current when only *one* bottom pore is blocked
    % I_TBblocked: current when both top and one bottom pore is blocked
    % I_T2blocked: current when top is blocked by folded
    % I_B2blocked: current when one bottom pore is blocked by folded
    % I_T2Bblocked: current when top is blocked by folded and bottom is blocked by unfolded
    % I_TB2blocked: ""
    % I_T2B2blocked: ""
    
    % Defining constants:
    sigma = 12;  % units in S/m
    if DNA == "ss"
        dDNA = 1.1;  % units in nm
    elseif DNA == "ds"
        dDNA = 2.3;  % units in nm
    else
        error('Please enter "ss" for single-stranded DNA or "ds" for double-stranded DNA.');
    end
    
    function I = calc_I(G_T, G_Bi, G_Bj, N, mV)  % G_Bj refers to the conductance of the other pores
        if G_T < 0  % checking if the DNA is too large, if it is, we call it "fully blocked," i.e. G is 0
            G_T = 0;
        end
        if G_Bi < 0
            G_Bi = 0;
        end
        if G_Bj < 0  % G_Bj should never be less than 0 since DNA never enters, but just adding in case code changes
            G_Bj = 0;
        end
        G = (1/G_T + 1/(G_Bi + (N-1) * G_Bj))^-1;  % calculate the resulting conductance via top and bottom layer conductances
        I = mV * G / 1000;  % Calculate the current from the total conductance
    end
    
    G_T = sigma * (4*tT/(pi*dT^2) + 1/dT)^-1;  % conductance of top pore, units in nS
    G_Bi = sigma * (4*tB/(pi*dB^2) + 1/dB)^-1;  % conductance of *one* bottom pore, units in nS
    
    I_Total = calc_I(G_T, G_Bi, G_Bi, N, mV);  % total current, units in nA
    
    G_Tblocked = (1-(dDNA/dT)^2) * G_T;  % total conductance of top pore when blocked
    G_Biblocked = (1-(dDNA/dB)^2) * G_Bi;  % total conductance of one bottom pore when blocked
    
    I_Tblocked = calc_I(G_Tblocked, G_Bi, G_Bi, N, mV);  % total current when top pore blocked unfolded
    I_Bblocked = calc_I(G_T, G_Biblocked, G_Bi, N, mV);  % total current when one bottom pore blocked unfolded
    I_TBblocked = calc_I(G_Tblocked, G_Biblocked, G_Bi, N, mV);  % total current when top and one bottom pore blocked unfolded
    
    G_T2blocked = (1-2*(dDNA/dT)^2) * G_T;  % setting up for folded DNA blockage
    G_Bi2blocked = (1-2*(dDNA/dB)^2) * G_Bi;
    
    I_T2blocked = calc_I(G_T2blocked, G_Bi, G_Bi, N, mV);  % all of the below are combinations of folded DNA blockage
    I_B2blocked = calc_I(G_T, G_Bi2blocked, G_Bi, N, mV);
    I_T2Bblocked = calc_I(G_T2blocked, G_Biblocked, G_Bi, N, mV);
    I_TB2blocked = calc_I(G_Tblocked, G_Bi2blocked, G_Bi, N, mV);
    I_T2B2blocked = calc_I(G_T2blocked, G_Bi2blocked, G_Bi, N, mV);
    
    output = [I_Total, I_Tblocked, I_Bblocked, I_TBblocked, I_T2blocked, I_B2blocked, I_T2Bblocked, I_TB2blocked, I_T2B2blocked];
end


% [I_Total, I_Tblocked, I_Bblocked, I_TBblocked, I_T2blocked, I_B2blocked, I_T2Bblocked, I_TB2blocked, I_T2B2blocked] = calculate_All_Depths(200, 1, 0.6, 6.5, 20, 15, "ds");
% yline(I_Total, 'k', 'DisplayName', "I_Total", "LineWidth", 1.5);
% hold on;
% yline(I_Tblocked, 'b', 'DisplayName', "I_Tblocked", "LineWidth", 1.5);
% yline(I_Bblocked, 'g', 'DisplayName', "I_Bblocked", "LineWidth", 1.5);
% yline(I_TBblocked, 'r', 'DisplayName', "I_TBblocked", "LineWidth", 1.5);
% yline(I_T2blocked, 'm', 'DisplayName', "I_T2blocked", "LineWidth", 1.5);
% yline(I_B2blocked, 'y', 'DisplayName', "I_B2blocked", "LineWidth", 1.5);
% yline(I_T2Bblocked, 'k', 'DisplayName', "I_T2Bblocked", "LineWidth", 1.5);
% yline(I_TB2blocked, 'b', 'DisplayName', "I_TB2blocked", "LineWidth", 1.5);
% yline(I_T2B2blocked, 'g', 'DisplayName', "I_T2B2blocked", "LineWidth", 1.5);
% legend();