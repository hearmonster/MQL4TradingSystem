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
   
   PH_FX_PAIRS  eMarketSymbol;
   PH_CURR_CODE eCurrCode;   
   string       sSymbol;
   string       sCurrSymbol;

   //PCCurrDecimal
   double dCashRoundingStep;
   
   double dTickValue, dTickSize, dAsk_BUY, dBid_SELL, dMargin_1Lot ;


/*

//<<< PHDecimal >>>

   // Constructor #0 [Default] - creates an invalid object! 
   // PHDecimal::PHDecimal() : _eStatus( OBJECT_UNITIALIZED ), _lUnits( -1 ), _iPrecision( -1 ) {};

   sTest = "1";
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_1 <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object => Result: BAD OBJECT", sTest ) );
      PHDecimal num_1(  );
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD [%s] : %s  << Should be: %s", num_1.toString() )  : "Object is BAD" );
      


   // Constructor #1 [Parametric] (Regular Constructor)
   // PHDecimal::PHDecimal( const double dInitialUnits, const short iPrecision );


   sTest = "2-a";
      dInitialUnits = 12.11;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_2a <Constructor { value = %s, precision = %i }> - STRAIGHTFORWARD: INPUT 2DPs WITH PRECISION OF 2DPs", sTest, sFmtDdp(dInitialUnits, iPrecision), iPrecision ) );
      PHDecimal num_2a( dInitialUnits, iPrecision );
      dNum_Value = num_2a.toNormalizedDouble();
      myLogger.logINFO( num_2a.isValueReadable() ? StringFormat( "Object is GOOD [%s] : %s  << Should be: %s", num_2a.toString(), sFmtDdp(dNum_Value,iPrecision), sFmtDdp(dInitialUnits,iPrecision) )  : "Object is BAD" );

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


   // Constructor #2a [Parametric] (Partial Constructor)
   //void PHDecimal::set( const double dInitialUnits )
   sTest = "3a";
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: New PHDecimal num_3a <Default Constructor {}...then .set() [Partial] { value = %i, precision = NOT SUPPLIED }>  <attempt to set only Units on an uninitialized object => ERROR", sTest, dNum_Value ) );
      dInitialUnits = 123.4567;
      PHDecimal num_3a();
      num_3a.set( dInitialUnits );
      myLogger.logINFO( num_3a.isValueReadable() ? StringFormat( "Object is GOOD : %s", num_3a.toString() ) : "Object is BAD (only Partially Initialized)"  );


   // Constructor #2b [Parametric] (Partial Constructor)
   // PHDecimal::PHDecimal( const short iPrecision );
   sTest = "3b";
      iPrecision = 3;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: New PHDecimal num_3b <Constructor #2 [Partial] { value = N/A, precision = %i }>", sTest, iPrecision ) );
      PHDecimal num_3b( iPrecision );  
      myLogger.logINFO( num_3b.isValueReadable() ? StringFormat( "Object is GOOD : %s", num_3b.toString() ) : "Object is BAD (only Partially Initialized)"  );

   sTest = "3c";
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: Reuse PHDecimal num_3b [Partially Initialized]... then .set() { value = %s } (precision = N/S) >", sTest, sFmtDdp(dInitialUnits, iPrecision)  ) );
      num_3b.set( dInitialUnits );
      myLogger.logINFO( num_3b.isValueReadable() ? StringFormat( "Object is GOOD : %s", num_3b.toString() ) : "Object is BAD (only Partially Initialized)"  );


   // Constructor #3 [Object] (Copy Constructor)
   // PHDecimal::PHDecimal( const PHDecimal& oDecimal );

   sTest = "4";
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: New PHDecimal num_4 <Copy Constructor (Object 'num_2c') { value = %s, precision (unavailable) }>", sTest, num_2c.toString() ) );
      PHDecimal num_4( num_2c );  //"12.34567"
      myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD : %s", num_4.toString() ) : "Object is BAD"  );

/*
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

// '.add()' has been disabled...
//      sTest = "5";
//      //continue using Object #4 as base object, new Object #5 <Constructor#1()> will supply Operand to ADD
//         dInitialUnits = 127.22222;
//         iPrecision = 5;
//         PHDecimal num_5( dInitialUnits, iPrecision );
//         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_4 <{ value = %s, precision = %i }>, then <ADD PHDecimal num_5 Constructor#1 { value = %s, same precision } > ...>", sTest, num_4.toString(), iPrecision, num_5.toString()  ) );
//         num_4.add( num_5 );
//         myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_5.toString(), num_4.toString() ) : "Object is BAD"  );
//
//      sTest = "5-a";
//      //continue using Object #4 (previous value): ... + add( negative object, same precision )
//         num_5.set( -dInitialUnits, iPrecision );
//         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_4 <{ value = %s, precision = %i }>, then <ADD PHDecimal num_5 Constructor#1 { negative value = %s, same precision } > ...>", sTest, num_4.toString(), iPrecision, num_5.toString()  ) );
//         num_4.add( num_5 );
//         myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_5.toString(), num_4.toString() ) : "Object is BAD"  );
//   
//      sTest = "5-b";
//      //continue using Object #4 (previous object: ... + add( object, longer precision - expect error/invalidated object! )
//         dInitialUnits = 1.23456789;
//         iNewPrecision = 8;
//         num_5.set( dInitialUnits, iNewPrecision );
//         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_4 <{ value = %s, precision = %i }> ADD <PHDecimal num_5 <setValue { value = %s, Precision = %i (longer precision - expect error!)> ...>", sTest, num_4.toString(), iPrecision, sFmtDdp(dAddUnits,iNewPrecision), iNewPrecision   ) );
//         num_4.add( num_5 );
//         myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_4.toString(), num_5.toString() ) : "Object is BAD"  );
 

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
         num_1.set( dAddUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_6 <{ value = %s, precision = %i }>, then <ADD PHDecimal num_1 setValue { value = %s, same precision } > ...", sTest, num_6.toString(), iPrecision, num_1.toString()  ) );
         num_6.arithmeticOperation( add, num_1 );
         myLogger.logINFO( num_6.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_1.toString(), num_6.toString() ) : "Object is BAD"  );

      sTest = "6-a";
      //continue using Object #6 (previous value): ... + add( negative object, same precision )
         dAddUnits = -23.45678;
         num_1.set( dAddUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_6 <{ value = %s, precision = %i }>, then <ADD PHDecimal num_1 setValue { negative value = %s, same precision } > ...", sTest, num_6.toString(), iPrecision, num_1.toString()  ) );
         num_6.arithmeticOperation( add, num_1 );
         myLogger.logINFO( num_6.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_1.toString(), num_6.toString() ) : "Object is BAD"  );

   
      sTest = "6-b";
      //continue using Object #6 (previous object: ... + add( object, longer precision - expect error/invalidated object! )
         dAddUnits = 1.23456789;
         iNewPrecision = 8;
         num_1.set( dAddUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_6 <{ value = %s, precision = %i }> ADD <PHDecimal num_1 <setValue { value = %s, Precision = %i (longer precision - expect error!)> ...", sTest, num_6.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_6.arithmeticOperation( add, num_1 );
         myLogger.logINFO( num_6.isValueReadable() ? StringFormat( "Object is GOOD after adding %s = %s", num_1.toString(), num_6.toString() ) : "Object is BAD"  );

      sTest = "6-c";
      //continue using Object #6 (previous object: ... + add( object, shorter precision)
         dAddUnits = 21.23;
         iNewPrecision = 2;
         num_1.set( dAddUnits, iNewPrecision );
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
         num_1.set( dSubtractUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_8 <{ value = %s, precision = %i }>, then <subtract PHDecimal num_1 setValue { value = %s, same precision } > ...", sTest, num_8.toString(), iPrecision, num_1.toString()  ) );
         num_8.arithmeticOperation( subtract, num_1 );
         myLogger.logINFO( num_8.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", num_1.toString(), num_8.toString() ) : "Object is BAD"  );

      sTest = "8-a";
      //continue using Object #8 (previous value): ... + subtract( negative object, same precision )
         dSubtractUnits = -23.45878;
         num_1.set( dSubtractUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_8 <{ value = %s, precision = %i }>, then <subtract PHDecimal num_1 setValue { negative value = %s, same precision } > ...", sTest, num_8.toString(), iPrecision, num_1.toString()  ) );
         num_8.arithmeticOperation( subtract, num_1 );
         myLogger.logINFO( num_8.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", num_1.toString(), num_8.toString() ) : "Object is BAD"  );

   
      sTest = "8-b";
      //continue using Object #8 (previous object: ... + subtract( object, longer precision )
         dSubtractUnits = 1.23458789;
         iNewPrecision = 8;
         num_1.set( dSubtractUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_8 <{ value = %s, precision = %i }> subtract <PHDecimal num_1 <setValue { value = %s, Precision = %i (longer precision) > ...", sTest, num_8.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_8.arithmeticOperation( subtract, num_1 );
         myLogger.logINFO( num_8.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %s = %s", num_1.toString(), num_8.toString() ) : "Object is BAD"  );


      sTest = "8-c";
      //continue using Object #8 (previous object: ... + subtract( object, shorter precision )
         dSubtractUnits = 1.23;
         iNewPrecision = 2;
         num_1.set( dSubtractUnits, iNewPrecision );
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
         num_1.set( dMultiplyUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_10 <{ value = %s, precision = %i }>, then <multiply PHDecimal num_1 setValue { value = %s, same precision } > ...>", sTest, num_10.toString(), iPrecision, num_1.toString()  ) );
         num_10.arithmeticOperation( multiply, num_1 );
         myLogger.logINFO( num_10.isValueReadable() ? StringFormat( "Object is GOOD after multiplying %s = %s", num_1.toString(), num_10.toString() ) : "Object is BAD"  );

      sTest = "10-a";
      //continue using Object #10 (previous value): ... + multiply( negative object, same precision )
         dMultiplyUnits = -1.59321;
         num_1.set( dMultiplyUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_10 <{ value = %s, precision = %i }>, then <multiply PHDecimal num_1 setValue { negative value = %s, same precision } > ...>", sTest, num_10.toString(), iPrecision, num_1.toString()  ) );
         num_10.arithmeticOperation( multiply, num_1 );
         myLogger.logINFO( num_10.isValueReadable() ? StringFormat( "Object is GOOD after multiplying %s = %s", num_1.toString(), num_10.toString() ) : "Object is BAD"  );

      sTest = "10-b";
      //continue using Object #10 (previous object: ... + multiply( object, longer precision - expect error/invalidated object! )
         dMultiplyUnits = 1.23456789;
         iNewPrecision = 8;
         num_1.set( dMultiplyUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_10 <{ value = %s, precision = %i }> multiply <PHDecimal num_1 <setValue { value = %s, Precision = %i (longer precision - expect error!)> ...>", sTest, num_10.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_10.arithmeticOperation( multiply, num_1 );
         myLogger.logINFO( num_10.isValueReadable() ? StringFormat( "Object is GOOD after multiplying %s = %s", num_1.toString(), num_10.toString() ) : "Object is BAD"  );

      sTest = "10-c";
      //continue using Object #10 (previous object: ... + multiply( object, short precision )
         dMultiplyUnits = 1.23;
         iNewPrecision = 2;
         num_1.set( dMultiplyUnits, iNewPrecision );
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
         num_1.set( dDivideUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_12 <{ value = %s, precision = %i }>, then <divide PHDecimal num_1 setValue { value = %s, same precision } > ...>", sTest, num_12.toString(), iPrecision, num_1.toString()  ) );
         num_12.arithmeticOperation( divide, num_1 );
         myLogger.logINFO( num_12.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", num_1.toString(), num_12.toString() ) : "Object is BAD"  );

      sTest = "12-a";
      //continue using Object #12 (previous value): ... + divide( negative object, same precision )
         dDivideUnits = -1.59321;
         num_1.set( dDivideUnits, iPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_12 <{ value = %s, precision = %i }>, then <divide PHDecimal num_1 setValue { negative value = %s, same precision } > ...>", sTest, num_12.toString(), iPrecision, num_1.toString()  ) );
         num_12.arithmeticOperation( divide, num_1 );
         myLogger.logINFO( num_12.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", num_1.toString(), num_12.toString() ) : "Object is BAD"  );

      sTest = "12-b";
      //continue using Object #12 (previous object: ... + divide( object, longer precision - expect error/invalidated object! )
         dDivideUnits = 1.23456789;
         iNewPrecision = 8;
         num_1.set( dDivideUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_12 <{ value = %s, precision = %i }> divide <PHDecimal num_1 <setValue { value = %s, Precision = %i (longer precision - expect error!)> ...>", sTest, num_12.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_12.arithmeticOperation( divide, num_1 );
         myLogger.logINFO( num_12.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", num_1.toString(), num_12.toString() ) : "Object is BAD"  );

      sTest = "12-c";
      //continue using Object #12 (previous object: ... + divide( object, short precision )
         dDivideUnits = 1.23;
         iNewPrecision = 2;
         num_1.set( dDivideUnits, iNewPrecision );
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal num_12 <{ value = %s, precision = %i }> divide <PHDecimal num_1 <setValue { value = %s, Precision = %i (shorter precision - expect error!)> ...>", sTest, num_12.toString(), iPrecision, num_1.toString(), iNewPrecision   ) );
         num_12.arithmeticOperation( divide, num_1 );
         myLogger.logINFO( num_12.isValueReadable() ? StringFormat( "Object is GOOD after dividing %s = %s", num_1.toString(), num_12.toString() ) : "Object is BAD"  );

*/




