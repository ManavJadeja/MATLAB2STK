function outmat = cpm(invec)
    % Function cpm computes the standard cross-product matrix for a given
    % 3-vector.

    i1 = invec(1);
    i2 = invec(2);
    i3 = invec(3);

    outmat = [0, -i3, i2;
              i3, 0, -i1;
              -i2, i1, 0];
end