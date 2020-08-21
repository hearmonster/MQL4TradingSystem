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

/*
      myLogger.logINFO( "<<<First Decimal>>>  <Uninitialized>  Deliberately leave it uninitialized...but then try to Add, then View" );
      PHDecimal oDec_BAD();  //Deliberately leave it uninitialized...but then try to Add, then View
      oDec_BAD.add( 3 );
      double dDec_BAD = oDec_BAD.toNormalizedDouble();
      myLogger.logINFO( StringFormat( ".toNormalizedDouble() of an un-initialized object: %g", dDec_BAD ) );

      myLogger.logINFO( "\r\n<<<Next Decimal>>>  value = 1, precision = 15 <PRECISION IS OUT OF BOUNDS/TOO HIGH>" );
      PHDecimal oDec_BAD2( 1, 15 );  //Too high precision
      oDec_BAD2.add( 3 );
      double dDec_BAD2 = oDec_BAD2.toNormalizedDouble();
      myLogger.logINFO( StringFormat( ".toNormalizedDouble() of an un-initialized object: %g", dDec_BAD2 ) );

      myLogger.logINFO( "<<<Next Decimal>>>  value = 0.15, precision = 2  then add, subtract...>" );
     //Addition & Subtraction
      PHDecimal num_2( 0.15, 2 );
      num_2.add( 0.238 );
      num_2.subtract( 0.059 );
      double dNum_2 = num_2.toNormalizedDouble();
      myLogger.logINFO( StringFormat( "ADDITION/SUBTRACTION 1: dNum_2 [0.15 + 0.238 -0.059 @2dp] : %g", dNum_2 ) );

      myLogger.logINFO( "<<<Next Decimal>>>  value = 0.15, precision = 5  then add, subtract...>" );
     //Addition & Subtraction
      PHDecimal num_2a( 0.15, 5 );
      num_2a.add( 0.238 );
      num_2a.subtract( 0.059 );
      double dNum_2a = num_2a.toNormalizedDouble();
      myLogger.logINFO( StringFormat( "ADDITION/SUBTRACTION 1: dNum_2a [0.15 + 0.238 -0.059 @5dp] : %g", dNum_2a )  );

      myLogger.logINFO( "<<<Next Decimal>>>  value = 0.25, precision = 5 then add, subtract..." );
      PHDecimal num_3( 0.15, 5 );
      num_3.add( -0.238 );
      num_3.subtract( -0.059 );
      double dNum_3 = num_3.toNormalizedDouble();
      myLogger.logINFO( StringFormat( "ADDITION/SUBTRACTION 2: dNum_3 [0.15 + -0.238 - -0.059 @2dp] : %g", dNum_3 )  );

      myLogger.logINFO( "<<<Next Decimal>>>  value = 0.25, precision = 5, Step = 0.025 then add, subtract..." );
      PHDecimal num_3a( 0.15, 5, 0.025 );
      num_3a.add( -0.238 );
      num_3a.subtract( -0.059 );
      double dNum_3a = num_3a.toNormalizedDouble();
      myLogger.logINFO( StringFormat( "ADDITION/SUBTRACTION 2: dNum_3 [0.15 + -0.238 - -0.059 @2dp] : %g", dNum_3a )  );
 
      double d_3b = 12.34;
      myLogger.logINFO( StringFormat( "<<<Next Decimal>>>  value = %g, precision = 2, Step = 0.25 ...", d_3b ) );
      PHDecimal num_3b( d_3b, 2, 0.25 );
      double dNum_3b = num_3b.toNormalizedDouble();
      myLogger.logINFO( StringFormat( "12.34 @ Step: 0.25 : %g", dNum_3b )  );

      double d_3c = 12.49;
      myLogger.logINFO( StringFormat( "<<<Next Decimal>>>  value = %g, precision = 2, Step = 0.25 ...", d_3c ) );
      PHDecimal num_3c( d_3c, 2, 0.25 );
      double dNum_3c = num_3c.toNormalizedDouble();
      myLogger.logINFO( StringFormat( "12.34 @ Step: 0.25 : %g", dNum_3c )  );

      double d1 = 0.1;
      double d2 = 0.2;
      double d3 = 0.3;
      myLogger.logINFO(  StringConcatenate ( StringFormat( "BAD DOUBLES: d1 + d2 - d3 Result1: %g", d1 + d2 - d3)  , "logic: ", ( (d1+d2) == d3 ) ) );

     //Comparison
      myLogger.logINFO( "<<<Next Decimal>>>  Compare ((0.1+0.2) == 0.3)" );
      PHDecimal num_4( d1, 5 );
      num_4.add( d2 );
      myLogger.logINFO(  StringConcatenate( "COMPARISON: num_4 compare [d1 + d2] == d3 Result: ", num_4.compare( d3 ) ) );
      num_4.subtract( d3 );
      myLogger.logINFO(  StringFormat( "COMPARISON 2: num_4 result [d1 + d2 - d3] Result1: %g", num_4.toNormalizedDouble() ) );
     
     
     //Multiplication
      myLogger.logINFO( "<<<Next Decimal>>>  value = 15, precision = 5  then multiply, mutiply...>" );
      PHDecimal num_5( 15, 5 );
      num_5.multiply( 20 );
      num_5.multiply( -0.586 );
      double dNum_5 = num_5.toNormalizedDouble();
      myLogger.logINFO( StringFormat( "MULTIPLICATION:  dNum_5 [ 15 x 20 x -0.586 (check DP)] : %g", dNum_5 )  );
     
  

     //Division
      myLogger.logINFO( "<<<Next Decimal>>>  value = 25, precision = 5  then divide, divide...>" );
      PHDecimal num_6( 25, 5 );
      num_6.divide( 15 );
      num_6.divide( -0.586 );
      double dNum_6 = num_6.toNormalizedDouble();
      myLogger.logINFO( StringFormat( "DIVISION:  dNum_6 [ 25 ÷ 15 ÷ -0.586 (check DP)] : %g;  toString(): %s", dNum_6, num_6.toString() )  );
      


     //PERCENT
      //PHPercent perc_BAD();  //UNABLE TO CALL ("wrong parameters count")

      myLogger.logINFO( "<<<Next Decimal>>>  value = 1, precision = 15 <PRECISION IS OUT OF BOUNDS/TOO HIGH>" );
      PHDecimal num_BAD3( 1, 15 );  //Too high precision
      num_BAD3.add( 3 );   //test to confirm that object is bad (will error)
      myLogger.logINFO( StringFormat( "(Numerical?) Result of .toNormalizedDouble of an UNSET value: %g",   num_BAD3.toNormalizedDouble() ) );
      string sBool = ( num_BAD3.toNormalizedDouble() == NULL ) ? "true" : "false";
      myLogger.logINFO( StringFormat( "Is the Boolean result of .toNormalizedDouble of an UNSET value: %s IS NULL?",   sBool ) );
      sBool = ( num_BAD3.toNormalizedDouble() == 0 ) ? "true" : "false";
      myLogger.logINFO( StringFormat( "Is the result of .toNormalizedDouble of an UNSET value EQUAL TO ZERO?: %s",   sBool ) );

      myLogger.logINFO( "<<<Next Percentage>>>  value = 26, precision = 3" );
      PHPercent perc_1( 26, 3 );  
      myLogger.logINFO( StringFormat( "Result of .toNormalizedDouble: %g",   perc_1.toNormalizedDouble() ) );
      myLogger.logINFO( StringFormat( "Percentage: getFigure : %g", perc_1.getFigure() ) );
      myLogger.logINFO( StringFormat( "Percentage: getPercent : %g", perc_1.getPercent() ) );
      myLogger.logINFO( StringFormat( "Percentage: toString(): %s", perc_1.toString() ) );
      
      myLogger.logINFO( "<<<Next Percentage>>>  value = 0.32, precision = 3 <Warn me to set the precentage between 0 and 100>" );
      PHPercent perc_mistake( 0.32, 2 );  //Warn me to set the precentage between 0 and 100
      myLogger.logINFO( StringFormat( "Result of .toNormalizedDouble: %g",   perc_mistake.toNormalizedDouble() ) );
      

      myLogger.logINFO( "<<<Next Percentage>>>  value = 100, precision = 2 <ERROR, Value is too high - Warn me that I'm overriding and setting to 100 instead" );
      PHPercent perc_BAD1( 999, 2 );  //Too high - override and set to 100 instead
      myLogger.logINFO( StringFormat( "Result of .toNormalizedDouble: %g",   perc_BAD1.toNormalizedDouble() ) );

      myLogger.logINFO( "<<<Next Percentage>>>  value = 0.32, precision = 3 <ERROR, Value is too low>" );
      PHPercent perc_BAD2( -5, 2 );   //Too low
      myLogger.logINFO( StringFormat( "Result of .toNormalizedDouble: %g",   perc_BAD2.toNormalizedDouble() ) );

*/      

