//--------------------------------------------------------------------
// tradingexpert.mq4 
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
#property copyright "Copyright © Book, 2007"
#property link      "http://AutoGraf.dp.ua"
//--------------------------------------------------------------- 1 --

#include <PHLogger.mqh>



class PHTradingExpert {
 
   // <<<class variables>>>
                   // Numeric values for M15
   private:
      double dStopLoss;       // SL for an opened order
      double dTakeProfit;     // TP for an opened order
      int    iPeriod_MA_1;    // Period of MA 1
      int    iPeriod_MA_2;    // Period of MA 2
      double dRastvor;        // Distance between MAs 
      double dLots;           // Strictly set amount of lots
      double dPercFM;         // Percent of free margin
       
      string sSymbol;            // Security name
      bool   bWork;           // disables the EA - set by an error
      int    iErrorCode;
      //--------------------------------------------------------------- 2 --
      
      int
         iTotOrds,            // Amount of orders in a window 
         iOrdType_Selected,   // Type of selected order (B=0,S=1)
    //>>>>Consider enum?
         iOrderTicket;        // Order number
      
      double
         dMA_1_t,             // Current MA_1 value
         dMA_2_t,             // Current MA_2 value 
         dLot_Selected,       // Amount of lots in a selected order
         dLts_Opened,         // Amount of lots in an opened order
         dMinLot,             // Minimal amount of lots
         dStep,               // Step of lot size change
         dFreeMargin,         // Current free margin
         dPriceOneLot,             // Price of one lot
         dPrice_Selected,     // Price of a selected order
         dSL_Selected,        // SL of a selected order
         dTP_Selected;        // TP of a selected order
       
       bool
         bAns,                // Server response after closing
         isClsBuy,            // Criterion for closing Buy
         isClsSell,           // Criterion for closing Sell
         isOpnBuy,            // Criterion for opening Buy
         isOpnSell;           // Criterion for opening Sell
   
   
   
   // <<< CLASS METHODS - PUBLIC >>>
   public:
      void        PHTradingExpert( string _sSymbol );
      void        OrdersAccounting1();
      void        TradingCriteria2();
      void        CloseOrders3();
      void        CalcOrderSize4();
      void        CreateMarketOrder5();

   // <<< CLASS METHODS - PRIVATE >>>
   private:
      int         Fun_Error( int Error );
      double      New_Stop( double dStopLoss );

}; // end class HEADER
//--------------------------------------------------------------- 3 --



/*---------------------------------------------------------------
   Constructor
/---------------------------------------------------------------*/
void PHTradingExpert::PHTradingExpert( string _sSymbol ) {
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   bWork = true;  // Assume EA will remain enabled...unless set otherwise...


   if( Bars < iPeriod_MA_2 ) {                     // Not enough bars
      myLogger.logINFO( "Not enough bars in the window. EA doesn't work.");
      iErrorCode = INIT_FAILED;
      bWork = false;  // Disable EA and indicate Constructor failed during init

   }
   if( !IsExpertEnabled() ) {                   // Critical error
      myLogger.logINFO( "Critical error. EAs are disabled in general - Enable them.");
      iErrorCode = INIT_FAILED;
      bWork = false;  // Disable EA and indicate Constructor failed during init
   }
   if ( !IsTradeAllowed() ) {
      myLogger.logINFO( "Critical error. Trading is disabled.");
      iErrorCode = INIT_FAILED;
      bWork = false;  // Disable EA and indicate Constructor failed during init
   }
   if ( !bWork ) {
      myLogger.logINFO( "Critical error. EA is disabled (for some reason)");
      iErrorCode = INIT_FAILED;
      bWork = false;  // Disable EA and indicate Constructor failed during init
   }

   if ( bWork ) {
      dStopLoss    = 200;        // SL for an opened order
      dTakeProfit  =  39;        // TP for an opened order
      
      iPeriod_MA_1 =  11;        // Period of MA 1
      iPeriod_MA_2 =  31;        // Period of MA 2
      
      dRastvor     =  28.0;      // Distance between MAs 
      dLots        =     0.1;    // Strictly set amount of lots
      dPercFM      =     0.07;   // Percent of free margin
       
      bWork             = true;  // disables the EA - set by an error
      iOrdType_Selected = -1;    // Type of selected order (B=0,S=1)
      iOrderTicket      = -1;
   
      bAns      = false;   // Server response after closing
      isClsBuy  = false;   // Criterion for closing Buy
      isClsSell = false;   // Criterion for closing Sell
      isOpnBuy  = false;   // Criterion for opening Buy
      isOpnSell = false;   // Criterion for opening Sell

//TODO tighten logic for Symbol validation
      if ( StringLen( _sSymbol ) == 6 )
         sSymbol = _sSymbol;
         
      if ( sSymbol == "" )
         sSymbol = Symbol();      // Security name

      
      iErrorCode = INIT_SUCCEEDED;
   }
   myLogger.logDEBUG( StringConcatenate( "bWork: ", bWork + "; (initialization) iErrorCode: ", iErrorCode ) );
}  //end Constructor()




