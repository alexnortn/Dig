/*
	Generative Animation for "The Dig"
	Eyewire's big neuron countdown.
	-
	Alex Norton
	2016
*/

ArrayList<Square> _squares = new ArrayList<Square>();
int _square_size;



void setup() {
	size(1024, 512); // Keep ratio consistent (2:1) prefferably powers of 2

	_square_size = int(pow(2, 5)); // 2s

	int gridX = int(width / _square_size);
	int gridY = int(height / _square_size);

	generate_squares(gridX, gridY, _square_size);
}

void draw() {
	background(255);
	render_squares();

	pushMatrix();
		fill(255,0,0);
		ellipse(width/2,height/2,5,5);
	popMatrix();
	
}

void generate_squares(int gridX, int gridY, int _square_size) {
	boolean state = true;
	int index = 0;

	for (int i = 0; i < gridX; i++) {
		for (int j = 0; j < gridY; j++) {
			PVector loc = new PVector(); // All pointing at same ref. Vec
			loc.x = i * _square_size;
			loc.y = j * _square_size;
			_squares.add(
				new Square(loc, state, _square_size, index)
			);
			
			index++;
			state = !state; // Flip color
		}

		state = !state; // Flip color
	}

	println(_squares.size());
	
	for(Square square : _squares) {
		println(square._loc);
	}
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
	if (keyCode == TAB) {
		println("Set reset for squares");
		for (Square square : _squares) {
			square.reset_state();
		}
	}

	if (keyCode == 48) {
		println("Set squares white");
		for (Square square : _squares) {
			square.set_white();
		}
	}

	if (keyCode == 49) {
		println("Set squares black");
		for (Square square : _squares) {
			square.set_black();
		}
	}

	if (keyCode == 50) {
		println("Toggle stroke");
		for (Square square : _squares) {
			square.toggle_stroke();
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












