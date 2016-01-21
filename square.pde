class Square {
	color _c;
	int _size;
	int _index;
	float _intensity;
	boolean _state = true;
	boolean _init_state = true;
	boolean _stroke = false;
	boolean _done = false;
	PVector _loc;

	Square (PVector loc, boolean state, int size, float intensity, int index) {
		_init_state = state;
		_state = state;
		_loc = loc;
		_size = size;
		_intensity = intensity;
		_index = index;
	}

	// Render the <Square> as a rectangle
	void render() {
		if (_state) {
			_c = color(0); // Black (on)
		} 
		else {
			_c = color(255); // White (off)
		}

		fill(_c);

		if (_stroke) {	
			stroke(0);
			strokeWeight(1);
		} 
		else {
			noStroke();
		}
		
		rect(_loc.x, _loc.y, _size, _size);
	}

	// Might be useful for checking hover
	void set_state(boolean state) {
		_state = state;
	}

	// Useful for painting
	void toggle_state() {
		_state = !_state;
	}

	void reset_state() {
		_state = _init_state;
	}

	void set_white() {
		_state = false;
	}

	void set_black() {
		_state = true;
	}

	void toggle_stroke() {
		_stroke = !_stroke;
	}
}