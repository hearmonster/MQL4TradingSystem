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

   PHDecimal oDec_BAD();
   int iPrecision = 2;
   int iTest = 0;
   string sSuffix;
   double dInitialUnits = 12.11;
   double dAddUnits_a = 3;
   double dAddUnits_b = 3;
   double dAddUnits_c = 3;
   double dSubUnits = 3;
   double dMultUnits = 3;
   double dDivUnits = 3;
   
   double dNumBAD_Value;
   
   //PHDecimal num_1;
   double dNum_Value;
   bool   bNum_res;
   
   PH_FX_PAIRS  eSymbol;
   PH_CURR_CODE eCurrCode;   
   string       sSymbol;
   string       sCurrSymbol;

   //PCCurrDecimal
   double dCashRoundingStep;
   
   double dTickValue, dTickSize, dAsk_BUY, dBid_SELL, dMargin_1Lot ;

//<<< PHDecimal >>>

/*
   iTest = 1;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object", iTest ) );
      PHDecimal num_BAD(  );
      dNumBAD_Value = num_BAD.toNormalizedDouble();
      myLogger.logINFO(  num_BAD.isValueReadable() ? StringFormat( "dNumBAD_Value : %.8g", dNumBAD_Value ) : "Object is BAD" );
      

   iTest = 2;
      dInitialUnits = 12.11;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <Constructor { value = %.8g, precision = %.8g }>", iTest, dInitialUnits, iPrecision ) );
      PHDecimal num_1( dInitialUnits, iPrecision );
      dNum_Value = num_1.toNormalizedDouble();
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD [%s] : %.8g  << Should be: %.8g", num_1.objectToString(), dNum_Value, dInitialUnits )  : "Object is BAD" );

   iTest = 3;
      dInitialUnits = 12.119;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <Constructor { value = %.8g, precision = %.8g }>", iTest, dInitialUnits, iPrecision ) );
      PHDecimal num_2( dInitialUnits, iPrecision );
      dNum_Value = num_2.toNormalizedDouble();
      myLogger.logINFO( num_2.isValueReadable() ? StringFormat( "Object is GOOD : %.8g << Should be: 12.12 i.e. rounded up to 2dp", dNum_Value )  : "Object is BAD" );

   iTest = 4;
      dInitialUnits = 12.34567;
      iPrecision = 5;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <Constructor { value = %.8g, precision = %.8g }>", iTest, dInitialUnits, iPrecision ) );
      PHDecimal num_3( dInitialUnits, iPrecision );
      dNum_Value = num_3.toNormalizedDouble();
      myLogger.logINFO( StringFormat( "dNum_Value : %.8g  << Should be: 12.34567", dNum_Value ) );

   iTest = 5;
      dInitialUnits = 1;
      iPrecision = 15;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <Constructor (PRECISION IS OUT OF BOUNDS/TOO HIGH)  value = %.8g, precision = %.8g ", iTest, dInitialUnits, iPrecision ) );
      PHDecimal num_4( dInitialUnits, iPrecision );  //Too high precision
      dNum_Value = num_4.toNormalizedDouble();
      myLogger.logINFO( num_4.isValueReadable() ? StringFormat( "Object is GOOD : %.8g", dNum_Value ) : "Object is BAD"  );

   iTest = 6;
      dInitialUnits = 1;
      iPrecision = -1;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <Constructor (PRECISION IS OUT OF BOUNDS/NEGATIVE/TOO LOW)  value = %.8g, precision = %.8g ", iTest, dInitialUnits, iPrecision ) );
      PHDecimal num_5( dInitialUnits, iPrecision );  //Too low precision
      dNum_Value = num_5.toNormalizedDouble();
      myLogger.logINFO( num_5.isValueReadable() ? StringFormat( "Object is GOOD : %.8g", dNum_Value ) : "Object is BAD"  );

   iTest = 7;
      dInitialUnits = 12.9;
      iPrecision = 0;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <Constructor (INT)  value = %.8g, precision = %.8g ", iTest, dInitialUnits, iPrecision ) );
      PHDecimal num_6( dInitialUnits, iPrecision );  //effectively an INT
      dNum_Value = num_6.toNormalizedDouble();
      myLogger.logINFO( num_6.isValueReadable() ? StringFormat( "Object is GOOD : %.8g", dNum_Value ) : "Object is BAD"  );


//setValue() + Addition (pos number) @2dp
//reusing Object #1
   iTest = 8;
      dInitialUnits = 12.11;
      iPrecision = 2;
      dAddUnits_a = 0.238;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <setValue { value = %.8g, precision = %.8g }>, then ADD <Double> %.8g...>", iTest, dInitialUnits, iPrecision, dAddUnits_a  ) );
      num_1.setValue( dInitialUnits, iPrecision );
      num_1.add( dAddUnits_a );
      dNum_Value = num_1.toNormalizedDouble();
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after adding %.8g: %.8g", dAddUnits_a, dNum_Value ) : "Object is BAD"  );
      
   iTest = 9;
      dAddUnits_a = 0.059;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal ADD <Double> %.8g...>", iTest, dAddUnits_a  ) );
      num_1.add( dAddUnits_a );
      dNum_Value = num_1.toNormalizedDouble();
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after adding %.8g: %.8g", dAddUnits_a, dNum_Value ) : "Object is BAD"  );

   iTest = 10;
      num_2.setValue( 123.45, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal ADD <Object> : (%s + %s) [Same Precision] ...>", iTest, num_1.toString(), num_2.toString()  ) );
      num_1.add( num_2 );
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD.  Result of addition = %s", num_1.toString() ) : "Object is BAD"  );

   iTest = 11;
      num_2.setValue( 123.45, (iPrecision+2) );
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal ADD <Object> : (%s + %s) [Different Precision => Error & Invalid Object] ...>", iTest, num_1.toString(), num_2.toString()  ) );
      num_1.add( num_2 );
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD.  Result of addition = %s", num_1.toString() ) : "Object is BAD"  );

//setValue() + Addition (neg number) @5dp
   iTest = 12;
      iPrecision = 5;
      dAddUnits_a = -0.059;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <setValue { value = %.8g, precision = %.8g }>, then ADD %.8g...>", iTest, dInitialUnits, iPrecision, dAddUnits_a  ) );
      num_1.setValue( dInitialUnits, iPrecision );
      num_1.add( dAddUnits_a );
      dNum_Value = num_1.toNormalizedDouble();
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after adding %.8g: %.8g", dAddUnits_a, dNum_Value ) : "Object is BAD"  );


//setValue() + Subtraction (pos number) @2dp
   iTest = 13;
      dInitialUnits = 12.11;
      iPrecision = 2;
      dSubUnits = 0.238;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <setValue { value = %.8g, precision = %.8g }>, then SUBTRACT %.8g ...>", iTest, dInitialUnits, iPrecision, dSubUnits  ) );
      num_1.setValue( dInitialUnits, iPrecision );
      num_1.subtract( dSubUnits );
      dNum_Value = num_1.toNormalizedDouble();
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %.8g: %.8g", dSubUnits, dNum_Value ) : "Object is BAD"  );

   iTest = 14;
      dSubUnits = 0.059;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal SUBTRACT %.8g ...>", iTest, dSubUnits  ) );
      num_1.subtract( dSubUnits );
      dNum_Value = num_1.toNormalizedDouble();
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %.8g: %.8g", dSubUnits, dNum_Value ) : "Object is BAD"  );

//setValue() + Subtraction (neg number) @5dp
   iTest = 15;
      iPrecision = 5;
      dSubUnits = -0.059;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal <setValue { value = %.8g, precision = %.8g }>, then SUBTRACT %.8g...>", iTest, dInitialUnits, iPrecision, dSubUnits  ) );
      num_1.setValue( dInitialUnits, iPrecision );
      num_1.subtract( dSubUnits );
      dNum_Value = num_1.toNormalizedDouble();
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after subtracting %.8g: %.8g", dSubUnits, dNum_Value ) : "Object is BAD"  );


// Addition to an uninitialized object
//reusing Object BAD
   iTest = 16;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal ADD %.8g to an uninitialized object", iTest, dAddUnits_a  ) );
      num_BAD.add( dAddUnits_a );
      dNum_Value = num_BAD.toNormalizedDouble();
      myLogger.logINFO( num_BAD.isValueReadable() ? StringFormat( "Object is GOOD after adding %.8g: %.8g", dAddUnits_a, dNum_Value ) : "Object is BAD"  );

//Demonstrate BAD DOUBLES
   iTest = 17;
      double d1 = 0.1;
      double d2 = 0.2;
      double d3 = 0.3;
      myLogger.logINFO(  StringFormat( "\r\n\nTest %i: BAD DOUBLES: math logic: %.8g + %.8g - %.8g   Result: %.8g", iTest, d1, d2, d3, (d1 + d2 - d3) ) );
      myLogger.logINFO(  StringConcatenate( StringFormat( "\r\n\nTest %i: BAD DOUBLES: bool logic: (%.8g + %.8g) == %.8g   Result: ", iTest, d1, d2, d3 ) , ( (d1+d2) == d3 ) ) );

   //Comparison
   iTest = 18;
      dInitialUnits = 0.1;
      iPrecision = 1;
      dAddUnits_a = 0.2;
      dAddUnits_b = 0.3;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal COMPARE (( %.8g + %.8g ) == %.8g )", iTest, dInitialUnits, dAddUnits_a, dAddUnits_b ) );
      
      num_1.setValue( dInitialUnits, iPrecision );
      num_1.add( dAddUnits_a );
      bNum_res = num_1.compare( dAddUnits_b );
      myLogger.logINFO(  StringConcatenate( StringFormat( "COMPARISON: compare [%.8g + %.8g] == %.8g Result: ", dInitialUnits, dAddUnits_a, dAddUnits_b), bNum_res ) );
      
   iTest = 19;
      num_2.setValue( dAddUnits_b, iPrecision );  // units: 0.3, precision: 1
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal COMPARE <object> ( %s == %s ) [Same Precision]", iTest, num_1.toString(), num_2.toString() ) );
      
      bNum_res = num_1.compare( num_2 );
      myLogger.logINFO( StringConcatenate( "Result after Object comparison : Result = ", bNum_res ) );

   iTest = 20;
      num_3.setValue( dAddUnits_b, 5 );  // units: 0.3, precision: 5
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal COMPARE <object> ( %s == %s ) [Diff Precision]", iTest, num_1.toString(), num_2.toString() ) );
      bNum_res = num_1.compare( num_3 );
      myLogger.logINFO( StringConcatenate( "Result after Object comparison : Result = ", bNum_res ) );

   iTest = 21;
      num_1.subtract( dAddUnits_b );
      myLogger.logINFO(  StringFormat( "\r\n\nTest %i: PHDecimal (should result in zero): [%.8g + %.8g - %.8g] Result: %s", iTest, dInitialUnits, dAddUnits_a, dAddUnits_b, num_1.toString() ) );


     
     
   //Multiplication
   iTest = 22;
      dInitialUnits = 15;
      iPrecision = 5;
      dAddUnits_a = 20;
      dAddUnits_b = -0.586;

      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal (MULTIPLY) - Initial: { value = %.8g, precision = %.8g } then MULTIPLY by %.8g, MULTIPLY by %.8g ...>", iTest, dInitialUnits, iPrecision, dAddUnits_a, dAddUnits_b ) );
      num_1.setValue( dInitialUnits, iPrecision );
      num_1.multiply( dAddUnits_a );
      num_1.multiply( dAddUnits_b );
      dNum_Value = num_1.toNormalizedDouble();
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after multiplication : %.8g", dNum_Value ) : "Object is BAD"  );
  

   //Division
   iTest = 23;
      dInitialUnits = 25;
      iPrecision = 5;
      dAddUnits_a = 15;
      dAddUnits_b = -0.586;

      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal (DIVIDE) - Initial: { value = %.8g, precision = %.8g } then DIVIDE by %.8g, DIVIDE by %.8g ...>", iTest, dInitialUnits, iPrecision, dAddUnits_a, dAddUnits_b ) );
      num_1.setValue( dInitialUnits, iPrecision );
      num_1.divide( dAddUnits_a );
      num_1.divide( dAddUnits_b );
      dNum_Value = num_1.toNormalizedDouble();
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after division : %.8g", dNum_Value ) : "Object is BAD"  );




// OVERFLOW:  Max Long value is 9,223,372,036,854,775,807
// This gets me to 9e+14 (900000000000000.00) - I can't seem to get much higher (but that is with 2DPs)
   iTest = 24;
      dInitialUnits = 60000000;
      iPrecision = 2;
      dAddUnits_a = 10000000;

      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHDecimal (MULTIPLY) - Initial: { value = %.8g, precision = %.8g } then MULTIPLY by %.8g, MULTIPLY by %.8g ...>", iTest, dInitialUnits, iPrecision, dAddUnits_a, dAddUnits_b ) );
      num_1.setValue( dInitialUnits, iPrecision );
      num_1.multiply( dAddUnits_a );
      //num_1.add( dAddUnits_c );
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after multiplication of (%.8g x %.8g) = %s", dInitialUnits, dAddUnits_a, num_1.toString() ) : "Object is BAD"  );

      dAddUnits_b = 10;
      num_1.multiply( dAddUnits_b );
      myLogger.logINFO( num_1.isValueReadable() ? StringFormat( "Object is GOOD after multiplication : (%.8g x %.8g x %.8g) = %s", dInitialUnits, dAddUnits_a, dAddUnits_b, num_1.toString() ) : "Object is BAD"  );



   //Less Than or Equal To
   iTest = 25;    // 25 <= 55 i.e. TRUE
      //Object #1
      dInitialUnits = 25;
      iPrecision = 5;
      num_1.setValue( dInitialUnits, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: \t\t\t\t\t\tPHDecimal (lte) - Initial Object #1: { value = %.8g, precision = %i }", iTest, dInitialUnits, iPrecision ) );

      //Object #2
      dAddUnits_a = 55;
      num_2.setValue( dAddUnits_a, iPrecision );  //deliberately using same precision
      myLogger.logINFO( StringFormat( "PHDecimal (lte) - Initial Object #2: { value = %.8g, precision = %i }", dAddUnits_a, iPrecision ) );

//      bNum_res = num_1.lte( num_2 );
      bNum_res = num_1.operatorAndOperand( eq, num_2 );
      myLogger.logINFO( num_1.isValueReadable() ? StringConcatenate( StringFormat( "Object is GOOD after lte comparison : %s <= %s >>> Result: ", num_1.toString(), num_2.toString() ), bNum_res ) : "Object is BAD"  );


   iTest = 26;    // 50 <= 50 i.e. TRUE
      //Object #1
      dInitialUnits = 50;
      iPrecision = 5;
      num_1.setValue( dInitialUnits, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: \t\t\t\t\t\tPHDecimal (lte) - Initial Object #1: { value = %.8g, precision = %i }", iTest, dInitialUnits, iPrecision ) );

      //Object #2
      dAddUnits_a = 50;
      num_2.setValue( dAddUnits_a, iPrecision );  //deliberately using same precision
      myLogger.logINFO( StringFormat( "PHDecimal (lte) - Initial Object #2: { value = %.8g, precision = %i }", dAddUnits_a, iPrecision ) );

//      bNum_res = num_1.lte( num_2 );
      bNum_res = num_1.operatorAndOperand( eq, num_2 );
      myLogger.logINFO( num_1.isValueReadable() ? StringConcatenate( StringFormat( "Object is GOOD after lte comparison : %s <= %s >>> Result: ", num_1.toString(), num_2.toString() ), bNum_res ) : "Object is BAD"  );

   iTest = 27;    // 50 <= 45 i.e. FALSE
      //Object #1
      dInitialUnits = 50;
      iPrecision = 5;
      num_1.setValue( dInitialUnits, iPrecision );
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: \t\t\t\t\t\tPHDecimal (lte) - Initial Object #1: { value = %.8g, precision = %i }", iTest, dInitialUnits, iPrecision ) );

      //Object #2
      dAddUnits_a = -45;
      num_2.setValue( dAddUnits_a, iPrecision );  //deliberately using same precision
      myLogger.logINFO( StringFormat( "PHDecimal (lte) - Initial Object #2: { value = %.8g, precision = %i }", dAddUnits_a, iPrecision ) );

//      bNum_res = num_1.lte( num_2 );
      bNum_res = num_1.operatorAndOperand( eq, num_2 );
      myLogger.logINFO( num_1.isValueReadable() ? StringConcatenate( StringFormat( "Object is GOOD after lte comparison : %s <= %s >>> Result: ", num_1.toString(), num_2.toString() ), bNum_res ) : "Object is BAD"  );




//<<< PHCurrency >>>    (a PHDecimal, but with a Currency Code, Currency Symbol and a Cash Rounding Step )

// 1. Instantiate an uninitialized object (just like what happens when you embed an Object in a Class structure) - and call a Method
//    Results should return an error
   iTest = 28;
      //New object PHCurrency #1
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrency <Default Constructor (#0) { no params } - test .toString() on an uninitialized object", iTest ) );
      PHCurrency numCurrency_1(); // Dummy/uninitialized object
      numCurrency_1.toString();
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1.toString() : %s", numCurrency_1.toString() ) : "Object is BAD" );

// 2. Test 'setValue()' (on existing Object PHCurrency #1) with

//    2a. Supply all params (manditory and optional): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode, [int] iPrecision, [string] sCurrSymbol, [double] dCashRoundingStep 
//        NOT TESTING OUTPUT.  Result should be >>> a fully initialized object
   iTest = 29;
   sSuffix = "-a";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = USD;
      iPrecision = 2;
      sCurrSymbol = "$";
      dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHCurrency <setValue()> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s, Cash Rounding Step: %s }", iTest, sSuffix, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol, sFmtDdp(dCashRoundingStep,2) ) );
      numCurrency_1.setValue( dInitialUnits, eCurrCode, iPrecision, sCurrSymbol, dCashRoundingStep ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .setValue(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );


//    2b. Supply all params (except optional Cash Rounding Step): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode, [int] iPrecision, [string] sCurrSymbol
//        NO OUTPUT (note we'll not test Cash Rounding yet, only initialization). Result should be >>> a Cash Rounding Step equivalent to the Precision
   iTest = 29;
   sSuffix = "-b";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = EUR;
      iPrecision = 2;
      sCurrSymbol = "€";
      //dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHCurrency <setValue()> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s (MISSING: Cash Rounding Step }", iTest, sSuffix, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol ) );
      numCurrency_1.setValue( dInitialUnits, eCurrCode, iPrecision, sCurrSymbol ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .setValue(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );



//    2c. Supply all params (except optional Currency Symbol, Cash Rounding Step): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode, [int] iPrecision
//        NO OUTPUT. Result should be >>> a Currency Symbol that matches the Currency Code
   iTest = 29;
   sSuffix = "-c";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = USD;
      iPrecision = 2;
      //sCurrSymbol = "USD";
      //dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHCurrency <setValue()> { Units: %s, CurrCode: %s, Precision: %i (MISSING: Curr Symbol, Cash Rounding Step }", iTest, sSuffix, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision ) );
      numCurrency_1.setValue( dInitialUnits, eCurrCode, iPrecision ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .setValue(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );


//    2d. Supply only mandatory params (miss out optional Currency Symbol, Cash Rounding Step and iPrecision): [double] dInitialUnits, [PH_CURR_CODE] eCurrCode
//        NO OUTPUT. Result should be >>> a iPrecision of 2 (and check Cash Rounding Step for 0.01 while you're at it)
   iTest = 29;
   sSuffix = "-d";
      //Existing object PHCurrency #1
      dInitialUnits = 123.45;
      eCurrCode = USD;
      //iPrecision = 2;
      //sCurrSymbol = "USD";
      //dCashRoundingStep = 0.01;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHCurrency <setValue()> { Units: %s, CurrCode: %s (MISSING: Precision, Curr Symbol, Cash Rounding Step } - Result should be >>> a iPrecision of 2 (and check Cash Rounding Step for 0.01 while you're at it)", iTest, sSuffix, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode) ) );
      numCurrency_1.setValue( dInitialUnits, eCurrCode, iPrecision ); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .setValue(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );


// 3. Test '.unset()' on existing Object PHCurrency #1
   iTest = 30;
   sSuffix = "";
      //Existing object PHCurrency #1
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHCurrency <unsetValue()> { }", iTest, sSuffix ) );
      numCurrency_1.unsetValue(); 
      myLogger.logINFO(  numCurrency_1.isValueReadable() ? StringFormat( "numCurrency_1 after .setValue(): Result = %s ", numCurrency_1.toString() ) : "Object is BAD" );

// 4. Test '.toNormalizeDouble()' with
//    4a. a new Object (value: 123.45, precision: 2)
//        Result should be: "123.45"
      iTest = 31;
      sSuffix = "-a";
         //New object PHCurrency #2
         dInitialUnits = 123.19;
         eCurrCode = EUR;
         iPrecision = 2;
         sCurrSymbol = "EUR";
         //dCashRoundingStep = 0.01;
         myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHCurrency <Parametric Constructor #1> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s (MISSING: Cash Rounding Step }", iTest, sSuffix, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol ) );
         PHCurrency numCurrency_2( dInitialUnits, eCurrCode, iPrecision, sCurrSymbol ); 
         myLogger.logINFO(  numCurrency_2.isValueReadable() ? StringFormat( "numCurrency_2.toString() : %s", numCurrency_2.toString() ) : "Object is BAD" );

//    4b. a new Object (value: 123.45, precision: 2, Cash Rounding Step: 0.25)
//        Result should be: "123.50" (rounded up to nearest 0.25)
      iTest = 31;
      sSuffix = "-b";
         //New object PHCurrency #3
         dInitialUnits = 123.19;
         eCurrCode = EUR;
         iPrecision = 2;
         sCurrSymbol = "EUR";
         dCashRoundingStep = 0.25;
         myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHCurrency <Parametric Constructor #1> { Units: %s, CurrCode: %s, Precision: %i, CurrSymbol: %s, Cash Rounding Step: %s }", iTest, sSuffix, sFmtDdp(dInitialUnits,5), EnumToString(eCurrCode), iPrecision, sCurrSymbol, sFmtDdp(dCashRoundingStep,2) ) );
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

*/