/*
// OVERFLOW:  Max Long value is 9,223,372,036,854,775,807
// This gets me to 9e+14 (900000000000000.00) - I can't seem to get much higher (but that is with 2DPs)
   sTest = "13";
      dInitialUnits = 4611686018427382500;
      iPrecision = 0;
      dMultiplyUnits = 2;  

      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal (MULTIPLY) - Initial: { value = %.8g, precision = %i } then MULTIPLY by %.8G...>", sTest, dInitialUnits, iPrecision, dMultiplyUnits ) );
      PHDecimal num_13( dInitialUnits, iPrecision );
      num_13.multiply( dMultiplyUnits );
      //num_1.add( dAddUnits_c );
      myLogger.logINFO( num_13.isValueReadable() ? StringFormat( "Object is GOOD after multiplication of (%.8g x %.8g) = %s [%i chars]", dInitialUnits, dMultiplyUnits, num_13.toString(), StringLen(num_13.toString()) ) : "Object is BAD"  );

       
//      dAddUnits = 11264; is good - it actually gets to to one more than the above! (i.e. ...808)
      dAddUnits = 11265;   //flips it over into negative terratory
      num_13.add( dAddUnits );
      myLogger.logINFO( num_13.isValueReadable() ? StringFormat( "Object is GOOD after further multiplication : (%.8g x %.8g + %.8g) = %s [%i chars]", dInitialUnits, dMultiplyUnits, dAddUnits, num_13.toString(),StringLen(num_13.toString()) ) : "Object is BAD"  );

*/



