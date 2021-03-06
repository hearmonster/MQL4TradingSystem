//+------------------------------------------------------------------+
//|                                 Print out my Account Details.mq4 |
//|                                                            Harry |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Harry"
#property link      ""
#define _MAGICMA 1111


#include <stderror.mqh>    // For "ErrorDescription()" resulting from GetLastError()
#include <stdlib.mqh>      // ditto

#include <PHLogger.mqh>      //LOGGING
//<<<Global Variables>>>



//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void OnStart ()
  {
  //Info will get Printed to <APP ROOT>\experts\logs\<yyyymmdd>.Print (Timestamp will be local workstation's)

   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function



   myLogger.logINFO("\n------- Deposit Currency snapshot --------");

// Account - Static Info

//   myLogger.logINFO( StringConcatenate( "Current Account Name: ", s_CurrentAccountName() ) );
//   myLogger.logINFO( StringConcatenate( "Current Account Number: ", i_CurrentAccountNumber() ) );
//   myLogger.logINFO( StringConcatenate( "Current Account Server: ", s_CurrentAccountServer() ) );
//
//
//   myLogger.logINFO( StringConcatenate( "Current Account Company: ", s_CurrentAccountCompany() ) );
//   myLogger.logINFO( StringConcatenate( "Current Account Currency: ", s_CurrentAccountCurrency() ) );

   myLogger.logINFO( StringConcatenate( "Current Account Max num of orders ('LimitOrders'): ", i_CurrentAccountLimitOrders() ) );

// Account - Current Levels
   myLogger.logINFO( StringConcatenate( "Current Account Profit: ", d_CurrentAccountTerminalProfit(), "(combined of all open trades)" ) );
   myLogger.logINFO( StringConcatenate( "Current Account Balance: ", d_CurrentAccountTerminalBalance() ) );
   myLogger.logINFO( StringConcatenate( "Current Account Credit: ", d_CurrentAccountTerminalCredit() ) );
   
   double dCurrentAccountTerminalEquity = d_CurrentAccountTerminalEquity();
   myLogger.logINFO( StringConcatenate( "Current Account Terminal 'Equity': ", dCurrentAccountTerminalEquity) );

   double dCurrentAccountTerminalMarginUsed = d_CurrentAccountTerminalMarginUsed();
   myLogger.logINFO( StringConcatenate( "Current Account Terminal 'Used Margin': ", dCurrentAccountTerminalMarginUsed ) );

   double dCurrentAccountTerminalFreeMargin = d_CurrentAccountTerminalMarginFree();
   myLogger.logINFO( StringConcatenate( "Current Account Terminal 'FreeMargin' (Equity - Used Margin): ", dCurrentAccountTerminalFreeMargin ) );

   myLogger.logINFO( StringConcatenate( "Current Account Terminal 'Margin Level' (Equity ÷ Used Margin x 100): ", d_CurrentAccountTerminalMarginLevel(), "%" ) );

   bool isCurrentAccountTradeAllowed = is_CurrentAccountTradeAllowed();
   myLogger.logINFO( StringConcatenate( "is Trading currently allowed?: ", isCurrentAccountTradeAllowed ) );

   bool isCurrentAccountTradeExpertAllowed = is_CurrentAccountTradeExpertAllowed();
   myLogger.logINFO( StringConcatenate( "is Trading currently allowed via an EXPERT?: ", isCurrentAccountTradeExpertAllowed ) );



   
// Account Margin Level / Maintenance / Mode?

   myLogger.logINFO( StringConcatenate( "Current Account 'Margin Call' and 'Stop Out' Mode: ", EnumToString( e_CurrentAccountMarginStopOutUnitsMode() ), "  (same Mode used for Margin Call and Stop Out - they're very similar after all!)" ) );

// Before deleting this call to "e_CurrentAccountMarginStopOutUnitsMode()", remember that there may be a later call to "d_CurrentAccountMarginStopOutThreshold()" - and you may wish to preserve this to give this value some context
   myLogger.logINFO( StringConcatenate( "Current Account Margin Call Threshold/Level: ", d_CurrentAccountMarginCallThreshold(),  (e_CurrentAccountMarginStopOutUnitsMode()==ACCOUNT_STOPOUT_MODE_PERCENT)?"%":"($)" ) );

   double dLeverageDecimal = d_CurrentAccountLeverageDecimal();
   myLogger.logINFO( StringConcatenate( "Current Account Leverage (as a decimal percentage): ", dLeverageDecimal, "...or (as a percentage): ", (dLeverageDecimal*100), "%" ) );
   //Used to add:     "The upshot meaning that with an Account Equity of only $",dEquity," I can control up to $",(dEquity*iAccountLeverage)," (Account Equity multiplied by leverage)"
   
// Account Stop Out Level / Mode
// If you delete the earlier call to "e_CurrentAccountMarginStopOutUnitsMode()", you may wish to place one here - to give this value some context
   myLogger.logINFO( StringConcatenate( "Current Account Stop Out Threshold/Level: ", d_CurrentAccountMarginStopOutThreshold(),  (e_CurrentAccountMarginStopOutUnitsMode()==ACCOUNT_STOPOUT_MODE_PERCENT)?"%":"($)" ) );

// Margin Calcultaion Mode
   int iCurrentAccountMarginStopOutCalcMode = i_CurrentAccountMarginStopOutCalcMode();
   myLogger.logINFO( StringConcatenate( "Margin Calculation Mode: ", iCurrentAccountMarginStopOutCalcMode ) );
   myLogger.logINFO( "FYI (Hardcoded!)   '1' => both floating profit and loss on opened orders on the current account are used for free margin calculation" );



   myLogger.logINFO("\n------- Market/Symbol snapshot --------");


   string sSymbol  = Symbol(); //"EURGBP";
   string sSymbol2 = "GBPUSD";



   MqlTick mqlTick;
//---
   if(SymbolInfoTick( sSymbol, mqlTick ))
     {
      myLogger.logINFO( StringConcatenate( "Symbol: ", sSymbol, ", @Time: ", mqlTick.time,": Bid = ",mqlTick.bid, " Ask = ",mqlTick.ask,"  Volume = ",mqlTick.volume ) );
     }
   else Print("SymbolInfoTick() failed, error = ",GetLastError());
   
   if(SymbolInfoTick( sSymbol2, mqlTick ))
     {
      myLogger.logINFO( StringConcatenate( "Symbol2: ", sSymbol2, ", @Time: ", mqlTick.time,": Bid = ",mqlTick.bid, " Ask = ",mqlTick.ask,"  Volume = ",mqlTick.volume ) );
     }
   else Print("SymbolInfoTick() failed, error = ",GetLastError());

   long lSymbolDigits = l_SymbolDigits( sSymbol );
   myLogger.logINFO( StringConcatenate( "Symbol Digits: ", lSymbolDigits, " (Digits after a decimal point)" ) );

   long lSymbolSpread = l_SymbolSpread( sSymbol );
   myLogger.logINFO( StringConcatenate( "Symbol Spread: ", lSymbolSpread, " (Spread value - measured in whole points)" ) );

   long iSymbolMinTicksToPlaceStop = i_SymbolMinTicksToPlaceStop( sSymbol );
   myLogger.logINFO( StringConcatenate( "Symbol Stops: ", iSymbolMinTicksToPlaceStop, " (Minimal indention in points from the current close price to place Stop orders - measured in whole points)" ) );

   bool bSymbolIsTradeAllowed = b_SymbolIsTradeAllowed( sSymbol );
   myLogger.logINFO( StringConcatenate( "Symbol - Is trade allowed?: ", bSymbolIsTradeAllowed ) );


   long lSymbolFreezeRange = l_SymbolFreezeRange( sSymbol );
   myLogger.logINFO( StringConcatenate( "Symbol - Freeze Range is within: ", lSymbolFreezeRange, " ticks" ) );


   datetime lSymbolLastQuoteTime = l_SymbolLastQuoteTime( sSymbol );
   myLogger.logINFO( StringConcatenate( "Symbol - Last Quote Time: ", lSymbolLastQuoteTime ) );



   string sMarginCurrency = SymbolInfoString( sSymbol, SYMBOL_CURRENCY_MARGIN ); //Margin currency
   myLogger.logINFO( StringConcatenate( "Margin currency: ", sMarginCurrency, "  (Margin currency)"  ) );
   
   string sBaseCurrency = SymbolInfoString( sSymbol, SYMBOL_CURRENCY_BASE ); //Basic currency of a symbol
   myLogger.logINFO( StringConcatenate( "Base/Basic currency: ", sBaseCurrency, "  (Basic currency of a symbol)"  ) );
   
   string sProfitCurrency = SymbolInfoString( sSymbol, SYMBOL_CURRENCY_PROFIT ); //Profit currency
   myLogger.logINFO( StringConcatenate( "Counter/Profit currency: ", sProfitCurrency, "  (Profit currency)"  ) );
   
   string sSymbolDesc = SymbolInfoString( sSymbol, SYMBOL_DESCRIPTION ); //Symbol description
   myLogger.logINFO( StringConcatenate( "Symbol description: ", sSymbolDesc, "  (Symbol description)"  ) );
   
   string sSymbolPath = SymbolInfoString( sSymbol, SYMBOL_PATH ); //Path in the symbol tree
   myLogger.logINFO( StringConcatenate( "Symbol Path: ", sSymbolPath, "  (Path in the symbol tree)"  ) );

   double dSwapLong2 = SymbolInfoDouble( sSymbol, SYMBOL_SWAP_LONG ); 
   double dSwapShort2 = SymbolInfoDouble( sSymbol, SYMBOL_SWAP_SHORT ); 
   myLogger.logINFO( StringConcatenate( "SwapLong: ", dSwapLong2, " SwapShort: ", dSwapShort2 ));



   myLogger.logINFO("\n------- Lots (Symbol) snapshot --------");

   double dMinLot1 = MarketInfo(sSymbol,MODE_MINLOT); //confirmed DOUBLE
   double dMaxLot1 = MarketInfo(sSymbol,MODE_MAXLOT); //confirmed DOUBLE
   double dLotStep1 = MarketInfo(sSymbol,MODE_LOTSTEP); //confirmed DOUBLE
   myLogger.logINFO( StringConcatenate( "[via MarketInfo]  MinLot: ", dMinLot1, " MaxLot: ", dMaxLot1, " LotStep: ", dLotStep1 ) );

   double dMinLot2 = SymbolInfoDouble( sSymbol, SYMBOL_VOLUME_MIN ); 
   double dMaxLot2 = SymbolInfoDouble( sSymbol, SYMBOL_VOLUME_MAX ); 
   double dLotStep2 = SymbolInfoDouble( sSymbol, SYMBOL_VOLUME_STEP ); 
   myLogger.logINFO( StringConcatenate( "[via SymbolInfoDouble]  MinLot: ", dMinLot2, " MaxLot: ", dMaxLot2, " LotStep: ", dLotStep2 ) );



   int    iLotSize1 = (int) MarketInfo(sSymbol,MODE_LOTSIZE);        //confirmed INT
   double dLotSize2 = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_CONTRACT_SIZE ); 
   
   
   
   myLogger.logINFO( StringConcatenate( "lot size: [via MarketInfo] ",iLotSize1, " ; [via SymbolInfoDouble]: ", dLotSize2, " (Lot size in the base currency)" ) );
   if ( iLotSize1 == 100000) {
      myLogger.logINFO( "\'LotSize\' used to detect: Standard Account (100,000)");
   } else {
      if ( iLotSize1 == 10000) {
         myLogger.logINFO( "\'LotSize\' used to detect: Mini Account (10,000)");
      } else {
         if ( iLotSize1 == 1000) {
            myLogger.logINFO( "\'LotSize\' used to detect: Micro Account (1,000)");
         } else {
            myLogger.logINFO( "Unable to detect Account type");
         }
      }
   }




   myLogger.logINFO("\n------- Deposit Currency (for Symbol) snapshot --------");

   double dTickSize1 =  MarketInfo( sSymbol, MODE_TICKSIZE );
   double dTickValue1 = MarketInfo( sSymbol, MODE_TICKVALUE );
   myLogger.logINFO( StringConcatenate( "dTickValue [via MarketInfo]: ", dTickValue1, ", dTickSize [via MarketInfo]: ", dTickSize1, " dTickValue/dTickSize [via MarketInfo]: ", (dTickValue1/dTickSize1)  ) );

   double dTickSize2 =  SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_SIZE ); 
   double dTickValue2 = SymbolInfoDouble( sSymbol, SYMBOL_TRADE_TICK_VALUE ); 
   myLogger.logINFO( StringConcatenate( "dTickValue [via SymbolInfoDouble]: ", dTickValue2, ", dTickSize [via SymbolInfoDouble]: ", dTickSize2, " dTickValue/dTickSize [via SymbolInfoDouble]: ", (dTickValue2/dTickSize2)  ) );


   
   double MI_point =MarketInfo( sSymbol, MODE_POINT);  //confirmed DOUBLE
   myLogger.logINFO( StringConcatenate( "MI Point: ", DoubleToStr(MI_point, Digits), " Point: ", DoubleToStr(Point, Digits), "  (Point size in the quote currency)" ) );








