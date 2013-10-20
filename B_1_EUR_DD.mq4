//+------------------------------------------------------------------+
//|                                              AK_BAR_1.mq4        |
//|                            Copyright © 2010, Advanced FX, Inc.   |
//|                                                                  |
//+------------------------------------------------------------------+

   #property copyright "Copyright © 2007-2010, AK"
   
  extern int TP_b=210,SL_b=200,TP_s=240,SL_s=220,Int_Stop=800;
  extern double h_Buy=260,d_Buy=5,h_Sell=300,d_Sell=4;

//K1 (TEMP/OPT_Bar1...) 1724	1053980.12	1317	4.11	800.29	202309.53	33.23%	TP_b=210 	SL_b=230 	
//TP_s=220 	SL_s=200 	Int_Stop=800 	h_Buy=100 	d_Buy=5 	h_Sell=100 	d_Sell=5

//OPT (the same)63195.36	263	4.02	240.29	14116.18	16.58%	TP_b=210 	SL_b=200 	TP_s=240 	SL_s=220 	
//Int_Stop=800 	h_Buy=260 	d_Buy=5 	h_Sell=300 	d_Sell=4	


//2013- 5/20 P:192	34328.78	169	8.35	203.13	2686.20	6.03%	TP=280 	SL=270 	N=23 	Int_Stop=800	


//2619	10581027.14	2431	14.96	4352.54	100579.88	9.06%	TP=330 	SL=300 	N=22 	Int_Stop=900 	h_Buy=300 	
//d_Buy=9 	h_Sell=300 	d_Sell=5

//CHF: PRFT 1842.01	79	1.39	23.32	1549.97	15.47%	TP=58 	SL=55 	N=19 	Int_Stop=10800	
//dd: 831.71	85	1.11	9.78	1611.08	12.95%	TP=33 	SL=44 	N=15 	Int_Stop=6300	
   int start()
 {
    int cnt,MN=1222010;
    int TP_b=210,SL_b=200,TP_s=240,SL_s=220,Int_Stop=800;
    double h_Buy=260,d_Buy=5,h_Sell=300,d_Sell=4;
    double lots=NormalizeDouble(AccountFreeMargin()*0.0001,2);
    if(lots>49.99)lots=49.99;
    
    if(OrdersTotal()==1)
    {
     OrderSelect(OrderTicket(), SELECT_BY_POS, MODE_TRADES);
     if (OrderSymbol()!=Symbol()&&OrderMagicNumber()!=MN)return(0);
     if(TimeCurrent()-OrderOpenTime()<Int_Stop) return(0);
     if(OrderType()==OP_BUY)// long position is opened
       { 
        OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet);return(0);
       } 
        else// Close SELL
         {
          OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet);return(0);
         }         
    
    return(0);
    }
       if(Minute()==40)// || Hour()<M)
         {
                if(Open[0]>Close[0]+h_Buy*Point)
                {
                if(Low[0]+d_Buy*Point<Close[0])
    OrderSend(Symbol(),OP_BUY,lots,Ask,3,Ask-SL_b*Point,Ask+TP_b*Point,"BUY ",1222010,0,Green);
                return(0);
                }
                if(Open[0]+h_Sell*Point<Close[0])
                {
                if(High[0]>Close[0]+d_Sell*Point)
    OrderSend(Symbol(),OP_SELL,lots,Bid,3,Bid+SL_s*Point,Bid-TP_s*Point,"SELL",1222010,0,Red);
                return(0);
                }
         }
         return(0);
 }
 