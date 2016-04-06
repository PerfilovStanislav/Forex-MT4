#property strict
#property stacksize                       8192
#property copyright                       "Perfilov Family © (2015)"
#property icon                            "Bookmark.ico"
#property version                         "15.111"
#property link                            "https://tr.im/aligarh"


enum     OrdersType {
                              Only_Buy             =  1,          // Only Buy
                              Only_Sell            =  2,          // Only Sell
                              Buy_and_Sell         =  3,          // Buy and Sell
};

enum     recoveryType {
                              recovery_next_only   =  0,          //use Recovery Factor Next 
                              multi_recovery       =  1           //use Multi Recovery (1, 2, 3)
};

enum     METHOD  {
                              SMA                  = 0,    //Simple
                              EMA                  = 1,    //Exponential
                              LWMA                 = 3     //Linear weighted
};

   
sinput   string                                    = "";          //Access number   
input    int                  magic_number         = 1;
input    OrdersType           ordersType           = Buy_and_Sell;
                 
input    int                  def                  = 50000;       //def:                     Lot = Balance /  
input    double               sl                   = 0.8,         //StopLoss
                              tp                   = 400;         //TakeProfit                           
input    recoveryType         multi_recovery       = 1;           //recoveryType 
input    double               recovery_factor_1    = 1.75,        //Recovery Factor 1
                              recovery_factor_2    = 1.5,         //Recovery Factor 2
                              recovery_factor_3    = 1.25,        //Recovery Factor 3 
                              recovery_factor_4    = 1.15,        //Recovery Factor 4 
                              recovery_factor_next = 1.1;         //Recovery Factor Next                                          
input    int                  MartinGeil           = 1;
input    int                  maxLosses            = 4;           //Count of max losses
input    int                  Optimization         = 1;           //For optimization only


// 3
input    string               a1                   = "";          // 
input    string               b1                   = "";          //      
input    string               g1                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
input    string               c1                   = "For sell: MA1 < MA2        For buy: MA1 > MA2"; // 
input    int                  ma1_period           = 0;
input    METHOD               ma1_method           = SMA;        
input    ENUM_APPLIED_PRICE   ma1_price            = PRICE_CLOSE;
input    int                  ma2_period           = 0;
input    METHOD               ma2_method           = SMA;      
input    ENUM_APPLIED_PRICE   ma2_price            = PRICE_CLOSE; 
input    int                  ma4_period           = 0;
input    METHOD               ma4_method           = SMA;      
input    ENUM_APPLIED_PRICE   ma4_price            = PRICE_CLOSE; 
input    string               f1                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================

                            

int            result, multi = 1, kol_losses=0, attempts = 1, a=0, b=0;
double         Stoploss, Takeprofit;
               
double         tempLots,               
               closeTP              = 0,
               closeSL              = 0,               
               maxBalans            = 0,
               Def;
               
datetime       curBar;


bool           initialized    = False,
               fixedLot       = False,
               TEST;
               
string btnName = "Try to open";
               
void init() {
   initialized    = False;
   Def = def * (MarketInfo(Symbol(),MODE_LOTSIZE) / 10000.0);
   Takeprofit  = tp;
   Stoploss    = sl > 3 ? tp + sl : tp * sl;
   multi = 10;
   
   curBar = iTime(NULL, NULL, 0);
   tempLots = maxProfit();
   
   Profit();
   initialized = true; 
}
  
void start()   {
   if (curBar != iTime(NULL, NULL, 0) && initialized) {
      TryToOpen();
   }
}

void TryToOpen() {  
   if(IsTradeAllowed()) {                  
      if (MayOpen() == true) {
         if (ordersType == 3  ||  ordersType == 1) CheckForOpen(OP_BUY);   
         if (ordersType == 3  ||  ordersType == 2) CheckForOpen(OP_SELL);      
      }        
      curBar = iTime(NULL, NULL, 0);
      Profit();
   }
}


// Âûâîäèì ïðîôèò  +   -   =
void Profit() {
   if (TEST) return;
   double profitPlus=0,
          profitMinus=0,
          profitSum=0,
          availableProfit = 0;
    
   if (!MayOpen()) availableProfit = MarketInfo(Symbol(), MODE_TICKVALUE)*OrderLots()*Takeprofit;
   int OrdersHistory=OrdersHistoryTotal();
   for (int i=OrdersHistory-1; i>=0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) == false) break;
      if (OrderMagicNumber() != magic_number   ||   OrderSymbol() != Symbol()) continue;
      if       (OrderProfit() < 0) profitMinus += OrderProfit();
      else if  (OrderProfit() > 0) profitPlus += OrderProfit();
      else break;
   } 
   profitSum = profitPlus + profitMinus;
   
   Comment(StringFormat("#%d    +%.2f  %.2f  =  %.2f", magic_number, profitPlus, profitMinus, profitSum));
}