//   double SwapLong=MarketInfo(sSymbol,MODE_SWAPLONG); //Is this an INT or DOUBLE???      measured on a standard size of 1.0 lot (100,000 base units).
//   double SwapShort = MarketInfo(sSymbol,MODE_SWAPSHORT); //Is this an INT or DOUBLE???  measured on a standard size of 1.0 lot (100,000 base units).
//   int SwapType = (int) MarketInfo(sSymbol,MODE_SWAPTYPE); //(INT Constant) Swap calculation method. 0 - in points; 1 - in the symbol base currency; 2 - by interest; 3 - in the margin currency
//   myLogger.logINFO( StringConcatenate( "SwapLong: ", SwapLong, " SwapShort: ", SwapShort ));
//   myLogger.logINFO( StringConcatenate( " SwapType: ", SwapType, "  (Swap calculation method. 0 - in points; 1 - in the symbol base currency; 2 - by interest; 3 - in the margin currency)" ) );

   int ProfitCalcMode = (int) MarketInfo( sSymbol, MODE_PROFITCALCMODE); //(INT Constant)Profit calculation mode. 0 - Forex; 1 - CFD; 2 - Futures.
   myLogger.logINFO( StringConcatenate( "Symbol ProfitCalcMode: ", ProfitCalcMode, "  (Profit calculation mode. 0 - Forex; 1 - CFD; 2 - Futures)" ) );

//   double Starting=MarketInfo(sSymbol,MODE_STARTING); //Is this an INT or DOUBLE or DATE???
//   double Expiration=MarketInfo(sSymbol,MODE_EXPIRATION); //Is this an INT or DOUBLE or DATE???
//   myLogger.logINFO(  StringConcatenate( "Starting: ", Starting, " Expiration: ", Expiration, "  Market starting/expiration dates (usually used for futures)" ) );







   
   testMarginViaPhantomTrade( OP_BUY, 0.5, "EURUSD", dLeverageDecimal, dCurrentAccountTerminalFreeMargin );
   testMarginViaPhantomTrade( OP_BUY, 0.5, "EURGBP", dLeverageDecimal, dCurrentAccountTerminalFreeMargin );
   testMarginViaPhantomTrade( OP_SELL, 0.5, "EURUSD", dLeverageDecimal, dCurrentAccountTerminalFreeMargin );

// int nOrderTicket = OrderSend( sSymbol, OP_BUY, 0.18, Ask, 2, 0, 0,"", _MAGICMA, 0, Blue);  //Opening Buy
// int nErrCode = GetLastError();
//      
//      if ( nOrderTicket != -1 ) {                       // Success (an nOrderTicket of "-1" indicates an error occurred)
//         myLogger.logINFO( StringConcatenate( "Opened order ticket #", OrderTicket(), "(Buy)" ) );
//      } else {
//         myLogger.logINFO( StringConcatenate( "Order open failed with code ", nErrCode ) );
//         printErrorDescription( nErrCode );
//      }


   
   return;
  }


//| AccountXXXX functions     1/19
//+------------------------------------------------------------------+
//| AccountInfoDouble()    GENERAL PROPERTY FUNCTION
//|  
//| Returns a value of double type of the corresponding account property
//|  
//| 


//| AccountXXXX functions     2/19
//+------------------------------------------------------------------+
//| AccountInfoInteger()    GENERAL PROPERTY FUNCTION
//|  
//| Returns a value of integer type (bool, int or long) of the corresponding account property
//|  
//| 


//| AccountXXXX functions     3/19
//+------------------------------------------------------------------+
//| AccountInfoString()    GENERAL PROPERTY FUNCTION
//|  
//| Returns a value string type corresponding account property
//|  
//| 


//| AccountXXXX functions     4/19
//+------------------------------------------------------------------+
//| AccountBalance()          >>> SEE "d_CurrentAccountTerminalBalance()"
//|  
//| Returns balance value of the current account
//|  
//| 


//| AccountXXXX functions     5/19
//+------------------------------------------------------------------+
//| AccountCredit()           >>> SEE "d_CurrentAccountTerminalCredit()"
//|  
//| Returns credit value of the current account
//|  
//| 


//| AccountXXXX functions     6/19
//+------------------------------------------------------------------+
//| AccountCompany()          >>> SEE "s_CurrentAccountCompany()"
//|  
//| Returns the brokerage company name where the current account was registered
//|  
//| 


//| AccountXXXX functions     7/19
//+------------------------------------------------------------------+
//| AccountCurrency()         >>> SEE "s_CurrentAccountCurrency()"
//|  
//| Returns currency name of the current account
//|  
//| 


//| AccountXXXX functions     8/19
//+------------------------------------------------------------------+
//| AccountEquity()           >>> SEE "d_CurrentAccountTerminalEquity()"
//|  
//| Returns equity value of the current account
//|  
//| 


//| AccountXXXX functions     9/19
//+------------------------------------------------------------------+
//| AccountFreeMargin()       >>> SEE "d_CurrentAccountTerminalMarginFree()"
//|  
//| Returns free margin value of the current account
//|  
//| 


//| AccountXXXX functions     10/19
//+------------------------------------------------------------------+
//| AccountFreeMarginCheck()  >>> SEE "d_CurrentAccountTerminalMarginFreeCheck()"
//|  
//| Returns free margin that remains after the specified position has been opened at the current price on the current account
//|  
//| 


//| AccountXXXX functions     11/19
//+------------------------------------------------------------------+
//| AccountFreeMarginMode()   >>> SEE "d_CurrentAccountTerminalMarginFree()"
//|  
//| Calculation mode of free margin allowed to open orders on the current account
//|  
//| 


//| AccountXXXX functions     12/19
//+------------------------------------------------------------------+
//| AccountLeverage()         >>> SEE "d_CurrentAccountLeverageDecimal()"  (although converts the ratio into a decimal)
//|  
//| Returns leverage of the current account  (in a ratio)
//|  
//| 


//| AccountXXXX functions     13/19
//+------------------------------------------------------------------+
//| AccountMargin()           >>> SEE "d_CurrentAccountTerminalMarginUsed()"
//|  
//| Returns margin value of the current account
//|  
//| 


//| AccountXXXX functions     14/19
//+------------------------------------------------------------------+
//| AccountName()             >>> SEE "s_CurrentAccountName()"
//|  
//| Returns the current account name
//|  
//| 


//| AccountXXXX functions     15/19
//+------------------------------------------------------------------+
//| AccountNumber()           >>> SEE "i_CurrentAccountNumber()"
//|  
//| Returns the current account number
//|  
//| 


//| AccountXXXX functions     16/19
//+------------------------------------------------------------------+
//| AccountProfit()           >>> SEE "d_CurrentAccountTerminalProfit()"
//|  
//| Returns profit value of the current account
//|  
//| 


//| AccountXXXX functions     17/19
//+------------------------------------------------------------------+
//| AccountServer()           >>> SEE "s_CurrentAccountServer()"
//|  
//| Returns the connected server name
//|  
//| 


//| AccountXXXX functions     18/19
//+------------------------------------------------------------------+
//| AccountStopoutLevel()     >>> SEE "d_CurrentAccountMarginStopOutThreshold()"
//|  
//| Returns the value of the Stop Out level
//|  
//| 


//| AccountXXXX functions     19/19
//+------------------------------------------------------------------+
//| AccountStopoutMode()      >>> SEE "e_CurrentAccountMarginStopOutUnitsMode()"
//|  
//| Returns the calculation mode for the Stop Out level
//|  




//<<< AccountInfoDouble functions >>>


//| AccountInfoDouble()    1/14
//+------------------------------------------------------------------+
//| ACCOUNT_BALANCE        >>> see "d_CurrentAccountTerminalBalance()"
//| 
//| "Account balance in the deposit currency"
//|
//| built-in function:  AccountInfoDouble( ACCOUNT_BALANCE )
//| Documented: MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+



//| AccountInfoDouble()    2/14
//+------------------------------------------------------------------+
//| ACCOUNT_CREDIT         >>> see "d_CurrentAccountTerminalCredit()"
//|
//| "Account credit in the deposit currency"
//|
//| built-in function:  AccountInfoDouble( ACCOUNT_CREDIT )
//|
//+------------------------------------------------------------------+



//| AccountInfoDouble()    3/14
//+------------------------------------------------------------------+
//| ACCOUNT_PROFIT         >>> see "d_CurrentAccountTerminalProfit()"
//|
//| "Current profit of an account in the deposit currency"
//|
//| Uses the built-in function:  AccountInfoDouble( ACCOUNT_PROFIT )
//|
//+------------------------------------------------------------------+
 

