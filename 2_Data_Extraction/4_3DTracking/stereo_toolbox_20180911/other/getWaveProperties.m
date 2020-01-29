function [H ids] = getWaveProperties(data, doZeroMean, zmWidth)
%GETWAVEPROPERTIES  Calculate Hilbert-transformed of a time series and return
%derived wave properties
%
%   H = GETWAVEPROPERTIES(DATA) calculates the Hilbert-transformed of the time
%   series in DATA, which has to be an Nx2 matrix with times in the first column
%   and the data to be evaluated in the second. H then is an Nx7 matrix of the
%   form H = [t I Î A Phi(-pi pi) Phi(0 Phi_max) f deconv_offset]
%
%   H = GETWAVEPROPERTIES(DATA, DOZEROMEAN, ZMWIDTH) calculates the zero-mean of
%   the time series before transforming. Use this function call whenever the
%   input data is NOT zero-mean - otherwise, the transformation will return
%   senseless results. ZMWIDTH is half the width of the moving average filter,
%   i.e., filtering is done over 2*ZMWIDTH values. ZMWIDTH should this be chosen
%   to cover half a typical wavelength to perform averaging over a full
%   wavelength.
%
%   [H IDS] = GETWAVEPROPERTIES(...) returns the surviving (after applying the
%   moving average) indices of the original time series in IDS.

%                                                            created: 11.03.2011
% ------------------------------------------------------------------------------


    % (1) check input parameters, set defaults if necessary
    
    % check for correct column count in DATA
    assert(size(data,2) == 2, 'Wrong format of DATA: has to be Nx2 !');
    % DEFAULT: do not create zero-mean of time series
    if ~exist('doZeroMean','var'), doZeroMean = 0; end;
    % DEFAULT: width of moving average filter is 11 frames
    if ~exist('zmWidth','var'), zmWidth = 11; end;

    
    % (2) create zero-mean of time series, if requested

    ids = 1:size(data,1);
    if exist('doZeroMean','var') && (doZeroMean == 1)
        % moving average filter
        av = movave(data(:,2), zmWidth);
        % correct data for moving average
        data(:,2) = data(:,2)-av;
        % remove NaN values from dataset and index array
        data(isnan(av),:) = [];
        ids(isnan(av)) = [];
    end;
    
    
    % (3) create Hilbert transformed and derived properties
    
    % create results array
    H = zeros(size(data,1), 7);
    
    % transform time series

    ht = hilbert(data(:,2));

    
    % fill results array
    H = [data(:,1) ...                      1 - timing information
        real(ht) ...                        2 - original signal
        imag(ht) ...                        3 - Hilbert transformed
        sqrt(real(ht).^2+imag(ht).^2) ...   4 - inst. amplitude
        atan2(imag(ht), real(ht)) ...       5 - inst. phase (-pi pi)
        atan2(imag(ht), real(ht)) ...       6 - inst. phase (0 Phi_max)
        zeros(length(ht),1) ...             7 - inst. frequency
        zeros(length(ht),1) ...             8 - deconv. information for phase (offset)
        ];
    
    % unwrap inst. phase at positions with jumps larger than pi
    for l = 2:length(H(:,6))
        if (H(l-1,6) - H(l,6) > pi)
            H(l:end,6) = H(l:end,6) + (2*pi);
            H(l:end,8) = H(l:end,8) + (2*pi);
        end;
    end;
    
    % get inst. frequency
    H(1:end-1,7) = 1/(2*pi) * diff(sgolayfilt(H(:,6),2,5))./diff(H(:,1));
    %H(1:end-1,7) = 1/(2*pi) * diff(H(:,6))./diff(H(:,1));
    