bool OptimizeLots() {
   double 
      profit=0,
      recovery_factor = 0;
   kol_losses = 0;
   int OrdersHistory=OrdersHistoryTotal(); 
   for (int i=OrdersHistory-1; i>=0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) == false) break;
      if (OrderMagicNumber() != magic_number   ||   OrderSymbol() != Symbol()) continue;
      if (OrderProfit() < 0) {
         profit += OrderProfit();
         kol_losses += 1;
      }
      else break;
   }
              
   if (MartinGeil > 0) {
      if (multi_recovery == 1) {
         switch(kol_losses) {
            case 1: recovery_factor = recovery_factor_1; break;
            case 2: recovery_factor = recovery_factor_2; break;
            case 3: recovery_factor = recovery_factor_3; break;
            case 4: recovery_factor = recovery_factor_4; break;
            default: recovery_factor = recovery_factor_next;break;
         }
      }
      else {
         recovery_factor = recovery_factor_next;
      }
      
      if (profit < 0) {      
         tempLots = MathCeil(-100.0*profit*recovery_factor/ MarketInfo(Symbol(), MODE_TICKVALUE) /Takeprofit)/100.0;
      }
      else tempLots = maxProfit();
   }
   else {
      tempLots = maxProfit();
   }
   
   if(IsOptimization()) {   
      tempLots += MathFloor((a++)/Optimization)*0.01;
   }
   
   return true;
}


double maxProfit() {
   return MathMax(MathMin(AccountFreeMargin(), AccountBalance()) / Def, SymbolInfoDouble(NULL, SYMBOL_VOLUME_MIN));
}


bool MayOpen() {
   int orders = OrdersTotal();
   if (orders == 0) return (true);
   for(int i=0; i<orders; i++) {
      bool r = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderMagicNumber() == magic_number) return (false);
   }
   return (true);
}


bool checkIma_1_2(int cmd) {  
   //if          (ma1_period == 0) return (true);   
   //double ima1     = iMA(NULL, 0, ma1_period, 0, ma1_method, ma1_price, 0);
   
   double ima2     = iMA(NULL, 0, ma2_period, 0, int(ma2_method), ma2_price, 0);
   double ima4     = iMA(NULL, 0, ma4_period, 0, int(ma4_method), ma4_price, 0);
   
   if (cmd == OP_SELL) {
      if (ima2 < ima4) {
         if (iMA(NULL, 0, ma1_period, 0, int(ma1_method), ma1_price, 0) < ima2) return (true);
         else return (false);
      }
      else return (false);
   }
   else {
      if (ima2 > ima4) {
         if(iMA(NULL, 0, ma1_period, 0, int(ma1_method), ma1_price, 0) > ima2) return (true);
         else return (false);
      }
      else return (false);
   }   
}





void CheckForOpen(int cmd) {
   if (checkIma_1_2(cmd))        
      if (OptimizeLots()) {
         if (cmd == OP_BUY) {
            closeTP = Open[0]+Ask-Bid+Takeprofit*Point;
            closeSL = Open[0]+Ask-Bid-Stoploss*Point;
         }
         else if (cmd == OP_SELL) {
            closeTP = Open[0]-Takeprofit*Point;
            closeSL = Open[0]+Stoploss*Point;
         } 
         else return;
         
         openTrade(cmd); 
         return;
   }   
}



void openTrade(int cmd) {
   RefreshRates();
   result = OrderSend(Symbol(), cmd,  tempLots, cmd == OP_BUY ? Ask : Bid, 5*multi, closeSL, closeTP, StringFormat("#%d (%d of %d)", magic_number, kol_losses+1, maxLosses), magic_number, 0, Red);                                       
   if (result == -1) {   
      int lastError = GetLastError(); 
      if (TEST) {
         Comment("Error #", lastError); 
         Print("Error #", lastError); 
         ExpertRemove(); 
      }
      else if (lastError == 134) {
         Alert(_Symbol, ". Magic number: ", magic_number, ". Error #", lastError, "   Not enough money to open trade: ");
         attempts = 1;
      }
      else {
         if (attempts % 5 == 1) {
            string msg = StringFormat("Valute: %s. Magic number: #%d. Error #%d. Attempts: %d", _Symbol, magic_number, lastError, attempts);
            Alert(msg);
            Print(msg);
         }
         Sleep(1000);
         if (MayOpen() == true) {
            attempts++;
            if (attempts < 20) openTrade(cmd);
            else if (attempts < 60) CheckForOpen(cmd);
            else Alert("Error opening");
         }
         else {
            Alert(StringFormat("OK! Valute: %s. Magic number: #%d. Attempts: %d", _Symbol, magic_number, attempts));
            attempts = 1;
         }
      }               
   }
   else {
      attempts = 1;
   }
}


void CreateButton() {
   ObjectDelete(0, btnName);
   ObjectCreate(0, btnName,OBJ_BUTTON, 0,0,0);
   ObjectSetString(0, btnName,OBJPROP_TEXT, btnName);
   ObjectSetString(0, btnName,OBJPROP_FONT, "Calibri");
   
   int p[10][2] = {
      OBJPROP_XDISTANCE,      10,
      OBJPROP_YDISTANCE,      30,
      OBJPROP_XSIZE,          150,
      OBJPROP_YSIZE,          22,
      OBJPROP_FONTSIZE,       12,
      OBJPROP_COLOR,          clrWhite,
      OBJPROP_BGCOLOR,        C'00,172,240',
      OBJPROP_BORDER_COLOR,   C'00,130,210',
      OBJPROP_SELECTABLE,     false,
      OBJPROP_CORNER,         CORNER_LEFT_LOWER
   };
   
   for (int i=0; i<10; i++) ObjectSetInteger(0,btnName,p[i][0], p[i][1]);
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)  {                  
   if(sparam == btnName) { // åñëè íàæàëè íà êíîïêó "Try to open"      
      ObjectSetString(0, btnName,OBJPROP_TEXT, StringFormat("%s [%s]", btnName, TimeToStr(TimeCurrent(),TIME_SECONDS)));
      TryToOpen();
      ObjectSetInteger(0,btnName, OBJPROP_STATE,false);
   }
}
