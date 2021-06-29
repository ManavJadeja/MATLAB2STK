function A = q2a(q)

q = q/norm(q);

A=[q(1)^2-q(2)^2-q(3)^2+q(4)^2, 2*(q(1)*q(2)+q(3)*q(4)), 2*(q(1)*q(3)-q(2)*q(4));
   2*(q(1)*q(2)-q(3)*q(4)), -q(1)^2+q(2)^2-q(3)^2+q(4)^2, 2*(q(2)*q(3)+q(1)*q(4));
   2*(q(1)*q(3)+q(2)*q(4)), 2*(q(2)*q(3)-q(1)*q(4)), -q(1)^2-q(2)^2+q(3)^2+q(4)^2];

end

% This function converts a quaternion to an attitude matrix.
% Andrew Dianetti
% 5 December 2014