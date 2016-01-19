/*
	Generative Animation for "The Dig"
	Eyewire's big neuron countdown.
	-
	Alex Norton
	2016
*/

ArrayList<Square> _squares;



void setup() {
	size(1024, 512); // Keep ratio consistent (2:1) prefferably powers of 2

	int square_size = pow(2, 4); // 2s

	int gridX = int(width / square_size);
	int gridY = int(height / square_size);

	generate_squares(gridX, gridY);
}

void draw() {
	background(255);
	
}

void generate_squares(int density) {
	Pvector loc = new Pvector();

	for (int i = 0; i < gridX; i++) {
		for (int j = 0; j < gridY; j++) {
			loc.x = 
			Square square = new Square()
			_squares.add(square);
		}
	}
}

class Square {
	color _c;
	int _size;
	boolean _state = true;
	PVector _loc;

	Square (PVector loc, boolean state, int size) {
		_state = state;
		_loc = loc;
		_size = size;
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





}