classdef shape < handle
    %SHAPE Summary of this class goes here
    % Shape is the representation of an object and its properties
    
    properties
        vertices    % Matrix with list of vertices
        faces       % Faces between those vertices
        mass        % Scalar for mass
        inertia     % 1x3 with xx, yy, and zz inertia
        color       % 1x3 color matrix (from 0-1 for RGB)
        
        h           % handle
    end
    
    methods (Access = public)
        function [obj] = shape(vertices, faces, mass, inertia, color)
            %SHAPE Construct an instance of this class
            % Everything needed to define this shape
            obj.vertices = vertices;
            obj.faces = faces;
            obj.mass = mass;
            obj.inertia = inertia;
            obj.color = color;
            
            obj.draw();
        end
        
        function [] = updateAttitude(obj, rotmat)
            % Update attitude 
            % > Input is rotation matrix and current verticies
            % > Output is new verticies
            % > Update object new verticies
            v_new = (rotmat*obj.vertices')';
            set(obj.h,'Vertices', v_new);
        end
        
        function [] = draw(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.h = patch('Faces', obj.faces, 'Vertices', obj.vertices,...
                          'FaceColor', obj.color);
            axis equal
            grid on
            rotate3d on
        end
    end
end

