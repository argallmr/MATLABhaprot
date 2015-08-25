%--------------------------------------------------------------------------
% NAME
%   test_coordinate_transformations
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
	
	use_rbsp = true;
	
	% Load data
	if use_rbsp
		% Load the mat file
		filename = '/home/argall/MATLAB/HapgoodRotations/rbsp-a_magnetometer_hires_emfisis-L3_20140814.mat';
		load(filename);
		
		% Pick a single vector
		t1_datvec = spdfbreakdowntt2000( t_gei(1) );
		t1_datnum = datenum( t1_datvec(1:3) );
		t1_utc    = MrCDF_epoch2ssm( t_gei(1) ) / 3600.0;
		gei1 = b_gei(:,1);
		geo1 = b_geo(:,1);
		gm1  = zeros(3,1);
		gse1 = b_gse(:,1);
		gsm1 = b_gsm(:,1);
		sm1  = b_sm(:,1);
	else
		% Read the text file
		filename = '/home/argall/MATLAB/HapgoodRotations/test_vectors.dat';
		[time, gei, geo, gm, gse, gsm, sm] = test_read_vectors(filename);

		% Start with a single vector
		t1   = time(1,:)';
		gei1 = gei(1,:)';
		geo1 = geo(1,:)';
		gm1  = gm(1,:)';
		gse1 = gse(1,:)';
		gsm1 = gsm(1,:)';
		sm1  = sm(1,:)';
	end


%-------------------------------------
% Transformations                    |
%-------------------------------------

	% Get Modified Julian Date and UT
	%   - Number of days since 17 Nov 1858
	mjd = date2julday(t1_datnum, 'MJD', true);
%	ut  = mod(mjd, 1) * 24.0;
%	mjd = floor(mjd);

	% Create transformation matrices.
	T1 = gei2geo(mjd, t1_utc);
	T2 = gei2gse(mjd, t1_utc);
%	T3 = gse2gsm();
%	T4 = gsm2sm();
%	T5 = geo2mag();


%-------------------------------------
% Transform from GEI to *            |
%-------------------------------------
	geo_hap =           T1 * gse1;
	gse_hap =           T2 * gei1;
%   gsm_hap =      T3 * T2 * gei1;
%   sm_hap  = T4 * T3 * T2 * gei1;

%-------------------------------------
% Absolute difference                |
%-------------------------------------
	diff_geo = abs(geo_hap - geo1);
	diff_gse = abs(gse_hap - gse1);
%	diff_gsm = abs(gsm_hap - gsm1);
%	diff_sm  = abs(sm_hap  - sm1);

%-------------------------------------
% Percent difference                 |
%-------------------------------------
	perc_geo = abs(100.0 - geo1 ./ geo_hap * 100.0);
	perc_gse = abs(100.0 - gse1 ./ gse_hap * 100.0);
%	perc_gsm = abs(100.0 - gsm1 ./ gsm_hap * 100.0);
%	perc_sm  = abs(100.0 - sm1  ./ sm_hap  * 100.0);


%-------------------------------------
% Output Answers                     |
%-------------------------------------
	fprintf('Cluster 1 - Year 2004     X          Y          Z         AVG\n');
	fprintf('\n');
	fprintf('GEI to GEO\n');
	fprintf('  Absolute Difference: %0.4f %0.4f %0.4f\n', diff_geo);
	fprintf('  Percent Difference:  %0.4f %0.4f %0.4f\n', perc_geo);
	fprintf('\n');
	fprintf('GEI to GSE\n');
	fprintf('  Absolute Difference: %0.4f %0.4f %0.4f\n', diff_gse);
	fprintf('  Percent Difference:  %0.4f %0.4f %0.4f\n', perc_gse);
end