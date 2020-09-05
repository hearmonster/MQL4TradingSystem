//+------------------------------------------------------------------+
//|                                           PH TestCustomTypes.mq4 |
//|                                                      HearMonster |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "HearMonster"
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict

#ifndef _PHCustomTypes
   #include <PH Custom Types.mqh>
#endif 

#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
      LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   short iPrecision = 2;
   short iNewPrecision = 1;
   string sTest = "";
   double dInitialUnits = 12.11;
   double dAddUnits = 3;
   double dSubtractUnits = 3;
   double dMultiplyUnits = 3;
   double dDivideUnits = 3;
   
   
   //PHDecimal num_1;
   double dNum_Value;
   bool   bNum_res;
   
   PH_FX_PAIRS  eMarketSymbol;
   PH_CURR_CODE eCurrCode;   
   string       sSymbol;
   string       sCurrSymbol;

   //PCCurrDecimal
   double dCashRoundingStep;
   
   double dTickValue, dTickSize, dAsk_BUY, dBid_SELL, dMargin_1Lot ;


//<<< PHDecimal >>>


   // Constructor #0 [Default] - creates an invalid object! See my notes regarding "DUMMY Constructor #0" below on why I'm doing this...
   // PHDecimal::PHDecimal() : _eStatus( OBJECT_UNITIALIZED ), _lUnits( -1 ), _iPrecision( -1 ) {};

   sTest = "1";
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_1 <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object => Result: BAD OBJECT", sTest ) );
      PHDecimal num_1(  );
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD [%s] : %s  << Should be: %s", num_1.objectToString() )  : "Object is BAD" );
      

   // Constructor #1 [Parametric] (Regular Constructor)
   // PHDecimal::PHDecimal( const double dInitialUnits, const short iPrecision );


   sTest = "2-a";
      dInitialUnits = 12.11;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_2a <Constructor { value = %s, precision = %i }> - STRAIGHTFORWARD: INPUT 2DPs WITH PRECISION OF 2DPs", sTest, sFmtDdp(dInitialUnits, iPrecision), iPrecision ) );
      PHDecimal num_2a( dInitialUnits, iPrecision );
      dNum_Value = num_2a.toNormalizedDouble();
      myLogger.logINFO( num_2a.isValueReadable() ? StringFormat( "Object is GOOD [%s] : %s  << Should be: %s", num_2a.objectToString(), sFmtDdp(dNum_Value,iPrecision), sFmtDdp(dInitialUnits,iPrecision) )  : "Object is BAD" );

   sTest = "2-b";
      dInitialUnits = 12.119;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_2b <Constructor { value = %s, precision = %i }> - ROUND UP INPUT (3DPs) TO 2DPs", sTest, sFmtDdp(dInitialUnits, 3), iPrecision ) );
      PHDecimal num_2b( dInitialUnits, iPrecision );
      myLogger.logINFO( num_2b.isValueReadable() ? StringFormat( "Object is GOOD : %s << Should be: 12.12 i.e. rounded up to 2dp", num_2b.toString() )  : "Object is BAD" );

   sTest = "2-c";
      dInitialUnits = 12.34567;
      iPrecision = 5;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_2c <Constructor { value = %s, precision = %i }> - STRAIGHTFORWARD: INPUT 5DPs WITH PRECISION OF 5DPs", sTest, sFmtDdp(dInitialUnits, iPrecision), iPrecision ) );
      PHDecimal num_2c( dInitialUnits, iPrecision );
      myLogger.logINFO( num_2b.isValueReadable() ? StringFormat( "Object is GOOD : %s  << Should be: 12.34567", num_2c.toString() )  : "Object is BAD" );

   sTest = "2-d";
      dInitialUnits = 1;
      iPrecision = 15;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_2d <Constructor (PRECISION IS OUT OF BOUNDS/TOO HIGH) { value = %s, precision = %i }>", sTest, sFmtDdp(dInitialUnits, iPrecision), iPrecision ) );
      PHDecimal num_2d( dInitialUnits, iPrecision );  //Too high precision
      myLogger.logINFO( num_2d.isValueReadable() ? StringFormat( "Object is GOOD : %s  ", num_2d.toString() )  : "Object is BAD" );

   sTest = "2-e";
      dInitialUnits = 1;
      iPrecision = -1;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_2e <Constructor (PRECISION IS OUT OF BOUNDS/NEGATIVE/TOO LOW) { value = %s, precision = %i }>", sTest, sFmtDdp(dInitialUnits, iPrecision), iPrecision ) );
      PHDecimal num_2e( dInitialUnits, iPrecision );  //Too low precision
      myLogger.logINFO( num_2e.isValueReadable() ? StringFormat( "Object is GOOD : %s  ", num_2e.toString() )  : "Object is BAD" );

   sTest = "2-f";
      dInitialUnits = 12.9;
      iPrecision = 0;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_2f <Constructor (INT) { value = %s, precision = %i }>", sTest, sFmtDdp(dInitialUnits, iPrecision), iPrecision ) );
      PHDecimal num_2f( dInitialUnits, iPrecision );  //effectively an INT
      myLogger.logINFO( num_2f.isValueReadable() ? StringFormat( "Object is GOOD : %s  ", num_2f.toString() )  : "Object is BAD" );


   // Constructor #2 [Object] (Copy Constructor)
   // PHDecimal::PHDecimal( const PHDecimal& oDecimal );

   sTest = "3";
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_3 <Copy Constructor (Object 'num_2c') { value = %s, precision (unavailable) }>", sTest, num_2c.toString() ) );
      PHDecimal num_3( num_2c );  //"12.34567"
      myLogger.logINFO( num_3.isValueReadable() ? StringFormat( "Object is GOOD : %s", num_3.toString() ) : "Object is BAD"  );


   //<<< Addition >>>
   //       void  PHDecimal::add( const double dAddUnits );
   //4      * addition of (positive) double, same precision
   //4-a    * addition of (positive) double, longer precision (expect rounding)
   //4-b    * addition of (negative) double, same precision
   
      sTest = "4";
      //new Object #4: Constructor#1() + add( double, same precision )
         dInitialUnits = 12.39569;
         iPrecision = 5;
         dAddUnits = 0.00129;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_4 <Constructor#1 { value = %s, precision = %i }>, then ADD <double, same precision> %s...>", sTest, sFmtDdp(dInitialUnits, iPrecision), iPrecision, sFmtDdp(dAddUnits,5)  ) );
         PHDecimal num_4( dInitialUnits, iPrecision );
         num_4.add( dAddUnits );
         myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", sFmtDdp(dAddUnits,iPrecision), num_4.toString() ) : "Object is BAD"  );
         
      sTest = "4-a";
      //continue using Object #4 (previous value): ... + add( negative double, same precision )
         dAddUnits = -23.45678;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_4 <{ value = %s, precision = %i }> ADD < negative double, same precision > %s...>", sTest, num_4.toString(), iPrecision, sFmtDdp(dAddUnits,iPrecision)  ) );
         num_4.add( dAddUnits );
         myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", sFmtDdp(dAddUnits,5), num_4.toString() ) : "Object is BAD"  );
   
      sTest = "4-b";
      //continue using Object #4 (previous value): ... + add( double, longer precision - expect rounding! )
         dAddUnits = 1.23456789;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_4 <{ value = %s, precision = %i }> ADD <double, longer precision (expect rounding)> %s...>", sTest, num_4.toString(), iPrecision, sFmtDdp(dAddUnits,8)  ) );
         num_4.add( dAddUnits );
         myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", sFmtDdp(dAddUnits,8), num_4.toString() ) : "Object is BAD"  );

      sTest = "4-c";
      //continue using Object #4 (previous value): ... + add( double, shorter precision )
         dAddUnits = 21.23;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_4 <{ value = %s, precision = %i }> ADD <double, shorter precision> %s...>", sTest, num_4.toString(), iPrecision, sFmtDdp(dAddUnits,2)  ) );
         num_4.add( dAddUnits );
         myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", sFmtDdp(dAddUnits,8), num_4.toString() ) : "Object is BAD"  );

   //       void PHDecimal::add( cons1t PHDecimal& oAddDecimal );
   //5      * addition of (positive) object, same precision
   //5-a    * addition of (positive) object, different precision (expect error)
   //5-b    * addition of (negative) object, same precision

