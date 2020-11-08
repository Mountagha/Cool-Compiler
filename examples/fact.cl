class Main inherits A2I {
	
	main(): Object {
		(new IO).out_string(i2a(fact(a2i((new IO).in_string()))).concat("\n"))
	};

	fact(i: Int): Int {
		i + 1
	};
};