/*
//<<< PERCENT >>>
   sTest = 14;
   // PHPercent::PHPercent() {};

      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHPercent <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object", sTest ) );
      PHPercent numPHPercent_BAD(  );
      myLogger.logINFO(  numPHPercent_BAD.isValueReadable() ? StringFormat( "Call on object: %s", numPHPercent_BAD.toString() ) : "Object is BAD" );


   sTest = 15;
   // PHPercent::PHPercent( const double dFigure, const short iPrecision = _DEFAULT_PERCENTAGE_PRECISION );

      dInitialUnits = 123.45;
      iPrecision = 16;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHPercent <Constructor #1> { value = %s, precision = %i } <PRECISION IS OUT OF BOUNDS/TOO HIGH>", sTest, sFmtDdp(dInitialUnits,8), iPrecision ) );
      PHPercent numPHPercent_BAD2( dInitialUnits, iPrecision );  //Too high precision
      numPHPercent_BAD2.add( 3 );   //test to confirm that object is bad (will error)
      myLogger.logINFO(  numPHPercent_BAD2.isValueReadable() ? StringFormat( "Call on object: %s", numPHPercent_BAD2.toString() ) : "Object is BAD" );

   sTest = 16;
      dInitialUnits = 123.45;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHPercent <Constructor #1> { value = %s, precision = %i }  <FIGURE IS OUT OF RANGE i.e. gt 100% => BAD OBJECT>", sTest, sFmtDdp(dInitialUnits,iPrecision), iPrecision ) );
      PHPercent numPHPercent_BAD3( dInitialUnits, iPrecision );
      dAddUnits = 3; 
      numPHPercent_BAD3.add( dAddUnits );   //test to confirm that object is bad (will error)
      myLogger.logINFO( numPHPercent_BAD3.isValueReadable() ? StringFormat( "After add of %s: Result = %s", sFmtDdp(dAddUnits,iPrecision), numPHPercent_BAD3.toString() ) : "Object is BAD" );

   sTest = 17;
      dInitialUnits = 45.11;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHPercent <Constructor #1 { value = %s, precision = %i }>  <Regular Initialization @ 2DPs, THEN ADD 3.00>", sTest, sFmtDdp(dInitialUnits,iPrecision), iPrecision ) );
      PHPercent numPHPercent_1( dInitialUnits, iPrecision );
      dAddUnits = 3; 
      numPHPercent_1.add( dAddUnits );   //test to confirm that object is bad (will error)
      myLogger.logINFO( numPHPercent_1.isValueReadable() ? StringFormat( "After add of %s: Result = %s", sFmtDdp(dAddUnits,2), numPHPercent_1.toString() ) : "Object is BAD" );
      myLogger.logINFO( numPHPercent_1.isValueReadable() ? StringFormat( "Percentage: .getFigure() : %.8g", numPHPercent_1.getFigure() ) : "Percentage: .getFigure() - Object is BAD" );
      myLogger.logINFO( numPHPercent_1.isValueReadable() ? StringFormat( "Percentage: getPercent : %.8g", numPHPercent_1.getPercent() ) : "Percentage: .getPercent() - Object is BAD" );

   sTest = 18;
      dInitialUnits = 56.33;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHPercent <Constructor #1 { value = %s, NO precision } <PRECISION SHOULD DEFAULT to 2>", sTest, sFmtDdp(dInitialUnits,2) ) );
      PHPercent numPHPercent_2( dInitialUnits );
      dAddUnits = 3; 
      numPHPercent_2.add( dAddUnits );   //test to confirm that object is bad (will error)
      myLogger.logINFO( numPHPercent_2.isValueReadable() ? StringFormat( "After add of %.8g: Result = %s", dAddUnits, numPHPercent_2.toString() ) : "Object is BAD" );
      myLogger.logINFO( numPHPercent_2.isValueReadable() ? StringFormat( "Percentage: .getFigure() : %.8g", numPHPercent_2.getFigure() ) : "Percentage: .getFigure() - Object is BAD" );
      myLogger.logINFO( numPHPercent_2.isValueReadable() ? StringFormat( "Percentage: .getPercent : %.8g", numPHPercent_2.getPercent() ) : "Percentage: .getPercent() - Object is BAD" );

   sTest = 19;
      dInitialUnits = 0.33;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHPercent <Constructor #1 { value = %s, NO precision }> WARN ME - DID YOU MEAN %.8g INSTEAD? >", sTest, sFmtDdp(dInitialUnits,3), (dInitialUnits*100) ) );
      PHPercent numPHPercent_3( dInitialUnits );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s", numPHPercent_3.toString() ) : "Object is probably BAD" );

   sTest = 20;
      dInitialUnits = 86.33;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHPercent <setValue> { value = %.8g, NO precision }", sTest, dInitialUnits ) );
      numPHPercent_3.set( dInitialUnits );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s", numPHPercent_3.toString() ) : "Object is BAD" );
     
   sTest = 21;
      dInitialUnits = 86.1234;
      iPrecision = 4;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHPercent <setValue> { value = %.8g, precision = %.8g }", sTest, dInitialUnits, iPrecision ) );
      numPHPercent_3.set( dInitialUnits, iPrecision );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s", numPHPercent_3.toString() ) : "Object is BAD" );


   sTest = 22;
   // Test of taking PHPercent (20%) of an existing PHDecimal...
   // Reuse num_1.setValue + numPHPercent_3.setValue  (same precision)
      dInitialUnits = 85;
      dAddUnits = 20;  // 20%
      iPrecision = 2;
      num_1.set( dInitialUnits, iPrecision );
      numPHPercent_3.set( dAddUnits, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal <setValue { value = %s, precision = %i }>", sTest, num_1.toString(), iPrecision ) );
      myLogger.logINFO( StringFormat( "Test %s: PHPercent <setValue { value = %s, precision = %i }>", sTest, numPHPercent_3.toString(), iPrecision ) );
      num_1.arithmeticOperation( percent, numPHPercent_3 );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s", num_1.toString() ) : "Object is BAD" );

   sTest = 22;
   // Test of taking PHPercent (20%) of an existing PHDecimal...
   // Reuse num_1.setValue + resuse numPHPercent_3 as is (@ 20%)  (different precision)
      dInitialUnits = 285.2345;
      iNewPrecision = 4;
      num_1.set( dInitialUnits, iNewPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal <setValue { value = %s, precision = %i }>", sTest, num_1.toString(), iNewPrecision ) );
      myLogger.logINFO( StringFormat( "Test %s: PHPercent <setValue { value = %s, precision = %i }>", sTest, numPHPercent_3.toString(), iPrecision ) );
      num_1.arithmeticOperation( percent, numPHPercent_3 );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s << Should be '57.0469'", num_1.toString() ) : "Object is BAD" );

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

   //new Object #1:    Object#1.set( 0.1 ) + add( 0.2 ) + compare( Object#1 == 0.3 )?  (COMPARISON OF AN OBJECT'S VALUE WITH A DOUBLE)
      num_1.set( dInitialUnits, iPrecision );
      num_1.add( dAddUnits );
      bNum_res = num_1.compare( dAddUnits_b );
      myLogger.logINFO(  StringConcatenate( StringFormat( "COMPARISON: compare [%.8g + %.8g] == %.8g Result: ", dInitialUnits, dAddUnits, dAddUnits_b), bNum_res ) );
      
   sTest = "10-b";
   //reusing Objects #1 & #2a:    Object#2a.set( 0.3 @1DP ) + compare( Object#1 == Object#2a )?  (COMPARISON OF TWO OBJECT VALUES - SAME PRECISION)
      num_2a.set( dAddUnits_b, iPrecision );  // units: 0.3, precision: 1
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHDecimal COMPARE <object> ( %s == %s ) [Same Precision]", sTest, num_1.toString(), num_2a.toString() ) );
      
      bNum_res = num_1.compare( num_2a );
      myLogger.logINFO( StringConcatenate( "Result after Object comparison : Result = ", bNum_res ) );

   sTest = "10-c";
   //reusing Objects #1 & #2a:    Object#2a.set( 0.3 @5DPs ) + compare( Object#1 == Object#2a )?  (COMPARISON OF TWO OBJECT VALUES - DIFFERENT PRECISION)
      num_1.set( dAddUnits_b, 5 );  // units: 0.3, precision: 5
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
      num_1.set( dInitialUnits, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: \t\t\t\t\t\tPHDecimal (lte) - Initial Object #1: { value = %.8g, precision = %i }", sTest, dInitialUnits, iPrecision ) );

      //Object #2
      dAddUnits = 55;
      PHDecimal num_2();
      num_2.set( dAddUnits, iPrecision );  //deliberately using same precision
      myLogger.logINFO( StringFormat( "PHDecimal (lte) - Initial Object #2: { value = %.8g, precision = %i }", dAddUnits, iPrecision ) );

//      bNum_res = num_1.lte( num_2 );
      bNum_res = num_1.relationOperation( eq, num_2 );
      myLogger.logINFO( num_1.isValueReadable() ? StringConcatenate( StringFormat( "Object is GOOD after lte comparison : %s <= %s >>> Result: ", num_1.toString(), num_2.toString() ), bNum_res ) : "Object is BAD"  );


   sTest = "13-b";    // 50 <= 50 i.e. TRUE
      //Object #1
      dInitialUnits = 50;
      iPrecision = 5;
      num_1.set( dInitialUnits, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: \t\t\t\t\t\tPHDecimal (lte) - Initial Object #1: { value = %s, precision = %i }", sTest, sFmtDdp(dInitialUnits,iPrecision), iPrecision ) );

      //Object #2
      dAddUnits = 50;
      num_2.set( dAddUnits, iPrecision );  //deliberately using same precision
      myLogger.logINFO( StringFormat( "PHDecimal (lte) - Initial Object #2: { value = %.8g, precision = %i }", dAddUnits, iPrecision ) );

//      bNum_res = num_1.lte( num_2 );
      bNum_res = num_1.relationOperation( eq, num_2 );
      myLogger.logINFO( num_1.isValueReadable() ? StringConcatenate( StringFormat( "Object is GOOD after lte comparison : %s <= %s >>> Result: ", num_1.toString(), num_2.toString() ), bNum_res ) : "Object is BAD"  );

   sTest = "13-c";    // 50 <= 45 i.e. FALSE
      //Object #1
      dInitialUnits = 50;
      iPrecision = 5;
      num_1.set( dInitialUnits, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: \t\t\t\t\t\tPHDecimal (lte) - Initial Object #1: { value = %s, precision = %i }", sTest, sFmtDdp(dInitialUnits,iPrecision), iPrecision ) );

      //Object #2
      dAddUnits = -45;
      num_2.set( dAddUnits, iPrecision );  //deliberately using same precision
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

// 2. Test 'set()' (on existing Object PHCurrency #1) with

//    2a. Supply all params (manditory and optional): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode, [int] iPrecision, [string] sCurrSymbol, [double] dCashRoundingStep 
//        NOT TESTING OUTPUT.  Result should be >>> a fully initialized object
   sTest = "15-a";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = USD;
      iPrecision = 2;
      sCurrSymbol = "$";
      dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <set()> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s, Cash Rounding Step: %s }", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol, sFmtDdp(dCashRoundingStep,2) ) );
      numCurrency_1.set( dInitialUnits, eCurrCode, iPrecision, sCurrSymbol, dCashRoundingStep ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .set(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );


//    2b. Supply all params (except optional Cash Rounding Step): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode, [int] iPrecision, [string] sCurrSymbol
//        NO OUTPUT (note we'll not test Cash Rounding yet, only initialization). Result should be >>> a Cash Rounding Step equivalent to the Precision
   sTest = "15-b";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = EUR;
      iPrecision = 2;
      sCurrSymbol = "€";
      //dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <set()> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s (MISSING: Cash Rounding Step }", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol ) );
      numCurrency_1.set( dInitialUnits, eCurrCode, iPrecision, sCurrSymbol ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .set(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );



//    2c. Supply all params (except optional Currency Symbol, Cash Rounding Step): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode, [int] iPrecision
//        NO OUTPUT. Result should be >>> a Currency Symbol that matches the Currency Code
   sTest = "15-c";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = USD;
      iPrecision = 2;
      //sCurrSymbol = "USD";
      //dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <set()> { Units: %s, CurrCode: %s, Precision: %i (MISSING: Curr Symbol, Cash Rounding Step }", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision ) );
      numCurrency_1.set( dInitialUnits, eCurrCode, iPrecision ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .set(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );


//    2d. Supply only mandatory params (miss out optional Currency Symbol, Cash Rounding Step and iPrecision): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode
//        NO OUTPUT. Result should be >>> a iPrecision of 2 (and check Cash Rounding Step for 0.01 while you're at it)
   sTest = "15-d";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = USD;
      //iPrecision = 2;
      //sCurrSymbol = "USD";
      //dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <set()> { Units: %s, CurrCode: %s (MISSING: Precision, Curr Symbol, Cash Rounding Step } - Result should be >>> a iPrecision of 2 (and check Cash Rounding Step for 0.01 while you're at it)", sTest, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode) ) );
      numCurrency_1.set( dInitialUnits, eCurrCode, iPrecision ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .set(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );


// 3. Test '.unset()' on existing Object PHCurrency #1
      sTest = "16";
         //Existing object PHCurrency #1
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrency <unset()> { }", sTest ) );
         numCurrency_1.unset(); 
         myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .set(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );

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

*/