//<<< Ticks >>>

// PHTicks::PHTicks(); // Constructor #0 - creates an invalid object! See my notes regarding "DUMMY Constructor #0" below on why I'm doing this...

   iTest = 32;
   sSuffix = "";
   //Object PHTicks #1
      myLogger.logINFO( StringFormat( "\r\n\nTest %i%s: PHTicks <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object", iTest, sSuffix ) );
      PHTicks numPHTicks_1();
      //dNumBAD_Value = numPHTicks_BAD.toNormalizedDouble();
      myLogger.logINFO(  numPHTicks_1.isValueReadable() ? StringFormat( "Call on object: %s", numPHTicks_1.toString() ) : "Object is BAD" );


   iTest = 33;
   sSuffix = "-a";
   //Existing object PHTicks #1
      //dInitialUnits = 105.786;
      eSymbol = USDJPY;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHTicks <setValue()> { TickerSymbol: %s, (Units: N/A)  } ", iTest, EnumToString(eSymbol) ) );
      numPHTicks_1.setValue( dInitialUnits, eSymbol ); 
      myLogger.logINFO(  numPHTicks_1.isValueReadable() ? StringFormat( "numPHTicks_1.toString() : %s", numPHTicks_1.toString() ) : "Object is BAD" );

   iTest = 33;
   sSuffix = "-b";
   //New object PHTicks #2
      dInitialUnits = 105.786;
      eSymbol = USDJPY;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHTicks <Constructor #2> { TickerSymbol: %s, (Units: N/A)  } >>> .calcStopLossWidth_10dATRx3() ", iTest, EnumToString(eSymbol) ) );
      PHTicks numPHTicks_2( eSymbol );
      numPHTicks_2.calcStopLossWidth_10dATRx3();
      myLogger.logINFO(  numPHTicks_2.isValueReadable() ? StringFormat( "numPHTicks_2.toString() : %s", numPHTicks_2.toString() ) : "Object is BAD" );




