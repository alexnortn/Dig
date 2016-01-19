/*
	Generative Animation for "The Dig"
	Eyewire's big neuron countdown.
	-
	Alex Norton
	2016
*/

ArrayList<Square> _squares = new ArrayList<Square>();
int[] dig = { 210,213,227,230,245,246,278,280,281,313,314,329,332,346,348,349 };
int _square_size;



void setup() {
	size(1024, 512); // Keep ratio consistent (2:1) prefferably powers of 2

	_square_size = int(pow(2, 5)); // 2s
	println(dig.length);

	int gridX = int(width / _square_size) + 1; // Add (1) to get perfect center!
	int gridY = int(height / _square_size) + 2; // Add (1) to get symmetry

	generate_squares(gridX, gridY, _square_size);
}

void draw() {
	background(255);

	render_squares();	

	// Center Point
	pushMatrix();
		fill(255,0,0);
		noStroke();
		ellipse(width/2,height/2,5,5);
	popMatrix();
	
}

void generate_squares(int gridX, int gridY, int _square_size) {
	boolean state = true;
	int index = 0;
	float offset = _square_size/2;

	for (int i = 0; i < gridX; i++) {
		for (int j = 0; j < gridY; j++) {
			PVector loc = new PVector(); // All pointing at same ref. Vec
			loc.x = i * _square_size - offset;
			loc.y = j * _square_size - offset;
			_squares.add(
				new Square(loc, state, _square_size, index)
			);

			// Clean Up extra Y row (for symmetry)
			Square square_test = _squares.get(index);
				if (square_test._loc.y > height) {
					_squares.remove(index);
					index--;
				} 
			
			index++;
			if (j % 1 == 0) {
				state = !state; // Flip Color (extendable control)
			} 
		}

		if (i % 1 == 0) {
			state = !state; // Flip Color (extendable control)
		}
	}

	println(_squares.size());
	
}

void render_squares() {
	for (Square square : _squares) {
		square.render();
		// println(square._loc);
	}
}

void mouseDragged() {
	int x,y;
	for (Square square : _squares) {
		x = int(square._loc.x);
		y = int(square._loc.y);
		if ((mouseX > x) && (mouseX < x + _square_size)) {
			if ((mouseY > y) && (mouseY < y + _square_size)) {
				println(square._loc + " " + square._index);
				square.toggle_state();
			}
		}
	}
}

void mousePressed() {
	int x,y;
	for (Square square : _squares) {
		x = int(square._loc.x);
		y = int(square._loc.y);
		if ((mouseX > x) && (mouseX < x + _square_size)) {
			if ((mouseY > y) && (mouseY < y + _square_size)) {
				println(square._loc + " " + square._index);
				square.toggle_state();
			}
		}
	}
}

void keyPressed() {
	if (keyCode == TAB) { // Tab
		println("Set reset for squares");
		for (Square square : _squares) {
			square.reset_state();
		}
	}

	if (keyCode == 32) { // Space
		println("Log DiG array");
		for (Square square : _squares) {
			if (square._state) {
				println(square._index);
			}
		}
	}

	if (keyCode == 48) { // 0
		println("Set squares white");
		for (Square square : _squares) {
			square.set_white();
		}
	}

	if (keyCode == 49) { // 1
		println("Set squares black");
		for (Square square : _squares) {
			square.set_black();
		}
	}

	if (keyCode == 50) { // 2
		println("Toggle stroke");
		for (Square square : _squares) {
			square.toggle_stroke();
		}
	}

	if (keyCode == 51) { // 3
		println("Invert");
		for (Square square : _squares) {
			square.toggle_state();
		}
	}

	if (keyCode == 53) { // 5
		println("DiG");
		for (Square square : _squares) {
			square.set_white();
			
			for (int i = 0; i < dig.length; i++) {
				if (square._index == dig[i]) {
					square.set_black();
				}
			}
		}
	}
}

class Square {
	color _c;
	int _size;
	int _index;
	boolean _state = true;
	boolean _init_state = true;
	boolean _stroke = true;
	PVector _loc;

	Square (PVector loc, boolean state, int size, int index) {
		_init_state = state;
		_state = state;
		_loc = loc;
		_size = size;
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