/*---------------------------------------------------------------
// <<Orders accounting block>>>
//
// allow only one working market order at a time
// "SELECT_BY_POS" => source of opened and pending orders
/---------------------------------------------------------------*/
void PHTradingExpert::OrdersAccounting1() 
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   iTotOrds = 0;                                         // Amount of orders
   for( int i = 1; i <= OrdersTotal(); i++ )             // Loop through orders   <OP FLIPPED>
     {
      if ( OrderSelect( i-1, SELECT_BY_POS ) == true )   // If there is an order, analyze it...
        {                                       
         if ( OrderSymbol() != sSymbol ) continue;       // (Ignore the Order if it's for another security)
         
         if ( OrderType() > 1 )                          // If Pending order found, Abort!
           {
            myLogger.logDEBUG( "Pending order detected. EA doesn't work." );
            return;                             // Exit start()
           }
         
         iTotOrds ++;   
                                           // Increment market orders Counter
         if ( iTotOrds > 1 )                             // Unable to handle MORE THAN ONE open order, Abort!   <OP FLIPPED>
           {
            myLogger.logDEBUG( "Several market orders. EA doesn't work.");
            return;                             // Exit start()
           }
           
         //Set some convenient variables from Attributes of the selected Market Order...  
         iOrderTicket      = OrderTicket();                  // Number of selected order
         iOrdType_Selected = OrderType();                    // Type of selected order
         dPrice_Selected   = OrderOpenPrice();               // Price of selected order
         dSL_Selected      = OrderStopLoss();                // SL of selected order
         dTP_Selected      = OrderTakeProfit();              // TP of selected order
         dLot_Selected     = OrderLots();                    // Amount of lots
        }
     } //end for
     myLogger.logDEBUG( StringConcatenate( "iTotOrds: ", iTotOrds, "; iOrderTicket: ", iOrderTicket ) );

} //end 'OrdersAccounting()'