/* '.add()' has been disabled...
      sTest = "5";
      //continue using Object #4 as base object, new Object #5 <Constructor#1()> will supply Operand to ADD
         dInitialUnits = 127.22222;
         iPrecision = 5;
         PHDecimal num_5( dInitialUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_4 <{ value = %s, precision = %i }>, then <ADD PHDecimal num_5 Constructor#1 { value = %s, same precision } > ...>", sTest, num_4.toString(), iPrecision, num_5.toString()  ) );
         num_4.add( num_5 );
         myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_5.toString(), num_4.toString() ) : "Object is BAD"  );

      sTest = "5-a";
      //continue using Object #4 (previous value): ... + add( negative object, same precision )
         num_5.setValue( -dInitialUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_4 <{ value = %s, precision = %i }>, then <ADD PHDecimal num_5 Constructor#1 { negative value = %s, same precision } > ...>", sTest, num_4.toString(), iPrecision, num_5.toString()  ) );
         num_4.add( num_5 );
         myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_5.toString(), num_4.toString() ) : "Object is BAD"  );
   
      sTest = "5-b";
      //continue using Object #4 (previous object: ... + add( object, longer precision - expect error/invalidated object! )
         dInitialUnits = 1.23456789;
         iNewPrecision = 8;
         num_5.setValue( dInitialUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_4 <{ value = %s, precision = %i }> ADD <PHDecimal num_5 <setValue { value = %s, Precision = %i (longer precision - expect error!)> ...>", sTest, num_4.toString(), iPrecision, sFmtDdp(dAddUnits,iNewPrecision), iNewPrecision   ) );
         num_4.add( num_5 );
         myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_4.toString(), num_5.toString() ) : "Object is BAD"  );
*/ 

   //     void  PHDecimal::arithmeticOperation( const PH_ARITHMETIC_OPERATOR eOp, const PHDecimal& oOperand );
   //6      * addition of (positive) object, same precision
   //6-a    * addition of (positive) object, different precision (expect error)
   //6-b    * addition of (negative) object, same precision

      sTest = "6";
      // new Object #5 <Constructor#1()> as base object, reuse Object #1 to supply Operand to ADD
         dInitialUnits = 12.39569;
         iPrecision = 5;
         PHDecimal num_6( dInitialUnits, iPrecision );
         dAddUnits = 0.00129;
         num_1.setValue( dAddUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_6 <{ value = %s, precision = %i }>, then <ADD PHDecimal num_1 setValue { value = %s, same precision } > ...", sTest, num_6.toString(), iPrecision, num_1.toString()  ) );
         num_6.arithmeticOperation( add, num_1 );
         myLogger.logINFO( num_6.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_1.toString(), num_6.toString() ) : "Object is BAD"  );

      sTest = "6-a";
      //continue using Object #6 (previous value): ... + add( negative object, same precision )
         dAddUnits = -23.45678;
         num_1.setValue( dAddUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_6 <{ value = %s, precision = %i }>, then <ADD PHDecimal num_1 setValue { negative value = %s, same precision } > ...", sTest, num_6.toString(), iPrecision, num_1.toString()  ) );
         num_6.arithmeticOperation( add, num_1 );
         myLogger.logINFO( num_6.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_1.toString(), num_6.toString() ) : "Object is BAD"  );

   
      sTest = "6-b";
      //continue using Object #6 (previous object: ... + add( object, longer precision - expect error/invalidated object! )
         dAddUnits = 1.23456789;
         iNewPrecision = 8;
         num_1.setValue( dAddUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_6 <{ value = %s, precision = %i }> ADD <PHDecimal num_1 <setValue { value = %s, Precision = %i (longer precision - expect error!)> ...", sTest, num_6.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_6.arithmeticOperation( add, num_1 );
         myLogger.logINFO( num_6.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_1.toString(), num_6.toString() ) : "Object is BAD"  );

      sTest = "6-c";
      //continue using Object #6 (previous object: ... + add( object, shorter precision)
         dAddUnits = 21.23;
         iNewPrecision = 2;
         num_1.setValue( dAddUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_6 <{ value = %s, precision = %i }> ADD <PHDecimal num_1 <setValue { value = %s, Precision = %i (shorter precision)> ...", sTest, num_6.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_6.arithmeticOperation( add, num_1 );
         myLogger.logINFO( num_6.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_1.toString(), num_6.toString() ) : "Object is BAD"  );




   //<<< Subtraction >>>
   //       void PHDecimal::subtract( const double  dSubtractUnits );
   //7      * subtract (positive) double, same precision
   //7-a    * subtract (positive) double, longer precision (expect rounding)
   //7-b    * subtract (negative) double, same precision
   
      sTest = "7";
      //new Object #7: Constructor#1() + subtract( double, same precision )
         dInitialUnits = 12.39569;
         iPrecision = 5;
         dSubtractUnits = 0.00124;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_7 <Constructor#1 { value = %s, precision = %i }>, then subtract <double, same precision> %s...", sTest, sFmtDdp(dInitialUnits, iPrecision), iPrecision, sFmtDdp(dSubtractUnits,5)  ) );
         PHDecimal num_7( dInitialUnits, iPrecision );
         num_7.subtract( dSubtractUnits );
         myLogger.logINFO( num_7.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", sFmtDdp(dSubtractUnits,iPrecision), num_7.toString() ) : "Object is BAD"  );
         
      sTest = "7-a";
      //continue using Object #7 (previous value): ... + subtract( negative double, same precision )
         dSubtractUnits = -23.45878;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_7 <{ value = %s, precision = %i }> subtract < negative double, same precision > %s...", sTest, num_7.toString(), iPrecision, sFmtDdp(dSubtractUnits,iPrecision)  ) );
         num_7.subtract( dSubtractUnits );
         myLogger.logINFO( num_7.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", sFmtDdp(dSubtractUnits,5), num_7.toString() ) : "Object is BAD"  );
   
      sTest = "7-b";
      //continue using Object #7 (previous value): ... + subtract( double, longer precision - expect rounding! )
         dSubtractUnits = 1.23458789;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_7 <{ value = %s, precision = %i }> subtract <double, longer precision (expect rounding)> %s...", sTest, num_7.toString(), iPrecision, sFmtDdp(dSubtractUnits,8)  ) );
         num_7.subtract( dSubtractUnits );
         myLogger.logINFO( num_7.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", sFmtDdp(dSubtractUnits,8), num_7.toString() ) : "Object is BAD"  );

      sTest = "7-c";
      //continue using Object #7 (previous value): ... + subtract( double, shorter precision )
         dSubtractUnits = 1.23;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_7 <{ value = %s, precision = %i }> subtract <double, shorter precision> %s...", sTest, num_7.toString(), iPrecision, sFmtDdp(dSubtractUnits,2)  ) );
         num_7.subtract( dSubtractUnits );
         myLogger.logINFO( num_7.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", sFmtDdp(dSubtractUnits,2), num_7.toString() ) : "Object is BAD"  );


   //     void  PHDecimal::arithmeticOperation( const PH_ARITHMETIC_OPERATOR eOp, const PHDecimal& oOperand );
   //8      * subtraction of (positive) object, same precision
   //8-a    * subtraction of (positive) object, different precision (expect error)
   //8-b    * subtraction of (negative) object, same precision

      sTest = "8";
      // new Object #8 <Constructor#1()> as base object, reuse Object #1 to supply Operand to subtract
         dInitialUnits = 12.39569;
         iPrecision = 5;
         PHDecimal num_8( dInitialUnits, iPrecision );
         dSubtractUnits = 0.00124;
         num_1.setValue( dSubtractUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_8 <{ value = %s, precision = %i }>, then <subtract PHDecimal num_1 setValue { value = %s, same precision } > ...", sTest, num_8.toString(), iPrecision, num_1.toString()  ) );
         num_8.arithmeticOperation( subtract, num_1 );
         myLogger.logINFO( num_8.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", num_1.toString(), num_8.toString() ) : "Object is BAD"  );

      sTest = "8-a";
      //continue using Object #8 (previous value): ... + subtract( negative object, same precision )
         dSubtractUnits = -23.45878;
         num_1.setValue( dSubtractUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_8 <{ value = %s, precision = %i }>, then <subtract PHDecimal num_1 setValue { negative value = %s, same precision } > ...", sTest, num_8.toString(), iPrecision, num_1.toString()  ) );
         num_8.arithmeticOperation( subtract, num_1 );
         myLogger.logINFO( num_8.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", num_1.toString(), num_8.toString() ) : "Object is BAD"  );

   
      sTest = "8-b";
      //continue using Object #8 (previous object: ... + subtract( object, longer precision )
         dSubtractUnits = 1.23458789;
         iNewPrecision = 8;
         num_1.setValue( dSubtractUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_8 <{ value = %s, precision = %i }> subtract <PHDecimal num_1 <setValue { value = %s, Precision = %i (longer precision) > ...", sTest, num_8.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_8.arithmeticOperation( subtract, num_1 );
         myLogger.logINFO( num_8.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", num_1.toString(), num_8.toString() ) : "Object is BAD"  );


      sTest = "8-c";
      //continue using Object #8 (previous object: ... + subtract( object, shorter precision )
         dSubtractUnits = 1.23;
         iNewPrecision = 2;
         num_1.setValue( dSubtractUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_8 <{ value = %s, precision = %i }> subtract <PHDecimal num_1 <setValue { value = %s, Precision = %i (longer precision) > ...", sTest, num_8.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_8.arithmeticOperation( subtract, num_1 );
         myLogger.logINFO( num_8.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", num_1.toString(), num_8.toString() ) : "Object is BAD"  );




   //<<< Multiplication >>>
   //       void PHDecimal::multiply( const double  dMultiplicationUnits );
   //9      * Multiply (positive) double, same precision
   //9-a    * Multiply (positive) double, longer precision (expect rounding)
   //9-b    * Multiply (negative) double, same precision
   
      sTest = "9";
      //new Object #9: Constructor#1() + Multiply( double, same precision )
         dInitialUnits = 12.39569;
         iPrecision = 5;
         dMultiplyUnits = 0.00129;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_9 <Constructor#1 { value = %s, precision = %i }>, then Multiply <double, same precision> %s...>", sTest, sFmtDdp(dInitialUnits, iPrecision), iPrecision, sFmtDdp(dMultiplyUnits,5)  ) );
         PHDecimal num_9( dInitialUnits, iPrecision );
         num_9.multiply( dMultiplyUnits );
         myLogger.logINFO( num_9.isValueReadable() ? StringFormat( "Object is GOOD after Multiplying %s = %s", sFmtDdp(dMultiplyUnits,iPrecision), num_9.toString() ) : "Object is BAD"  );
         
      sTest = "9-a";
      //continue using Object #9 (previous value): ... + Multiply( negative double, same precision )
         dMultiplyUnits = -1.59321;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_9 <{ value = %s, precision = %i }> Multiply < negative double, same precision > %s...>", sTest, num_9.toString(), iPrecision, sFmtDdp(dMultiplyUnits,iPrecision)  ) );
         num_9.multiply( dMultiplyUnits );
         myLogger.logINFO( num_9.isValueReadable() ? StringFormat( "Object is GOOD after Multiplying %s = %s", sFmtDdp(dMultiplyUnits,5), num_9.toString() ) : "Object is BAD"  );
   
      sTest = "9-b";
      //continue using Object #9 (previous value): ... + Multiply( double, longer precision - expect rounding! )
         dMultiplyUnits = 1.23456789;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_9 <{ value = %s, precision = %i }> Multiply <double, longer precision (expect rounding)> %s...>", sTest, num_9.toString(), iPrecision, sFmtDdp(dMultiplyUnits,8)  ) );
         num_9.multiply( dMultiplyUnits );
         myLogger.logINFO( num_9.isValueReadable() ? StringFormat( "Object is GOOD after Multiplying %s = %s", sFmtDdp(dMultiplyUnits,8), num_9.toString() ) : "Object is BAD"  );

      sTest = "9-c";
      //continue using Object #9 (previous value): ... + Multiply( double, shorter precision )
         dMultiplyUnits = 1.23;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_9 <{ value = %s, precision = %i }> Multiply <double, longer precision (expect rounding)> %s...>", sTest, num_9.toString(), iPrecision, sFmtDdp(dMultiplyUnits,8)  ) );
         num_9.multiply( dMultiplyUnits );
         myLogger.logINFO( num_9.isValueReadable() ? StringFormat( "Object is GOOD after Multiplying %s = %s", sFmtDdp(dMultiplyUnits,8), num_9.toString() ) : "Object is BAD"  );


   //     void  PHDecimal::arithmeticOperation( const PH_ARITHMETIC_OPERATOR eOp, const PHDecimal& oOperand );
   //10      * multiply (positive) object, same precision
   //10-a    * multiply (positive) object, different precision (expect error)
   //10-b    * multiply (negative) object, same precision

      sTest = "10";
      // new Object #10 <Constructor#1()> as base object, reuse Object #1 to supply Operand to multiply
         dInitialUnits = 12.39569;
         iPrecision = 5;
         PHDecimal num_10( dInitialUnits, iPrecision );
         dMultiplyUnits = 0.00129;
         num_1.setValue( dMultiplyUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_10 <{ value = %s, precision = %i }>, then <multiply PHDecimal num_1 setValue { value = %s, same precision } > ...>", sTest, num_10.toString(), iPrecision, num_1.toString()  ) );
         num_10.arithmeticOperation( multiply, num_1 );
         myLogger.logINFO( num_10.isValueReadable() ? StringFormat( "Object is GOOD after multiplying %s = %s", num_1.toString(), num_10.toString() ) : "Object is BAD"  );

      sTest = "10-a";
      //continue using Object #10 (previous value): ... + multiply( negative object, same precision )
         dMultiplyUnits = -1.59321;
         num_1.setValue( dMultiplyUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_10 <{ value = %s, precision = %i }>, then <multiply PHDecimal num_1 setValue { negative value = %s, same precision } > ...>", sTest, num_10.toString(), iPrecision, num_1.toString()  ) );
         num_10.arithmeticOperation( multiply, num_1 );
         myLogger.logINFO( num_10.isValueReadable() ? StringFormat( "Object is GOOD after multiplying %s = %s", num_1.toString(), num_10.toString() ) : "Object is BAD"  );

      sTest = "10-b";
      //continue using Object #10 (previous object: ... + multiply( object, longer precision - expect error/invalidated object! )
         dMultiplyUnits = 1.23456789;
         iNewPrecision = 8;
         num_1.setValue( dMultiplyUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_10 <{ value = %s, precision = %i }> multiply <PHDecimal num_1 <setValue { value = %s, Precision = %i (longer precision - expect error!)> ...>", sTest, num_10.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_10.arithmeticOperation( multiply, num_1 );
         myLogger.logINFO( num_10.isValueReadable() ? StringFormat( "Object is GOOD after multiplying %s = %s", num_1.toString(), num_10.toString() ) : "Object is BAD"  );

      sTest = "10-c";
      //continue using Object #10 (previous object: ... + multiply( object, short precision )
         dMultiplyUnits = 1.23;
         iNewPrecision = 2;
         num_1.setValue( dMultiplyUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_10 <{ value = %s, precision = %i }> multiply <PHDecimal num_1 <setValue { value = %s, Precision = %i (longer precision - expect error!)> ...>", sTest, num_10.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_10.arithmeticOperation( multiply, num_1 );
         myLogger.logINFO( num_10.isValueReadable() ? StringFormat( "Object is GOOD after multiplying %s = %s", num_1.toString(), num_10.toString() ) : "Object is BAD"  );




  

   //<<< Division >>>
   //       void   PHDecimal::divide( const double  dDivisionUnits );
   //11      * Divide (positive) double, same precision
   //11-a    * Divide (positive) double, longer precision (expect rounding)
   //11-b    * Divide (negative) double, same precision
   
      sTest = "11";
      //new Object #11: Constructor#1() + Divide( double, same precision )
         dInitialUnits = 12.31156;
         iPrecision = 5;
         dDivideUnits = 0.00129;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_11 <Constructor#1 { value = %s, precision = %i }>, then Divide <double, same precision> %s...>", sTest, sFmtDdp(dInitialUnits, iPrecision), iPrecision, sFmtDdp(dDivideUnits,5)  ) );
         PHDecimal num_11( dInitialUnits, iPrecision );
         num_11.divide( dDivideUnits );
         myLogger.logINFO( num_11.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", sFmtDdp(dDivideUnits,iPrecision), num_11.toString() ) : "Object is BAD"  );
         
      sTest = "11-a";
      //continue using Object #11 (previous value): ... + Divide( negative double, same precision )
         dDivideUnits = -1.59321;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_11 <{ value = %s, precision = %i }> Divide < negative double, same precision > %s...>", sTest, num_11.toString(), iPrecision, sFmtDdp(dDivideUnits,iPrecision)  ) );
         num_11.divide( dDivideUnits );
         myLogger.logINFO( num_11.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", sFmtDdp(dDivideUnits,5), num_11.toString() ) : "Object is BAD"  );
   
      sTest = "11-b";
      //continue using Object #11 (previous value): ... + Divide( double, longer precision - expect rounding! )
         dDivideUnits = 1.23456789;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_11 <{ value = %s, precision = %i }> Divide <double, longer precision (expect rounding)> %s...>", sTest, num_11.toString(), iPrecision, sFmtDdp(dDivideUnits,8)  ) );
         num_11.divide( dDivideUnits );
         myLogger.logINFO( num_11.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", sFmtDdp(dDivideUnits,8), num_11.toString() ) : "Object is BAD"  );

      sTest = "11-c";
      //continue using Object #11 (previous value): ... + Divide( double, shorter precision )
         dDivideUnits = 1.23;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_11 <{ value = %s, precision = %i }> Divide <double, shorter precision (expect rounding)> %s...>", sTest, num_11.toString(), iPrecision, sFmtDdp(dDivideUnits,2)  ) );
         num_11.divide( dDivideUnits );
         myLogger.logINFO( num_11.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", sFmtDdp(dDivideUnits,8), num_11.toString() ) : "Object is BAD"  );


   //     void  PHDecimal::arithmeticOperation( const PH_ARITHMETIC_OPERATOR eOp, const PHDecimal& oOperand );
   //12      * Divide (positive) object, same precision
   //12-a    * Divide (positive) object, different precision (expect error)
   //12-b    * Divide (negative) object, same precision

      sTest = "12";
      // new Object #12 <Constructor#1()> as base object, reuse Object #1 to supply Operand to divide
         dInitialUnits = 12.31156;
         iPrecision = 5;
         PHDecimal num_12( dInitialUnits, iPrecision );
         dDivideUnits = 0.00129;
         num_1.setValue( dDivideUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_12 <{ value = %s, precision = %i }>, then <divide PHDecimal num_1 setValue { value = %s, same precision } > ...>", sTest, num_12.toString(), iPrecision, num_1.toString()  ) );
         num_12.arithmeticOperation( divide, num_1 );
         myLogger.logINFO( num_12.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", num_1.toString(), num_12.toString() ) : "Object is BAD"  );

      sTest = "12-a";
      //continue using Object #12 (previous value): ... + divide( negative object, same precision )
         dDivideUnits = -1.59321;
         num_1.setValue( dDivideUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_12 <{ value = %s, precision = %i }>, then <divide PHDecimal num_1 setValue { negative value = %s, same precision } > ...>", sTest, num_12.toString(), iPrecision, num_1.toString()  ) );
         num_12.arithmeticOperation( divide, num_1 );
         myLogger.logINFO( num_12.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", num_1.toString(), num_12.toString() ) : "Object is BAD"  );

      sTest = "12-b";
      //continue using Object #12 (previous object: ... + divide( object, longer precision - expect error/invalidated object! )
         dDivideUnits = 1.23456789;
         iNewPrecision = 8;
         num_1.setValue( dDivideUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_12 <{ value = %s, precision = %i }> divide <PHDecimal num_1 <setValue { value = %s, Precision = %i (longer precision - expect error!)> ...>", sTest, num_12.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_12.arithmeticOperation( divide, num_1 );
         myLogger.logINFO( num_12.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", num_1.toString(), num_12.toString() ) : "Object is BAD"  );

      sTest = "12-c";
      //continue using Object #12 (previous object: ... + divide( object, short precision )
         dDivideUnits = 1.23;
         iNewPrecision = 2;
         num_1.setValue( dDivideUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_12 <{ value = %s, precision = %i }> divide <PHDecimal num_1 <setValue { value = %s, Precision = %i (shorter precision - expect error!)> ...>", sTest, num_12.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_12.arithmeticOperation( divide, num_1 );
         myLogger.logINFO( num_12.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", num_1.toString(), num_12.toString() ) : "Object is BAD"  );




/*


// OVERFLOW:  Max Long value is 9,223,372,036,854,775,807
// This gets me to 9e+14 (900000000000000.00) - I can't seem to get much higher (but that is with 2DPs)
   sTest = "13";
      dInitialUnits = 60000000;
      iPrecision = 2;
      dAddUnits = 10000000;

      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal (MULTIPLY) - Initial: { value = %.8g, precision = %.8g } then MULTIPLY by %.8g, MULTIPLY by %.8g ...>", sTest, dInitialUnits, iPrecision, dAddUnits, dAddUnits_b ) );
      num_1.setValue( dInitialUnits, iPrecision );
      num_1.multiply( dAddUnits );
      //num_1.add( dAddUnits_c );
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after multiplication of (%.8g x %.8g) = %s", dInitialUnits, dAddUnits, num_1.toString() ) : "Object is BAD"  );

      dAddUnits_b = 10;
      num_1.multiply( dAddUnits_b );
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after multiplication : (%.8g x %.8g x %.8g) = %s", dInitialUnits, dAddUnits, dAddUnits_b, num_1.toString() ) : "Object is BAD"  );


/*         




/*
//PERCENT
   sTest = 34;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object", sTest ) );
      PHPercent numPHPercent_BAD(  );
      dNumBAD_Value = numPHPercent_BAD.toNormalizedDouble();
      myLogger.logINFO(  numPHPercent_BAD.isValueReadable() ? StringFormat( "Call on object: %s", numPHPercent_BAD.toString() ) : "Object is BAD" );


   sTest = 35;
      dInitialUnits = 123.45;
      iPrecision = 16;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Constructor #1> { value = %.8g, precision = %.8g } <PRECISION IS OUT OF BOUNDS/TOO HIGH>", sTest, dInitialUnits, iPrecision ) );
      PHPercent numPHPercent_BAD2( dInitialUnits, iPrecision );  //Too high precision
      numPHPercent_BAD2.add( 3 );   //test to confirm that object is bad (will error)
      myLogger.logINFO(  numPHPercent_BAD2.isValueReadable() ? StringFormat( "Call on object: %s", numPHPercent_BAD2.toString() ) : "Object is BAD" );

   sTest = 36;
      dInitialUnits = 123.45;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Constructor #1> { value = %.8g, precision = %.8g }  <FIGURE IS OUT OF RANGE i.e. gt 100% => BAD OBJECT>", sTest, dInitialUnits, iPrecision ) );
      PHPercent numPHPercent_BAD3( dInitialUnits, iPrecision );
      dAddUnits = 3; 
      numPHPercent_BAD3.add( dAddUnits );   //test to confirm that object is bad (will error)
      myLogger.logINFO( numPHPercent_BAD3.isValueReadable() ? StringFormat( "After add of %.8g: Result = %s", dAddUnits, numPHPercent_BAD3.toString() ) : "Object is BAD" );

   sTest = 37;
      dInitialUnits = 45.11;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Constructor #1> { value = %.8g, precision = %.8g } ", sTest, dInitialUnits, iPrecision ) );
      PHPercent numPHPercent_1( dInitialUnits, iPrecision );
      dAddUnits = 3; 
      numPHPercent_1.add( dAddUnits );   //test to confirm that object is bad (will error)
      myLogger.logINFO( numPHPercent_1.isValueReadable() ? StringFormat( "After add of %.8g: Result = %s", dAddUnits, numPHPercent_1.toString() ) : "Object is BAD" );
      myLogger.logINFO( numPHPercent_1.isValueReadable() ? StringFormat( "Percentage: .getFigure() : %.8g", numPHPercent_1.getFigure() ) : "Percentage: .getFigure() - Object is BAD" );
      myLogger.logINFO( numPHPercent_1.isValueReadable() ? StringFormat( "Percentage: getPercent : %.8g", numPHPercent_1.getPercent() ) : "Percentage: .getPercent() - Object is BAD" );

   sTest = 38;
      dInitialUnits = 56.33;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Constructor #1> { value = %.8g, NO precision } <PRECISION SHOULD DEFAULT to 2>", sTest, dInitialUnits ) );
      PHPercent numPHPercent_2( dInitialUnits );
      dAddUnits = 3; 
      numPHPercent_2.add( dAddUnits );   //test to confirm that object is bad (will error)
      myLogger.logINFO( numPHPercent_2.isValueReadable() ? StringFormat( "After add of %.8g: Result = %s", dAddUnits, numPHPercent_2.toString() ) : "Object is BAD" );
      myLogger.logINFO( numPHPercent_2.isValueReadable() ? StringFormat( "Percentage: .getFigure() : %.8g", numPHPercent_2.getFigure() ) : "Percentage: .getFigure() - Object is BAD" );
      myLogger.logINFO( numPHPercent_2.isValueReadable() ? StringFormat( "Percentage: .getPercent : %.8g", numPHPercent_2.getPercent() ) : "Percentage: .getPercent() - Object is BAD" );

   sTest = 39;
      dInitialUnits = 0.33;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Constructor #1> { value = %.8g, NO precision } <WARN ME - DID YOU MEAN %.8g INSTEAD? >", sTest, dInitialUnits, (dInitialUnits*100) ) );
      PHPercent numPHPercent_3( dInitialUnits );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s", numPHPercent_3.toString() ) : "Object is BAD" );

   sTest = 40;
      dInitialUnits = 86.33;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <setValue> { value = %.8g, NO precision }", sTest, dInitialUnits ) );
      numPHPercent_3.setValue( dInitialUnits );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s", numPHPercent_3.toString() ) : "Object is BAD" );
     
   sTest = 41;
      dInitialUnits = 86.1234;
      iPrecision = 4;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <setValue> { value = %.8g, precision = %.8g }", sTest, dInitialUnits, iPrecision ) );
      numPHPercent_3.setValue( dInitialUnits, iPrecision );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s", numPHPercent_3.toString() ) : "Object is BAD" );
*/   



/*

//Demonstrate BAD DOUBLES
   sTest = "10";
      double d1 = 0.1;
      double d2 = 0.2;
      double d3 = 0.3;
      myLogger.logINFO(  StringFormat( "\r\n\nTest %s: BAD DOUBLES: math logic: %.8g + %.8g - %.8g   Result: %.8g", sTest, d1, d2, d3, (d1 + d2 - d3) ) );
      myLogger.logINFO(  StringConcatenate( StringFormat( "\r\n\nTest %s: BAD DOUBLES: bool logic: (%.8g + %.8g) == %.8g   Result: ", sTest, d1, d2, d3 ) , ( (d1+d2) == d3 ) ) );

   //Comparison
   sTest = "10-a";
      dInitialUnits = 0.1;
      iPrecision = 1;
      dAddUnits = 0.2;
      dAddUnits_b = 0.3;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal COMPARE (( %.8g + %.8g ) == %.8g )", sTest, dInitialUnits, dAddUnits, dAddUnits_b ) );

   //new Object #1:    Object#1.setValue( 0.1 ) + add( 0.2 ) + compare( Object#1 == 0.3 )?  (COMPARISON OF AN OBJECT'S VALUE WITH A DOUBLE)
      num_1.setValue( dInitialUnits, iPrecision );
      num_1.add( dAddUnits );
      bNum_res = num_1.compare( dAddUnits_b );
      myLogger.logINFO(  StringConcatenate( StringFormat( "COMPARISON: compare [%.8g + %.8g] == %.8g Result: ", dInitialUnits, dAddUnits, dAddUnits_b), bNum_res ) );
      
   sTest = "10-b";
   //reusing Objects #1 & #2a:    Object#2a.setValue( 0.3 @1DP ) + compare( Object#1 == Object#2a )?  (COMPARISON OF TWO OBJECT VALUES - SAME PRECISION)
      num_2a.setValue( dAddUnits_b, iPrecision );  // units: 0.3, precision: 1
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal COMPARE <object> ( %s == %s ) [Same Precision]", sTest, num_1.toString(), num_2a.toString() ) );
      
      bNum_res = num_1.compare( num_2a );
      myLogger.logINFO( StringConcatenate( "Result after Object comparison : Result = ", bNum_res ) );

   sTest = "10-c";
   //reusing Objects #1 & #2a:    Object#2a.setValue( 0.3 @5DPs ) + compare( Object#1 == Object#2a )?  (COMPARISON OF TWO OBJECT VALUES - DIFFERENT PRECISION)
      num_1.setValue( dAddUnits_b, 5 );  // units: 0.3, precision: 5
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal COMPARE <object> ( %s == %s ) [Diff Precision]", sTest, num_1.toString(), num_2a.toString() ) );
      bNum_res = num_1.compare( num_2a );
      myLogger.logINFO( StringConcatenate( "Result after Object comparison : Result = ", bNum_res ) );

   sTest = "10-d";
   //resuse Object #1 (starting value: "0.3"):    Object#1.subtract( 0.2 ) + compare( Object#1 == zero )?  (COMPARISON OF AN OBJECT'S VALUE WITH ZERO [hard to do with doubles!])
      num_1.subtract( dAddUnits_b );
      myLogger.logINFO(  StringFormat( "\r\n\nTest %s: PHDecimal (should result in zero): [%.8g + %.8g - %.8g] Result: %s", sTest, dInitialUnits, dAddUnits, dAddUnits_b, num_1.toString() ) );


     
     



   //Less Than or Equal To
   sTest = "13-a";    // 25 <= 55 i.e. TRUE
      //Object #1
      dInitialUnits = 25;
      iPrecision = 5;
      num_1.setValue( dInitialUnits, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: \t\t\t\t\t\tPHDecimal (lte) - Initial Object #1: { value = %.8g, precision = %i }", sTest, dInitialUnits, iPrecision ) );

      //Object #2
      dAddUnits = 55;
      PHDecimal num_2();
      num_2.setValue( dAddUnits, iPrecision );  //deliberately using same precision
      myLogger.logINFO( StringFormat( "PHDecimal (lte) - Initial Object #2: { value = %.8g, precision = %i }", dAddUnits, iPrecision ) );

//      bNum_res = num_1.lte( num_2 );
      bNum_res = num_1.relationOperation( eq, num_2 );
      myLogger.logINFO( num_1.isValueReadable() ? StringConcatenate( StringFormat( "Object is GOOD after lte comparison : %s <= %s >>> Result: ", num_1.toString(), num_2.toString() ), bNum_res ) : "Object is BAD"  );


   sTest = "13-b";    // 50 <= 50 i.e. TRUE
      //Object #1
      dInitialUnits = 50;
      iPrecision = 5;
      num_1.setValue( dInitialUnits, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: \t\t\t\t\t\tPHDecimal (lte) - Initial Object #1: { value = %s, precision = %i }", sTest, sFmtDdp(dInitialUnits,iPrecision), iPrecision ) );

      //Object #2
      dAddUnits = 50;
      num_2.setValue( dAddUnits, iPrecision );  //deliberately using same precision
      myLogger.logINFO( StringFormat( "PHDecimal (lte) - Initial Object #2: { value = %.8g, precision = %i }", dAddUnits, iPrecision ) );

//      bNum_res = num_1.lte( num_2 );
      bNum_res = num_1.relationOperation( eq, num_2 );
      myLogger.logINFO( num_1.isValueReadable() ? StringConcatenate( StringFormat( "Object is GOOD after lte comparison : %s <= %s >>> Result: ", num_1.toString(), num_2.toString() ), bNum_res ) : "Object is BAD"  );

   sTest = "13-c";    // 50 <= 45 i.e. FALSE
      //Object #1
      dInitialUnits = 50;
      iPrecision = 5;
      num_1.setValue( dInitialUnits, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: \t\t\t\t\t\tPHDecimal (lte) - Initial Object #1: { value = %s, precision = %i }", sTest, sFmtDdp(dInitialUnits,iPrecision), iPrecision ) );

      //Object #2
      dAddUnits = -45;
      num_2.setValue( dAddUnits, iPrecision );  //deliberately using same precision
      myLogger.logINFO( StringFormat( "PHDecimal (lte) - Initial Object #2: { value = %.8g, precision = %i }", dAddUnits, iPrecision ) );

//      bNum_res = num_1.lte( num_2 );
      bNum_res = num_1.relationOperation( eq, num_2 );
      myLogger.logINFO( num_1.isValueReadable() ? StringConcatenate( StringFormat( "Object is GOOD after lte comparison : %s <= %s >>> Result: ", num_1.toString(), num_2.toString() ), bNum_res ) : "Object is BAD"  );

*/


/*
//<<< PHCurrency >>>    (a PHDecimal, but with a Currency Code, Currency Symbol and a Cash Rounding Step )

// 1. Instantiate an uninitialized object (just like what happens when you embed an Object in a Class structure) - and call a Method
//    Results should return an error
   sTest = "14";
   //New object PHCurrency #1
      myLogger.logINFO( StringFormat( "\r\n\nTest %2: PHCurrency <Default Constructor (#0) { no params } - test .toString() on an uninitialized object", sTest ) );
      PHCurrency numCurrency_1(); // Dummy/uninitialized object
      numCurrency_1.toString();
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1.toString() : %s", numCurrency_1.toString() ) : "Object is BAD" );

// 2. Test 'setValue()' (on existing Object PHCurrency #1) with

//    2a. Supply all params (manditory and optional): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode, [int] iPrecision, [string] sCurrSymbol, [double] dCashRoundingStep 
//        NOT TESTING OUTPUT.  Result should be >>> a fully initialized object
   sTest = "15-a";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = USD;
      iPrecision = 2;
      sCurrSymbol = "$";
      dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <setValue()> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s, Cash Rounding Step: %s }", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol, sFmtDdp(dCashRoundingStep,2) ) );
      numCurrency_1.setValue( dInitialUnits, eCurrCode, iPrecision, sCurrSymbol, dCashRoundingStep ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .setValue(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );


//    2b. Supply all params (except optional Cash Rounding Step): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode, [int] iPrecision, [string] sCurrSymbol
//        NO OUTPUT (note we'll not test Cash Rounding yet, only initialization). Result should be >>> a Cash Rounding Step equivalent to the Precision
   sTest = "15-b";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = EUR;
      iPrecision = 2;
      sCurrSymbol = "€";
      //dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <setValue()> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s (MISSING: Cash Rounding Step }", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol ) );
      numCurrency_1.setValue( dInitialUnits, eCurrCode, iPrecision, sCurrSymbol ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .setValue(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );



//    2c. Supply all params (except optional Currency Symbol, Cash Rounding Step): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode, [int] iPrecision
//        NO OUTPUT. Result should be >>> a Currency Symbol that matches the Currency Code
   sTest = "15-c";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = USD;
      iPrecision = 2;
      //sCurrSymbol = "USD";
      //dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <setValue()> { Units: %s, CurrCode: %s, Precision: %i (MISSING: Curr Symbol, Cash Rounding Step }", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision ) );
      numCurrency_1.setValue( dInitialUnits, eCurrCode, iPrecision ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .setValue(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );


//    2d. Supply only mandatory params (miss out optional Currency Symbol, Cash Rounding Step and iPrecision): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode
//        NO OUTPUT. Result should be >>> a iPrecision of 2 (and check Cash Rounding Step for 0.01 while you're at it)
   sTest = "15-d";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = USD;
      //iPrecision = 2;
      //sCurrSymbol = "USD";
      //dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <setValue()> { Units: %s, CurrCode: %s (MISSING: Precision, Curr Symbol, Cash Rounding Step } - Result should be >>> a iPrecision of 2 (and check Cash Rounding Step for 0.01 while you're at it)", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode) ) );
      numCurrency_1.setValue( dInitialUnits, eCurrCode, iPrecision ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .setValue(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );


// 3. Test '.unset()' on existing Object PHCurrency #1
      sTest = "16";
         //Existing object PHCurrency #1
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <unsetValue()> { }", sTest ) );
         numCurrency_1.unsetValue(); 
         myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .setValue(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );

// 4. Test '.toNormalizeDouble()' with
//    4a. a new Object (value: 123.45, precision: 2)
//        Result should be: "123.45"
      sTest = "17-a";
      //New object PHCurrency #2
         dInitialUnits = 123.19;
         eCurrCode = EUR;
         iPrecision = 2;
         sCurrSymbol = "EUR";
         //dCashRoundingStep = 0.01;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <Parametric Constructor #1> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s (MISSING: Cash Rounding Step }", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol ) );
         PHCurrency numCurrency_2( dInitialUnits, eCurrCode, iPrecision, sCurrSymbol ); 
         myLogger.logINFO(  numCurrency_2.isValueReadable() ? StringFormat( "numCurrency_2.toString() : %s", numCurrency_2.toString() ) : "Object is BAD" );

//    4b. a new Object (value: 123.45, precision: 2, Cash Rounding Step: 0.25)
//        Result should be: "123.50" (rounded up to nearest 0.25)
      sTest = "15-b";
      //New object PHCurrency #3
         dInitialUnits = 123.19;
         eCurrCode = EUR;
         iPrecision = 2;
         sCurrSymbol = "EUR";
         dCashRoundingStep = 0.25;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <Parametric Constructor #1> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s, Cash Rounding Step: %s }", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol, sFmtDdp(dCashRoundingStep,2) ) );
         PHCurrency numCurrency_3( dInitialUnits, eCurrCode, iPrecision, sCurrSymbol, dCashRoundingStep ); 
         myLogger.logINFO(  numCurrency_3.isValueReadable() ? StringFormat( "numCurrency_3.toString() : %s", numCurrency_3.toString() ) : "Object is BAD" );

// 5. Test '.toString()' with
//    5a. Existing Object 2a (where the symbol was supplied)
      //>>>Not required (covered by previous test 31-b)
      
//    5b. Existing Object 2a (where the symbol was not supplied, and it auto-provided the Currency Code)
      //>>>Not required (covered by previous test 29-c)

// 6. Bad enum

      // eCurrCode = EURUSD;     //Bad ENUM (for *this* particular use, anyhow)

      //    NOTES
      //       a) Returns a compiler warning: >>>  implicit conversion from 'enum PH_FX_PAIRS' to 'enum PH_CURR_CODE' <<<  ...when the two enums share the same integer ranges
      //       b) Returns a compiler Error: >>>  'EURUSD' - cannot convert enum <<<  ...when the two enums are given non-overlapping/unique integer ranges



// 7.Copy Constructor
      sTest = "16";
      //reuse object PHCurrency #3  (Result = € 123.19 )
      //New object PHCurrency #4
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <Parametric Constructor #1> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s, Cash Rounding Step: %s }", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol, sFmtDdp(dCashRoundingStep,2) ) );
         PHCurrency numCurrency_4( numCurrency_3 ); 
         myLogger.logINFO(  numCurrency_4.isValueReadable() ? StringFormat( "numCurrency_4.toString() : %s", numCurrency_4.toString() ) : "Object is BAD" );



/*
//<<< Ticks >>>


   sTest = 32;
   sSuffix = "";
   // Object PHTicks #1
   // PHTicks::PHTicks() : _eTickerSymbol(-1), _sTickerSymbol("") {}; 
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHTicks <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object", sTest, sSuffix ) );
      PHTicks numPHTicks_1();
      //dNumBAD_Value = numPHTicks_BAD.toNormalizedDouble();
      myLogger.logINFO(  numPHTicks_1.isValueReadable() ? StringFormat( "Call on object: %s", numPHTicks_1.toString() ) : "Object is BAD" );


   sTest = 33;
   sSuffix = "-a";
   // New object PHTicks #2
   // PHTicks::PHTicks( const PH_FX_PAIRS eTickerSymbol, const double dInitialUnits = -1 ) ...but with only the first (mandatory) parameter
      //dInitialUnits = 105.786;
      eMarketSymbol = USDJPY;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHTicks <Constructor #1> { TickerSymbol: %s, (Units: N/A) } (Partial Set, then call .toString() => BAD ", sTest, sSuffix, EnumToString(eMarketSymbol) ) );
      PHTicks numPHTicks_2( eMarketSymbol );
      myLogger.logINFO(  numPHTicks_2.isValueReadable() ? StringFormat( "numPHTicks_2.toString() : %s", numPHTicks_2.toString() ) : "Object is BAD" );


   sTest = 33;
   sSuffix = "-b";
   // New object PHTicks #3
   // PHTicks::PHTicks( const PH_FX_PAIRS eTickerSymbol, const double dInitialUnits = -1 ) ...with both params  
      dInitialUnits = 105.786;
      eMarketSymbol = USDJPY;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHTicks <Constructor #1> { TickerSymbol: %s, Units: %s  } ", sTest, sSuffix, EnumToString(eMarketSymbol), sFmtDdp(dInitialUnits,3) ) );
      PHTicks numPHTicks_3( eMarketSymbol, dInitialUnits );
      myLogger.logINFO(  numPHTicks_3.isValueReadable() ? StringFormat( "numPHTicks_3.toString() : %s", numPHTicks_3.toString() ) : "Object is BAD" );



   sTest = 34;
   sSuffix = "-a";
   // Reuse existing object PHTicks #1
      //dInitialUnits = 105.786;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHTicks <setValue()> { TickerSymbol: %s, (Units: N/A) } (Partial Set, then call .toString() => BAD ", sTest, sSuffix, EnumToString(eMarketSymbol) ) );
      numPHTicks_1.setValue( eMarketSymbol ); 
      myLogger.logINFO(  numPHTicks_1.isValueReadable() ? StringFormat( "numPHTicks_1.toString() : %s", numPHTicks_1.toString() ) : "Object is BAD" );

   sTest = 34;
   sSuffix = "-b";
   //New object PHTicks #1 (partially set)
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: Now call .calcStopLossWidth_10dATRx3() ", sTest, sSuffix ) );
      numPHTicks_1.calcStopLossWidth_10dATRx3();
      myLogger.logINFO(  numPHTicks_1.isValueReadable() ? StringFormat( "numPHTicks_1.toString() : %s", numPHTicks_1.toString() ) : "Object is BAD" );




/*
<<< OLD >>>>
// PHTicks::PHTicks( const double dTicks, const PH_FX_PAIRS eMarketSymbol );   //Constructor #1 (Elemental)

   sTest = 37;
      //Object PHTicks #1 (Normal)
      dInitialUnits = 1.23456;
      eMarketSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHTicks <Parametric Constructor #1> { Units: %.8g, Symbol: %s } ", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      PHTicks numPHTicks_1( dInitialUnits, eMarketSymbol ); 
      myLogger.logINFO(  numPHTicks_1.isValueReadable() ? StringFormat( "numPHTicks_1.toString() : %s, Object: %s", numPHTicks_1.toString(), numPHTicks_1.objectToString() ) : "Object is BAD" );

   sTest = 38;
      //Object PHTicks #2 (Tick Units are a negative number)
      dInitialUnits = -1.23456;
      eMarketSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHTicks <Parametric Constructor #1> { Units: %.8g, Symbol: %s } ", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      PHTicks numPHTicks_2( dInitialUnits, eMarketSymbol ); 
      myLogger.logINFO(  numPHTicks_2.isValueReadable() ? StringFormat( "numPHTicks_2.toString() : %s, Object: %s", numPHTicks_2.toString(), numPHTicks_2.objectToString() ) : "Object is BAD" );



// PHTicks::PHTicks( const PHTicks& that );     // Constructor #2 (Copy Constructor)

   sTest = 39;
      //Object PHTicks #2 (Tick Units are a negative number)
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHTicks <Parametric Constructor #2> { existing PHTicks object } ", sTest, numPHTicks_BAD.objectToString() ) );
      PHTicks numPHTicks_3( numPHTicks_BAD ); 
      myLogger.logINFO(  numPHTicks_3.isValueReadable() ? StringFormat( "numPHTicks_3.toString() : %s, Object: %s", numPHTicks_3.toString(), numPHTicks_3.objectToString() ) : "Object is BAD" );



// void   PHTicks::calcStopLossWidth_10dATRx3( const PH_FX_PAIRS eMarketSymbol ) ;

   sTest = 40;
      //Object PHTicks #2 (Stop Loss Width: ADTR (10 day) x 3)
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHTicks <Default Constructor { no params } + .calcStopLossWidth_10dATRx3() { Symbol: %s } ", sTest, EnumToString(eMarketSymbol) ) );
      PHTicks numPHTicks_SLW();
      numPHTicks_SLW.calcStopLossWidth_10dATRx3( eMarketSymbol );
      myLogger.logINFO(  numPHTicks_SLW.isValueReadable() ? StringFormat( "numPHTicks_SLW  .toString() : %s, Object: %s", numPHTicks_SLW.toString(), numPHTicks_SLW.objectToString() ) : "Object is BAD" );

*/








/*
//<<< PHCurrDecimal >>>


//PHCurrDecimal::PHCurrDecimal() : _eMarketSymbol( NULL), _sSymbol( NULL), _dCashRoundingStep( NULL), PHDecimal() { } ;   //Construct an UNINITIALIZED object
// and '.toNormalizedDouble()' via '.toString()'
//double PHCurrDecimal::toNormalizedDouble() const;    // Override PHDecimal::toNormalizedDouble()

   sTest = 28;
      //Object PHCurrDecimal #1
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <Default Constructor (#0) { no params } - test .toString() on an uninitialized object", sTest ) );
      PHCurrDecimal numCurrDec_1(); // Dummy/uninitialized object
      numCurrDec_1.toString();
      myLogger.logINFO(  numCurrDec_1.isValueReadable() ? StringFormat( "numCurrDec_1.toString() : %s", numCurrDec_1.toString() ) : "Object is BAD" );

//PHCurrDecimal::PHCurrDecimal( const double dInitialUnits, const PH_FX_PAIRS eMarketSymbol );  // Constructor #1 - The "real" Constructor

   sTest = 29;
      //Object PHCurrDecimal #2
      dInitialUnits = 1.23456;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <Parametric Constructor #1 { Units: %.8g, Symbol: %s } - test .toString()", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      PHCurrDecimal numCurrDec_2( dInitialUnits, eMarketSymbol ); 
      myLogger.logINFO(  numCurrDec_2.isValueReadable() ? StringFormat( "numCurrDec_2.toString() : %s, Object: %s", numCurrDec_2.toString(), numCurrDec_2.objectToString() ) : "Object is BAD" );

//PHCurrDecimal::PHCurrDecimal( const double dInitialUnits, const int iPrecision, const double dCashRoundingStep, const PH_FX_PAIRS eMarketSymbol );  // Constructor #2 - Constructor for tesing Cash Rounding

   sTest = 30;
      //Object PHCurrDecimal #2
      dInitialUnits = 1.11;
      iPrecision = 2;
      dCashRoundingStep = 0.25;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <Parametric Constructor #2 { Units: %.8g, iPrecision: %i, dCashRoundingStep: %.8g, eMarketSymbol: %s } - test .toString()", sTest, dInitialUnits, iPrecision, dCashRoundingStep, EnumToString(eMarketSymbol) ) );
      PHCurrDecimal numCurrDec_3a( dInitialUnits, iPrecision, dCashRoundingStep, eMarketSymbol ); 
      myLogger.logINFO(  numCurrDec_3a.isValueReadable() ? StringFormat( "numCurrDec_3a.toString() : %s << SHOULD ROUND-DOWN TO NEAREST %.8g", numCurrDec_3a.toString(), dCashRoundingStep ) : "Object is BAD" );

   sTest = 31;
      //Object PHCurrDecimal #2
      dInitialUnits = 2.22;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <Parametric Constructor #2 { Units: %.8g, iPrecision: %i, dCashRoundingStep: %.8g, eMarketSymbol: %s } - test .toString()", sTest, dInitialUnits, iPrecision, dCashRoundingStep, EnumToString(eMarketSymbol) ) );
      PHCurrDecimal numCurrDec_3b( dInitialUnits, iPrecision, dCashRoundingStep, eMarketSymbol ); 
      myLogger.logINFO(  numCurrDec_3b.isValueReadable() ? StringFormat( "numCurrDec_3b.toString() : %s << SHOULD ROUND-UP TO NEAREST %.8g", numCurrDec_3b.toString(), dCashRoundingStep ) : "Object is BAD" );


   sTest = 32;
      //Object PHCurrDecimal, then ADD
      dInitialUnits = 123.45;
      iPrecision = 2;
      dAddUnits = 55;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <Parametric Constructor #1 { Units: %.8g, eMarketSymbol: %s } - test .toString()", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      PHCurrDecimal numCurrDec_4( dInitialUnits, eMarketSymbol ); 
      numCurrDec_4.add( dAddUnits );
      myLogger.logINFO(  numCurrDec_4.isValueReadable() ? StringFormat( "numCurrDec_4 after ADD %.8g: Result = %s ", dAddUnits, numCurrDec_4.toString() ) : "Object is BAD" );


// void  PHCurrDecimal::setValue( const double dInitialUnits, const PH_FX_PAIRS eMarketSymbol );

   sTest = 33;
      //Object PHCurrDecimal, then ADD
      dInitialUnits = 123.45;
      iPrecision = 2;
      dAddUnits = 55;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <setValue()> { Units: %.8g, eMarketSymbol: %s } - then ADD &.8g", sTest, dInitialUnits, EnumToString(eMarketSymbol), dAddUnits ) );
      numCurrDec_4.setValue( dInitialUnits, eMarketSymbol ); 
      numCurrDec_4.add( dAddUnits );
      myLogger.logINFO(  numCurrDec_4.isValueReadable() ? StringFormat( "numCurrDec_4 after ADD %.8g: Result = %s ", dAddUnits, numCurrDec_4.toString() ) : "Object is BAD" );
*/



/*
      double dLarge1 = 100000;
      double dSmall1 = 1.2;
      //double dResult1 = dLarge1 + dSmall1 - dLarge1;
      double dResult1 = (double) 100000 + (double) 1.2 - (double) 100000;
      myLogger.logINFO(  StringFormat( "\r\n\ndResult1: %.8g", dResult1 ) );

      double d_a = 100000;
      double d_b = 0.0000000000000000000000001;
      double d_res = d_a + d_b;
      myLogger.logINFO(  StringFormat( "\r\n\nd_res: %.8g", d_res ) );

      double dMedium2 = 362.2;
      double dResult2 = dMedium2 - dMedium2;
      myLogger.logINFO(  StringFormat( "\r\n\ndResult2: %.8g", dResult2 ) );

      
      PHDecimal num_large( 100000, 10 );
      num_large.add( 1.2 );
      num_large.subtract( 100000 );
      num_large.toNormalizedDouble();
      myLogger.logINFO(  "\r\n\nnum_large.toNormalizedDouble(): " + num_large.toString() );
     
  
      
      


//<<< Lots >>>

   double dTestNum = 1.23;
   string sTestNum = string( dTestNum );
   int iDPpos = StringFind( sTestNum, ".", 0 );
   int iDigits = StringLen( sTestNum ) - iDPpos - 1;
   int x = 5;





// PHLots::PHLots() {}; // Constructor #0 

   sTest = 41;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object", sTest ) );
      PHLots numPHLots_BAD();
      dNumBAD_Value = numPHLots_BAD.toNormalizedDouble();
      myLogger.logINFO(  numPHLots_BAD.isValueReadable() ? StringFormat( "Call on object: %s", numPHLots_BAD.toString() ) : "Object is BAD" );

// PHLots::PHLots( const double dLots, const PH_FX_PAIRS eMarketSymbol );


   sTest = 42;    // Instantiate an unitialized PHLots instance
      dInitialUnits = 0.12;
      eMarketSymbol = EURUSD;

      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <Constructor #1> { Units: %.8g, Symbol: %s } << UNINITIALIZED >> ", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      PHLots numPHLots_1( dInitialUnits, eMarketSymbol );
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s, Object: %s", numPHLots_1.toString(), numPHLots_1.objectToString() ) : "Object is BAD" );

   sTest = 43;    // Attempt to set an PHLots instance with 'too many lots'  i.e. > MAX_LOT_SIZE (typically 50.0) - gets errored out
      dInitialUnits = 55;
      eMarketSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <setValue()> { Units: %.8g, Symbol: %s } <<TOO LARGE - GREATER THAN LOTS_MAX_SIZE", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      numPHLots_1.setValue( dInitialUnits, eMarketSymbol ); 
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );

   sTest = 44;    // Attempt to set an PHLots instance with 'too few lots...but gets rounded up to 0.01'  i.e. MIN_LOT_SIZE (typically 0.01)
      dInitialUnits = 0.005;
      eMarketSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <setValue()> { Units: %.8g, Symbol: %s } <<TOO SMALL - ENDS UP BEING ROUNDED TO LOTS_MIN_SIZE", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      numPHLots_1.setValue( dInitialUnits, eMarketSymbol ); // i.e Result = 0.01 (min lot size)
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );

   sTest = 45;
      dInitialUnits = 0.003;    // Attempt to set an PHLots instance with 'too few lots...but gets rounded down (to zero) - gets errored out
      eMarketSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <setValue()> { Units: %.8g, Symbol: %s } <<TOO SMALL - LESS THAN LOTS_MIN_SIZE", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      numPHLots_1.setValue( dInitialUnits, eMarketSymbol ); 
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );

   sTest = 46;
      dInitialUnits = 0.01;    // Attempt to set an PHLots instance with 'too few lots...but gets rounded down (to zero) - gets errored out
      eMarketSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <setValue()> { Units: %.8g, Symbol: %s } <<NORMALIZE INTO LOTS_STEP_SIZE", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      numPHLots_1.setValue( dInitialUnits, eMarketSymbol ); 
      numPHLots_1.multiply( 2.5 ); // result will be 0.025 (unnormalized!)
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );
*/
/*
      sSymbol = "EURUSD";
      dTickValue = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_VALUE );  // MarketInfo(sSymbol, MODE_TICKVALUE );
      dTickSize = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_SIZE );
      dBid_SELL = SymbolInfoDouble( sSymbol, SYMBOL_BID );
      dAsk_BUY = SymbolInfoDouble( sSymbol, SYMBOL_ASK );
      dMargin_1Lot = MarketInfo(sSymbol, MODE_MARGINREQUIRED);  // SymbolInfoDouble( sSymbol, SYMBOL_MARGIN_INITIAL );

      sSymbol = "USDCHF";
      dTickValue = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_VALUE );  // MarketInfo(sSymbol, MODE_TICKVALUE );
      dTickSize = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_SIZE );
      dBid_SELL = SymbolInfoDouble( sSymbol, SYMBOL_BID );
      dAsk_BUY = SymbolInfoDouble( sSymbol, SYMBOL_ASK );
      dMargin_1Lot = MarketInfo(sSymbol, MODE_MARGINREQUIRED);  // SymbolInfoDouble( sSymbol, SYMBOL_MARGIN_INITIAL );
*/
      sSymbol = "CADCHF";
      double CADCHF_TickValue = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_VALUE );  // MarketInfo(sSymbol, MODE_TICKVALUE );
      double CADCHF_TickSize = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_SIZE );
      double CADCHF_Bid_SELL = SymbolInfoDouble( sSymbol, SYMBOL_BID );
      double CADCHF_Ask_BUY = SymbolInfoDouble( sSymbol, SYMBOL_ASK );
      double CADCHF_Margin_1Lot = MarketInfo(sSymbol, MODE_MARGINREQUIRED);  // SymbolInfoDouble( sSymbol, SYMBOL_MARGIN_INITIAL );
      double CADCHF_StdCntSize = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_CONTRACT_SIZE );

      sSymbol = "USDCAD";
      double USDCAD_TickValue = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_VALUE );  // MarketInfo(sSymbol, MODE_TICKVALUE );
      double USDCAD_TickSize = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_SIZE );
      double USDCAD_Bid_SELL = SymbolInfoDouble( sSymbol, SYMBOL_BID );
      double USDCAD_Ask_BUY = SymbolInfoDouble( sSymbol, SYMBOL_ASK );
      double USDCAD_Margin_1Lot = MarketInfo(sSymbol, MODE_MARGINREQUIRED);  // SymbolInfoDouble( sSymbol, SYMBOL_MARGIN_INITIAL );
      double USDCAD_StdCntSize = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_CONTRACT_SIZE );

      sSymbol = "USDJPY";
      double USDJPY_TickValue = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_VALUE );  // MarketInfo(sSymbol, MODE_TICKVALUE );
      double USDJPY_TickSize = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_SIZE );
      double USDJPY_Bid_SELL = SymbolInfoDouble( sSymbol, SYMBOL_BID );
      double USDJPY_Ask_BUY = SymbolInfoDouble( sSymbol, SYMBOL_ASK );
      double USDJPY_Margin_1Lot = MarketInfo(sSymbol, MODE_MARGINREQUIRED);  // SymbolInfoDouble( sSymbol, SYMBOL_MARGIN_INITIAL );
      double USDJPY_StdCntSize = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_CONTRACT_SIZE );

      int x = 5;
/*
   //<<< Dollars>>>
      PHDollar dolls_tooSmall( 0.0078 );
      PHDollar dolls_large( 9999999.99 );
      PHDollar dolls_unNormalized( 1.23456 );
      PHDollar dolls_already_Normalised( 1.56 );
      PHDollar dolls_from_tick1( ticks_negative.tickValueDollarsPerUnit() );
      PHDollar dolls_from_tick2( ticks_negative.tickValueDollarsForGivenNumLots( lots_already_Normalised ) );

      myLogger.logINFO(  "\r\n\ndolls_tooSmall: "           + dolls_tooSmall.toString() );
      myLogger.logINFO(  "dolls_large: "              + dolls_large.toString() );
      myLogger.logINFO(  "dolls_unNormalized: "       + dolls_unNormalized.toString() );
      myLogger.logINFO(  "dolls_already_Normalised: " + dolls_already_Normalised.toString() );
      myLogger.logINFO(  "dolls_from_tick1: " + dolls_from_tick1.toString() );
      myLogger.logINFO(  "dolls_from_tick2: " + dolls_from_tick2.toString() );
*/   


/*
   //Add 'risk' (returns Ticks-width of risk) to PHTicks
   //Size the Lot (given Ticks-width of risk)
   
      PH_FX_PAIRS eDummyVal = -1;
      PH_FX_PAIRS eMarketSymbol = StringToEnum( Symbol(), eDummyVal );

      
      myLogger.logINFO( StringFormat( "<<<PHTicks>>>  value = 1.23456, Symbol: %s", eMarketSymbol ) );
      PHTicks ticks_buyTest( 1.23456, eMarketSymbol );
      string sResult = ticks_buyTest.toString();
      myLogger.logINFO(  StringConcatenate( "ticks_buyTest: ", sResult, "\r\n\n"  ) );

      myLogger.logINFO( StringFormat( "<<<PHTicks>>>  value = TBD, Symbol: %s", eMarketSymbol ) );
      PHTicks ticks_ADTRx10dayCCPriceMoveWidth();
      ticks_ADTRx10dayCCPriceMoveWidth.calcStopLossWidth_10dATRx3( eMarketSymbol );
      sResult = ticks_ADTRx10dayCCPriceMoveWidth.toString();
      myLogger.logINFO(  StringConcatenate( "StopLossWidth_10dATRx3: ", sResult, "\r\n\n"  ) );


/*      
      PHTicks Ticks_StopLossWidth = ticks_buyTest.calcStopLossWidth10dATRx3( Symbol() );
      myLogger.logINFO(  "ticks_buyTest: "       + ticks_buyTest.toString() );
      myLogger.logINFO(  "Ticks_StopLossWidth: " + Ticks_StopLossWidth.toString() );
*/   
  }
//+------------------------------------------------------------------+