//<<< Ticks >>>
/*



                     
   //Public Methods


                           // Kinda like a Constructor, except that *it* derives the actual Units itself
                           // Intent: You would call Constructor #1 to construct an partly-initialized object with a Market Symbol, (which in turn sets Precision and Cash Rounding - for a "Tick"!), then call this to set the Units/mark the Object as COMPLETE
         void              PHTicks::calcStopLossWidth_10dATRx3() ;
         string            PHTicks::toString();
         string            PHTicks::PHTicksToStringDump() const { return StringConcatenate( "PHTicks={ Val:",toString(),",TS:",_sTickerSymbol,",P:",_iPrecision,",CRS:",_dCashRoundingStep,",St:", StringSubstr(EnumToString(_eStatus),7,3)," }" ); };
         
   // Protected Methods
   protected:
         virtual void      PHTicks::setValue( const double dInitialUnits, const PH_FX_PAIRS eTickerSymbol, const bool isUnitsSupplied );
*/


/*
//<<< Ticks >>>

   // Default Constructor (empty body: {}) - construct an UNINITIALIZED object (necessary for when you include one in a Structure/Class)
   //PHTicks::PHTicks(); 


      sTest = "50";
      // Object PHTicks #1
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHTicks <Default Constructor { no params }> - test .toNormalizedDouble() on an uninitialized object", sTest ) );
         PHTicks objTicks_1();
         myLogger.logINFO(  objTicks_1.isValueReadable() ? StringFormat( "Call on object: %s", objTicks_1.toString() ) : "Object is BAD" );

   // Parametric Constructor #1 [Elemental] (Regular/Full Constructor) 
   //PHTicks::PHTicks( const double dInitialUnits, const PH_FX_PAIRS eTickerSymbol );

      sTest = "51-a";
         //Object PHTicks #2 (Normal)
         dInitialUnits = 1.23456;
         eMarketSymbol = GBPUSD;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHTicks <Parametric Constructor #1 { Units: %.8g, Symbol: %s }>   <Should be a 5-DP Market> ", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
         PHTicks objTicks_2( dInitialUnits, eMarketSymbol ); 
         myLogger.logINFO(  objTicks_2.isValueReadable() ? StringFormat( "objTicks_2.toString: >>>%s<<<;   PHTicksToStringDump(): >>>%s<<<", objTicks_2.toString(), objTicks_2.PHTicksToStringDump() ) : "Object is BAD" );
 
 
       sTest = "51-b";
      // New object PHTicks #3
         dInitialUnits = 105.786;
         eMarketSymbol = USDJPY;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHTicks <Constructor #1 { Units: %s , TickerSymbol: %s }>   <Should be a 3-DP Market>", sTest, sFmtDdp(dInitialUnits,3), EnumToString(eMarketSymbol) ) );
         PHTicks objTicks_3( dInitialUnits, eMarketSymbol );
         myLogger.logINFO(  objTicks_3.isValueReadable() ? StringFormat( "objTicks_3.PHTicksToStringDump() : %s", objTicks_3.PHTicksToStringDump() ) : "Object is BAD" );

  
      sTest = "51-c";
         //Object PHTicks #4 (Tick Units are a negative number)
         dInitialUnits = -1.23456;
         eMarketSymbol = GBPUSD;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHTicks <Parametric Constructor #1 { Units: %.8g, Symbol: %s }>  <Tick units are negative!> ", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
         PHTicks objTicks_4( dInitialUnits, eMarketSymbol ); 
         myLogger.logINFO(  objTicks_4.isValueReadable() ? StringFormat( "objTicks_4.PHTicksToStringDump() : %s", objTicks_4.PHTicksToStringDump() ) : "Object is BAD" );


   // Parametric Constructor #2 [Elemental] (Partial Constructor) 
   //PHTicks::PHTicks( const PH_FX_PAIRS eTickerSymbol );   

      sTest = "52-a";
      // New object PHTicks #5
         //dInitialUnits = 105.786;
         eMarketSymbol = USDJPY;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHTicks <Constructor #2> { TickerSymbol: %s, (Units: N/A) } (Partial Set, then call .toString() => BAD ", sTest, EnumToString(eMarketSymbol) ) );
         PHTicks objTicks_5( eMarketSymbol );
         myLogger.logINFO(  objTicks_5.isValueReadable() ? StringFormat( "objTicks_5.PHTicksToStringDump() : %s", objTicks_5.PHTicksToStringDump() ) : "Object is BAD (only Partially Initialized)" );
   
   

   // Constructor #3 [Object] (Copy Constructor)
   //PHTicks::PHTicks( const PHTicks& oTick ) : PHCurrency( oTick )

      sTest = "53";
      // New object PHTicks #6, also reuse existing/valid PHTicks #2
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHTicks <Constructor #3 [Object]> ", sTest ) );
         PHTicks objTicks_6( objTicks_2 );
         myLogger.logINFO(  objTicks_6.isValueReadable() ? StringFormat( "ORIGINAL: objTicks_2.PHTicksToStringDump() : %s;   NEW: objTicks_6.PHTicksToStringDump() : %s", objTicks_2.PHTicksToStringDump(), objTicks_6.PHTicksToStringDump() ) : "Object is BAD" );


   // Setter #1 [Elemental] (Regular/Full Constructor) 
   //void PHTicks::set( const double dInitialUnits, const PH_FX_PAIRS eTickerSymbol );

      sTest = "54";
      // Reuse existing object PHTicks #1
         dInitialUnits = 1.23456;
         eMarketSymbol = EURUSD;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHTicks <set() #1 { Units: %.8g, Symbol: %s }>   <Should be a 5-DP Market> ", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
         objTicks_1.set( dInitialUnits, eMarketSymbol ); 
         myLogger.logINFO(  objTicks_1.isValueReadable() ? StringFormat( "objTicks_1.PHTicksToStringDump() : %s", objTicks_2.PHTicksToStringDump() ) : "Object is BAD" );


   // Setter #2 [Elemental] (Partial Constructor) 
   //void PHTicks::set( const PH_FX_PAIRS eTickerSymbol );   
      sTest = "55";
         //dInitialUnits = 105.786;
         eMarketSymbol = EURUSD;
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHTicks <set()> { TickerSymbol: %s, (Units: N/A) } (Partial Set, then call .toString() => BAD ", sTest, EnumToString(eMarketSymbol) ) );
         objTicks_1.set( eMarketSymbol ); 
         myLogger.logINFO(  objTicks_1.isValueReadable() ? StringFormat( "objTicks_1.toString() : %s", objTicks_1.toString() ) : "Object is BAD (only Partially Initialized)" );


   //void PHTicks::calcStopLossWidth_10dATRx3() ;

      sTest = "56-a";
      //New object PHTicks #7 (completely unset)
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: Now call .calcStopLossWidth_10dATRx3() ", sTest ) );
         PHTicks objTicks_7();
         objTicks_7.calcStopLossWidth_10dATRx3();
         myLogger.logINFO(  objTicks_7.isValueReadable() ? StringFormat( "objTicks_7.PHTicksToStringDump() : %s", objTicks_7.PHTicksToStringDump() ) : "Object is BAD" );

      sTest = "56-b";
      //New object PHTicks #8 (partially set)
         myLogger.logINFO( StringFormat( "\r\n\nTest %s: Now call .calcStopLossWidth_10dATRx3() ", sTest ) );
         eMarketSymbol = EURUSD;
         PHTicks objTicks_8( eMarketSymbol );
         objTicks_8.calcStopLossWidth_10dATRx3();
         myLogger.logINFO(  objTicks_8.isValueReadable() ? StringFormat( "objTicks_8.PHTicksToStringDump() : %s", objTicks_8.PHTicksToStringDump() ) : "Object is BAD" );

*/








