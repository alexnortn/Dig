/*
	Generative Animation for "The Dig"
	Eyewire's big neuron countdown.
	-
	Alex Norton
	2016
*/

import processing.pdf.*;

ArrayList<Square> _squares = new ArrayList<Square>();
// Array of Squares to paint for DiG
int[] dig =       { 210,213,227,230,245,246,278,280,281,313,314,329,332,346,348,349 };
// Array of space surround DiG to avoid
int[] dig_space = { 175,176,177,178,179,180,191,192,193,194,195,196,197,198,208,209,
					210,211,212,213,214,215,225,226,227,228,229,230,231,232,242,243,
					244,245,246,247,248,249,260,261,262,263,264,265,276,277,278,279,
					280,281,282,283,294,295,296,297,298,299,310,311,312,313,314,315,
					316,317,327,328,329,330,331,332,333,334,344,345,346,347,348,349,
					350,351,361,362,363,364,365,366,367,368,379,380,381,382,383,384 };
int _square_size,
	_rows,
	_cols;
int _counter = 0;
float _xoff = random(1);
float _yoff = random(1);
float _theta,
	  _threshold_gen,
	  _threshold;


void setup() {
	size(1024, 512); // Keep ratio consistent (2:1) prefferably powers of 2
	frameRate(15);

	exit_check();

	_counter++;

	_theta = 0;
	_threshold = 0;
	_threshold_gen = random(1);

	println("Threshold: " + _threshold_gen);

	_square_size = int(pow(2, 5)); // 2s

	_cols = int(width / _square_size) + 1; // Add (1) to get perfect center!
	_rows = int(height / _square_size) + 1; // Add (1) to get symmetry

	generate_noise(_rows, _cols, _square_size);
	delta_threshold(0);
	delta_threshold(random(0.25,0.75));
}

void draw() {
	background(255);

	// update_noise(_rows, _cols);

	saveVector();
	// transition();
	// render_squares();
	
	// center_point();

	// saveFrame("dig2-######.tga");
	
}

void exit_check() {
	if (_counter >= 250) exit();
}

void saveVector() {
	PGraphics tmp = null;
	tmp = beginRecord(PDF, _counter + "_" + "DiG" + ".pdf");
		render_squares();
		setup();
		// transition();
	endRecord();
}

void center_point() {
	// Center Point
	pushMatrix();
		fill(255,0,0);
		noStroke();
		ellipse(width/2,height/2,5,5);
	popMatrix();
}

void generate_checker(int _rows, int _cols, int _square_size) {
	boolean state = true;
	int index = 0;
	float offset = _square_size/2;

	_squares.clear(); // Empty our ArrayList each time

	for (int i = 0; i < _rows; i++) {
		for (int j = 0; j < _cols; j++) {
			PVector loc = new PVector(); // All pointing at same ref. Vec
			loc.x = i * _square_size - offset;
			loc.y = j * _square_size;

			_squares.add(
				new Square(loc, state, _square_size, offset, index)
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
}

void generate_noise(int _rows, int _cols, int _square_size) {
	boolean state = true;
	int index = 0;
	float offset = _square_size/2;
	float step = 0.8;

	_squares.clear(); // Empty our ArrayList each time

	for (int i = 0; i < _cols; i++) {
		for (int j = 0; j < _rows; j++) {

			PVector loc = new PVector(); // All pointing at same ref. Vec
			loc.x = i * _square_size - offset;
			loc.y = j * _square_size;

			// float theta = map(noise(_xoff, _yoff), 0, 1, 0, TWO_PI);
			// float value = sin(theta);
			float value = noise(_xoff, _yoff);

			_squares.add(
				new Square(loc, state, _square_size, value, index)
			);

			// Clean Up extra Y row (for symmetry)
			Square square_test = _squares.get(index);
				if (square_test._loc.y > height) {
					_squares.remove(index);
					index--;
				} 
			
			index++;

			if (value > _threshold_gen) {
				state = !state; // Flip Color (extendable control) 
			} 

			_yoff += step;
		}
		_yoff = 0;
		_xoff += step;
	}	
}

void update_noise(int _rows, int _cols) {
	int index = 0;
	float step = 0.1;

	for (int i = 0; i < _cols; i++) {
		for (int j = 0; j < _rows; j++) {

			if (index < _squares.size() -1) index++;

			Square square = _squares.get(index); // Get Square;

			float value = noise(_xoff, _yoff);

			if (value > 0.5) {
				square._state = !square._state; // Flip Color (extendable control)
			} 

			_yoff += step;
		}

		_yoff = 0;
		_xoff += step;
	}	
}

boolean two_random() {
	boolean flip = false;
	float rand_fill, rand_density;

	rand_fill = random(1);
	rand_density = random(0.25, 2);

	if (rand_fill > rand_density) {
		flip = true;
	} 

	return flip;
}

void transition() {
	float step = 0.005;

	// _theta += step + _theta / 10;  // Fast
	_theta += step;  // Slow
	_threshold = 2 * abs(sin(_theta));

	if (_threshold > 0.9) {
		// println("noLoop");
		// noLoop();
		setup(); // Reset Sketch
		return;
	}

	for (Square square : _squares) {

		for (int i = 0; i < dig.length; i++) { // Slowly reveal DiG
			if (square._index == dig[i]) {
				if (random(1) < _threshold) {
					square.set_black();
					square._done = true;
				}
			}
		}

		if (square._done) {
			continue;
		}

		if (square._intensity < _threshold) { // Slowly turn squares white
			square.set_white();
			square._done = true;
		} 
	}
}

void delta_threshold(float delta_t) {

	float _delta_t = delta_t;
	println("Threshold " + _delta_t);

	for (Square square : _squares) {

		if (square._done) {
			continue;
		}

		for (int i = 0; i < dig.length; i++) { // Reveal DiG
			if (square._index == dig[i]) {
				square.set_black();
				square._done = true;
				println("DIG");
			}
		}

		for (int i = 0; i < dig_space.length; i++) { // Create space around DiG
			if ((square._index == dig_space[i]) && (!square._done)) {
				square.set_white();
				square._done = true;
			}
		}

		if (square._intensity < _delta_t) { // Slowly turn squares white
			square.set_white();
		} 
		else if (!square._done) {
			square.set_black();
		}
	}
}

void render_squares() {
	for (Square square : _squares) {
		square.render();
		// println(square._loc);
	}
}

void paint() {
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

void multi_paint() {
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

void mouseDragged() {
	float delta_t = map(mouseX, 0, width, 0, 1); // Mouse control + norm threshold value
	delta_threshold(delta_t);
}

void mousePressed() {
	// paint();
}

void keyPressed() {
	if (keyCode == TAB) { // Tab
		println("Reset Checkers");
		for (Square square : _squares) {
			square.reset_state();
		}
	}

	if (keyCode == SHIFT) { // Shift
		println("Reset");
		loop();
		setup();
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

	if (keyCode == 54) { // 6
		println("Save");
		saveVector();
	}
}

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