/*---------------------------------------------------------------
// <<<Trading criteria>>>
// calculated on the difference between Moving Averages with different periods of averaging

// if 
//    1. The current value of the MA with smaller period is larger than the value of MA with larger period 
//    2. AND The difference between the values is larger than a certain value
//   THEN => Bull/Upward Trend
//       1. Set Criterion for "closing Sell" (Close any open SELL orders)
//       2. Set Criterion for "opening Buy"  (get ready to BUY)

// if
//    1. MA with smaller period is lower than MA with larger period 
//    2. AND The difference is also larger than a certain critical value
//   THEN => Bear/Downward Trend
//       1. Set Criterion for "closing Buy"   (Close any open BUY orders)
//       2. Set Criterion for "opening Sell"  (get ready to SELL)
/---------------------------------------------------------------*/
void PHTradingExpert::TradingCriteria2() 
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   dMA_1_t = iMA(NULL, 0 ,iPeriod_MA_1,0, MODE_LWMA, PRICE_TYPICAL, 0); // МА_1
   dMA_2_t = iMA(NULL, 0 ,iPeriod_MA_2,0, MODE_LWMA, PRICE_TYPICAL, 0); // МА_2
 
   if (dMA_1_t > (dMA_2_t + dRastvor*Point))  {       // If difference between MA 1 and 2 is large

      myLogger.logINFO( "Trading criteria:: Open a Buy. Close any Sells." );
      myLogger.logDEBUG( StringConcatenate( "dMA_1_t: ", dMA_1_t, "; dMA_2_t: ", dMA_2_t, "; dRastvor: ", dRastvor, "; Point: ", Point, "; 2nd half: ", (dMA_2_t + dRastvor*Point) ) );
      isOpnBuy=true;                               // Criterion for opening Buy
      isClsSell=true;                               // Criterion for closing Sell
   }  //endif

   if (dMA_1_t > (dMA_2_t - dRastvor*Point))   {       // If difference between MA 1 and 2 is large

      myLogger.logINFO( "Trading criteria:: Open a Sell. Close any Buys." );
      myLogger.logDEBUG( StringConcatenate( "dMA_1_t: ", dMA_1_t, "; dMA_2_t: ", dMA_2_t, "; dRastvor: ", dRastvor, "; Point: ", Point, "; 2nd half: ", (dMA_2_t - dRastvor*Point) ) );
      isOpnSell=true;                               // Criterion for opening Sell
      isClsBuy=true;                               // Criterion for closing Buy
     }
} //end 'TradingCriteria()'


     
/*---------------------------------------------------------------
// <<<Close any open orders>>>
// it is known for sure that at the current moment there are either no orders for the security, or there is only one market order.
/---------------------------------------------------------------*/
void PHTradingExpert::CloseOrders3() 
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   // 'While' is used here for the purpose that in case of a trade operation failure it could be repeated once again.
   while(true)                                  // Loop of closing orders
     {
      myLogger.logDEBUG( StringConcatenate( "iOrdType_Selected: ", iOrdType_Selected, "; isClsBuy: ", isClsBuy, "; isClsSell: ", isClsSell ) );
      if ( iOrdType_Selected == 0 && isClsBuy == true )  {  // An Order Buy has previously been opened..
                                                            // and there is criterion to close the Buy
         myLogger.logINFO( StringConcatenate( "Attempt to close Buy ",iOrderTicket,". Waiting for response.." ) );
         RefreshRates();                        // Refresh rates
         bAns = OrderClose( iOrderTicket, dLot_Selected, Bid, 2);      // Closing Buy
         if (bAns==true) {                        // Success :)
            myLogger.logINFO( StringConcatenate( "Closed order Buy. Ticket: ", iOrderTicket ) );
            break;                              // Exit closing loop
         }
         if ( Fun_Error( GetLastError() ) == 1 )      // Processing errors
            continue;                           // Retry to close the open order
         return;                                // Exit start()
      }
 
      if ( iOrdType_Selected == 1 && isClsSell == true ) {  //  An Order Sell has previously been opened..
                                                            // and there is criterion to close the Sell
         myLogger.logINFO( StringConcatenate( "Attempt to close Sell ",iOrderTicket,". Waiting for response.." ) );
         RefreshRates();                        // Refresh rates
         bAns=OrderClose(iOrderTicket,dLot_Selected,Ask,2);      // Closing Sell
         if (bAns==true)                         // Success :)
           {
               myLogger.logINFO( StringConcatenate( "Closed order Sell. Ticket: ",iOrderTicket ) );
               break;                              // Exit closing loop
           }
         if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;                           // Retrying
         return;                                // Exit start()
      }
      break;                                    // Exit while
     }
} //end 'CloseOrders()'