//| AccountInfoDouble()    4/14
//+------------------------------------------------------------------+
//| ACCOUNT_EQUITY         >>> see "d_CurrentAccountTerminalEquity()"
//|
//| "Account equity in the deposit currency"
//|
//| Uses the built-in function:  AccountInfoDouble( ACCOUNT_EQUITY )
//|
//+------------------------------------------------------------------+



//| AccountInfoDouble()    5/14
//+------------------------------------------------------------------+
//| ACCOUNT_MARGIN         >>> see "d_CurrentAccountTerminalMarginUsed()"
//|
//| "Account margin used in the deposit currency"
//|
//| Uses the built-in function:  AccountInfoDouble( ACCOUNT_MARGIN )
//|
//+------------------------------------------------------------------+
 

//| AccountInfoDouble()    6/14
//+------------------------------------------------------------------+
//| ACCOUNT_MARGIN_FREE    >>> see "d_CurrentAccountTerminalMarginFree()"
//|
//| "Free margin of an account in the deposit currency"
//|
//| Uses the built-in function:  AccountInfoDouble( ACCOUNT_MARGIN_FREE )
//|
//+------------------------------------------------------------------+
 

//| AccountInfoDouble()    7/14
//+------------------------------------------------------------------+
//| ACCOUNT_MARGIN_LEVEL
//|
//| "Account margin level in percents"
//|
//| Uses the built-in function:  AccountInfoDouble( ACCOUNT_MARGIN_LEVEL )
//|
//| Manual Calc:  (Equity ÷ Margin x 100)  Result is in % e.g. " 2,345.67% "  (in good times, can be a rather high %!)
//|   If it falls below ACCOUNT_MARGIN_SO_CALL (120%) then a Margin Call is generated
//|   If it falls below ACCOUNT_MARGIN_SO_SO   (100%) then a Stop Out occurs
//|
//+------------------------------------------------------------------+
double d_CurrentAccountTerminalMarginLevel()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function
   int nErrCode;

   // New way...
   double dCurrentAccountTerminalMarginLevel = AccountInfoDouble( ACCOUNT_MARGIN_LEVEL );
   nErrCode = GetLastError();
   if( nErrCode != ERR_NO_ERROR )  {
      myLogger.logERROR( StringConcatenate( "AccountInfoDouble(ACCOUNT_MARGIN_LEVEL)::Error: ", ErrorDescription( nErrCode ) ) ); 
   }
   myLogger.logDEBUG( StringConcatenate( "Current Account Terminal Margin Level (Equity ÷ Margin x 100): ", dCurrentAccountTerminalMarginLevel, " %" ) );


// Disabling the "return as a decimal" stuff - so the figure resembles the "Margin Level ...%" number in the Terminal

//   ENUM_ACCOUNT_STOPOUT_MODE  eStopOutMode = e_CurrentAccountStopOutMode();
//   myLogger.logDEBUG( StringConcatenate( "Current Account LimitOrders: ", EnumToString( eStopOutMode ) ) );
//   
//   if (eStopOutMode == ACCOUNT_STOPOUT_MODE_PERCENT)
//      dCurrentAccountMarginLevel = dCurrentAccountMarginLevel/100;

   return( dCurrentAccountTerminalMarginLevel );
}







//| AccountInfoDouble()    8/14
//+------------------------------------------------------------------+
//| ACCOUNT_MARGIN_SO_CALL >>> see "d_CurrentAccountMarginCallThreshold()"
//|
//| "Margin call level. Depending on the set ACCOUNT_MARGIN_SO_MODE is expressed in percents or in the deposit currency"
//|
//| Uses the built-in function:  AccountInfoDouble( ACCOUNT_MARGIN_SO_CALL )
//|
//+------------------------------------------------------------------+
 

//| AccountInfoDouble()    9/14
//+------------------------------------------------------------------+
//| ACCOUNT_MARGIN_SO_SO   >>> see "d_CurrentAccountMarginStopOutThreshold()"
//|   
//| "Margin stop out level. Depending on the set ACCOUNT_MARGIN_SO_MODE is expressed in percents or in the deposit currency"
//|
//| Uses the built-in function:  AccountInfoDouble( ACCOUNT_MARGIN_SO_SO )
//|
//+------------------------------------------------------------------+
 

//| AccountInfoDouble()    10/14
//+------------------------------------------------------------------+
//| ACCOUNT_MARGIN_INITIAL     >>> Not Supported    (although refer to  "d_SymbolMarginRequiredForOneLot()"  which indirectly addresses this call)
//|
//| built-in function:  AccountInfoDouble( ACCOUNT_MARGIN_INITIAL )
//|
//| Not supported
//|
//+------------------------------------------------------------------+
 
 
//| AccountInfoDouble()    11/14
//+------------------------------------------------------------------+
//| ACCOUNT_MARGIN_MAINTENANCE   >>> Not Supported
//|
//| built-in function:  AccountInfoDouble( ACCOUNT_MARGIN_MAINTENANCE )
//|
//| Not supported  (I tried using it, it triggers "GetLastError()" with a "invalid function parameter value" error! )
//|
//+------------------------------------------------------------------+
//double d_CurrentAccountMarginLevelMaintenance()
//{
//   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function
//   int nErrCode;
//
//   double dCurrentAccountMarginLevelMaintenance = AccountInfoDouble( ACCOUNT_MARGIN_MAINTENANCE );
//   nErrCode = GetLastError();
//   if( nErrCode != ERR_NO_ERROR )  {
//      myLogger.logERROR( StringConcatenate( "AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE)::Error: ", ErrorDescription( nErrCode ) ) ); 
//   }
//   myLogger.logDEBUG( StringConcatenate( "Current Account Margin Maintenance: ", dCurrentAccountMarginLevelMaintenance ) );
//
//   return( dCurrentAccountMarginLevelMaintenance );
//}
 

//| AccountInfoDouble()    12/14
//+------------------------------------------------------------------+
//| ACCOUNT_ASSETS
//|
//| built-in function:  AccountInfoDouble( ACCOUNT_ASSETS )
//|
//| Not supported
//|
//+------------------------------------------------------------------+
 

//| AccountInfoDouble()    13/14
//+------------------------------------------------------------------+
//| ACCOUNT_LIABILITIES
//|
//| built-in function:  AccountInfoDouble( ACCOUNT_LIABILITIES )
//|
//| Not supported
//|
//+------------------------------------------------------------------+
 

//| AccountInfoDouble()    14/14
//+------------------------------------------------------------------+
//| ACCOUNT_COMMISSION_BLOCKED
//|
//| built-in function:  AccountInfoDouble( ACCOUNT_COMMISSION_BLOCKED )
//|
//+------------------------------------------------------------------+
 


//<<< AccountInfoInteger functions >>>


//| AccountInfoInteger()   1/7
//+------------------------------------------------------------------+
//| long  ACCOUNT_LOGIN   >>> see "i_CurrentAccountNumber()"
//| 
//| "Account number"
//|
//| Uses the built-in function:  AccountInfoInteger( ACCOUNT_LOGIN )
//| Documented: MQL4 Reference  /  Constants, Enumerations and Structures  /  Environment State / Account Properties 
//|
//+------------------------------------------------------------------+


//| AccountInfoInteger()   2/7
//+------------------------------------------------------------------+
//| ENUM  ACCOUNT_TRADE_MODE  [skipped]
//|
//| "Account trade mode"  => 
//|   * ACCOUNT_TRADE_MODE_DEMO     (Demo account)
//|   * ACCOUNT_TRADE_MODE_CONTEST  (Contest account)
//|   * ACCOUNT_TRADE_MODE_REAL     (Real account)
//|
//| Uses the built-in function:  AccountInfoInteger( ACCOUNT_TRADE_MODE )
//| Documented: MQL4 Reference  /  Constants, Enumerations and Structures  /  Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
 


//| AccountInfoInteger()   3/7
//+------------------------------------------------------------------+
//| long  ACCOUNT_LEVERAGE   >>> see "d_CurrentAccountLeverageDecimal()"
//| 
//| "Account leverage"
//|
//| Uses the built-in function:  AccountInfoInteger( ACCOUNT_LEVERAGE )
//| Documented: MQL4 Reference  /  Constants, Enumerations and Structures  /  Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
 

//| AccountInfoInteger()   4/7
//+------------------------------------------------------------------+
//| int  ACCOUNT_LIMIT_ORDERS
//| "Maximum allowed number of open positions and active pending orders (in total), 0 — unlimited"
//|
//| Uses the built-in function:  AccountInfoInteger( ACCOUNT_LIMIT_ORDERS )
//| Documented: MQL4 Reference  /  Constants, Enumerations and Structures  /  Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
int i_CurrentAccountLimitOrders()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function
   int nErrCode;

   int iCurrentAccountLimitOrders = (int) AccountInfoInteger( ACCOUNT_LIMIT_ORDERS );        //interesting...it complains about being an INT (it compiles with no warnings if converted to a bool)...but it returns a true INT i.e "5000" !
   nErrCode = GetLastError();
   if( nErrCode != ERR_NO_ERROR )  {
      myLogger.logERROR( StringConcatenate( "AccountLimitOrders()::Error: ", ErrorDescription( nErrCode ) ) ); 
   }
   myLogger.logDEBUG( StringConcatenate( "Current Account LimitOrders: ", iCurrentAccountLimitOrders ) );

   return( iCurrentAccountLimitOrders );
}



//| AccountInfoInteger()   5/7
//+------------------------------------------------------------------+
//| int  ACCOUNT_MARGIN_SO_MODE
//| "Mode for setting the minimal allowed margin"
//|
//| Returns ENUM:
//|   * ACCOUNT_STOPOUT_MODE_PERCENT      Account stop out mode in percents
//|   * ACCOUNT_STOPOUT_MODE_MONEY        Account stop out mode in money
//|
//| Uses the built-in function:  AccountInfoInteger( ACCOUNT_MARGIN_SO_MODE )
//| Documented: MQL4 Reference  /  Constants, Enumerations and Structures  /  Environment State / Account Properties 
//|
//+------------------------------------------------------------------+










//| AccountInfoInteger()   6/7
//+------------------------------------------------------------------+
//| bool  ACCOUNT_TRADE_ALLOWED     >> see "s_CurrentAccountTradeAllowed()"
//| "Allowed trade for the current account" i.e. Is trading enabled for the current account?
//|
//| AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) may return false in the following cases:
//|   * no connection to the trade server. That can be checked using TerminalInfoInteger(TERMINAL_CONNECTED));
//|   * trading account switched to read-only mode (sent to the archive);
//|   * trading on the account is disabled at the trade server side;
//|   * connection to a trading account has been performed in Investor mode.
//|
//| Uses the built-in function:  AccountInfoInteger( ACCOUNT_TRADE_ALLOWED )
//| Documented: MQL4 Reference  /  Constants, Enumerations and Structures  /  Environment State / Account Properties 
//|
//+------------------------------------------------------------------+





