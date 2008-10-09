	.text

	// Below 4 bytes are "R3:2 = CMUL(R0,R1) (IS);"
	// with a invalid mode "0xf".
	.byte 0x0f
	.byte 0xc7
	.byte 0x81
	.byte 0xc0