/*---------------------------------------------------------------
// Derive the Order size (dLots)
// Two options:
//  a) A certain constant value set up by a user (dLts_Opened)
//  OR b) The amount of lots is calculated on the basis of a sum equal to a certain percentage (set by a user) of a free margin.
/---------------------------------------------------------------*/
void PHTradingExpert::CalcOrderSize4() 
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function
   
   RefreshRates();                                          // Refresh rates
   dMinLot      = MarketInfo(sSymbol,MODE_MINLOT);          // Minimal number of lots 
   dFreeMargin  = AccountFreeMargin();                      // Free margin
   dPriceOneLot = MarketInfo(sSymbol,MODE_MARGINREQUIRED);  // Price of 1 lot
   dStep        = MarketInfo(sSymbol,MODE_LOTSTEP);         // Step is changed
   
   myLogger.logDEBUG( StringConcatenate( "dMinLot: ", dMinLot, "; dFreeMargin: ", dFreeMargin, "; dPriceOneLot: ", dPriceOneLot, "; dStep: ", dStep ) );
 

   // If user has specified non-zero for 'dLts_Opened', use it...
   if (dLots > 0) {
      dLts_Opened = dLots;
      myLogger.logINFO( StringConcatenate( "dLts_Opened (user supplied): ", dLts_Opened ) );
   
   // else use the % of free margin
   } else                                         
      dLts_Opened = MathFloor(dFreeMargin*dPercFM/dPriceOneLot/dStep)*dStep;
   
   myLogger.logINFO( StringConcatenate( "dLts_Opened (Calc): ", dLts_Opened ) );
   

   if(dLts_Opened < dMinLot) 
      dLts_Opened = dMinLot;               // Can't be less than minimal lots (broker)
   myLogger.logINFO( StringConcatenate( "dLts_Opened (after min check): ", dLts_Opened ) );
   
   // If non enough free margin, Abort!
   double dCostOfOrder = dLts_Opened * dPriceOneLot;
   myLogger.logDEBUG( "dCostOfOrder: " + string( dCostOfOrder ) );
   if ( dCostOfOrder > dFreeMargin ) {                     // Lot larger than free margin
      myLogger.logERROR( StringConcatenate( " Not enough money for ", dLts_Opened," lots" ) );
      return;                                   // Exit start()
   } else
      myLogger.logDEBUG( "Sufficient Free Margin available" );

}  //end 'CalcOrderSize()'



/*---------------------------------------------------------------
// <<<Open/Create Market Order>>>

// Stop Loss: 
// A user might set values for this parameters smaller that a broker allows. 
// so stop levels must be calculate taking into account values set a) by a user and b) the minimal allowed value set up by a broker.
/---------------------------------------------------------------*/
void PHTradingExpert::CreateMarketOrder5() 
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   while(true)                                  // Orders closing loop
     {
      if ( iTotOrds == 0 && isOpnBuy == true )              // No existing open orders AND criterion for opening Buy
        {                                    
         RefreshRates();                                       // Refresh rates
         dSL_Selected = Bid - New_Stop(  dStopLoss  ) * Point; // Calculating SL of opened
         dTP_Selected = Bid + New_Stop( dTakeProfit ) * Point; // Calculating TP of opened
         
         myLogger.logDEBUG( StringConcatenate( "Attempt to open Buy.  dSL_Selected: ", dSL_Selected, "; dTP_Selected: ", dTP_Selected, "; Waiting for response..." ) );
         
         iOrderTicket = OrderSend( sSymbol, OP_BUY, dLts_Opened, Ask, 2, dSL_Selected, dTP_Selected );  //Opening Buy
         
         if (iOrderTicket > 0)                        // Success!  <OP FLIPPED>
           {
            myLogger.logDEBUG( StringConcatenate( "Opened order Buy. Ticket: ", iOrderTicket ) );
            return;                             // Exit start()
           }
         if ( Fun_Error( GetLastError() ) == 1 )   // Processing errors
            continue;                              // Retrying
            
         return;                                   // Exit start()
        } //end if (iTotOrds==0 && isOpnBuy==true)
        
      if ( iTotOrds == 0 && isOpnSell == true )              // No existing open orders AND criterion for opening Sell
        {                                       
         RefreshRates();                        // Refresh rates
         dSL_Selected = Ask + New_Stop(  dStopLoss  ) * Point;     // Calculating SL of opened
         dTP_Selected = Ask - New_Stop( dTakeProfit ) * Point;   // Calculating TP of opened
         
         myLogger.logDEBUG( StringConcatenate( "Attempt to open Sell.  dSL_Selected: ", dSL_Selected, "; dTP_Selected: ", dTP_Selected, "; Waiting for response..." ) );
         iOrderTicket = OrderSend( sSymbol, OP_SELL, dLts_Opened, Bid, 2, dSL_Selected, dTP_Selected ); //Opening Sell
         
         if (iOrderTicket > 0)                        // Success  <OP FLIPPED>
           {
            myLogger.logDEBUG( StringConcatenate( "Opened order Buy. Ticket: ", iOrderTicket ) );
            return;                             // Exit start()
           }
         if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;                           // Retrying
         return;                                // Exit start()
        }  //end if (iTotOrds==0 && isOpnSell==true)
      break;                                    // Exit while
     } //end while
