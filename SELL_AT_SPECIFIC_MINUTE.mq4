/****************************************************************

This is a SELL only strategy 
Time frame is 1 hour
currency is EURUSD

*****************************************************************/

#property copyright "HFCG"

string output_filename = "ticks.csv";  
int handle = -9999;
string all_ticks_output_filename = "all_ticks.csv";  
int all_ticks_handle = -9999;
int current_hour = -1;

double open_bid = -9999.99;
double open_ask = -9999.99;
   
int start()
{
    int cnt;
    int order_id=1222010;
    int take_profit_for_sell=220;
    int stop_loss_for_sell=200;
    int triggering_delta_for_sell=100;
    int d_Sell=5;
    int life_span_in_seconds=800;
    double lots = 1;
    int current_minute = -1;
        
    // open the log file if needed
    if(handle == -9999)
    { 
        handle=FileOpen(output_filename, FILE_CSV|FILE_WRITE, ' ');    
    }
   
    if(all_ticks_handle == -9999)
    { 
        all_ticks_handle=FileOpen(all_ticks_output_filename, FILE_CSV|FILE_WRITE, ',');    
    }

    FileWrite(all_ticks_handle, Year(), Month(), Day(), Hour(),Minute(),Seconds(),Bid,Ask);    
    
    if(current_hour != Hour())
    {
         current_hour = Hour();
         FileWrite(handle, "Entering new hour:",Year(), Month(), Day(), Hour(),Minute(),Seconds()," ",Bid," ",Ask,",Open[0]= " ,Open[0]);    
         open_bid = Bid;
         open_ask = Ask;
         return 0;
    }
    
    if(OrdersTotal()==1)
    {
         OrderSelect(OrderTicket(), SELECT_BY_POS, MODE_TRADES);
         
         if (OrderSymbol()!=Symbol()  && OrderMagicNumber()!=order_id)
            return 0;
            
         if(TimeCurrent()-OrderOpenTime() >= life_span_in_seconds) 
         {
               OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet);
         }
                             
        return 0;
    }
   
     if(Minute() == 40)
     {         
          double delta = (Bid - open_bid) * 10000;

          if(delta >= triggering_delta_for_sell)
          {
                 OrderSend(Symbol(),OP_SELL,lots,Bid,3,Bid+stop_loss_for_sell*Point,Bid-take_profit_for_sell*Point,"SELL",1222010,0,Red);
                 FileWrite(handle, "create NEW sell order: ", Minute(),":",Seconds()," ",Bid," ",Ask," Price_Open_Hour =",Open[0]);
                 return 0;
            }
          }
      }
      return 0;
 }
 
