function idx = makeIndexCube(dims)

idx = [1:dims(1)]';
dimprod = cumprod(dims);

for d=2:length(dims)
idx = [repmat(idx, dims(d),1) reshape(repmat(1:dims(d), dimprod(d-1), 1), dimprod(d),1)];
end

end