//| AccountInfoInteger()   7/7
//+------------------------------------------------------------------+
//| bool  ACCOUNT_TRADE_EXPERT   >>> see "is_CurrentAccountTradeExpertAllowed()"
//|
//| "Allowed trade for an Expert Advisor" i.e. Is this account permitted to trade via Expert Advisors?
//| (Automated trading can be disabled at the trade server side)
//|
//| Uses the built-in function:  AccountInfoInteger( ACCOUNT_TRADE_EXPERT )
//| Documented: MQL4 Reference  /  Constants, Enumerations and Structures  /  Environment State / Account Properties 
//|
//+------------------------------------------------------------------+






//<<< AccountInfoString functions >>>


//| AccountInfoString()    1/4
//+------------------------------------------------------------------+
//| string  ACCOUNT_NAME      >>> see "s_CurrentAccountName()"
//| "Client name"
//|
//| Uses the built-in function:  AccountInfoString( ACCOUNT_NAME )
//| Documented: MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
 

//| AccountInfoString()    2/4
//+------------------------------------------------------------------+
//| string  ACCOUNT_SERVER    >>> see "s_CurrentAccountServer()"
//| "Trade server name"
//|
//| Uses the built-in function:  AccountInfoString( ACCOUNT_SERVER )
//| Documented: MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+

 

//| AccountInfoString()    3/4
//+------------------------------------------------------------------+
//| string  ACCOUNT_CURRENCY  >>> see "s_CurrentAccountCurrency()"
//| "Account currency"
//|
//| Uses the built-in function:  AccountInfoString( ACCOUNT_CURRENCY )
//| Documented: MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+

 

//| AccountInfoString()    4/4
//+------------------------------------------------------------------+
//| string  ACCOUNT_COMPANY   >>> see "s_CurrentAccountCompany()"
//| "Name of a company that serves the account"
//|
//| Uses the built-in function:  AccountInfoString( ACCOUNT_COMPANY )
//| Documented: MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
 

 








//+------------------------------------------------------------------+

//  <<< MY 'ACCOUNT' WRAPPERS >>>

//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
//| s_CurrentAccountCompany()
//| 
//| "Returns the brokerage company name where the current account was registered."
//|
//| Uses the built-in functions:
//|   * AccountCompany()                        MQL4 Reference / Account Information / AccountCompany 
//|   * AccountInfoString( ACCOUNT_COMPANY )    MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
string s_CurrentAccountCompany()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //string sCurrentAccountCompany1 = AccountCompany();
   //myLogger.logDEBUG( StringConcatenate( "Current Account Company1: ", sCurrentAccountCompany1 ) );

   // New way...
   string sCurrentAccountCompany2 = AccountInfoString( ACCOUNT_COMPANY );
   myLogger.logDEBUG( StringConcatenate( "Current Account Company2: ", sCurrentAccountCompany2 ) );

   return( sCurrentAccountCompany2 );
}





//+------------------------------------------------------------------+
//|   s_CurrentAccountCurrency()
//| 
//| "Currency name of the current account"
//|
//| Uses the built-in functions:
//|   * AccountCurrency()                       MQL4 Reference / Account Information / AccountCurrency
//|   * AccountInfoString( ACCOUNT_CURRENCY )   MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
string s_CurrentAccountCurrency()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //string sCurrentAccountCurrency1 = AccountCurrency();
   //myLogger.logDEBUG( StringConcatenate( "Current Account Currency1: ", sCurrentAccountCurrency1 ) );

   // New way...
   string sCurrentAccountCurrency2 = AccountInfoString( ACCOUNT_CURRENCY );
   myLogger.logDEBUG( StringConcatenate( "Current Account Currency2: ", sCurrentAccountCurrency2 ) );

   return( sCurrentAccountCurrency2 );
}






//+------------------------------------------------------------------+
//|   d_CurrentAccountLeverageDecimal()
//| 
//| "Returns leverage of the current account" ...but converts from a Ratio into a Decimal! 
//| 
//|
//| Uses the built-in functions:
//|   * AccountLeverage()                         MQL4 Reference / Account Information / AccountLeverage
//|   * AccountInfoInteger( ACCOUNT_LEVERAGE )    MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//| 
//|
//+------------------------------------------------------------------+

double d_CurrentAccountLeverageDecimal()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way... Account Leverage - First as a Ratio [via AccountLeverage()]...
   //int i_CurrentAccountLeverageRatio1 = AccountLeverage();
   //int nErrCode = GetLastError();
   //if( nErrCode != ERR_NO_ERROR )  {
   //   myLogger.logERROR( StringConcatenate( "AccountLeverage()::Error: ", ErrorDescription( nErrCode ) ) ); 
   //}
   //myLogger.logDEBUG( StringConcatenate( "Current Account Leverage #1 (Ratio): ", i_CurrentAccountLeverageRatio1, ":1  [via AccountLeverage()]" ) );


   // New way... Account Leverage - Again as a Ratio [but this time via  'AccountInfoInteger( ACCOUNT_LEVERAGE )']...
   long l_CurrentAccountLeverageRatio2 = AccountInfoInteger( ACCOUNT_LEVERAGE );
   myLogger.logDEBUG( StringConcatenate( "Current Account Leverage #2 (Ratio): ", l_CurrentAccountLeverageRatio2, ":1  [via AccountInfoInteger( ACCOUNT_LEVERAGE )]" ) );

   // Test for zero (I think this occurs when markets are closed over the weekend!)
   double dLeverageDecimal;
   if ( l_CurrentAccountLeverageRatio2 > 0 )
   {
      // Account Leverage - Then as a Decimal...
      dLeverageDecimal = (1 / (double) l_CurrentAccountLeverageRatio2 ); 
      myLogger.logDEBUG( StringConcatenate( "...or (as a decimal percentage): ", dLeverageDecimal, "...or (as a percentage): ", (dLeverageDecimal*100), "%" ) );
   } else {
      myLogger.logERROR( "Leverage is zero - Cannot divide by zero!" );
      dLeverageDecimal = 0;
   }

   return( dLeverageDecimal );
}

//+------------------------------------------------------------------+





//+------------------------------------------------------------------+
//|   i_CurrentAccountLimitOrders()    >>> go look in "AccountInfoInteger( ACCOUNT_LIMIT_ORDERS )"
//+------------------------------------------------------------------+






//+------------------------------------------------------------------+
//|   d_CurrentAccountMarginCallThreshold()
//| 
//| "Returns the value of the Margin Call level"/Static Threshold
//| Also (Silently) returns the calculation mode for the Margin Call level. 
//|
//| ACCOUNT_MARGIN_SO_CALL typically returns 120% 
//| If the Terminal's "Margin Level" (Equity ÷ Margin x 100) falls below this then a Margin Call is generated
//|
//| Uses the built-in functions:  
//|   * AccountInfoDouble( ACCOUNT_MARGIN_SO_CALL )        MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
double  d_CurrentAccountMarginCallThreshold()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   // (Can't find one)   

   // New way...
   double dMarginCallThreshold2    = AccountInfoDouble( ACCOUNT_MARGIN_SO_CALL ); 
   myLogger.logDEBUG( StringConcatenate( "Current Account Margin Call Threshold2: ", dMarginCallThreshold2 ) );

   ENUM_ACCOUNT_STOPOUT_MODE  eMarginCallMode = e_CurrentAccountMarginStopOutUnitsMode();
   myLogger.logDEBUG( StringConcatenate( "Current Account Margin Call/Stop Out Mode: ", EnumToString( eMarginCallMode ) ) );
   
   return( dMarginCallThreshold2 );
}







//+------------------------------------------------------------------+
//|   d_CurrentAccountMarginStopOutThreshold()
//| 
//| "Returns the value of the Stop Out level"/Static Threshold
//| Also (Silently) returns the calculation mode for the Stop Out level. 
//|
//| ACCOUNT_MARGIN_SO_SO typically returns 100% 
//| If the Terminal's "Margin Level" (Equity ÷ Margin x 100) falls below this then a Stop Out occurs
//|
//| Uses the built-in functions:  
//|   * AccountStopoutLevel()                         MQL4 Reference / Account Information / AccountStopoutLevel (and) .../AccountStopoutMode 
//|   * AccountInfoDouble( ACCOUNT_MARGIN_SO_SO )     MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
double  d_CurrentAccountMarginStopOutThreshold()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //int iLevel = AccountStopoutLevel();
   
   
      //if( AccountStopoutMode() == 0 ) {
      //   myLogger.logDEBUG( StringFormat( "StopOut level: %i%%", iLevel ) );
      //} else {
      //   //( AccountStopoutMode() == 1 )
      //   myLogger.logDEBUG( StringConcatenate( "StopOut level: %i  %s  << Comparison of the free margin level to the absolute value", iLevel, s_CurrentAccountCurrency() ) );
      //}; //end if


   // New way...
   double dStopOut    = AccountInfoDouble( ACCOUNT_MARGIN_SO_SO ); 

   ENUM_ACCOUNT_STOPOUT_MODE  eStopOutMode = e_CurrentAccountMarginStopOutUnitsMode();
   myLogger.logDEBUG( StringConcatenate( "Current Account Threshold Mode: ", EnumToString( eStopOutMode ) ) );
   
   return( dStopOut );
}







//+------------------------------------------------------------------+
//|   i_CurrentAccountMarginStopOutCalcMode()
//|
//| Calculation mode of free margin allowed to opened orders on the current account. 
//| 
//| The calculation mode can take the following values:
//|   0 - floating profit/loss is not used for calculation
//|   1 - both floating profit and loss on opened orders on the current account are used for free margin calculation
//|   2 - only profit value is used for calculation, the current loss on opened orders is not considered
//|   3 - only loss value is used for calculation, the current floating profit on opened orders is not considered
//|
//+------------------------------------------------------------------+
int i_CurrentAccountMarginStopOutCalcMode()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   double  dAccountFreeMarginMode = AccountFreeMarginMode();      // IS THIS REALLY A DOUBLE OR INT!?!
   myLogger.logDEBUG( StringConcatenate( "dAccountFreeMarginMode (RAW): ", dAccountFreeMarginMode ) );

   int iAccountFreeMarginMode = (int) dAccountFreeMarginMode;
   string sText;
   switch ( iAccountFreeMarginMode )
   {
      case 0  : sText = "0 - floating profit/loss is not used for calculation"; break;
      case 1  : sText = "1 - both floating profit and loss on opened orders on the current account are used for free margin calculation"; break;
      case 2  : sText = "2 - only profit value is used for calculation, the current loss on opened orders is not considered"; break;
      case 3  : sText = "only loss value is used for calculation, the current floating profit on opened orders is not considered"; break;
      default : sText = "<Not Known>"; break;
   }
   myLogger.logDEBUG( StringConcatenate( "dAccountFreeMarginMode (PRETTY): ", sText ) );
   
   return( iAccountFreeMarginMode );
}







