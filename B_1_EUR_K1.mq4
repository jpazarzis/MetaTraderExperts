//+------------------------------------------------------------------+
//|                                              AK_BAR_1.mq4        |
//|                            Copyright © 2010, Advanced FX, Inc.   |
//|                                                                  |
//+------------------------------------------------------------------+

   #property copyright "Copyright © 2007-2010, AK"
     
   
   string output_filename = "ticks.csv";  
   int handle = -9999;
   
   string all_ticks_output_filename = "all_ticks.csv";  
   int all_ticks_handle = -9999;
   
   int current_hour = -1;
   
//extern int take_profit_for_buy=210,stop_loss_for_buy=230,take_profit_for_sell=220,stop_loss_for_sell=200,life_span_in_seconds=800;
//extern double triggering_delta_for_buy=100,d_Buy=5,triggering_delta_for_sell=100,d_Sell=5;

//K1 (TEMP/OPT_Bar1...) 1724	1053980.12	1317	4.11	800.29	202309.53	33.23%	take_profit_for_buy=210 	stop_loss_for_buy=230 	
//take_profit_for_sell=220 	stop_loss_for_sell=200 	life_span_in_seconds=800 	triggering_delta_for_buy=100 	d_Buy=5 	triggering_delta_for_sell=100 	d_Sell=5

//2013- 5/20 P:192	34328.78	169	8.35	203.13	2686.20	6.03%	TP=280 	SL=270 	N=23 	life_span_in_seconds=800	


//2619	10581027.14	2431	14.96	4352.54	100579.88	9.06%	TP=330 	SL=300 	N=22 	life_span_in_seconds=900 	triggering_delta_for_buy=300 	
//d_Buy=9 	triggering_delta_for_sell=300 	d_Sell=5

//CHF: PRFT 1842.01	79	1.39	23.32	1549.97	15.47%	TP=58 	SL=55 	N=19 	life_span_in_seconds=10800	
//dd: 831.71	85	1.11	9.78	1611.08	12.95%	TP=33 	SL=44 	N=15 	life_span_in_seconds=6300	
 int start()
 {
    int cnt;
    
    int order_id=1222010;
    int take_profit_for_buy=210;
    int stop_loss_for_buy=230;
    int take_profit_for_sell=220;
    int stop_loss_for_sell=200;
    int life_span_in_seconds=800;
    
    int triggering_delta_for_buy =100;
    int d_Buy=5;
    
    int triggering_delta_for_sell=100;
    int d_Sell=5;
    
    //double lots = NormalizeDouble(AccountFreeMargin()*0.0001,2);
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
         // open_bid = Bid;
         // open_ask = Ask;
         return(0);
    }
    
    if(lots>49.99){
      lots=49.99;
    }
    
        
    if(OrdersTotal()==1)
    {
         OrderSelect(OrderTicket(), SELECT_BY_POS, MODE_TRADES);
         
         //if (OrderSymbol()!=Symbol()  && OrderMagicNumber()!=order_id)
         //   return(0);
            
         if(TimeCurrent()-OrderOpenTime() >= life_span_in_seconds) 
         {
            if(OrderType()==OP_BUY)// long position is opened
            { 
               OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet);
            } 
            else// Close SELL
            {
               OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet);
            }
         }
                             
         return(0);
    }
   
     if(Minute()==40)
      {         
      
         
          if(Open[0]>Close[0]+triggering_delta_for_buy*Point)
          {
            if(Low[0]+d_Buy*Point<Close[0])
            {
                 //OrderSend(Symbol(),OP_BUY,lots,Ask,3,Ask-stop_loss_for_buy*Point,Ask+take_profit_for_buy*Point,"BUY ",1222010,0,Green);
                 //Print(Minute(),":",Seconds()," ",Bid," ",Ask," Price_Open_Hour =",Open[Hour()]);
                 //FileWrite(handle, Minute(),":",Seconds()," ",Bid," ",Ask," Price_Open_Hour =",Open[Hour()]);
                 return(0);
            }
          }
          if(Open[0]+triggering_delta_for_sell*Point<Close[0])
          {
            if(High[0]>Close[0]+d_Sell*Point)
            {
                 OrderSend(Symbol(),OP_SELL,lots,Bid,3,Bid+stop_loss_for_sell*Point,Bid-take_profit_for_sell*Point,"SELL",1222010,0,Red);
                 FileWrite(handle, "create NEW sell order: ", Minute(),":",Seconds()," ",Bid," ",Ask," Price_Open_Hour =",Open[0]);
                 return(0);
            }
          }
      }
      
      return(0);
 }
 