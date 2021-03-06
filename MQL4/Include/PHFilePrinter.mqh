//+------------------------------------------------------------------+
//|                                                 PHLoggerS2020.mq4 |
//|                                    Copyright � 2020, HearMonster |
//|                                         mailto:hearmonster@pm.me |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2020, HearMonster"
#property link      "mailto:hearmonster@pm.me"
#property strict

//+---------------------------------------------------------------------------+
//  WHEN DO THE LINES GET APPENDED? (When will my lines appear in the file?)
//
//  Flushing appears to be a definite issue with MT4!  :o(
//
//  So I've added a counter - which flushes the log file after exery 
//    50 rows appended
// 
//  You can also set up the Timer (in your calling script's INIT method) to 
//    explicitly call my Flush() method every 'x' seconds
//+---------------------------------------------------------------------------+

#define _AUTO_FLUSH 50

//+------------------------------------------------------------------+
//|  WHERE DO THE (LOG) FILES GET WRITTEN?
//|
//| The Terminal is installed into:
//| C:\Users\i817399\AppData\Roaming\MetaQuotes\Terminal\F2262CFAFF47C27887389DAB2852351A
//| (I'll refer to this as <TERMINAL_HOME> below)
//|
//| WHICH DIRETCTORY?
//| The *Directory* in which the file will be created:
//|    When run as a *Script*:         <TERMINAL_HOME>\MQL4\Files
//|    When run as an *Expert*:        <TERMINAL_HOME>\MQL4\Files
//|    But when run under the Tester:  <TERMINAL_HOME>\Tester\files\"
//|
//| UNDER WHAT FILENAME?
//| The file name will be:
//|  <Expert Name>(<Symbol>~<Period>).log   e.g. "PHTickTest(EURUSD~M1).log"
//|
//|   When executed under the MetaEditor, check Tools >> Options >> Debug [tab] for the <Symbol> and <Period>
//|   When executed under the Terminal TESTER, see the <Symbol> and <Period> fields
//|
//| FYI Remember that you *also* have
//|   a) Script/Expert Log files (the result of 'Print' functions) under "...\MetaTrader 4\experts\logs\"
//|   b) Tester Log files (loading of ex4 scripts + the result of trade opens & closes) under "...\MetaTrader 4\experts\logs\"
//|   c) MT4 System Log files (the result of trades) under "...\MetaTrader 4\logs\"
//|
//| "Print" commands get written to <TERMINAL_HOME>\MQL4\Logs\<YYYYMMDD>.log"
//|
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|
//+------------------------------------------------------------------+
class PHFilePrinter {

   public:
      //<<<Constructors>>>
               PHFilePrinter();
               ~PHFilePrinter();
      
      
      //<<<public methods>>>
      void     fileOpen( string sFileName_Param );
      void     filePrint( string text );
      void     fileFlush();

   protected:
      // The file handle (type:int). Used to be returned to the caller but is now held in a private attribute
      // This is protected (not private) so that child classes can check the validity of the file
      int      iFileHandle;
   
   
   private:

      int      iCurrentRecordFlushCount;
      int      fileMode;
      uint     nBytes;  //used to measure the number of bytes written. If zero after a write, then indicative of an error

}; // end class HEADER



/*
   //OLD CODE TO ENABLE OVERWRITE-MODE...         
      // isDelete_Param - if TRUE then overwrite log file (if it already exists)
      // set file mode to APPEND (typically, data/csv files) or OVERWRITE (typically, log files)
      int fileMode; 
      if ( isDelete_Param )
         // OVERWRITE - allows concurrent READs by Textpad while log still open by MT4
         fileMode = FILE_WRITE | FILE_SHARE_READ | FILE_TXT;  
      else {
         // APPEND - allows concurrent READs by Textpad while log still open by MT4
         fileMode = FILE_READ| FILE_SHARE_READ | FILE_WRITE | FILE_TXT; 
         // Apparently, the FILE_READ tag will result in the entire file being read at open...and then written back out before the first user write!
      }
*/

//+------------------------------------------------------------------+
//|  Constructor
//+------------------------------------------------------------------+
PHFilePrinter::PHFilePrinter() {

   fileMode = FILE_WRITE | FILE_SHARE_READ | FILE_TXT;  //Overwrite Mode. But still allow other problems (e.g TextPad) to open the file for reading
   nBytes = -1;
   iFileHandle = INVALID_HANDLE;
   iCurrentRecordFlushCount = -1;

}