/*
      double dLarge1 = 100000;
      double dSmall1 = 1.2;
      //double dResult1 = dLarge1 + dSmall1 - dLarge1;
      double dResult1 = (double) 100000 + (double) 1.2 - (double) 100000;
      myLogger.logINFO(  StringFormat( "dResult1: %g", dResult1 ) );

      double d_a = 1;
      double d_b = 0.0000000000000000000000001;
      double d_res = d_a + d_b;
      myLogger.logINFO(  StringFormat( "d_res: %g", d_res ) );

      double dMedium2 = 362.2;
      double dResult2 = dMedium2 - dMedium2;
      myLogger.logINFO(  StringFormat( "dResult2: %g", dResult2 ) );

      
      PHDecimal num_large( 100000 );
      num_large.add( 1.2 );
      num_large.subtract( 100000 );
      num_large.toNormalizedDouble();
      myLogger.logINFO(  "num_large.toNormalizedDouble(): " + num_large.toString() );
*/      
      
   
      
/*
   //<<< Lots >>>
      PHLots lots_tooSmall( 0.0001, Symbol() );
      PHLots lots_tooBig( 999, Symbol() );
      PHLots lots_unNormalized( 0.056, Symbol() );
      PHLots lots_already_Normalised( 0.3, Symbol() );
   
      myLogger.logINFO(  "lots_tooSmall: "           + lots_tooSmall.toString() );
      myLogger.logINFO(  "lots_tooBig: "             + lots_tooBig.toString() );
      myLogger.logINFO(  "lots_unNormalized: "       + lots_unNormalized.toString() );
      myLogger.logINFO(  "lots_already_Normalised: " + lots_already_Normalised.toString() );
*/      
      
   //<<< Ticks >>>
