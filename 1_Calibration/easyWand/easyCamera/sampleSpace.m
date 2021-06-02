function points = sampleSpace(numPoints, xlims, ylims, zlims)
dx = xlims(2)-xlims(1);
dy = ylims(2)-ylims(1);
dz = zlims(2)-zlims(1);
points = util.rowadd(util.rowmult(rand(numPoints,3), [dx dy dz]), [xlims(1) ylims(1) zlims(1)]);
end