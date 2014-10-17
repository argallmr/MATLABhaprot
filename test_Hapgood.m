%--------------------------------------------------------------------------
% NAME
%   test_Hapgood
%
% PURPOSE
%   Test the Hapgood Rotations
%
% Calling Sequence:
%   test_Hapgood
%       Display the results of transforming vectors from GSE to other
%       geocentric coordinate systems using the Hapgood rotations. Results
%       are obtained by comparing Hapgood results with results obtained by
%       NASA GSFC.
%
% References:
%   CXFORM
%       http://nssdcftp.gsfc.nasa.gov/selected_software/coordinate_transform/
%   Test results from CXFORM
%       http://nssdcftp.gsfc.nasa.gov/selected_software/coordinate_transform/test_results/ACE_2000_results.pdf
%   NASA Spacecraft locator for generating test vectors.
%       http://sscweb.gsfc.nasa.gov/cgi-bin/Locator.cgi
%
%--------------------------------------------------------------------------
function [] = test_Hapgood()
    % Files with test vectors and IGRF coefficients
    root      = '/Users/argall/Documents/MATLAB/HapgoodRotations/';
    test_file = fullfile(root, 'test_vectors.dat');
    igrf_file = fullfile(root, 'igrf_coeffs.txt');

    % Read data from file
    [time, gei, geo, mag, gse, gsm, sm] = test_read_vectors(test_file);
    
    % Start with a single vector
    t1   = time(1,:)';
    gei1 = gei(1,:)';
    geo1 = geo(1,:)';
    mag1 = mag(1,:)';
    gse1 = gse(1,:)';
    gsm1 = gsm(1,:)';
    sm1  = sm(1,:)';
    
%-------------------------------------
% Get Required Parameters            |
%-------------------------------------
    
    % Get Modified Julian Date and UT
    %   - Number of days since 17 Nov 1858
    mjd = date2julday(t1, 'MJD', true);
    ut  = mod(mjd, 1) * 24.0;
    mjd = floor(mjd);
    
    % Read IGRF coefficients.
    %   - Get year of data.
    %   - Read coefficients.
    %   - Get indices of desired coefficients.
    [year, ~, ~]        = datevec(time(1));
    [coef, ~, n, m, gh] = read_igrf_coeffs(igrf_file, round(year/5.0)*5.0);
    ig10 = find(n == 1 & m == 0 & strcmp(gh, 'g'), 1, 'first');
    ig11 = find(n == 1 & m == 1 & strcmp(gh, 'g'), 1, 'first');
    ih11 = find(n == 1 & m == 1 & strcmp(gh, 'h'), 1, 'first');
    
    % Get the coefficients
    g10 = double(coef(ig10));
    g11 = double(coef(ig11));
    h11 = double(coef(ih11));

%-------------------------------------
% Create Transformations             |
%-------------------------------------
    
    % Create transformation matrices.
    T1 = gei2geo(mjd, ut);
    T2 = gei2gse(mjd, ut);
    T3 = gse2gsm(g10, g11, h11, mjd, ut);
    T4 = gsm2sm (g10, g11, h11, mjd, ut);
    T5 = geo2mag(g10, g11, h11);
    
%-------------------------------------
% Transform from GSE to *            |
%-------------------------------------
    gei_hap =           T2' * gse1;
    geo_hap =      T1 * T2' * gse1;
    gsm_hap =           T3' * gse1;
    sm_hap  =      T4 * T3  * gse1;
    mag_hap = T5 * T1 * T2' * gse1;
    
%-------------------------------------
% Absolute difference                |
%-------------------------------------
    diff_gei = abs(gei_hap - gei1);
    diff_geo = abs(geo_hap - geo1);
    diff_gsm = abs(gsm_hap - gsm1);
    diff_sm  = abs(sm_hap  - sm1);
    diff_mag = abs(mag_hap - mag1);
    
%-------------------------------------
% Percent difference                 |
%-------------------------------------
    perc_gei = abs(100.0 - gei1 ./ gei_hap * 100.0);
    perc_geo = abs(100.0 - geo1 ./ geo_hap * 100.0);
    perc_gsm = abs(100.0 - gsm1 ./ gsm_hap * 100.0);
    perc_sm  = abs(100.0 - sm1  ./ sm_hap  * 100.0);
    perc_mag = abs(100.0 - mag1 ./ mag_hap * 100.0);
    
%-------------------------------------
% Output Answers                     |
%-------------------------------------
    fprintf('Cluster 1 - Year 2004     X          Y          Z         AVG\n');
    fprintf('\n');
    fprintf('GSE to GEI\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_gei);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_gei);
    fprintf('\n');
    fprintf('GSE to GEO\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_geo);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_geo);
    fprintf('\n');
    fprintf('GSE to GSM\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_gsm);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_gsm);
    fprintf('\n');
    fprintf('GSE to SM\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_sm);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_sm);
    fprintf('\n');
    fprintf('GSE to MAG\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_mag);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_mag);
end