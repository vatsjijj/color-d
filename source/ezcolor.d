module ezcolor;

import std.conv;
import std.string : split;
import std.math : abs, round;

const string RESET = "\x1b[0m";

private string[] styles = [
  "b", "i",
  "bi"
];

private template clampT(T) {
  T clamp(T up, T low, T init) {
    return init > up ? up : init < low ? low : init;
  }
}

struct HSL {
  double h, s, l = 0;
  string style = "";

  this(double h, double s, double l) {
    this.h = clampT!(double).clamp(360.0, 0.0, h);
    this.s = clampT!(double).clamp(100.0, 0.0, s) / 100;
    this.l = clampT!(double).clamp(100.0, 0.0, l) / 100;
  }
  this(double h, double s, double l, string style) {
    this.h = clampT!(double).clamp(360.0, 0.0, h);
    this.s = clampT!(double).clamp(100.0, 0.0, s) / 100;
    this.l = clampT!(double).clamp(100.0, 0.0, l) / 100;
    this.style = style;
  }

  string toString() const @safe pure nothrow {
    string res;
    double rp, gp, bp;
    int r, g, b;
    double c = (1 - abs(2 * this.l - 1)) * this.s;
    double x = c * (1 - abs((this.h / 60.0) % 2 - 1));
    double m = this.l - c / 2.0;
    if (0 <= this.h && this.h < 60) {
      rp = c;
      gp = x;
      bp = 0;
    }
    else if (60 <= this.h && this.h < 120) {
      rp = x;
      gp = c;
      bp = 0;
    }
    else if (120 <= this.h && this.h < 180) {
      rp = 0;
      gp = c;
      bp = x;
    }
    else if (180 <= this.h && this.h < 240) {
      rp = 0;
      gp = x;
      bp = c;
    }
    else if (240 <= this.h && this.h < 300) {
      rp = x;
      gp = 0;
      bp = c;
    }
    else if (300 <= this.h && this.h < 360) {
      rp = c;
      gp = 0;
      bp = x;
    }
    r = cast(int)round((rp + m) * 255);
    g = cast(int)round((gp + m) * 255);
    b = cast(int)round((bp + m) * 255);
    switch (this.style) {
      case "b": res ~= "\x1b[1m"; break;
      case "i": res ~= "\x1b[2m"; break;
      case "bi": res ~= "\x1b[1m\x1b[2m"; break;
      default: res ~= "\x1b[0m"; break;
    }
    res ~= "\x1b[";
    res ~= "38;";
    res ~= "2;";
    res ~= to!string(r) ~ ";";
    res ~= to!string(g) ~ ";";
    res ~= to!string(b) ~ "m";
    return res;
  }
}

struct HSV {
  double h, s, v = 0;
  string style = "";

  this(double h, double s, double v) {
    this.h = clampT!(double).clamp(360.0, 0.0, h);
    this.s = clampT!(double).clamp(100.0, 0.0, s) / 100;
    this.v = clampT!(double).clamp(100.0, 0.0, v) / 100;
  }
  this(double h, double s, double v, string style) {
    this.h = clampT!(double).clamp(360.0, 0.0, h);
    this.s = clampT!(double).clamp(100.0, 0.0, s) / 100;
    this.v = clampT!(double).clamp(100.0, 0.0, v) / 100;
    this.style = style;
  }