/*

// PHTicks::PHTicks( const double dTicks, const PH_FX_PAIRS eSymbol );   //Constructor #1 (Elemental)

   iTest = 37;
      //Object PHTicks #1 (Normal)
      dInitialUnits = 1.23456;
      eSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHTicks <Parametric Constructor #1> { Units: %.8g, Symbol: %s } ", iTest, dInitialUnits, EnumToString(eSymbol) ) );
      PHTicks numPHTicks_1( dInitialUnits, eSymbol ); 
      myLogger.logINFO(  numPHTicks_1.isValueReadable() ? StringFormat( "numPHTicks_1.toString() : %s, Object: %s", numPHTicks_1.toString(), numPHTicks_1.objectToString() ) : "Object is BAD" );

   iTest = 38;
      //Object PHTicks #2 (Tick Units are a negative number)
      dInitialUnits = -1.23456;
      eSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHTicks <Parametric Constructor #1> { Units: %.8g, Symbol: %s } ", iTest, dInitialUnits, EnumToString(eSymbol) ) );
      PHTicks numPHTicks_2( dInitialUnits, eSymbol ); 
      myLogger.logINFO(  numPHTicks_2.isValueReadable() ? StringFormat( "numPHTicks_2.toString() : %s, Object: %s", numPHTicks_2.toString(), numPHTicks_2.objectToString() ) : "Object is BAD" );



// PHTicks::PHTicks( const PHTicks& that );     // Constructor #2 (Copy Constructor)

   iTest = 39;
      //Object PHTicks #2 (Tick Units are a negative number)
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHTicks <Parametric Constructor #2> { existing PHTicks object } ", iTest, numPHTicks_BAD.objectToString() ) );
      PHTicks numPHTicks_3( numPHTicks_BAD ); 
      myLogger.logINFO(  numPHTicks_3.isValueReadable() ? StringFormat( "numPHTicks_3.toString() : %s, Object: %s", numPHTicks_3.toString(), numPHTicks_3.objectToString() ) : "Object is BAD" );



// void   PHTicks::calcStopLossWidth_10dATRx3( const PH_FX_PAIRS eSymbol ) ;

   iTest = 40;
      //Object PHTicks #2 (Stop Loss Width: ADTR (10 day) x 3)
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHTicks <Default Constructor { no params } + .calcStopLossWidth_10dATRx3() { Symbol: %s } ", iTest, EnumToString(eSymbol) ) );
      PHTicks numPHTicks_SLW();
      numPHTicks_SLW.calcStopLossWidth_10dATRx3( eSymbol );
      myLogger.logINFO(  numPHTicks_SLW.isValueReadable() ? StringFormat( "numPHTicks_SLW  .toString() : %s, Object: %s", numPHTicks_SLW.toString(), numPHTicks_SLW.objectToString() ) : "Object is BAD" );

*/








