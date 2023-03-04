model Oscilliator
  Real x, y, t;
initial equation
  t = 0;
  x = 1.5;
  y = 1.1;
equation
  der(t) = 1;
  der(x) = y;
  der(y) = -2*x;
end Oscilliator;