//+------------------------------------------------------------------+
//|  Create/open my file (for writing)
//+------------------------------------------------------------------+
void PHFilePrinter::fileOpen( string sFileName_Param ) {

   ResetLastError(); 
	iFileHandle = FileOpen( sFileName_Param, fileMode, " " );
	
	//Check for errors during creation
   if ( iFileHandle == INVALID_HANDLE ) {
      // 'Print' will appear in the Terminal\<terminalID>\MQL4\Logs\<YYYYDDMM>.log file
      Alert("Failed to open " + sFileName_Param + " file, Error code = " + string(GetLastError())); 
      return;
   }

/*   
   	//Note: append mode
      if ( !isDelete_Param )
         FileSeek( iFileHandle, 0, SEEK_END );
*/   

   // 'Print' will appear in the Terminal\<terminalID>\MQL4\Logs\<YYYYDDMM>.log file
   Print( sFileName_Param + " file is available for writing. File path: " + TerminalInfoString(TERMINAL_DATA_PATH) + "\\Files\\" ); 

   //Note that if market is closed (eg weekend), then the timestamp shown will be of the last tick recived while open e.g. Friday night)
   
   string sFileIsNowOpenMsg = string( TimeLocal() ) + "::Log file opened for writing...";
   nBytes = FileWrite( iFileHandle, sFileIsNowOpenMsg );
	if ( nBytes == 0 )	{
	   //Log write failed for some reason
		int _GetLastError = GetLastError();
		Alert( "FileWrite ( ", iFileHandle, " ), Opened, but failed immediately afterwards. - Error #", _GetLastError );
		return;
   } else {

      //initial message written succsssfuly. Now flush.
      FileFlush( iFileHandle );
   }  //endif

}



     

//+------------------------------------------------------------------+
//|  Destructor                                                      |
//+------------------------------------------------------------------+
void PHFilePrinter::~PHFilePrinter() {
   //logMemFlush( iFileHandle );   //ensure all records are flushed from the RAM log


   if ( iFileHandle != INVALID_HANDLE ) {
      FileFlush( iFileHandle );
	   FileClose( iFileHandle );
	   //Print( "Log file: " + sStickyLogFilename + " is now closed." );
	}

}


//+------------------------------------------------------------------+
//| Flush log file on demand                                         |
//| (typicaly called via a EventTimer() or every 'x' records written)|
//+------------------------------------------------------------------+
void PHFilePrinter::fileFlush() {
   if ( iFileHandle != INVALID_HANDLE ) {
      //FileWrite( iFileHandle, TimeToStr( TimeCurrent(), TIME_DATE|TIME_SECONDS) + "::Log file flushed..." );
      FileFlush( iFileHandle );
   } //endif
   
}


//+------------------------------------------------------------------+
// filePrint( string text )
//
// Writes a text line into the expert's native log file. 
// Simple - Severity is not taken into account whatsover
//
//+------------------------------------------------------------------+
void PHFilePrinter::filePrint( string text ) {

   if ( iFileHandle != INVALID_HANDLE ) {
      //Add a time prefix
      //string logMsg = TimeToStr( TimeCurrent(), TIME_DATE|TIME_SECONDS) + "::" + text;    //OLD
      string logMsg = string( TimeLocal() ) + "::" + text;    
         // TimeLocal() returns local Workstation/Terminal time.
         // The format is a string ("2014.03.05 15:46:58") with #property strict, returns a datetime ("1394034418") without #property strict
         // For Tester:  Note that the time will reflect the first bar of the TESTER data, not the local Workstation/Terminal time
      
      //write the message to the log file, capture any error
      // 'FileWrite' returns number of bytes written or 0 in case of error. To obtain information about the error call the GetLastError() function.
      nBytes = FileWrite( iFileHandle, logMsg );
   	if ( nBytes == 0 )	{
   	   //Log write failed for some reason
   		int _GetLastError = GetLastError();
   		Alert( "FileWrite ( ", iFileHandle, ", \" failed while writing: ", text, "\" ) - Error #", _GetLastError );
   		return;
   	} else {
   	   //Log record wrtten successfully

         //Handle auto-flush, and reset counter if necessary
   	   iCurrentRecordFlushCount --;
   	   if ( iCurrentRecordFlushCount < 0 ) {
      	    // Save the written text on the disk
      		 fileFlush();
      		 //reset
      		 iCurrentRecordFlushCount = _AUTO_FLUSH;
         } //end if
      } // end else
   } //end if (not invalid file handle)
}


