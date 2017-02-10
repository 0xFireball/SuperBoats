let project = new Project('SuperBoats');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('n4');
project.addLibrary('n4e');
resolve(project);