//+------------------------------------------------------------------+
//|   e_CurrentAccountMarginStopOutUnitsMode()
//|
//| Returns whether Margin Call/Stop Out threshold is either a percentage or an absolute value
//|
//+------------------------------------------------------------------+
ENUM_ACCOUNT_STOPOUT_MODE e_CurrentAccountMarginStopOutUnitsMode()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   int iStopOutMode1 = AccountStopoutMode();
   string sMode;
   if( iStopOutMode1 == 0 ) {
      sMode = "calculation of percentage ratio between margin and equity";
   } else {
      //( AccountStopoutMode() == 1 )
      sMode = "comparison of the free margin level to the absolute value";
   }; //end if
  myLogger.logDEBUG( StringFormat( "AccountStopoutMode(): Is a %s", sMode ) );


   //New way...
   
   //--- Stop Out is set in percentage or money 
   ENUM_ACCOUNT_STOPOUT_MODE eStopOutMode2 = (ENUM_ACCOUNT_STOPOUT_MODE) AccountInfoInteger( ACCOUNT_MARGIN_SO_MODE );
   myLogger.logDEBUG( StringConcatenate( "Current Account Stoput/MarginCall Mode: ", EnumToString( eStopOutMode2 ) ) );

   //--- For DEBUG informational purposes only, get the value of the levels when a 'Margin Call' and 'Stop Out' occur .  These values are not returned by the function
   double dMarginCall = AccountInfoDouble( ACCOUNT_MARGIN_SO_CALL ); 
   double dStopOut    = AccountInfoDouble( ACCOUNT_MARGIN_SO_SO ); 

   //--- Show brief account information 
   myLogger.logDEBUG( StringFormat( "Account StopOut levels are set in %s",  (eStopOutMode2 == ACCOUNT_STOPOUT_MODE_PERCENT)?"percentage":" money"  ) ); 
   myLogger.logDEBUG( StringFormat( "MarginCall=%G, StopOut=%G", dMarginCall, dStopOut ) );
   

   return( eStopOutMode2 );
   
}






//+------------------------------------------------------------------+
//| s_CurrentAccountName()
//| 
//| "Returns the current account name"  e.g. "Paul Hearmon"
//|
//| Uses the built-in functions:
//|   * AccountName()                       MQL4 Reference / Account Information / AccountName
//|   * AccountInfoString( ACCOUNT_NAME )   MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
string s_CurrentAccountName()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //string sCurrentAccountName1 = AccountName();
   //myLogger.logDEBUG( StringConcatenate( "Current Account Name1: ", sCurrentAccountName1 ) );

   // New way...
   string sCurrentAccountName2 = AccountInfoString( ACCOUNT_NAME );
   myLogger.logDEBUG( StringConcatenate( "Current Account Name2: ", sCurrentAccountName2 ) );

   return( sCurrentAccountName2 );
}






//+------------------------------------------------------------------+
//| i_CurrentAccountNumber()
//| 
//| "Returns the current account Number"  e.g. "22229248"
//|
//| Uses the built-in function:
//|   * AccountNumber()                      MQL4 Reference / Account Information / AccountNumber
//|   * AccountInfoInteger( ACCOUNT_LOGIN )  MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
long i_CurrentAccountNumber()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //int iCurrentAccountNumber = AccountNumber();
   //myLogger.logDEBUG( StringConcatenate( "Current Account Number: ", iCurrentAccountNumber, "[via AccountNumber()]" ) );

   // New way...
   long lLogin = AccountInfoInteger( ACCOUNT_LOGIN ); 
   myLogger.logDEBUG( StringConcatenate( "Current Account Number: ", lLogin ) );

   return( lLogin );
}







//+------------------------------------------------------------------+
//| s_CurrentAccountServer()
//| 
//| "Returns the connected server name"   e.g. "Forex.com-Demo 106"
//|
//| Uses the built-in functions:
//|   * AccountServer()                      MQL4 Reference / Account Information / AccountServer
//|   * AccountInfoString( ACCOUNT_SERVER )  MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
string s_CurrentAccountServer()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //string sCurrentAccountServer1 = AccountServer();
   //myLogger.logDEBUG( StringConcatenate( "Current Account Server1: ", sCurrentAccountServer1 ) );

   // New way...
   string sCurrentAccountServer2 =  AccountInfoString( ACCOUNT_SERVER );
   myLogger.logDEBUG( StringConcatenate( "Current Account Server2: ", sCurrentAccountServer2 ) );

   return( sCurrentAccountServer2 );
}






//+------------------------------------------------------------------+
//|   d_CurrentAccountTerminalBalance()
//| 
//| "Balance value of the current account (the amount of money on the account)"
//|
//| Uses the built-in functions:
//|   *  AccountBalance()                       [MQL4 Reference / Account Information / AccountBalance ]
//|   *  AccountInfoDouble( ACCOUNT_BALANCE )   [MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties]
//|
//+------------------------------------------------------------------+
double d_CurrentAccountTerminalBalance()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //double dCurrentAccountTerminalBalance1 = AccountBalance();
   //myLogger.logDEBUG( StringConcatenate( "Current Account Balance #1: ", dCurrentAccountTerminalBalance1 ) );

   // New way...
   double dCurrentAccountTerminalBalance2 = AccountInfoDouble( ACCOUNT_BALANCE );
   myLogger.logDEBUG( StringConcatenate( "Current Account Balance #2: ", dCurrentAccountTerminalBalance2 ) );

   return( dCurrentAccountTerminalBalance2 );
}




//+------------------------------------------------------------------+
//|   d_CurrentAccountTerminalCredit()
//| 
//| "Credit value of the current account"
//|
//| Uses the built-in functions:  
//|   * AccountCredit()                      MQL4 Reference / Account Information / AccountCredit 
//|   * AccountInfoDouble( ACCOUNT_CREDIT )  MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
double d_CurrentAccountTerminalCredit()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //double dCurrentAccountTerminalCredit1 = AccountCredit();
   //myLogger.logDEBUG( StringConcatenate( "Current Account Credit1: ", dCurrentAccountTerminalCredit1 ) );

   // New way...
   double dCurrentAccountTerminalCredit2 = AccountInfoDouble( ACCOUNT_CREDIT );
   myLogger.logDEBUG( StringConcatenate( "Current Account Credit2: ", dCurrentAccountTerminalCredit2 ) );

   return( dCurrentAccountTerminalCredit2 );
}



//+------------------------------------------------------------------+
//|   d_CurrentAccountTerminalEquity()
//| 
//| "Equity value of the current account. Equity calculation depends on trading server settings."
//|
//| Uses the built-in functions:  
//|   * AccountEquity()                         MQL4 Reference / Account Information / AccountEquity
//|   * AccountInfoDouble( ACCOUNT_EQUITY )     MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
double d_CurrentAccountTerminalEquity()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //double dCurrentAccountEquity1 = AccountEquity();
   //myLogger.logDEBUG( StringConcatenate( "Current Account Equity1: ", dCurrentAccountEquity1 ) );

   // New way...
   double dCurrentAccountEquity2 = AccountInfoDouble( ACCOUNT_EQUITY );
   myLogger.logDEBUG( StringConcatenate( "Current Account Equity2: ", dCurrentAccountEquity2 ) );

   return( dCurrentAccountEquity2 );
}







//+------------------------------------------------------------------+
//|   d_CurrentAccountTerminalMarginFree()
//| 
//| "Returns free margin value of the current account"
//| Returns the Current Account's Free Margin
//| Also (Silently) Determines the Calculation Mode for calculating the Free Margin
//|
//| Uses the built-in functions:  
//|   * AccountFreeMargin() / AccountFreeMarginMode()    MQL4 Reference / Account Information / AccountFreeMargin (and) .../AccountFreeMarginMode
//|   * AccountInfoDouble( ACCOUNT_MARGIN_FREE )         MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
double d_CurrentAccountTerminalMarginFree()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // First describe the "Mode" i.e. the way the Free Margin is calculated
   myLogger.logDEBUG( StringConcatenate( "Current Account FreeMarginMode: ", AccountFreeMarginMode(), "  1=both floating profit and loss on open positions on the current account are used for free margin calculation"  ) );

   // Old way... Now return the Free Margin - first using "AccountFreeMargin()"
   //double dCurrentAccountFreeMargin1 = AccountFreeMargin();
   //myLogger.logDEBUG( StringConcatenate( "Current Account FreeMargin1: ", dCurrentAccountFreeMargin1 ) );


   // New way... Now return the Free Margin again - this time using "AccountInfoDouble( ACCOUNT_MARGIN_FREE )"
   double dCurrentAccountFreeMargin2 = AccountInfoDouble( ACCOUNT_MARGIN_FREE );
   myLogger.logDEBUG( StringConcatenate( "Current Account FreeMargin2: ", dCurrentAccountFreeMargin2 ) );

   return( dCurrentAccountFreeMargin2 );
}

//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
//|   d_CurrentAccountTerminalMarginFreeCheck()
//| 
//| "Returns Free margin that remains *AFTER* the specified order has been opened at the current price on the current account. 
//|   If the free margin is insufficient, an error 134 (ERR_NOT_ENOUGH_MONEY) will be generated."
//| 
//|
//| Uses the built-in function:  AccountFreeMarginCheck()
//| Documented: MQL4 Reference / Account Information / AccountFreeMarginCheck 
//| 
//|
//+------------------------------------------------------------------+
double d_CurrentAccountTerminalMarginFreeCheck( const string sSymbol, const int kTradeOperation, const double dLots )
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function
   int nErrCode;

   double dCurrentAccountFreeMarginAfterwards = AccountFreeMarginCheck( sSymbol, kTradeOperation, dLots );
   nErrCode = GetLastError();
   if( nErrCode != ERR_NO_ERROR )  {
      myLogger.logERROR( StringConcatenate( "AccountFreeMarginCheck()::Error: ", ErrorDescription( nErrCode ) ) ); 
   }
   myLogger.logDEBUG( StringConcatenate( "Current Account Free Margin Check: ", dCurrentAccountFreeMarginAfterwards ) );

   return( dCurrentAccountFreeMarginAfterwards );
}

//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|   d_CurrentAccountTerminalMarginLevel()     >>> go find in "AccountInfoDouble( ACCOUNT_MARGIN_LEVEL )"
//|
//| Returns the super-crazy-large % from the Terminal e.g.  "2,345.00%"
//+------------------------------------------------------------------+






//BUT I THOUGHT THE LEVERAGE VARIES WITH EACH SYMBOL!?     i.e. it doesn't need/isn't using:   "( const string sSymbol )"


