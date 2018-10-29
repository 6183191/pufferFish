addpath(genpath('source'));

imagesDir = "res/images";

a = dir(imagesDir);

a = {a.name};

a = a(3:end);