/*
//<<< PHCurrDecimal >>>


//PHCurrDecimal::PHCurrDecimal() : _eSymbol( NULL), _sSymbol( NULL), _dCashRoundingStep( NULL), PHDecimal() { } ;   //Construct an UNINITIALIZED object
// and '.toNormalizedDouble()' via '.toString()'
//double PHCurrDecimal::toNormalizedDouble() const;    // Override PHDecimal::toNormalizedDouble()

   iTest = 28;
      //Object PHCurrDecimal #1
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <Default Constructor (#0) { no params } - test .toString() on an uninitialized object", iTest ) );
      PHCurrDecimal numCurrDec_1(); // Dummy/uninitialized object
      numCurrDec_1.toString();
      myLogger.logINFO(  numCurrDec_1.isValueReadable() ? StringFormat( "numCurrDec_1.toString() : %s", numCurrDec_1.toString() ) : "Object is BAD" );

//PHCurrDecimal::PHCurrDecimal( const double dInitialUnits, const PH_FX_PAIRS eSymbol );  // Constructor #1 - The "real" Constructor

   iTest = 29;
      //Object PHCurrDecimal #2
      dInitialUnits = 1.23456;
      eSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <Parametric Constructor #1 { Units: %.8g, Symbol: %s } - test .toString()", iTest, dInitialUnits, EnumToString(eSymbol) ) );
      PHCurrDecimal numCurrDec_2( dInitialUnits, eSymbol ); 
      myLogger.logINFO(  numCurrDec_2.isValueReadable() ? StringFormat( "numCurrDec_2.toString() : %s, Object: %s", numCurrDec_2.toString(), numCurrDec_2.objectToString() ) : "Object is BAD" );

//PHCurrDecimal::PHCurrDecimal( const double dInitialUnits, const int iPrecision, const double dCashRoundingStep, const PH_FX_PAIRS eSymbol );  // Constructor #2 - Constructor for tesing Cash Rounding

   iTest = 30;
      //Object PHCurrDecimal #2
      dInitialUnits = 1.11;
      iPrecision = 2;
      dCashRoundingStep = 0.25;
      eSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <Parametric Constructor #2 { Units: %.8g, iPrecision: %i, dCashRoundingStep: %.8g, eSymbol: %s } - test .toString()", iTest, dInitialUnits, iPrecision, dCashRoundingStep, EnumToString(eSymbol) ) );
      PHCurrDecimal numCurrDec_3a( dInitialUnits, iPrecision, dCashRoundingStep, eSymbol ); 
      myLogger.logINFO(  numCurrDec_3a.isValueReadable() ? StringFormat( "numCurrDec_3a.toString() : %s << SHOULD ROUND-DOWN TO NEAREST %.8g", numCurrDec_3a.toString(), dCashRoundingStep ) : "Object is BAD" );

   iTest = 31;
      //Object PHCurrDecimal #2
      dInitialUnits = 2.22;
      eSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <Parametric Constructor #2 { Units: %.8g, iPrecision: %i, dCashRoundingStep: %.8g, eSymbol: %s } - test .toString()", iTest, dInitialUnits, iPrecision, dCashRoundingStep, EnumToString(eSymbol) ) );
      PHCurrDecimal numCurrDec_3b( dInitialUnits, iPrecision, dCashRoundingStep, eSymbol ); 
      myLogger.logINFO(  numCurrDec_3b.isValueReadable() ? StringFormat( "numCurrDec_3b.toString() : %s << SHOULD ROUND-UP TO NEAREST %.8g", numCurrDec_3b.toString(), dCashRoundingStep ) : "Object is BAD" );


   iTest = 32;
      //Object PHCurrDecimal, then ADD
      dInitialUnits = 123.45;
      iPrecision = 2;
      dAddUnits_a = 55;
      eSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <Parametric Constructor #1 { Units: %.8g, eSymbol: %s } - test .toString()", iTest, dInitialUnits, EnumToString(eSymbol) ) );
      PHCurrDecimal numCurrDec_4( dInitialUnits, eSymbol ); 
      numCurrDec_4.add( dAddUnits_a );
      myLogger.logINFO(  numCurrDec_4.isValueReadable() ? StringFormat( "numCurrDec_4 after ADD %.8g: Result = %s ", dAddUnits_a, numCurrDec_4.toString() ) : "Object is BAD" );


// void  PHCurrDecimal::setValue( const double dInitialUnits, const PH_FX_PAIRS eSymbol );

   iTest = 33;
      //Object PHCurrDecimal, then ADD
      dInitialUnits = 123.45;
      iPrecision = 2;
      dAddUnits_a = 55;
      eSymbol = EURUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHCurrDecimal <setValue()> { Units: %.8g, eSymbol: %s } - then ADD &.8g", iTest, dInitialUnits, EnumToString(eSymbol), dAddUnits_a ) );
      numCurrDec_4.setValue( dInitialUnits, eSymbol ); 
      numCurrDec_4.add( dAddUnits_a );
      myLogger.logINFO(  numCurrDec_4.isValueReadable() ? StringFormat( "numCurrDec_4 after ADD %.8g: Result = %s ", dAddUnits_a, numCurrDec_4.toString() ) : "Object is BAD" );
*/