//+------------------------------------------------------------------+
//|   d_CurrentAccountTerminalMarginUsed()
//| 
//| "Returns margin value of the current account"  (Returns the Current Account's *Used* Margin)
//|
//| Uses the built-in functions:  
//|   * AccountMargin()                      MQL4 Reference / Account Information / AccountMargin 
//|   * AccountInfoDouble( ACCOUNT_MARGIN )  MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
double d_CurrentAccountTerminalMarginUsed()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //double dCurrentAccountUsedMargin1 = AccountMargin();
   //myLogger.logDEBUG( StringConcatenate( "Current Account Margin1: ", dCurrentAccountUsedMargin1 ) );

   // New way...
   double dCurrentAccountUsedMargin2 = AccountInfoDouble( ACCOUNT_MARGIN );
   myLogger.logDEBUG( StringConcatenate( "Current Account Margin2: ", dCurrentAccountUsedMargin2 ) );

   return( dCurrentAccountUsedMargin2 );
}

//+------------------------------------------------------------------+







//+------------------------------------------------------------------+
//| d_CurrentAccountTerminalProfit()
//| 
//| "Returns the current account Profit" >>> Actually returns the combined profit of all my OPEN trades.  With no open trades, Profit returns 0
//|
//| Uses the built-in function:
//|   * AccountProfit()                      MQL4 Reference / Account Information / AccountProfit
//|   * AccountInfoDouble( ACCOUNT_PROFIT )  MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
double d_CurrentAccountTerminalProfit()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //double dCurrentAccountTerminalProfit1 = AccountProfit();
   //myLogger.logDEBUG( StringConcatenate( "Current Account Profit1: ", dCurrentAccountTerminalProfit1 ) );

   // New way...
   double dCurrentAccountTerminalProfit2 = AccountInfoDouble( ACCOUNT_PROFIT );
   myLogger.logDEBUG( StringConcatenate( "Current Account Profit2: ", dCurrentAccountTerminalProfit2 ) );
   
   return( dCurrentAccountTerminalProfit2 );
}





//+------------------------------------------------------------------+
// string   AccountFreeMarginMode()  [see "d_CurrentAccountTerminalMarginFree()"]
//+------------------------------------------------------------------+





//+------------------------------------------------------------------+
//| is_CurrentAccountTradeAllowed()
//| 
//| "Is trading Permitted?"
//|
//| Uses the built-in function:
//|   * isTradeAllowed()                            MQL4 Reference / Checkup / isTradeAllowed
//|   * AccountInfoDouble( ACCOUNT_TRADE_ALLOWED )  MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
bool is_CurrentAccountTradeAllowed()
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function
   // Old way...
   bool isCurrentAccountTradeAllowed1 = IsTradeAllowed();
   myLogger.logDEBUG( StringConcatenate( "Current Account Trading is allowed (1): ", isCurrentAccountTradeAllowed1 ) );
   

   // New way...
   bool isCurrentAccountTradeAllowed2 = AccountInfoInteger( ACCOUNT_TRADE_ALLOWED );
   myLogger.logDEBUG( StringConcatenate( "Current Account Trading is allowed (2): ", isCurrentAccountTradeAllowed2 ) );

   return( isCurrentAccountTradeAllowed2 );
}






//+------------------------------------------------------------------+
//| is_CurrentAccountTradeExpertAllowed()
//| 
//| Are experts enabled for trading BOTH in the Client AND on the Server (expert trading can be disabled at the server end
//|
//| Uses the built-in function:
//|   * isTradeAllowed()                            MQL4 Reference / Checkup / isTradeAllowed
//|   * AccountInfoDouble( ACCOUNT_TRADE_ALLOWED )  MQL4 Reference / Constants, Enumerations and Structures / Environment State / Account Properties 
//|
//+------------------------------------------------------------------+
bool is_CurrentAccountTradeExpertAllowed()
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way (still applicable?  CLIENT END)
   bool isCurrentAccountTradeExpertAllowed1 = IsExpertEnabled();
   myLogger.logDEBUG( StringFormat( "Automated trading has been %s for the account at the CLIENT end", (isCurrentAccountTradeExpertAllowed1)?"ALLOWED":"FORBIDDEN" ) );
   
      // Controlled by:  Tools [menu] >> Options [sub menu] >> Expert Advisors [tab] >> Allow Automated Trading [check box]

   // New way (still applicable?  SERVER END)
   bool isCurrentAccountTradeExpertAllowed2 = AccountInfoInteger( ACCOUNT_TRADE_EXPERT );
   myLogger.logDEBUG( StringFormat( "Automated trading has been %s for the account at the SERVER end", (isCurrentAccountTradeExpertAllowed2)?"ALLOWED":"FORBIDDEN" ) );

   return( isCurrentAccountTradeExpertAllowed1 && isCurrentAccountTradeExpertAllowed2 );
}





/*

Couple of interesting formulas found:  https://www.mql5.com/en/docs/constants/environment_state/marketinfoconstants#enum_symbol_calc_mode

   Margin:  Lots * Contract_Size / Leverage * Margin_Rate

   Profit:  (close_price - open_price) * Contract_Size*Lots
*/


//+------------------------------------------------------------------+

//  <<< MY 'SYMBOL' WRAPPERS >>>

// MQL4 Reference / Constants, Enumerations and Structures / Environment State / Symbol Properties
//    although note that "MarketInfo()" appear at the top, you have to scoll down for the "SymbolInfoInteger()", "SymbolInfoDouble()" and "SymbolInfoString()" Constants!


// Out of the "SymbolInfoXXX()" functions, some of them are 'Not Supported' and some I simply don't care about
// These are the ones I care about:

// SymbolInfoInteger():
//    SYMBOL_TIME                Time of the last quote                                                        datetime
//    SYMBOL_DIGITS              Digits after a decimal point                                                  int
//    SYMBOL_SPREAD_FLOAT        Indication of a floating spread                                               bool
//    SYMBOL_SPREAD              Spread value in points                                                        int
//    SYMBOL_TRADE_CALC_MODE     Contract price calculation mode                                               int
//    SYMBOL_TRADE_MODE          Order execution type                                                          ENUM_SYMBOL_TRADE_MODE
//          There are several symbol trading modes. Information about trading modes of a certain symbol is reflected in the values of enumeration ENUM_SYMBOL_TRADE_MODE...
//          *These values are not used in MQL4 (added for compatibility with MQL5)
//             SYMBOL_TRADE_MODE_DISABLED    Trade is disabled for the symbol
//             SYMBOL_TRADE_MODE_LONGONLY*   Allowed only long positions
//             SYMBOL_TRADE_MODE_SHORTONLY*  Allowed only short positions
//             SYMBOL_TRADE_MODE_CLOSEONLY   Allowed only position close operations
//             SYMBOL_TRADE_MODE_FULL        No trade restrictions
 
//    SYMBOL_TRADE_STOPS_LEVEL   Minimal indention in points from the current close price to place Stop orders int
//    SYMBOL_TRADE_FREEZE_LEVEL  Distance to freeze trade operations in points                                 int
//    SYMBOL_TRADE_EXEMODE       Deal execution mode                                                           ENUM_SYMBOL_TRADE_EXECUTION
//          Possible deal execution modes for a certain symbol are defined in enumeration ENUM_SYMBOL_TRADE_EXECUTION...
//          *These values are not used in MQL4 (added for compatibility with MQL5)
//             SYMBOL_TRADE_EXECUTION_REQUEST   Execution by request
//             SYMBOL_TRADE_EXECUTION_INSTANT   Instant execution
//             SYMBOL_TRADE_EXECUTION_MARKET    Market execution
//             SYMBOL_TRADE_EXECUTION_EXCHANGE* Exchange execution

//    SYMBOL_SWAP_MODE           Swap calculation model                                                        int
//    SYMBOL_SWAP_ROLLOVER3DAYS  Day of week to charge 3 days swap rollover                                    ENUM_DAY_OF_WEEK
//          ENUM_DAY_OF_WEEK = SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY


// SymbolInfoDouble():
//    SYMBOL_BID                 Bid - best sell offer                                                         double
//    SYMBOL_ASK                 Bid - best buy offer                                                          double
//    SYMBOL_POINT               Symbol point value                                                            double
//    SYMBOL_TRADE_TICK_VALUE    Value of SYMBOL_TRADE_TICK_VALUE_PROFIT  (weird 'cos that ain't supported!)   double
//    SYMBOL_TRADE_TICK_SIZE     Minimal price change                                                          double
//    SYMBOL_TRADE_CONTRACT_SIZE Trade contract size                                                           double
//    SYMBOL_VOLUME_MIN          Minimal volume for a deal                                                     double
//    SYMBOL_VOLUME_MAX          Maximal volume for a deal                                                     double
//    SYMBOL_VOLUME_STEP         Minimal volume change step for deal execution                                 double
//    SYMBOL_SWAP_LONG           Buy order swap value                                                          double
//    SYMBOL_SWAP_SHORT          Sell order swap value                                                         double
//    SYMBOL_MARGIN_INITIAL      see notes>>>                                                                  double   Initial margin means the amount in the margin currency required for opening an order with the volume of one lot. It is used for checking a client's assets when he or she enters the market.
//    SYMBOL_MARGIN_MAINTENANCE  see notes>>>                                                                  double   The maintenance margin. If it is set, it sets the margin amount in the margin currency of the symbol, charged from one lot. It is used for checking a client's assets when his/her account state changes. If the maintenance margin is equal to 0, the initial margin is used.

// SymbolInfoString():
//    SYMBOL_CURRENCY_BASE       Basic currency of a symbol                                                    string
//    SYMBOL_CURRENCY_PROFIT     Profit currency                                                               string
//    SYMBOL_CURRENCY_MARGIN     Margin currency                                                               string
//    SYMBOL_DESCRIPTION         Symbol description                                                            string
//    SYMBOL_PATH                Path in the symbol tree                                                       string
 

 
 
 

 

 


//+------------------------------------------------------------------+
datetime l_SymbolLastQuoteTime( const string sSymbol )
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //    *guessing* that it actually returns LONG but I'll cast it to a DATETIME
   datetime    dtLastQuoteTime1 = (datetime) MarketInfo( sSymbol, MODE_TIME);          //confirmed INT
   myLogger.logINFO( StringConcatenate( "LastQuoteTime2 [via SymbolInfoInteger]: ", dtLastQuoteTime1, " (The last incoming tick time (last known server time))" ) );

   // New way...
   //    actually returns LONG but I'll cast it to a DATETIME
   datetime dtLastQuoteTime2 = (datetime) SymbolInfoInteger( sSymbol, SYMBOL_TIME );      //confirmed INT
   myLogger.logINFO( StringConcatenate( "LastQuoteTime2 [via SymbolInfoInteger]: ", dtLastQuoteTime2, " (Time of the last quote)" ) );
   
   return ( dtLastQuoteTime2 );
}


long l_SymbolDigits( const string sSymbol )
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //int    iDigits1 = (int) MarketInfo( sSymbol, MODE_DIGITS);          //confirmed INT
   //myLogger.logINFO( StringConcatenate( "Digits [via MarketInfo]: ", iDigits1, "(Count of digits after decimal point in the symbol prices)" ) );

   // New way...
   long   lDigits2 = SymbolInfoInteger( sSymbol, SYMBOL_DIGITS );      //confirmed INT
   myLogger.logINFO( StringConcatenate( "Digits [via SymbolInfoInteger]: ", lDigits2, " (Digits after a decimal point)" ) );
   
   return ( lDigits2 );
}