/*
//<<< PHCurrDecimal >>>


//PHCurrDecimal::PHCurrDecimal() : _eMarketSymbol( NULL), _sSymbol( NULL), _dCashRoundingStep( NULL), PHDecimal() { } ;   //Construct an UNINITIALIZED object
// and '.toNormalizedDouble()' via '.toString()'
//double PHCurrDecimal::toNormalizedDouble() const;    // Override PHDecimal::toNormalizedDouble()

   sTest = 28;
      //Object PHCurrDecimal #1
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrDecimal <Default Constructor (#0) { no params } - test .toString() on an uninitialized object", sTest ) );
      PHCurrDecimal numCurrDec_1(); // Dummy/uninitialized object
      numCurrDec_1.toString();
      myLogger.logINFO(  numCurrDec_1.isValueReadable() ? StringFormat( "numCurrDec_1.toString() : %s", numCurrDec_1.toString() ) : "Object is BAD" );

//PHCurrDecimal::PHCurrDecimal( const double dInitialUnits, const PH_FX_PAIRS eMarketSymbol );  // Constructor #1 - The "real" Constructor

   sTest = 29;
      //Object PHCurrDecimal #2
      dInitialUnits = 1.23456;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrDecimal <Parametric Constructor #1 { Units: %.8g, Symbol: %s } - test .toString()", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      PHCurrDecimal numCurrDec_2( dInitialUnits, eMarketSymbol ); 
      myLogger.logINFO(  numCurrDec_2.isValueReadable() ? StringFormat( "numCurrDec_2.toString() : %s, Object: %s", numCurrDec_2.toString(), numCurrDec_2.objectToString() ) : "Object is BAD" );

//PHCurrDecimal::PHCurrDecimal( const double dInitialUnits, const int iPrecision, const double dCashRoundingStep, const PH_FX_PAIRS eMarketSymbol );  // Constructor #2 - Constructor for tesing Cash Rounding

   sTest = 30;
      //Object PHCurrDecimal #2
      dInitialUnits = 1.11;
      iPrecision = 2;
      dCashRoundingStep = 0.25;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrDecimal <Parametric Constructor #2 { Units: %.8g, iPrecision: %i, dCashRoundingStep: %.8g, eMarketSymbol: %s } - test .toString()", sTest, dInitialUnits, iPrecision, dCashRoundingStep, EnumToString(eMarketSymbol) ) );
      PHCurrDecimal numCurrDec_3a( dInitialUnits, iPrecision, dCashRoundingStep, eMarketSymbol ); 
      myLogger.logINFO(  numCurrDec_3a.isValueReadable() ? StringFormat( "numCurrDec_3a.toString() : %s << SHOULD ROUND-DOWN TO NEAREST %.8g", numCurrDec_3a.toString(), dCashRoundingStep ) : "Object is BAD" );

   sTest = 31;
      //Object PHCurrDecimal #2
      dInitialUnits = 2.22;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrDecimal <Parametric Constructor #2 { Units: %.8g, iPrecision: %i, dCashRoundingStep: %.8g, eMarketSymbol: %s } - test .toString()", sTest, dInitialUnits, iPrecision, dCashRoundingStep, EnumToString(eMarketSymbol) ) );
      PHCurrDecimal numCurrDec_3b( dInitialUnits, iPrecision, dCashRoundingStep, eMarketSymbol ); 
      myLogger.logINFO(  numCurrDec_3b.isValueReadable() ? StringFormat( "numCurrDec_3b.toString() : %s << SHOULD ROUND-UP TO NEAREST %.8g", numCurrDec_3b.toString(), dCashRoundingStep ) : "Object is BAD" );


   sTest = 32;
      //Object PHCurrDecimal, then ADD
      dInitialUnits = 123.45;
      iPrecision = 2;
      dAddUnits = 55;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrDecimal <Parametric Constructor #1 { Units: %.8g, eMarketSymbol: %s } - test .toString()", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      PHCurrDecimal numCurrDec_4( dInitialUnits, eMarketSymbol ); 
      numCurrDec_4.add( dAddUnits );
      myLogger.logINFO(  numCurrDec_4.isValueReadable() ? StringFormat( "numCurrDec_4 after ADD %.8g: Result = %s ", dAddUnits, numCurrDec_4.toString() ) : "Object is BAD" );


// void  PHCurrDecimal::set( const double dInitialUnits, const PH_FX_PAIRS eMarketSymbol );

   sTest = 33;
      //Object PHCurrDecimal, then ADD
      dInitialUnits = 123.45;
      iPrecision = 2;
      dAddUnits = 55;
      eMarketSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHCurrDecimal <set()> { Units: %.8g, eMarketSymbol: %s } - then ADD &.8g", sTest, dInitialUnits, EnumToString(eMarketSymbol), dAddUnits ) );
      numCurrDec_4.set( dInitialUnits, eMarketSymbol ); 
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
     
  
*/      
      