//--------------------------------------------------------------- 9 --
   return;                                      // Exit start()

}  //end 'CreateMarketOrder()'

  
//-------------------------------------------------------------- 10 --
// Function of processing errors

int PHTradingExpert::Fun_Error( int Error )
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   switch(Error)
     {                                          // Not crucial errors            
      case  4: myLogger.logINFO( "Trade server is busy. Trying once again..");
         Sleep(3000);                           // Simple solution
         return(1);                             // Exit the function
      case 135:myLogger.logINFO( "Price changed. Trying once again..");
         RefreshRates();                        // Refresh rates
         return(1);                             // Exit the function
      case 136:myLogger.logINFO( "No prices. Waiting for a new tick..");
         while(RefreshRates()==false)           // Till a new tick
            Sleep(1);                           // Pause in the loop
         return(1);                             // Exit the function
      case 137:myLogger.logINFO( "Broker is busy. Trying once again..");
         Sleep(3000);                           // Simple solution
         return(1);                             // Exit the function
      case 146:myLogger.logINFO( "Trading subsystem is busy. Trying once again..");
         Sleep(500);                            // Simple solution
         return(1);                             // Exit the function
         // Critical errors
      case  2: myLogger.logINFO( "Common error.");
         return(0);                             // Exit the function
      case  5: myLogger.logINFO( "Old terminal version.");
         bWork=false;                            // Terminate operation
         return(0);                             // Exit the function
      case 64: myLogger.logINFO( "Account blocked.");
         bWork=false;                            // Terminate operation
         return(0);                             // Exit the function
      case 133:myLogger.logINFO( "Trading forbidden.");
         return(0);                             // Exit the function
      case 134:myLogger.logINFO( "Not enough money to execute operation.");
         return(0);                             // Exit the function
      default: myLogger.logINFO( "Error occurred: " + string( Error) );  // Other variants   
         return(0);                             // Exit the function
     }
  }
//-------------------------------------------------------------- 11 --
// Checking stop levels
double      PHTradingExpert::New_Stop( double _dStopLoss )
{
   LLP( LOG_DEBUG ) //Set the 'Log File Prefix' and 'Log Threshold' for this function

   double dMinDist = MarketInfo( sSymbol, MODE_STOPLEVEL ); // Minimal distance allowed by broker
   
   // If current Stop Loss is less than allowed
   if ( _dStopLoss < dMinDist ) {
      _dStopLoss = dMinDist;                        // Set Stop Loss to mininum allowed by broker
      myLogger.logDEBUG( StringConcatenate( "Increased distance of stop level to ", _dStopLoss) );
   }
   return( _dStopLoss );                            // Returning value
  }
//-------------------------------------------------------------- 12 --