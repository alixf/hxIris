class Accumulator
{
	public var size(get_size, null) : Int;
	public var value(get_value, null) : Float;
	private var values : Array<Float>;
	private var index : Int;

	public function new(size : Int)
	{
		this.size = size;
		values = new Array();
		for(i in 0...size)
			values.push(0.0);
		value = 0.0;
		index = 0;
	}	
	
	public function feed(value : Float)
	{
		index = (index + 1) % size;
		values[index] = value;
		computeValue();
	}
	
	public function get_size() : Int
	{
		return size;
	}

	public function setSize(size : Int)
	{
		var newValues = new Array();
		for(i in 0...size)
		{
			index = (index - 1) % size;
			newValues.push(values[index]);
		}

		values = newValues;
		this.size = size;
		index = 0;

		computeValue();
		return this.size;
	}
	
	public function get_value() : Float
	{
		return value;
	}

	private function computeValue()
	{
		value = 0.0;
		for(i in 0...size)
			value += values[i];
		value /= size;
	}
}