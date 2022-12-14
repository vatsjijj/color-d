import std.stdio;
import ezcolor;

void main() {
	writeln(RGB(255, 111, 33), "RGB", RESET);
	writeln(CMYK(0, 56, 87, 0), "CMYK", RESET);
	writeln(HSV(21, 87, 100), "HSV", RESET);
	writeln(HSL(21, 100, 56.5), "HSL", RESET);
}