//<<< Lots >>>


// PHLots::PHLots() {}; // Constructor #0 

   sTest = "41";
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHLots <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object", sTest ) );
      PHLots numPHLots_BAD();
      myLogger.logINFO(  numPHLots_BAD.isValueReadable() ? StringFormat( "Call on object: %s", numPHLots_BAD.toString() ) : "Object is BAD" );

// PHLots::PHLots( const double dLots, const PH_FX_PAIRS eMarketSymbol );


   sTest = "42";    // Instantiate an unitialized PHLots instance
      dInitialUnits = 0.12;
      eMarketSymbol = EURUSD;

      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHLots <Constructor #1> { Units: %.8g, Symbol: %s } << UNINITIALIZED >> ", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      PHLots numPHLots_1( dInitialUnits, eMarketSymbol );
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s, Object: %s", numPHLots_1.toString(), numPHLots_1.PHLotsToStringDump() ) : "Object is BAD" );

   sTest = "43";    // Attempt to set an PHLots instance with 'too many lots'  i.e. > MAX_LOT_SIZE (typically 50.0) - gets errored out
      dInitialUnits = 55;
      eMarketSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHLots <set()> { Units: %.8g, Symbol: %s } <<TOO LARGE - GREATER THAN LOTS_MAX_SIZE", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      numPHLots_1.set( dInitialUnits, eMarketSymbol ); 
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );

   sTest = "44";    // Attempt to set an PHLots instance with 'too few lots...but gets rounded up to 0.01'  i.e. MIN_LOT_SIZE (typically 0.01)
      dInitialUnits = 0.005;
      eMarketSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHLots <set()> { Units: %.8g, Symbol: %s } <<SLIGHTLY TOO SMALL - ENDS UP BEING ROUNDED TO LOTS_MIN_SIZE", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      numPHLots_1.set( dInitialUnits, eMarketSymbol ); // i.e Result = 0.01 (min lot size)
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );

   sTest = "45";
      dInitialUnits = 0.003;    // Attempt to set an PHLots instance with 'too few lots...but gets rounded down (to zero) - gets errored out
      eMarketSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHLots <set()> { Units: %.8g, Symbol: %s } <<TOO SMALL - LESS THAN LOTS_MIN_SIZE", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      numPHLots_1.set( dInitialUnits, eMarketSymbol ); 
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );

   sTest = "46";
      dInitialUnits = 0.0273;    // Attempt to set an PHLots instance unnormalized to 2DPs
      eMarketSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHLots <set()> { Units: %.8g, Symbol: %s } <<NORMALIZE INTO LOTS_STEP_SIZE", sTest, dInitialUnits, EnumToString(eMarketSymbol) ) );
      numPHLots_1.set( dInitialUnits, eMarketSymbol ); 
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );


   sTest = "47";
   // sizePercentRiskModel( const PHTicks& oTicks_StopLossWidth, const PHPercent& oPercentageOfEquityToRisk )
      dInitialUnits = 0.0273;    // Attempt to set an PHLots instance unnormalized to 2DPs
      eMarketSymbol = GBPUSD;
      PHTicks tick47( dInitialUnits, eMarketSymbol );
      
      PHPercent percent47( 1, 2 );  // 1% (2DPs)

      myLogger.logINFO( StringFormat( "\r\n\nTest %s: PHLots <sizePercentRiskModel()  PHTick:{ %s }, PHPercent: { %s } ", sTest, tick47.toString(), percent47.toString() ) );

      PHLots lot47( eMarketSymbol );  //Partially initialize
      lot47.sizePercentRiskModel( tick47, percent47 );

      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "lot47.toString() : %s", lot47.toString() ) : "Object is BAD" );


      int Risk = 1;
      double dLotStep = MarketInfo(Symbol(),MODE_LOTSTEP);
      double dMinLot = MarketInfo(Symbol(),MODE_MINLOT);
      double dMaxLot = MarketInfo(Symbol(),MODE_MAXLOT);
      double _lots2 = MathMin(MathMax((MathRound((AccountFreeMargin()*Risk/1000/100)/dLotStep) * dLotStep), dMinLot), dMaxLot);


      double l1 = ((double) Risk)/100;
      double l2 = AccountFreeMargin();
      double l3 = l2*l1;
      double l4 = l3/1000;

      double l5 = (MathRound(l4/dLotStep) * dLotStep);
      double l6 = MathMax(l5, dMinLot);
      double _lotsX = MathMin(l6, dMaxLot);
      
      double _lots = MathMin(MathMax((MathRound((AccountFreeMargin()*Risk/1000/100)/MarketInfo(Symbol(),MODE_LOTSTEP)) * MarketInfo( Symbol(), MODE_LOTSTEP)), MarketInfo(Symbol(),MODE_MINLOT)),MarketInfo(Symbol(),MODE_MAXLOT));

      double dTickValue1 = MarketInfo( Symbol(), MODE_TICKVALUE );
             dTickSize = MarketInfo( Symbol(), MODE_TICKSIZE );
      double dTickValueInUSD  = MarketInfo( Symbol(), MODE_TICKVALUE ) / MarketInfo( Symbol(), MODE_TICKSIZE ); // Note: Using MODE_TICKSIZE, not Point.      
      double dTickValueInUSD2 = 25 / 0.00025;  i.e. each Tick is worth $25, but the TickSize is proprtionately larger

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
