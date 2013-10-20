/*------------------------------------------------------------------+
 |                                              Data_to_File_19.mq4 |
 |                                                 Copyright © 2013 |
 |                            aklim@msn.com  & basisforex@gmail.com |
 +------------------------------------------------------------------*/
#property copyright "Copyright © 2013"
#property link      "put your company name here"
//----
#property show_inputs
//----
extern string   strSymbol = "EURUSD";
extern datetime Beginning = D'2013.01.01';
extern string   Ending    = "Current Time";
extern int      FromHour  = -2;
extern int      ToHour    = 21;
//+------------------------------------------------------------------+
void Data_Output(string SymbolName, int PeriodMinutes)
 {
   int i;
   int dtDate;
   string strDate;
   double doubOpen, doubHigh = 0, doubLow = 99999, doubClose;
   int doubVolume;
   //---
   int size = iBars(SymbolName, PeriodMinutes);
   if(size == 0) return;
   int handle = FileOpen(SymbolName + "_" + TimeToStr(TimeCurrent(),TIME_DATE) + ".csv", FILE_WRITE|FILE_CSV, ",");
   if(handle < 0) return;
   FileWrite(handle);
   //---
   strDate = ""; doubOpen = 0; doubHigh = 0; doubLow = 9999; doubClose = 0; doubVolume = 0;
   //---
   for(i = size - 1; i >= 0; i--)
    {
      if(FromHour < 0)
       {                   
         if(iTime(SymbolName, PeriodMinutes, i) >= Beginning && iTime(SymbolName, PeriodMinutes, i) <= TimeCurrent())//TimeDay(iTime(NULL, PERIOD_H1, 0)) - 1)
          {
            if(strDate == "") 
             {
               strDate = StringSubstr(TimeToStr(iTime(SymbolName, PeriodMinutes, i)), 0, 10);
               dtDate = TimeDayOfYear(iTime(SymbolName, PeriodMinutes, i));
             } 
            if(doubOpen == 0 && TimeHour(iTime(SymbolName, PeriodMinutes, i)) == 24 + FromHour)
             {
               doubOpen  = iOpen(SymbolName, PeriodMinutes, i);//
             }
            if(TimeDayOfYear(iTime(SymbolName, PeriodMinutes, i)) != dtDate)
             {
               if(TimeHour(iTime(SymbolName, PeriodMinutes, i)) == ToHour && doubClose == 0)
                {
                  doubClose = iClose(SymbolName, PeriodMinutes, i);
                }
             }    
            //+++++++++++++++++++++++++++++++++++++++++++++++++
            if(TimeDayOfYear(iTime(SymbolName, PeriodMinutes, i)) != dtDate)
             { 
               if(TimeHour(iTime(SymbolName, PeriodMinutes, i)) >= 0 && TimeHour(iTime(SymbolName, PeriodMinutes, i)) <= ToHour)   
                {
                  if(iHigh(SymbolName, PeriodMinutes, i - FromHour) > doubHigh) doubHigh = iHigh(SymbolName, PeriodMinutes, i - FromHour);
                  if(iLow(SymbolName, PeriodMinutes, i - FromHour) < doubLow) doubLow = iLow(SymbolName, PeriodMinutes, i - FromHour);
                  doubVolume = doubVolume + iVolume(SymbolName, PeriodMinutes, i - FromHour);
                }
               if(doubOpen != 0 && doubClose != 0)//cDate != bDate && 
                {
                  FileWrite(handle, strDate, doubOpen, doubHigh, doubLow, doubClose, doubVolume);
                  strDate = ""; doubOpen = 0; doubHigh = 0; doubLow = 9999; doubClose = 0; doubVolume = 0;
                  dtDate = TimeDayOfYear(iTime(SymbolName, PeriodMinutes, i));
                }
             }    
          }                          
       }           
    }  
   //---                       
   FileClose(handle);      
   //----
   return;
 }
//+------------------------------------------------------------------+
int start()
 {
   Data_Output(strSymbol, PERIOD_H1);
   return(0);
 }
//+------------------------------------------------------------------+