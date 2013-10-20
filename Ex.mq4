//+------------------------------------------------------------------+
//|                                           zapis_do_pliku_csv.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
  int handle;
  datetime orderOpen=OrderOpenTime();
  handle=FileOpen("test", FILE_CSV|FILE_WRITE, ';');
  if(handle>0)
    {
     FileWrite(handle, "test");
     FileClose(handle);
    }
//----
   return(0);
  }
//+------------------------------------------------------------------+

