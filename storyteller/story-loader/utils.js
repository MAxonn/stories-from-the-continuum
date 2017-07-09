/**
 * Created by Michael Axonn on 08-Jul-17.
 */

//Checks if a number is Integer.
function isInt (value)
{
	if (isNaN(value))
	{
		return false;
	}
	var x = parseFloat(value);
	return (x | 0) === x;
}