/*
//PERCENT
   iTest = 34;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object", iTest ) );
      PHPercent numPHPercent_BAD(  );
      dNumBAD_Value = numPHPercent_BAD.toNormalizedDouble();
      myLogger.logINFO(  numPHPercent_BAD.isValueReadable() ? StringFormat( "Call on object: %s", numPHPercent_BAD.toString() ) : "Object is BAD" );


   iTest = 35;
      dInitialUnits = 123.45;
      iPrecision = 16;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Constructor #1> { value = %.8g, precision = %.8g } <PRECISION IS OUT OF BOUNDS/TOO HIGH>", iTest, dInitialUnits, iPrecision ) );
      PHPercent numPHPercent_BAD2( dInitialUnits, iPrecision );  //Too high precision
      numPHPercent_BAD2.add( 3 );   //test to confirm that object is bad (will error)
      myLogger.logINFO(  numPHPercent_BAD2.isValueReadable() ? StringFormat( "Call on object: %s", numPHPercent_BAD2.toString() ) : "Object is BAD" );

   iTest = 36;
      dInitialUnits = 123.45;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Constructor #1> { value = %.8g, precision = %.8g }  <FIGURE IS OUT OF RANGE i.e. gt 100% => BAD OBJECT>", iTest, dInitialUnits, iPrecision ) );
      PHPercent numPHPercent_BAD3( dInitialUnits, iPrecision );
      dAddUnits_a = 3; 
      numPHPercent_BAD3.add( dAddUnits_a );   //test to confirm that object is bad (will error)
      myLogger.logINFO( numPHPercent_BAD3.isValueReadable() ? StringFormat( "After add of %.8g: Result = %s", dAddUnits_a, numPHPercent_BAD3.toString() ) : "Object is BAD" );

   iTest = 37;
      dInitialUnits = 45.11;
      iPrecision = 2;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Constructor #1> { value = %.8g, precision = %.8g } ", iTest, dInitialUnits, iPrecision ) );
      PHPercent numPHPercent_1( dInitialUnits, iPrecision );
      dAddUnits_a = 3; 
      numPHPercent_1.add( dAddUnits_a );   //test to confirm that object is bad (will error)
      myLogger.logINFO( numPHPercent_1.isValueReadable() ? StringFormat( "After add of %.8g: Result = %s", dAddUnits_a, numPHPercent_1.toString() ) : "Object is BAD" );
      myLogger.logINFO( numPHPercent_1.isValueReadable() ? StringFormat( "Percentage: .getFigure() : %.8g", numPHPercent_1.getFigure() ) : "Percentage: .getFigure() - Object is BAD" );
      myLogger.logINFO( numPHPercent_1.isValueReadable() ? StringFormat( "Percentage: getPercent : %.8g", numPHPercent_1.getPercent() ) : "Percentage: .getPercent() - Object is BAD" );

   iTest = 38;
      dInitialUnits = 56.33;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Constructor #1> { value = %.8g, NO precision } <PRECISION SHOULD DEFAULT to 2>", iTest, dInitialUnits ) );
      PHPercent numPHPercent_2( dInitialUnits );
      dAddUnits_a = 3; 
      numPHPercent_2.add( dAddUnits_a );   //test to confirm that object is bad (will error)
      myLogger.logINFO( numPHPercent_2.isValueReadable() ? StringFormat( "After add of %.8g: Result = %s", dAddUnits_a, numPHPercent_2.toString() ) : "Object is BAD" );
      myLogger.logINFO( numPHPercent_2.isValueReadable() ? StringFormat( "Percentage: .getFigure() : %.8g", numPHPercent_2.getFigure() ) : "Percentage: .getFigure() - Object is BAD" );
      myLogger.logINFO( numPHPercent_2.isValueReadable() ? StringFormat( "Percentage: .getPercent : %.8g", numPHPercent_2.getPercent() ) : "Percentage: .getPercent() - Object is BAD" );

   iTest = 39;
      dInitialUnits = 0.33;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <Constructor #1> { value = %.8g, NO precision } <WARN ME - DID YOU MEAN %.8g INSTEAD? >", iTest, dInitialUnits, (dInitialUnits*100) ) );
      PHPercent numPHPercent_3( dInitialUnits );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s", numPHPercent_3.toString() ) : "Object is BAD" );

   iTest = 40;
      dInitialUnits = 86.33;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <setValue> { value = %.8g, NO precision }", iTest, dInitialUnits ) );
      numPHPercent_3.setValue( dInitialUnits );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s", numPHPercent_3.toString() ) : "Object is BAD" );
     
   iTest = 41;
      dInitialUnits = 86.1234;
      iPrecision = 4;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHPercent <setValue> { value = %.8g, precision = %.8g }", iTest, dInitialUnits, iPrecision ) );
      numPHPercent_3.setValue( dInitialUnits, iPrecision );
      myLogger.logINFO( numPHPercent_3.isValueReadable() ? StringFormat( "Result = %s", numPHPercent_3.toString() ) : "Object is BAD" );
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

   iTest = 41;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <Default Constructor { no params } - test .toNormalizedDouble() on an uninitialized object", iTest ) );
      PHLots numPHLots_BAD();
      dNumBAD_Value = numPHLots_BAD.toNormalizedDouble();
      myLogger.logINFO(  numPHLots_BAD.isValueReadable() ? StringFormat( "Call on object: %s", numPHLots_BAD.toString() ) : "Object is BAD" );

// PHLots::PHLots( const double dLots, const PH_FX_PAIRS eSymbol );


   iTest = 42;    // Instantiate an unitialized PHLots instance
      dInitialUnits = 0.12;
      eSymbol = EURUSD;

      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <Constructor #1> { Units: %.8g, Symbol: %s } << UNINITIALIZED >> ", iTest, dInitialUnits, EnumToString(eSymbol) ) );
      PHLots numPHLots_1( dInitialUnits, eSymbol );
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s, Object: %s", numPHLots_1.toString(), numPHLots_1.objectToString() ) : "Object is BAD" );

   iTest = 43;    // Attempt to set an PHLots instance with 'too many lots'  i.e. > MAX_LOT_SIZE (typically 50.0) - gets errored out
      dInitialUnits = 55;
      eSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <setValue()> { Units: %.8g, Symbol: %s } <<TOO LARGE - GREATER THAN LOTS_MAX_SIZE", iTest, dInitialUnits, EnumToString(eSymbol) ) );
      numPHLots_1.setValue( dInitialUnits, eSymbol ); 
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );

   iTest = 44;    // Attempt to set an PHLots instance with 'too few lots...but gets rounded up to 0.01'  i.e. MIN_LOT_SIZE (typically 0.01)
      dInitialUnits = 0.005;
      eSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <setValue()> { Units: %.8g, Symbol: %s } <<TOO SMALL - ENDS UP BEING ROUNDED TO LOTS_MIN_SIZE", iTest, dInitialUnits, EnumToString(eSymbol) ) );
      numPHLots_1.setValue( dInitialUnits, eSymbol ); // i.e Result = 0.01 (min lot size)
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );

   iTest = 45;
      dInitialUnits = 0.003;    // Attempt to set an PHLots instance with 'too few lots...but gets rounded down (to zero) - gets errored out
      eSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <setValue()> { Units: %.8g, Symbol: %s } <<TOO SMALL - LESS THAN LOTS_MIN_SIZE", iTest, dInitialUnits, EnumToString(eSymbol) ) );
      numPHLots_1.setValue( dInitialUnits, eSymbol ); 
      myLogger.logINFO(  numPHLots_1.isValueReadable() ? StringFormat( "numPHLots_1.toString() : %s", numPHLots_1.toString() ) : "Object is BAD" );

   iTest = 46;
      dInitialUnits = 0.01;    // Attempt to set an PHLots instance with 'too few lots...but gets rounded down (to zero) - gets errored out
      eSymbol = GBPUSD;
      myLogger.logINFO( StringFormat( "\r\n\nTest %i: PHLots <setValue()> { Units: %.8g, Symbol: %s } <<NORMALIZE INTO LOTS_STEP_SIZE", iTest, dInitialUnits, EnumToString(eSymbol) ) );
      numPHLots_1.setValue( dInitialUnits, eSymbol ); 
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
      PH_FX_PAIRS eSymbol = StringToEnum( Symbol(), eDummyVal );

      
      myLogger.logINFO( StringFormat( "<<<PHTicks>>>  value = 1.23456, Symbol: %s", eSymbol ) );
      PHTicks ticks_buyTest( 1.23456, eSymbol );
      string sResult = ticks_buyTest.toString();
      myLogger.logINFO(  StringConcatenate( "ticks_buyTest: ", sResult, "\r\n\n"  ) );

      myLogger.logINFO( StringFormat( "<<<PHTicks>>>  value = TBD, Symbol: %s", eSymbol ) );
      PHTicks ticks_ADTRx10dayCCPriceMoveWidth();
      ticks_ADTRx10dayCCPriceMoveWidth.calcStopLossWidth_10dATRx3( eSymbol );
      sResult = ticks_ADTRx10dayCCPriceMoveWidth.toString();
      myLogger.logINFO(  StringConcatenate( "StopLossWidth_10dATRx3: ", sResult, "\r\n\n"  ) );


/*      
      PHTicks Ticks_StopLossWidth = ticks_buyTest.calcStopLossWidth10dATRx3( Symbol() );
      myLogger.logINFO(  "ticks_buyTest: "       + ticks_buyTest.toString() );
      myLogger.logINFO(  "Ticks_StopLossWidth: " + Ticks_StopLossWidth.toString() );
*/   
  }
//+------------------------------------------------------------------+
