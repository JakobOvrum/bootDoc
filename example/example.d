module example.example;

/// Ut in enim magna, et vestibulum dui. Phasellus commodo ullamcorper.
void foo();

/**
 * Cras aliquet auctor dictum. Vestibulum posuere dolor sit amet arcu.
 * Params:
 *    a = Vivamus vitae semper eros. Cras.
 *    b = Sed pellentesque orci id felis.
 */
int bar(int a, int b);

/// Nulla eu eros et neque aliquam fermentum dictum eu turpis.
struct S
{
	/**
	 * Params:
	 *    a = Donec massa augue, mattis id.
	 */
	this(int a);
	
	///
	immutable this(int a);
	
	///
	@disable this();
	
	///
	~this();
	
	///
	this(this);
	
	/// Etiam gravida odio sed massa.
	static S foo();
	
	///
	struct S2
	{
		///
		int a;
		
		///
		void foo();
	}
}