long l_SymbolSpread( const string sSymbol )
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   //int  iSpread1 = (int) MarketInfo( sSymbol, MODE_SPREAD);       //confirmed INT
   //myLogger.logINFO( StringConcatenate( "Spread [via MarketInfo]: ", iSpread1, "  (Spread value in points)" ) );

   long lSpread2 = SymbolInfoInteger( sSymbol, SYMBOL_SPREAD );     //confirmed INT/LONG (not DOUBLE)
   myLogger.logINFO( StringConcatenate( "Symbol Spread: ", lSpread2, " (Spread value in points)" ) );
   
   return( lSpread2 );
}





long i_SymbolMinTicksToPlaceStop( const string sSymbol )
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   //MarketInfo( Symbol(), MODE_STOPLEVEL)                        MQL4 Reference / Constants, Enumerations and Structures / Environment State / Symbol Properties (top of page)
   //------------------------------------
   // Stop level in points
   // A zero value of MODE_STOPLEVEL means either absence of any restrictions on the minimal distance for Stop Loss/Take Profit or the fact 
   // that a trade server utilizes some external mechanisms for dynamic level control, which cannot be translated in the client terminal. 
   // In the second case, GetLastError() can return error 130, because MODE_STOPLEVEL is actually "floating" here.
   int dStopLevel1 = (int) MarketInfo( sSymbol, MODE_STOPLEVEL); //confirmed, but probably INT (measured in points, like Spread) -
   myLogger.logINFO( StringConcatenate( "StopLevel1: ", dStopLevel1, "  [MarketInfo]" ) );
   
   // SymbolInfoInteger( Symbol(), SYMBOL_TRADE_STOPS_LEVEL )     MQL4 Reference / Constants, Enumerations and Structures / Environment State / Symbol Properties (down the page)
   //--------------------------------------------------------
   // Minimal indention in points from the current close price to place Stop orders
   long dStopLevel2 = SymbolInfoInteger( sSymbol, SYMBOL_TRADE_STOPS_LEVEL );
   myLogger.logINFO( StringConcatenate( "StopLevel2: ", dStopLevel2, "  [SymbolInfoInteger]" ) );
   
   return( dStopLevel2 );

}


bool b_SymbolIsTradeAllowed( const string sSymbol )
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   bool bTradeAllowed1 = (int) MarketInfo( sSymbol,MODE_TRADEALLOWED);  //(BOOL Constant)
   myLogger.logINFO(  StringConcatenate( "TradeAllowed1: ", bTradeAllowed1, "  (1 = Trade is allowed for the symbol)" ) );

   //New way...
      // returns:
      //    * SYMBOL_TRADE_MODE_DISABLED - Trade is disabled for the symbol
      //    * SYMBOL_TRADE_MODE_CLOSEONLY - Allowed only position close operations
      //    * SYMBOL_TRADE_MODE_FULL - No trade restrictions

   ENUM_SYMBOL_TRADE_MODE bTradeAllowed2 = (ENUM_SYMBOL_TRADE_MODE) SymbolInfoInteger( sSymbol, SYMBOL_TRADE_MODE );
   return( bTradeAllowed2 != SYMBOL_TRADE_MODE_DISABLED );

}



long l_SymbolFreezeRange( const string sSymbol )
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // Old way...
   double dFreezeLevel1 = MarketInfo( sSymbol, MODE_FREEZELEVEL); //unconfirmed - Order freeze level in points. If the execution price lies within the range defined by the freeze level, the order cannot be modified, cancelled or closed   INT (in points)
   myLogger.logINFO( StringConcatenate( "FreezeLevel [via MarketInfo()]: ", dFreezeLevel1, "  (Order freeze level in points. If the execution price lies within the range defined by the freeze level, the order cannot be modified, cancelled or closed)"  ) );

   // New way...
   long lFreezeLevel2 = SymbolInfoInteger( sSymbol, SYMBOL_TRADE_FREEZE_LEVEL );          //confirmed INT
   myLogger.logINFO( StringConcatenate( "FreezeLevel [via SymbolInfoInteger()]: ", lFreezeLevel2, " (Distance to freeze trade operations in points)"  ) );

   return( lFreezeLevel2 );
}



//<<< TO BE SORTED/INTEGRATED... >>>

//+------------------------------------------------------------------+
//|   s_MarginCalculationMode()
//| 
//| Returns how the margin is calculated
//|
//| Either:
//|   * 0 - Forex
//|   * 1 - CFD
//|   * 2 - Futures
//|
//+------------------------------------------------------------------+
string s_SymbolMarginCalculationMode( const string sSymbol )
{
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   int iMarginCalcMode = (int) MarketInfo( sSymbol, MODE_MARGINCALCMODE ); //[INT]  Margin calculation mode. .
   myLogger.logDEBUG( StringConcatenate( "MarginCalcMode: ", iMarginCalcMode, " (Margin calculation mode. 0 - Forex; 1 - CFD; 2 - Futures)" ) );

   string sRet;
   switch ( iMarginCalcMode )
   {
      case 0  : sRet = "FOREX"; break;
      case 1  : sRet = "CFD"; break;
      case 2  : sRet = "FUTURES"; break;
      default : sRet = "<Not Known>"; break;
   }
   
   return( sRet );

}  


//<<< It appears that calls to "AccountInfoDouble( ACCOUNT_MARGIN_INITIAL )" are "not supported"...which may explain why the result is always zero? >>>

//+------------------------------------------------------------------+
//|   d_SymbolMarginRequiredForOneLot()
//| 
//| Returns the margin for (Purchasing?) one Lot of the Base Currency of the Market Symbol
//|
//|
//+------------------------------------------------------------------+
double d_SymbolMarginRequiredForOneLot( const string sSymbol )
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function
   int nErrCode;
   
   //These seem to only ever return "0"
   double MarginInit1 = MarketInfo( sSymbol, MODE_MARGININIT); //unconfirmed(returns "0") - Initial margin requirements for 1 lot [DOUBLE]
   nErrCode = GetLastError();
   if( nErrCode != ERR_NO_ERROR )  {
      myLogger.logERROR( StringConcatenate( "MarketInfo(MODE_MARGININIT)::Error: ", ErrorDescription( nErrCode ) ) ); 
   }
   myLogger.logDEBUG( StringConcatenate( "MarginInit #1: ", MarginInit1, "  (Initial margin requirements for 1 lot)   >>>MarketInfo(sSymbol,MODE_MARGININIT)" ) );


   double MarginInit2 = SymbolInfoDouble( sSymbol, SYMBOL_MARGIN_INITIAL ); //Initial margin means the amount in the margin currency required for opening an order with the volume of one lot. It is used for checking a client's assets when he or she enters the market.
   nErrCode = GetLastError();
   if( nErrCode != ERR_NO_ERROR )  {
      myLogger.logERROR( StringConcatenate( "SymbolInfoDouble(SYMBOL_MARGIN_INITIAL)::Error: ", ErrorDescription( nErrCode ) ) ); 
   }
   myLogger.logDEBUG( StringConcatenate( "MarginInit #2: ", MarginInit2, "  (Initial margin requirements for 1 lot)   >>>SymbolInfoDouble( sSymbol, SYMBOL_MARGIN_INITIAL )" ) );
   
   double MarginRequired3 = MarketInfo( sSymbol, MODE_MARGINREQUIRED ); //confirmed(works) - Free margin required to open 1 lot for buying [DOUBLE]
   myLogger.logDEBUG( StringConcatenate( "MarginRequired: ", MarginRequired3, "  (Free margin required to open 1 lot for buying)"  ) );

   return( MarginRequired3 );
}






//+------------------------------------------------------------------+
//|   d_MarginMaintenanceRequiredForOneLot()
//| 
//| Returns the margin for (Purchasing?) one Lot of the Base Currency of the Market Symbol
//|
//+------------------------------------------------------------------+
double d_SymbolMarginMaintenanceRequiredForOneLot( const string sSymbol )
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function
   int nErrCode;

   double MarginMaintenance1 = MarketInfo( sSymbol, MODE_MARGINMAINTENANCE); //unconfirmed(returns "0") - Margin to maintain open orders calculated for 1 lot [DOUBLE]
   nErrCode = GetLastError();
   if( nErrCode != ERR_NO_ERROR )  {
      myLogger.logERROR( StringConcatenate( "MarketInfo(MODE_MARGINMAINTENANCE)::Error: ", ErrorDescription( nErrCode ) ) ); 
   }
   myLogger.logINFO( StringConcatenate( "MarginMaintenance #1: ", MarginMaintenance1, "  (Margin to maintain open positions calculated for 1 lot) >> MarketInfo(sSymbol,MODE_MARGINMAINTENANCE)" ) );

   double MarginMaintenance2 = SymbolInfoDouble( sSymbol, SYMBOL_MARGIN_MAINTENANCE);   ////The maintenance margin. If it is set, it sets the margin amount in the margin currency of the symbol, charged from one lot. It is used for checking a client's assets when his/her account state changes. If the maintenance margin is equal to 0, the initial margin is used
   nErrCode = GetLastError();
   if( nErrCode != ERR_NO_ERROR )  {
      myLogger.logERROR( StringConcatenate( "SymbolInfoDouble(SYMBOL_MARGIN_MAINTENANCE)::Error: ", ErrorDescription( nErrCode ) ) ); 
   }
   myLogger.logINFO( StringConcatenate( "MarginMaintenance #2: ", MarginMaintenance2, "  (Margin to maintain open positions calculated for 1 lot) >> MarketInfo(sSymbol,MODE_MARGINMAINTENANCE)" ) );

   return( MarginMaintenance2 );
}

///... (TO BE SORTED)





//+------------------------------------------------------------------+

