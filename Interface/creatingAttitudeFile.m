%%% CREATING ATTITUDE FILE
fid = fopen('scriptedAttitude.a', 'wt');

% Variables needed for this one
start = '27 Jun 2021 00:00:00.000000000';

%%% PRELIMINARY INFORMATION
% See sample .a file on AGI help site for formatting this stuff
fprintf(fid, 'stk.v.12.2\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints %f\n', L); % L is number of data points
fprintf(fid, 'ScenarioEpoch %s\n', start); % start is starting time
fprintf(fid, 'BlockingFactor 20\n');
fprintf(fid, 'InterpolationOrder 1\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoorinateAxes J2000\n');
fprintf(fid, 'AttitudeTimeQuaternions\n');


for i = 1:L
    q_i = q(i, 1:4);
    fprintf( fid, '%f %f %f %f %f\n', 30*t(i), q_i(1), q_i(2), q_i(3), q_i(4));
end

fprintf(fid, 'END Attitude\n');

fclose(fid);