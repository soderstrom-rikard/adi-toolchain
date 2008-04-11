package com.adi.debug.ui.views;

import java.math.BigInteger;


/**
 * @author odcohen
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class ValueViewUtils
{	
	// Data Display Formats
	public static final String FORMAT_STR_HEX 				= "Hexadecimal";
	public static final String FORMAT_STR_UNSIGNED_INT 		= "Unsigned Integer";
	public static final String FORMAT_STR_SIGNED_INT 		= "Signed Integer";
	//public static final String FORMAT_STR_FLOAT			= "Floating Point";
	public static final String FORMAT_STR_OCT 				= "Octal";
	public static final String FORMAT_STR_BIN 				= "Binary";
	public static final String FORMAT_STR_DISASM 			= "Disassembly";
	
	
	//	base constatnts
	public static final int DEFAULT_DATA_SIZE = -1;
	
	static final double LAN10 = 2.3025850929940456840179914546844D;
	
	private static final int SIGNED 	= 1 << 17;
	private static final int INT 		= 1 << 18;
	private static final int FLOAT 		= 1 << 19;
	
	private static final int BASE_MASK = 0xFF;
	
	public static final int DISASSEMBLY 		= 0;
	public static final int BINARY 				= 2;
	public static final int OCTAL 				= 8;
	private static final int DECIMAL 			= 10;
	public static final int UNSIGNED_INT 		= DECIMAL | INT;
	public static final int SIGNED_INT 			= DECIMAL | INT | SIGNED;
	//public static final int FLOATING 			= DECIMAL | FLOAT;
	public static final int HEXA 				= 16;
	
	
	
	/**
	 * Get string representation of the given number according to the given parameters
	 * 
	 * @param number			The given number
	 * @param base				The base of the number
	 * @param dataSize		The data size of the number (in bits)
	 * @return	the string
	 */
	public static String getFormatedString(int number, int base, int dataSize)
	{
		return getFormatedString(number, base, dataSize, true);
	}
	
	/**
	 * Get string representation of the given number according to the given parameters
	 * @param number			The given number
	 * @param base				The base of the number
	 * @param dataSize		The data size of the number (in bits)
	 * @param withBrackets		Adding brackets or not ("[XXX]")
	 * @return the string
	 */
	public static String getFormatedString(int number, int base, int dataSize, boolean withBrackets)
	{	
		return getFormatedString(BigInteger.valueOf( ((long) number) & 0xFFFFFFFFL), base, dataSize, withBrackets);
	}

	/**
	 * Get string representation of the given number according to the given parameters
	 * @param number	The number	
	 * @param base		The base of the number
	 * @return	the string
	 */
	public static String getFormatedString(long number, int base)
	{	
		return getFormatedString(BigInteger.valueOf(number), base, DEFAULT_DATA_SIZE, false);
	}
	
	/**
	 * Get string representation of the given number according to the given parameters
	 * 
	 * @param number			The given number
	 * @param base				The base of the number
	 * @param dataSize		The data size of the number (in bits)
	 * @return	the string
	 */
	public static String getFormatedString(long number, int base, int dataSize)
	{
		return getFormatedString(number, base, dataSize, true);
	}
	
	/**
	 * Get string representation of the given number according to the given parameters
	 * @param number			The given number
	 * @param base				The base of the number
	 * @param dataSize		The data size of the number (in bits)
	 * @param withBrackets		Adding brackets or not ("[XXX]")
	 * @return the string
	 */
	public static String getFormatedString(long number, int base, int dataSize,  boolean withBrackets)
	{	
		return getFormatedString(BigInteger.valueOf(number), base, dataSize, withBrackets);
	}
	
	/**
	 * Get string representation of the given number according to the given parameters
	 * @param number			The number
	 * @param base				The base of the number
	 * @param dataSize		The data size of the number (in bits)
	 * @param withBrackets		Adding brackets or not ("[XXX]")
	 * @return	the string
	 */
	public static String getFormatedString(BigInteger number, int base, int dataSize, boolean withBrackets)
	{		
		String strNumber = null;
		
		BigInteger f;
		Double g;
		if ((base & FLOAT) > 0)
		{
			//if (dataSize <= 32)
				strNumber = new Float(Float.intBitsToFloat(number.intValue())).toString();
			//else
			//{
				// convert to 64 bit and than parse to string
			//	BigInteger num = number.and(BigInteger.valueOf(MANTISA_40BIT_MASK).shiftLeft(MANTISA_40BIT_OFFSET));
			//	num = num.or(number.and(BigInteger.valueOf(EXP_40BIT_MASK)).shiftLeft(EXP_40BIT_OFFSET));
			//	num = num.or(number.and(BigInteger.valueOf(SIGN_40BIT_MASK).shiftLeft(SIGN_40BIT_OFFSET)));
			//	strNumber = new Double(Double.longBitsToDouble(num.longValue())).toString();
			//}
		}
		else if ((base & INT) > 0 && (base & SIGNED) > 0)
		{
			if (dataSize == DEFAULT_DATA_SIZE)
				strNumber = new Integer(number.intValue()).toString();
			else
			{
				// meaning it has a negative representation
				if (number.testBit(dataSize-1))
				{
					BigInteger val = BigInteger.valueOf(-1);
					for (int ind=0; ind < dataSize; ind++)
						if (!number.testBit(ind))
							val = val.flipBit(ind);
					
					number = val;
				}
				
				strNumber = number.toString();
			}
		}
		else
		{
			strNumber = number.toString(base & BASE_MASK);
		}
			
		return formatDisplay(strNumber, dataSize, base, withBrackets );
	}

	/**
	 * Returns the value of the string number according to the given base
	 * @param number			The string number
	 * @param base				The base
	 * @return	the value
	 */
	public static BigInteger getValue(String number, int base)
	{
		return getValue(number, DEFAULT_DATA_SIZE, base);
	}
	
	/**
	 * Returns the value of the string number according to the given base
	 * @param number			The string number
	 * @param dataSize			The data size of the number (in bits)
	 * @param base				The base
	 * @return	the value
	 */
	public static BigInteger getValue(String number, int dataSize, int base)
	{
		if ((base & FLOAT) > 0)
		{
			//if (dataSize <= 32)
				return BigInteger.valueOf(Float.floatToRawIntBits(Float.parseFloat(number)));
			//else
			//{
				// parse and than convert to 40 bits
				//BigInteger orgNum = BigInteger.valueOf(Double.doubleToRawLongBits(Double.parseDouble(number)));
				//BigInteger num = orgNum.and(BigInteger.valueOf(MANTISA_40BIT_MASK).shiftLeft(MANTISA_40BIT_OFFSET)).shiftRight(MANTISA_40BIT_OFFSET);
				//num = num.or(orgNum.and(BigInteger.valueOf(EXP_40BIT_MASK).shiftLeft(EXP_40BIT_OFFSET)).shiftRight(EXP_40BIT_OFFSET));
				//num = num.or(orgNum.and(BigInteger.valueOf(SIGN_40BIT_MASK).shiftLeft(SIGN_40BIT_OFFSET)).shiftRight(SIGN_40BIT_OFFSET));
				//return num;
			//}
		}		
		else
		{
			return new BigInteger(number, base & BASE_MASK);
		}
	}
	
	
	private static String formatDisplay(String original, int dataSize, int base, boolean withBrackets)
	{
		StringBuffer buffer = new StringBuffer(original.toUpperCase());
		
		
		int viewSize = translateBits2Digits(dataSize, base);
		
		// Format the length if needed
		if (buffer.length() < viewSize)
		{
			int extraZeros = viewSize - buffer.length();
			for (int ind=0; ind < extraZeros; ind++)
				buffer.insert(0, '0');
		}
		else if (buffer.length() > viewSize && viewSize > 0)
		{
			buffer.delete(0, buffer.length() - viewSize);
		}
		
		// Add brackets if needed
		if (withBrackets)
		{
			buffer.insert(0, '[');
			buffer.append(']');
		}
		
		return buffer.toString();
	}
	
	/**
	 * Translate the number of bits to the number of required digit
	 * according to the given base
	 * @param bits	The number of bits
	 * @param base	The base of the number
	 * @return	the number of required digits
	 */
	public static int translateBits2Digits(int bits, int base)
	{
		if (bits == DEFAULT_DATA_SIZE)
			return -1;
			
		// if its a signed or float number we do not "pad" it with zeros 
		if ((base & SIGNED) > 0 || (base & FLOAT) > 0)
			return -1;
			
		base = base & BASE_MASK;
		int viewSize = 0;
		switch (base)
		{
			case HEXA:
				viewSize = bits / 4;
				viewSize+= (bits % 4) > 0 ? 1:0;
				break;
			case OCTAL: 
				viewSize = bits / 3;
				viewSize+= (bits % 3) > 0 ? 1:0;
				break;
			case BINARY:
				viewSize = bits;
				break;		
			// decimal 
			default:
				BigInteger value = BigInteger.valueOf(1).shiftLeft(bits);
				viewSize = (int)Math.round(Math.ceil(Math.log(value.doubleValue())/LAN10));
		}

		
		return viewSize;
	}
	
	/**
	 * Returns the string which matches the given base
	 * for one byte of data, with the widthest text.
	 * 
	 * @param base
	 * @return
	 */
	public static String getByteMaxString(int base)
	{
	    String byteStr;
		switch (base)
		{
			case ValueViewUtils.HEXA:
			    byteStr = "FF";
				break;
			case ValueViewUtils.OCTAL:
			    byteStr = "000";
				break;
			case ValueViewUtils.BINARY:
			    byteStr = "00000000";
				break;	
			default:
			    byteStr = "999";
		}
		
		return byteStr;
	}

	
	
	/**
	 * Convert the given base to its relevant string (to present to the user)
	 * @param base		The base
	 * @return the string
	 */
	public static String baseToFormat(int base)
	{
		String type = null;
		switch (base)
		{
			case ValueViewUtils.BINARY:
				type = FORMAT_STR_BIN;
				break;
			case ValueViewUtils.OCTAL:
				type = FORMAT_STR_OCT;
				break;
			case ValueViewUtils.UNSIGNED_INT:
				type = FORMAT_STR_UNSIGNED_INT;
				break;
			case ValueViewUtils.SIGNED_INT:
				type = FORMAT_STR_SIGNED_INT;
				break;
			//case ValueViewUtils.FLOATING:
			//	type = FORMAT_STR_FLOAT;
			//	break;
			case ValueViewUtils.HEXA:
				type = FORMAT_STR_HEX;
				break;	
		}
		
		return type;
	}
	
	
	/**
	 * Converting the string presented to the user to its relevant base
	 * @param format	The string format
	 * @return	the base
	 */
	public static int formatToBase(String format)
	{
		int base = -1;
		
		if (format.equalsIgnoreCase(FORMAT_STR_BIN))
			base = ValueViewUtils.BINARY;
		else if (format.equalsIgnoreCase(FORMAT_STR_OCT))
			base = ValueViewUtils.OCTAL;
		else if (format.equalsIgnoreCase(FORMAT_STR_UNSIGNED_INT))
			base = ValueViewUtils.UNSIGNED_INT;
		else if (format.equalsIgnoreCase(FORMAT_STR_SIGNED_INT))
			base = ValueViewUtils.SIGNED_INT;
		//else if (format.equalsIgnoreCase(FORMAT_STR_FLOAT))
		//	base = ValueViewUtils.FLOATING;
		else if (format.equalsIgnoreCase(FORMAT_STR_HEX))
			base = ValueViewUtils.HEXA;
		
		return base;
	}
}