void testMarginViaPhantomTrade( const int kTradeOperation, const double dLots, const string sSymbol, const double dLeverageDecimal, const double dAccountFreeMargin ) {

   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function
   myLogger.logINFO( StringConcatenate( "\r\n<<<testMarginViaPhantomTrade>>>  kTradeOperation: ", kTradeOperation, ", dLots: ", dLots, ", sSymbol: ", sSymbol ) );



   int nErrCode;
   double dPosValue;
   string sTradeOperation;

   double DIRorder        = Direction( kTradeOperation ),
          perLotPerPoint  = PointValuePerLot( sSymbol ),
          equityAtRisk = 0;

   myLogger.logINFO( StringConcatenate( "Test Margin via phantom ",sTradeOperation," trade of ",dLots," lots..." ) );


   

   myLogger.logINFO( StringFormat( "\n------- First print out some (relatively) static Margin info for the Symbol (%s) --------", sSymbol ) );

   myLogger.logINFO( StringConcatenate( "MarginCalcMode: ", s_SymbolMarginCalculationMode( sSymbol ) ) );

   
   double dMarginRequired = d_SymbolMarginRequiredForOneLot( sSymbol );
   myLogger.logINFO( StringConcatenate( "MarginRequired: ", dMarginRequired, "  (Free margin required to open 1 lot for buying)"  ) );
   
   double dMarginMaintenance = d_SymbolMarginMaintenanceRequiredForOneLot( sSymbol );
   myLogger.logINFO( StringConcatenate( "MarginMaintenance: ", dMarginMaintenance, "  (Margin to maintain open positions calculated for 1 lot) >> MarketInfo(sSymbol,MODE_MARGINMAINTENANCE)" ) );

// Keep out of a function for now (until I've figured out whether it's failing, or just always returns "0"...
   double MarginHedged = MarketInfo( sSymbol,MODE_MARGINHEDGED); //unconfirmed(returns "0") - Hedged margin calculated for 1 lot [DOUBLE]
   nErrCode = GetLastError();
   if( nErrCode != ERR_NO_ERROR )  {
      myLogger.logERROR( StringConcatenate( "MarketInfo(MODE_MARGINHEDGED)::Error: ", ErrorDescription( nErrCode ) ) ); 
   }
   myLogger.logINFO( StringConcatenate( "MarginHedged: ", MarginHedged, "  (Initial margin requirements for 1 lot)" ) );
//...end






   if ( kTradeOperation == OP_SELL )  {
      sTradeOperation = "Sell";
      myLogger.logINFO( StringConcatenate( "\tCurrent Bid = ", Bid ) );
      dPosValue = PriceMove2ValueCalculator( sSymbol, Bid, dLots );
      equityAtRisk += Bid * DIRorder  * dLots * perLotPerPoint;

   } else {
      sTradeOperation = "Buy";
      myLogger.logINFO( StringConcatenate( "\tCurrent Ask = ", Ask ) );
      dPosValue = PriceMove2ValueCalculator( sSymbol, Ask, dLots );
      equityAtRisk += Ask * DIRorder  * dLots * perLotPerPoint;
   }
   myLogger.logINFO(  StringConcatenate( "equityAtRisk: ", equityAtRisk ) );


   double dEstimatedFreeMarginAfterTrade = d_CurrentAccountTerminalMarginFreeCheck( sSymbol, kTradeOperation, dLots);

   double dUnitPrice_CC = (kTradeOperation == OP_SELL )?Bid:Ask;
   
   int iLotSize = 100000;     //call function instead!

   double dMarginRequired_MAN = ((dLots * iLotSize) * dUnitPrice_CC * dLeverageDecimal);      //(Base Units) × Quote Price × Margin    where (Base Units) = (Lot Size x Standard Contract Size)

   
   double dLotPrice = dLots*dUnitPrice_CC*iLotSize;
   myLogger.logINFO( StringFormat( "Buying %g Lots (where 1 Lot = %i Units) at %g would cost $%g (assuming USD) in the Counter Currency of %s", dLots, iLotSize, dUnitPrice_CC, dLotPrice, StringSubstr(sSymbol,3,3) ) );

   myLogger.logINFO( StringFormat( "My Margin (manually calculated) = $%g  ", dMarginRequired_MAN ) );

   myLogger.logINFO( StringFormat( "Given that my Prior Margin was $%g, that means that deducting $%g from it, will result in a new Margin of %g", dAccountFreeMargin, dMarginRequired_MAN, (dAccountFreeMargin-dMarginRequired_MAN)  ) );
   myLogger.logINFO( StringFormat( "This should match up with the result of the function [AccountFreeMarginCheck()] %g", dEstimatedFreeMarginAfterTrade  ) );

   myLogger.logINFO( "But supposing I don't want to use *their* leverage!?..." );
   
   double dLeverageDecimal_MOD = 0.2;  //i.e. 20%
   dMarginRequired_MAN = ((dLots * iLotSize) * dUnitPrice_CC * dLeverageDecimal_MOD);      //(Base Units) × Quote Price × Margin    where (Base Units) = (Lot Size x Standard Contract Size)
   myLogger.logINFO( StringFormat( "By upping my Account Leverage Decimal up to %i%%", (dLeverageDecimal_MOD*100), " I lay down more of my own money on the trade and use less of the broker's"  ) );
   myLogger.logINFO( StringFormat( "Which means that my Margin (manually calculated) is NOW = $%g  [((dLots * dLotSize2) * dUnitPrice_CC * dLeverageDecimal)]", dMarginRequired_MAN ) );
   myLogger.logINFO( StringFormat( "  Deducting this from my bank account results in ... [TBD]", 0  ) );
   myLogger.logINFO( StringFormat( "  Or gearing up MT4's Used Margin/Free Margin results in ... [TBD]", 0  ) );
   
   
/*
double DIRorder        = Direction( OrderType() ),
       perLotPerPoint  = PointValuePerLot( OrdersSymbol );

equityAtRisk += (OrderClosePrice()-OrderOpenPrice()) * DIRorder  * OrderLots() * perLotPerPoint;
*/


}

//double positionValueInDollars( string sSymbol

int printErrorDescription( int errorCode )                        
  {
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   switch( errorCode )
     {                                          // Not crucial errors            
      case  4: myLogger.logINFO("Trade server is busy. Trying once again..");
         Sleep(3000);                           // Simple solution
         return(1);                             // Exit the function

      case 135:myLogger.logINFO("Price changed. Trying once again..");
         RefreshRates();                        // Refresh rates
         return(1);                             // Exit the function

      case 136:myLogger.logINFO("No prices. Waiting for a new tick..");
         while(RefreshRates()==false)           // Till a new tick
            Sleep(1);                           // Pause in the loop
         return(1);                             // Exit the function

      case 137:myLogger.logINFO("Broker is busy. Trying once again..");
         Sleep(3000);                           // Simple solution
         return(1);                             // Exit the function

      case 146:myLogger.logINFO("Trading subsystem is busy. Trying once again..");
         Sleep(500);                            // Simple solution
         return(1);                             // Exit the function
         // Critical errors

      case  2: myLogger.logINFO("Common error.");
         return(0);                             // Exit the function

      case  5: myLogger.logINFO("Old terminal version.");
//         Work=false;                            // Terminate operation
         return(0);                             // Exit the function

      case 64: myLogger.logINFO("Account blocked.");
//         Work=false;                            // Terminate operation
         return(0);                             // Exit the function

      case 133:myLogger.logINFO("Trading forbidden.");
         return(0);                             // Exit the function

      case 134:myLogger.logINFO("Not enough money to execute operation.");
         return(0);                             // Exit the function

      case 0: myLogger.logINFO("no error");
         return(0);

      case 4106: myLogger.logINFO("SymbolInfoDouble()::symbol is not selected in 'Market Watch' (not found in the list of available ones)" ); return(1);

      case 4051: myLogger.logINFO("SymbolInfoDouble()::invalid identifier of a symbol property" ); return(1);

      case 4024: myLogger.logINFO("SymbolInfoDouble()::internal error" ); return(1);


      default: {
                  myLogger.logINFO( StringConcatenate( "Error occurred: ", errorCode ) );  // Other variants   
               }
         return(0);                             // Exit the function
     }
  }


//+------------------------------------------------------------------+
//| PriceMove2ValueCalculator
//| Takes: the Price Move difference (between two Price Levels) in terms of the counter currency, and a Lot size
//| Returns: Calculates the value of a position
//+------------------------------------------------------------------+
double PriceMove2ValueCalculator( string sSymbol, double dPriceMove, double dLots ) {
   LLP( LOG_INFO ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   //int kFunctionLoggingLevel = LOG_OFF;  
   //string sLogPrefix = "OrderManagement::PriceMove2ValueCalculator::";
   
   //(Price Move / (Value of a Point in Deposit Currency ) * Value of a Point in Quote Currency ) * Num of Lots [NOT units!]
   double valueInUSD = (dPriceMove /MarketInfo(sSymbol,MODE_TICKSIZE)) * MarketInfo(sSymbol,MODE_TICKVALUE) * dLots;
      //   double valueInUSD = dPriceMove * (MarketInfo(sSymbol,MODE_TICKVALUE)*Point)/MarketInfo(sSymbol,MODE_TICKSIZE) * (dLots * MarketInfo( sSymbol, MODE_LOTSIZE ) );  incorrect!!!

   //log( log_handle_trace, StringConcatenate( sLogPrefix, "value (Deposit Ccy/USD): $ ", valueInUSD ), kFunctionLoggingLevel, LOG_INFO );
   //log( log_handle_trace, StringConcatenate( sLogPrefix, "Price move (quote/counter currency): ", DoubleToStr(dPriceMove,Digits), ", Num Lots: ", dLots, ", Tick Value (Deposit currency): $", DoubleToStr(MarketInfo(sSymbol,MODE_TICKVALUE),2), ", Point (quote/counter currency): ", DoubleToStr(Point,Digits), ",  Tick Size (quote/counter currency): ", DoubleToStr(MarketInfo(sSymbol,MODE_TICKSIZE),Digits), ", Account Lot Size (base currency/Units): ", DoubleToStr(MarketInfo( sSymbol, MODE_LOTSIZE ),0) ), kFunctionLoggingLevel, LOG_DEBUG );
   return( valueInUSD );
}




double  Direction(int op_xxx){
   return( 1. - 2. * (op_xxx%2) );
}

double  PointValuePerLot(string pair="") {
    /* Value in account currency of a Point of Symbol.
     * In tester I had a sale: open=1.35883 close=1.35736 (0.0147)
     * gain$=97.32/6.62 lots/147 points=$0.10/point or $1.00/pip.
     * IBFX demo/mini       EURUSD TICKVALUE=0.1 MAXLOT=50 LOTSIZE=10,000
     * IBFX demo/standard   EURUSD TICKVALUE=1.0 MAXLOT=50 LOTSIZE=100,000
     *                                  $1.00/point or $10.0/pip.
     *
     * http://forum.mql4.com/33975 CB: MODE_TICKSIZE will usually return the
     * same value as MODE_POINT (or Point for the current symbol), however, an
     * example of where to use MODE_TICKSIZE would be as part of a ratio with
     * MODE_TICKVALUE when performing money management calculations which need
     * to take account of the pair and the account currency. The reason I use
     * this ratio is that although TV and TS may constantly be returned as
     * something like 7.00 and 0.0001 respectively, I've seen this
     * (intermittently) change to 14.00 and 0.0002 respectively (just example
     * tick values to illustrate).
     * http://forum.mql4.com/43064#515262 zzuegg reports for non-currency DE30:
     * MarketInfo(sSymbol,MODE_TICKSIZE) returns 0.5
     * MarketInfo(sSymbol,MODE_DIGITS) return 1
     * Point = 0.1
     * Prices to open must be a multiple of ticksize */
    if (pair == "") pair = Symbol();
    return(  MarketInfo(pair, MODE_TICKVALUE)
           / MarketInfo(pair, MODE_TICKSIZE) ); // Not Point.
}


 