/*
      PHTicks ticks_tooSmall( 0.000004 );
      PHTicks ticks_large( 999 );
      PHTicks ticks_unNormalized( 5.12345678, "GBPCHF" );   //Also a Cross Currency
      PHTicks ticks_already_Normalised( 1.23456 );
      PHTicks ticks_negative( -20, "USDCHF" );              //Also a non-USD Counter Currency
//      PHTicks ticks_copy1( ticks_already_Normalised );
//      PHTicks *ticks_copy2 = new PHTicks( ticks_already_Normalised );

      myLogger.logINFO(  "ticks_tooSmall: "           + ticks_tooSmall.toString() );
      myLogger.logINFO(  "ticks_large: "              + ticks_large.toString() );
      myLogger.logINFO(  "ticks_unNormalized: "       + ticks_unNormalized.toString() );
      myLogger.logINFO(  "ticks_already_Normalised: " + ticks_already_Normalised.toString() );
      myLogger.logINFO(  "ticks_negative: "           + ticks_negative.toString() );

/*
   //<<< Dollars>>>
      PHDollar dolls_tooSmall( 0.0078 );
      PHDollar dolls_large( 9999999.99 );
      PHDollar dolls_unNormalized( 1.23456 );
      PHDollar dolls_already_Normalised( 1.56 );
      PHDollar dolls_from_tick1( ticks_negative.tickValueDollarsPerUnit() );
      PHDollar dolls_from_tick2( ticks_negative.tickValueDollarsForGivenNumLots( lots_already_Normalised ) );

      myLogger.logINFO(  "dolls_tooSmall: "           + dolls_tooSmall.toString() );
      myLogger.logINFO(  "dolls_large: "              + dolls_large.toString() );
      myLogger.logINFO(  "dolls_unNormalized: "       + dolls_unNormalized.toString() );
      myLogger.logINFO(  "dolls_already_Normalised: " + dolls_already_Normalised.toString() );
      myLogger.logINFO(  "dolls_from_tick1: " + dolls_from_tick1.toString() );
      myLogger.logINFO(  "dolls_from_tick2: " + dolls_from_tick2.toString() );
*/   



   //Add 'risk' (returns Ticks-width of risk) to PHTicks
   //Size the Lot (given Ticks-width of risk)
   
      PH_FX_PAIRS eDummyVal = -1;
      PH_FX_PAIRS eSymbol = StringToEnum( Symbol(), eDummyVal );

      
      myLogger.logINFO( StringFormat( "<<<PHTicks>>>  value = 1.23456, Symbol: %s", eSymbol ) );
      PHTicks ticks_buyTest( 1.23456, eSymbol );
      string sResult = ticks_buyTest.toString();
      myLogger.logINFO(  StringConcatenate( "ticks_buyTest: ", sResult, "\r\n"  ) );

      myLogger.logINFO( StringFormat( "<<<PHTicks>>>  value = TBD, Symbol: %s", eSymbol ) );
      PHTicks ticks_ADTRx10dayCCPriceMoveWidth();
      ticks_ADTRx10dayCCPriceMoveWidth.calcStopLossWidth_10dATRx3( eSymbol );
      sResult = ticks_ADTRx10dayCCPriceMoveWidth.toString();
      myLogger.logINFO(  StringConcatenate( "StopLossWidth_10dATRx3: ", sResult, "\r\n"  ) );


/*      
      PHTicks Ticks_StopLossWidth = ticks_buyTest.calcStopLossWidth10dATRx3( Symbol() );
      myLogger.logINFO(  "ticks_buyTest: "       + ticks_buyTest.toString() );
      myLogger.logINFO(  "Ticks_StopLossWidth: " + Ticks_StopLossWidth.toString() );
*/   
  }
//+------------------------------------------------------------------+
