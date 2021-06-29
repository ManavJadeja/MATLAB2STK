%%% PRELIMINARY STUFF
% clear; clc


%%% LAUNCHING STK
%Create an instance of STK
uiApplication = actxserver('STK12.application');
uiApplication.Visible = 1;

%Get our IAgStkObjectRoot interface
root = uiApplication.Personality2;


%%% SCENARIO SETTINGS
% Create a new scenario 
scenario = root.Children.New('eScenario','matlabScript');

% Scenario time properties
scenario.SetTimePeriod('27 Jun 2021 00:00:00.000','28 Jun 2021 00:00:00.000')
scenario.StartTime = '27 Jun 2021 00:00:00.000';
scenario.StopTime = '28 Jun 2021 00:00:00.000';


%%% FACILITY PROPERTIES
% Add facility object
facility = root.CurrentScenario.Children.New('eFacility', 'RU_GS');

% Modify facility properties
% Rutgers Ground Station Coordinates
lat = 40.5215;          % Latitude (deg)
lon = -74.4618;         % Longitude (deg)
alt = 0;                % Altitude (km)

facility.Position.AssignGeodetic(lat, lon, alt) % Latitude, Longitude, Altitude
facility.HeightAboveGround = 0.05;   % km


%%% SATELLITE PROPERTIES
% Add satellite object
satellite = root.CurrentScenario.Children.New('eSatellite', 'SPICESat');

% Modify satellite properties
keplerian = satellite.Propagator.InitialState.Representation.ConvertTo('eOrbitStateClassical'); % Use the Classical Element interface
keplerian.SizeShapeType = 'eSizeShapeAltitude';  % Changes from Ecc/Inc to Perigee/Apogee Altitude
keplerian.LocationType = 'eLocationTrueAnomaly'; % Makes sure True Anomaly is being used
keplerian.Orientation.AscNodeType = 'eAscNodeLAN'; % Use LAN instead of RAAN for data entry

% Assign the perigee and apogee altitude values:
keplerian.SizeShape.PerigeeAltitude = 500;      % km
keplerian.SizeShape.ApogeeAltitude = 600;       % km

% Assign the other desired orbital parameters:
keplerian.Orientation.Inclination = 90;         % deg
keplerian.Orientation.ArgOfPerigee = 12;        % deg
keplerian.Orientation.AscNode.Value = 24;       % deg
keplerian.Location.Value = 180;                 % deg

% Apply the changes made to the satellite's state and propagate:
satellite.Propagator.InitialState.Representation.Assign(keplerian);
satellite.Propagator.Propagate;

% Change model of satellite (learn how to make a .dae file)
toSatelliteModel = 'C:\Program Files\AGI\STK 12\STKData\VO\Models\Space\cubesat_3u.dae';
model = satellite.VO.Model;
model.ModelData.Filename = toSatelliteModel;

% Add an external attitude file (learn how to make a .a file)
toAttitudeFile = 'C:\Users\miastra\Documents\MATLAB\Satellite Stuff\scriptedAttitude.a';
satellite.Attitude.External.Load(toAttitudeFile);


%%% SENSOR PROPERTIES
% Add sensor object to satellite
sensor = facility.Children.New('eSensor', 'Sensor');

% Modify sensor properties
sensor.CommonTasks.SetPatternSimpleConic(90, 1);

% Add range constraint
range = sensor.AccessConstraints.AddConstraint('eCstrRange');
range.EnableMin = true;
range.EnableMax = true;
range.min = 0;
range.max = 1000;


%%% ACCESS
% Compute access between objects (satellite > facility)
access = satellite.GetAccessToObject(sensor);
access.ComputeAccess();

%Get computed access intervals
intervalCollection = access.ComputedAccessIntervalTimes;
computedIntervals = intervalCollection.ToArray(0, -1);
access.SpecifyAccessIntervals(computedIntervals);
disp(computedIntervals)


%%% ANIMATION AND GRPAHICS SETTINGS
% Reset animation period (because its necessary)
% Connect Command > root.ExecuteCommand('Animate * Reset')
root.Rewind;

% Resolution changes
resolution = satellite.Graphics.Resolution;
resolution.Orbit = 60;


%%% DONE
disp("DONE")
