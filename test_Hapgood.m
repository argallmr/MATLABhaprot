%--------------------------------------------------------------------------
% NAME
%   test_Hapgood
%
% PURPOSE
%   Read data produced by
%       http://sscweb.gsfc.nasa.gov/cgi-bin/Locator.cgi
%
% Calling Sequence:
%   gei = read_SPDF_Locator_Form(filename);
%       Reads satellite position data from FILENAME and returns the
%       position in GEI coordinates.
%
%   [gei, geo, gm, gse, gsm, sm] = read_SPDF_Locator_Form(filename);
%       Returns position in GEO, GM, GSE, GSM, and SM coordinates.
%
%--------------------------------------------------------------------------
function [] = test_Hapgood()
    filename = '/Users/argall/Documents/MATLAB/HapgoodRotations/test_vectors.dat';

    % Read data from file
    [time, gei, geo, gm, gse, gsm, sm] = test_read_vectors(filename);
    
    % Start with a single vector
    t1   = time(1,:)';
    gei1 = gei(1,:)';
    geo1 = geo(1,:)';
    gm1  = gm(1,:)';
    gse1 = gse(1,:)';
    gsm1 = gsm(1,:)';
    sm1  = sm(1,:)';
    
    
%-------------------------------------
% Transformations                    |
%-------------------------------------
    
    % Get Modified Julian Date and UT
    %   - Number of days since 17 Nov 1858
    mjd = date2julday(t1, 'MJD', true);
    ut  = mod(mjd, 1) * 24.0;
    mjd = floor(mjd);
    
    % Create transformation matrices.
    T1 = gei2geo(mjd, ut);
    T2 = gei2gse(mjd, ut);
%     T3 = gse2gsm();
%     T4 = gsm2sm();
%     T5 = geo2mag();
    
    
%-------------------------------------
% Transform from GSE to *            |
%-------------------------------------
    gei_hap =      T2' * gse1;
    geo_hap = T1 * T2' * gse1;
    
%-------------------------------------
% Absolute difference                |
%-------------------------------------
    diff_gei = abs(gei_hap - gei1);
    diff_geo = abs(geo_hap - geo1);
    
%-------------------------------------
% Percent difference                 |
%-------------------------------------
    perc_gei = abs(100.0 - gei1 ./ gei_hap * 100.0);
    perc_geo = abs(100.0 - geo1 ./ geo_hap * 100.0);
    
    
%-------------------------------------
% Output Answers                     |
%-------------------------------------
    fprintf('Cluster 1 - Year 2004     X          Y          Z         AVG\n');
    fprintf('\n');
    fprintf('GSE to GSI\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_gei);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_gei);
    fprintf('\n');
    fprintf('GSE to GEO\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_geo);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_geo);
end