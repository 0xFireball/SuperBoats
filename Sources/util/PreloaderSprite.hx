package util;

import n4.entities.NSprite;

/**
 * Pre-cache makeGraphic() calls
 */
class PreloaderSprite extends NSprite {
	private var i:Int = 1;
	private var j:Int = 1;
	private var maxI:Int = 20;
	private var maxJ:Int = 20;
	private var cycleCount:Int = 10;

	public function new() {
		super(0, 0);
		// hide it
		y = x = -100;
	}

	public function doIteration() {
		makeGraphic(i, j);
		j++;
		if (j >= maxI) {
			j = 1;
			i++;
		}
	}

	override public function update(dt:Float) {
		// do a few makeGraphic()
		for (i in 1...cycleCount) {
			doIteration();
		}
		super.update(dt);
	}
}