  string toString() const @safe pure nothrow {
    string res;
    double rp, gp, bp;
    int r, g, b;
    double c = this.v * this.s;
    double x = c * (1 - abs((this.h / 60.0) % 2 - 1));
    double m = this.v - c;
    if (0 <= this.h && this.h < 60) {
      rp = c;
      gp = x;
      bp = 0;
    }
    else if (60 <= this.h && this.h < 120) {
      rp = x;
      gp = c;
      bp = 0;
    }
    else if (120 <= this.h && this.h < 180) {
      rp = 0;
      gp = c;
      bp = x;
    }
    else if (180 <= this.h && this.h < 240) {
      rp = 0;
      gp = x;
      bp = c;
    }
    else if (240 <= this.h && this.h < 300) {
      rp = x;
      gp = 0;
      bp = c;
    }
    else if (300 <= this.h && this.h < 360) {
      rp = c;
      gp = 0;
      bp = x;
    }
    r = cast(int)round((rp + m) * 255);
    g = cast(int)round((gp + m) * 255);
    b = cast(int)round((bp + m) * 255);
    switch (this.style) {
      case "b": res ~= "\x1b[1m"; break;
      case "i": res ~= "\x1b[2m"; break;
      case "bi": res ~= "\x1b[1m\x1b[2m"; break;
      default: res ~= "\x1b[0m"; break;
    }
    res ~= "\x1b[";
    res ~= "38;";
    res ~= "2;";
    res ~= to!string(r) ~ ";";
    res ~= to!string(g) ~ ";";
    res ~= to!string(b) ~ "m";
    return res;
  }
}

struct CMYK {
  double c, m, y, k = 0;
  string style = "";

  this(double c, double m, double y, double k) {
    this.c = clampT!(double).clamp(100.0, 0.0, c);
    this.m = clampT!(double).clamp(100.0, 0.0, m);
    this.y = clampT!(double).clamp(100.0, 0.0, y);
    this.k = clampT!(double).clamp(100.0, 0.0, k);
  }
  this(double c, double m, double y, double k, string style) {
    this.c = clampT!(double).clamp(100.0, 0.0, c);
    this.m = clampT!(double).clamp(100.0, 0.0, m);
    this.y = clampT!(double).clamp(100.0, 0.0, y);
    this.k = clampT!(double).clamp(100.0, 0.0, k);
    this.style = style;
  }

  string toString() const @safe pure nothrow {
    string res;
    int r, g, b;
    r = cast(int)round(255.0 * (1 - this.c / 100.0) * (1 - this.k / 100.0));
    g = cast(int)round(255.0 * (1 - this.m / 100.0) * (1 - this.k / 100.0));
    b = cast(int)round(255.0 * (1 - this.y / 100.0) * (1 - this.k / 100.0));
    switch (this.style) {
      case "b": res ~= "\x1b[1m"; break;
      case "i": res ~= "\x1b[2m"; break;
      case "bi": res ~= "\x1b[1m\x1b[2m"; break;
      default: res ~= "\x1b[0m"; break;
    }
    res ~= "\x1b[";
    res ~= "38;";
    res ~= "2;";
    res ~= to!string(r) ~ ";";
    res ~= to!string(g) ~ ";";
    res ~= to!string(b) ~ "m";
    return res;
  }
}

struct RGB {
  int r, g, b = 0;
  bool fg = true;
  string style = "";

  this(int r, int g, int b) {
    this.r = clampT!(int).clamp(255, 0, r);
    this.g = clampT!(int).clamp(255, 0, g);
    this.b = clampT!(int).clamp(255, 0, b);
  }
  this(int r, int g, int b, bool fg) {
    this.r = clampT!(int).clamp(255, 0, r);
    this.g = clampT!(int).clamp(255, 0, g);
    this.b = clampT!(int).clamp(255, 0, b);
    this.fg = fg;
  }
  this(int r, int g, int b, string style) {
    this.r = clampT!(int).clamp(255, 0, r);
    this.g = clampT!(int).clamp(255, 0, g);
    this.b = clampT!(int).clamp(255, 0, b);
    this.style = style;
  }

  string toString() const @safe pure nothrow {
    string res;
    switch (this.style) {
      case "b": res ~= "\x1b[1m"; break;
      case "i": res ~= "\x1b[2m"; break;
      case "bi": res ~= "\x1b[1m\x1b[2m"; break;
      default: res ~= "\x1b[0m"; break;
    }
    res ~= "\x1b[";
    res ~= this.fg ? "38;" : "48;";
    res ~= "2;";
    res ~= to!string(this.r) ~ ";";
    res ~= to!string(this.g) ~ ";";
    res ~= to!string(this.b) ~ "m";
    return res;
  }
}

const string BOLD = "\x1b[1m";
const string ITALIC = "\x1b[3m";
const string UNDERLINE = "\x1b[4m";