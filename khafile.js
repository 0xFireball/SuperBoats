let project = new Project('SuperBoats');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('n4');
resolve(project);
