#property strict
#property stacksize                       8192
#property copyright                       "Perfilov Family © (2015)"
#property icon                            "phoenix.ico"
#property version                         "15.04"
#property link                            "https://www.mql5.com/ru/market/product/6948"
#property description                     "Expert uses standart indicators: MA, RVI, CCI, RSI, Volumes, MFI, Bulls and Bears Power, SAR, ATR, Stochastic, Williams, Awesome Oscillator"
#property description                     "contacts:  perfilova.nataliya@gmail.com"
#property description                     "                 icq:673228274"
#property description                     "                 skype:insta8225375"
#property description                     ""


enum     OrdersType {
                              Only_Buy             =  1,          // Only Buy
                              Only_Sell            =  2,          // Only Sell
                              Buy_and_Sell         =  3,          // Buy and Sell
};

enum     On_Off {
                              OFF                  =  0,
                              ON                   =  1
};

enum     field {
                              LowHigh              =  0,          // Low/High
                              CloseClose           =  1           // Close/Close
};

enum     direction {
                              Both_Directions      =  0,          //Both Directions
                              ByTrend              =  1,          //By Trend
                              Opposite             =  2           //Opposite Trend
};

enum     recoveryType {
                              recovery_next_only   =  0,          //use Recovery Factor Next 
                              multi_recovery       =  1           //use Multi Recovery (1, 2, 3)
};


enum     enum_digits {
                              dig_3_5              =  5,          //3 or 5
                              dig_4                =  4           //4
};


input    int                  magic_number         = 1501010;
input    enum_digits          digits               = 5;           //Digits for Stoploss & Takeprofit
input    OrdersType           ordersType           = Buy_and_Sell;

input    recoveryType         multi_recovery       = recovery_next_only;  //recoveryType                  
input    double               Lots                 = 0.01,        //Minimal Lots
                              def                  = 7500,        //def:                     Lot = Balance / 
                              sl                   = 660,         //StopLoss
                              tp                   = 350,         //TakeProfit
                              recovery_factor_1    = 1.75,         //Recovery Factor 1
                              recovery_factor_2    = 1.5,         //Recovery Factor 2
                              recovery_factor_3    = 1.25,        //Recovery Factor 3 
                              recovery_factor_next = 1.05;        //Recovery Factor Next                                          
input    On_Off               MartinGeil           = ON;


// 3
input    string               a1                   = "";          // 
input    string               b1                   = "";          //      
input    string               g1                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
input    string               c1                   = "For sell: MA1 < MA2        For buy: MA1 > MA2"; // 
input    int                  ma1_period           = 0;
input    ENUM_MA_METHOD       ma1_method           = MODE_SMA;        
input    ENUM_APPLIED_PRICE   ma1_price            = PRICE_CLOSE;
input    int                  ma2_period           = 0;
input    ENUM_MA_METHOD       ma2_method           = MODE_SMA;      
input    ENUM_APPLIED_PRICE   ma2_price            = PRICE_CLOSE; 
input    string               f1                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
               

// 4
input    string               a2                   = "";            // 
input    string               b2                   = "";            // 
input    string               g2                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
input    string               c2                   = "For sell: RVI < RVI_percents         For buy: RVI > RVI_percents";// 
input    int                  RVI_period           = 2;               
input    double               RVI_percents_bottom  = -0.25,          
                              RVI_percents_top     =  0.85;
input    direction            RVI_direction        = 1;
input    string               f2                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================



// 5
input    string               a3                   = "";            // 
input    string               b3                   = "";            // 
input    string               g3                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   string               c3                   = "For sell: CCI < -CCI_percents         For buy: CCI > CCI_percents";// 
extern   int                  CCI_period           = 3;  
input    ENUM_APPLIED_PRICE   CCI_price            = PRICE_HIGH;
extern   int                  CCI_percents_bottom  = -200,
                              CCI_percents_top     = 400;
input    direction            CCI_direction        = 1;
input    string               f3                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================



// 6
input    string               a4                   = "";             //  
input    string               b4                   = "";             // 
input    string               g4                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   string               c4                   = "For sell: RSI < RSI_percents         For buy: RSI > 100-RSI_percents";  // 
extern   int                  RSI_period           = 0; 
input    ENUM_APPLIED_PRICE   RSI_price            = PRICE_CLOSE;
extern   int                  RSI_percents_range   = 0,
                              RSI_percents_top     = 100;
input    direction            RSI_direction        = Both_Directions;
input    string               f4                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================

               
               
// 7
input    string               a5                   = "";            // 
input    string               b5                   = "";            // 
input    string               g5                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   string               c5                   = "kof_volume_1  <   avg(Volume1) / avg(Volume2)   <  kof_volume_2"; // 
extern   int                  n_volume_1           = 1,
                              n_volume_2           = 16;              
extern   double               kof_volume_1         = 0.35,
                              kof_volume_2         = 0.3; 
input    string               f5                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
          

// 8
input    string               a6                   = "";            // 
input    string               b6                   = "";            // 
input    string               g6                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   string               c6                   = "For sell: MFI < MFI_percents         For buy: MFI > 100-MFI_percents";  // 
extern   int                  MFI_period           = 0,
                              MFI_percents_range   = 0,
                              MFI_percents_top     = 100;
input    direction            MFI_direction        = Both_Directions;
input    string               f6                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
               


// 9
input    string               a7                   = "";            // 
input    string               b7                   = "";            // 
input    string               g7                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   string               c7                   = "For sell: ( Bulls + Bears ) / Point > BullsBears_percents         For buy: ( Bulls + Bears ) / Point < BullsBears_percents";  // 
extern   int                  Bulls_period         = 2;
input    ENUM_APPLIED_PRICE   Bulls_price          = PRICE_CLOSE;
extern   int                  Bears_period         = 1;
input    ENUM_APPLIED_PRICE   Bears_price          = PRICE_LOW;
extern   int                  BullsBears_percents  = 76;
input    string               f7                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
    


// 10
input    string               a8                   = "";          // 
input    string               b8                   = "";          // 
input    string               g8                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   double               SAR_step             = 0.0,
                              SAR_maximum          = 0.2;
input    string               f8                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
         


// 11
input    string               a9                   = "";          // 
input    string               b9                   = "";          // 
input    string               g9                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   int                  ATR_period           = 0;
extern   double               ATR_percents         = 0.15;
input    string               f9                   = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================



// 12
input    string               a10                           = "";          // 
input    string               b10                           = "";          // 
input    string               g10                           = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   int                  Stochastic_k_period           = 0,
                              Stochastic_d_period           = 0,
                              Stochastic_slowing            = 0;
extern   int                  Stochastic_percents_range     = 0,
                              Stochastic_percents_top       = 100;
input    ENUM_MA_METHOD       Stochastic_method             = MODE_SMA;      
input    field                Stochastic_field              = LowHigh;
input    direction            Stochastic_direction          = Both_Directions;
input    string               f10                           = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================



// 13
input    string               a11                           = "";          //  
input    string               b11                           = "";          // 
input    string               g11                           = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   int                  Williams_period               = 0,
                              Williams_percents_range       = 30,
                              Williams_percents_top         = 100;
input    direction            Williams_direction            = Both_Directions;
input    string               f11                           = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================



               
               
// 14
input    string               a12                           = "";            // 
input    string               b12                           = "";            // 
input    string               g12                           = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   string               c12                           = "Awesome Oscillator"; // 
extern   int                  n_ao_1                        = 2,
                              n_ao_2                        = 13;              
extern   double               kof_ao_1                      = -0.4375,
                              kof_ao_2                      = -0.5625; 
input    string               f12                           = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
          

               
// 15
input    string               a99                           = "";            // 
input    string               b99                           = "";            // 
input    string               g99                           = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
extern   string               c99                           = " LINKS "; // 
sinput   string               d99                           = "http://goo.gl/Oh0Hxi";          //__SETS__
input    string               h12                           = "================================================================================================================================================================================================================================================"; //================================================================================================================================================================
          


                              

int            result, multi = 1;
               
double         tempLots,               
               closeTP              = 0,
               closeSL              = 0,               
               maxBalans            = 0,
               Stoploss, Takeprofit, Def;
               
datetime       curBar;


bool           initialized = False,
               fixedLot    = True;

               

void init() {
   Def = def * (MarketInfo(Symbol(),MODE_LOTSIZE) / 10000.0);
         
   if (digits == 4 && (_Digits == 3 || _Digits == 5)) {
      Stoploss    = sl * 10;
      Takeprofit  = tp * 10;
   }
   else if (digits == 5 && (_Digits == 4 || _Digits == 2)) {
      Stoploss    = sl / 10;
      Takeprofit  = tp / 10;
   }
   else {
      Stoploss    = sl;
      Takeprofit  = tp;
   }
   
   if (_Digits == 3 || _Digits == 5) {
      multi = 10;
   }      
   
   curBar = iTime(NULL, NULL, 0);
   tempLots = maxProfit();
   
   Profit(); 
   
   initialized = true;

}

  
void start()   {   
   if (curBar != iTime(NULL, NULL, 0) && initialized) {                      
      if      (MayOpen() == true)   CheckForOpen();         
      curBar = iTime(NULL, NULL, 0);
      Profit();
   }
}



// Âûâîäèì ïðîôèò  +   -   =
void Profit() {
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
      
      Comment("#" + string(magic_number) + "   +" + DoubleToStr(profitPlus,2)+"(" + DoubleToStr(availableProfit, 2) + ")" + "  " + DoubleToStr(profitMinus,2) + "  =  " + DoubleToStr(profitSum,2)); 
}



void OptimizeLots() {         
   if (MartinGeil > 0) {
      double 
         profit=0,
         recovery_factor = 0;
      int kol_losses=0;
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
      
      if (multi_recovery == 1) {
         switch(kol_losses) {
            case 1: recovery_factor = recovery_factor_1; break;
            case 2: recovery_factor = recovery_factor_2; break;
            case 3: recovery_factor = recovery_factor_3; break;
            default: recovery_factor = recovery_factor_next;break;
         }
      }
      else {
         recovery_factor = recovery_factor_next;
      }
      
      if (profit < 0) {      
         tempLots = MathCeil(-100.0*profit*recovery_factor/ MarketInfo(Symbol(), MODE_TICKVALUE) /Takeprofit)/100.0;
      }
      else tempLots = maxProfit(); //Lots;
   }
}



double maxProfit() {
   return MathMax( MathMin(AccountFreeMargin(), AccountBalance()) / Def, Lots);
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


// Èíäèêàòîðû

bool between(double what, double bottom, double top) {
   return bottom <= what && what <= top; 
}

bool Direction(double cmd_and_dir, double cur, double previous) {
   if (fmod(cmd_and_dir,2) == 0) {
      if (cur < previous) return (true);
   }
   else {
      if (cur > previous) return (true);
   }
   return false;
}

bool checkIma_1_2(int cmd) {  
   if          (ma1_period == 0) return (true);

   double ima1     = iMA(NULL, 0, ma1_period, 0, ma1_method, ma1_price, 0);
   double ima2     = iMA(NULL, 0, ma2_period, 0, ma2_method, ma2_price, 0);
   
   if          (cmd == OP_SELL   &&  ima1 < ima2) return (true);
   else if     (cmd == OP_BUY    &&  ima1 > ima2) return (true);
   
   return (false);
}


bool checkRVI(int cmd) {  
   if          (RVI_period == 0) return (true);
   double      rvi = iRVI(NULL, 0, RVI_period, 0, 0);   
   
   if (  
         (cmd == OP_SELL  &&  between(rvi, -RVI_percents_top, -RVI_percents_bottom))
            ||
         (cmd == OP_BUY   &&  between(rvi,  RVI_percents_bottom,  RVI_percents_top))   
      ) {
      if       (RVI_direction == 0)                                                    return (true);
      else if  (Direction(cmd+RVI_direction, rvi, iRVI(NULL, 0, RVI_period, 0, 1)))    return (true);
   }
  
   return (false);
}


bool checkCCI(int cmd) {  
   if          (CCI_period == 0) return (true);
   
   double      cci = iCCI(NULL, 0, CCI_period, CCI_price, 0);
   if (  
         (cmd == OP_SELL  &&  between(cci, -CCI_percents_top, -CCI_percents_bottom))
            ||
         (cmd == OP_BUY   &&  between(cci,  CCI_percents_bottom,  CCI_percents_top))   
      ) {
      if       (CCI_direction == 0)                                                          return (true);
      else if  (Direction(cmd+CCI_direction, cci, iCCI(NULL, 0, CCI_period, CCI_price, 1)))  return (true);
   }
   
   return (false);
}


bool checkRSI(int cmd) {  
   if          (RSI_period == 0) return (true);
   
   double      rsi = iRSI(NULL, 0, RSI_period, RSI_price, 0);  
   if (  
         (cmd == OP_SELL  &&  between(rsi, 100-RSI_percents_top, RSI_percents_range))
            ||
         (cmd == OP_BUY   &&  between(rsi, 100-RSI_percents_range, RSI_percents_top))   
      ) {
      if       (RSI_direction == 0)                                                          return (true);
      else if  (Direction(cmd+RSI_direction, rsi, iRSI(NULL, 0, RSI_period, RSI_price, 1)))  return (true);
   }
   
   return (false);
}


bool checkVolume() {
   if (n_volume_1 == 0) return (true);
   else {
      double   vol_1=0,
               vol_2=0,
               vol_res=0;
      for (int i=1; i<=n_volume_1; i++) {
         vol_1 += double(iVolume(NULL, 0, i));
      }
      vol_1 /= n_volume_1;
      
      for (int i=1; i<=n_volume_2; i++) {
         vol_2 += double(iVolume(NULL, 0, i));
      }
      vol_2 /= n_volume_2;
      
      vol_res = vol_1 / vol_2;
      
      if (kof_volume_1 < kof_volume_2) return kof_volume_1 < vol_res  &&  vol_res < kof_volume_2;
      else return vol_res > kof_volume_1  ||  kof_volume_2 > vol_res;
   }
}


bool checkAO() {
   if (n_ao_1 == 0) return (true);
   else {
      double   ao_1=0,
               ao_2=0,
               ao_res=0;
      for (int i=1; i<=n_ao_1; i++) {
         ao_1 += double(iAO(NULL, 0, i));
      }
      ao_1 /= n_ao_1;
      
      for (int i=1; i<=n_ao_2; i++) {
         ao_2 += double(iAO(NULL, 0, i));
      }
      ao_2 /= n_ao_2;
      
      ao_res = ao_1 / ao_2;
      
      if (kof_ao_1 < kof_ao_2) return kof_ao_1 < ao_res  &&  ao_res < kof_ao_2;
      else return ao_res > kof_ao_1  ||  kof_ao_2 > ao_res;
   }
}


bool checkMFI(int cmd) {
   if          (MFI_period == 0) return (true);
   
   double      mfi = iMFI(NULL, 0, MFI_period, 1);
   if (  
         (cmd == OP_SELL  &&  between(mfi, 100-MFI_percents_top, MFI_percents_range))
            ||
         (cmd == OP_BUY   &&  between(mfi, 100-MFI_percents_range, MFI_percents_top))   
      ) {
      if       (MFI_direction == 0)                                                 return (true);
      else if  (Direction(cmd+MFI_direction, mfi, iMFI(NULL, 0, MFI_period, 2)))    return (true);
   }
   
   return (false);  
}


bool checkBullsBears(int cmd) {
   if          (Bulls_period == 0  &&  Bears_period == 0) return (true);
      
   double      BullsBears;
   if          (Bears_period == 0) BullsBears = iBullsPower(NULL, 0, Bulls_period, Bulls_price, 1)/Point;
   else if     (Bulls_period == 0) BullsBears = iBearsPower(NULL, 0, Bears_period, Bears_price, 1)/Point;
   else        BullsBears = (
                        iBullsPower(NULL, 0, Bulls_period, Bulls_price, 1)+
                        iBearsPower(NULL, 0, Bears_period, Bears_price, 1)
                        )/Point;
   
   if          (cmd == OP_SELL  &&  BullsBears > BullsBears_percents) return (true);
   else if     (cmd == OP_BUY   &&  BullsBears < BullsBears_percents) return (true);
   else return (false);   
}


bool checkSAR(int cmd) {
   if          (SAR_step == 0) return (true);
   
   double      sar = iSAR(NULL, 0, SAR_step, SAR_maximum, 1);   
   if          (cmd == OP_SELL  &&  Bid < sar)  return (true);
   else if     (cmd == OP_BUY   &&  Ask > sar)  return (true);
   else return (false);   
}


bool checkATR(int cmd) {
   if          (ATR_period == 0) return (true);
   
   double      atr = iATR(NULL, 0, ATR_period, 1);
   if          (cmd == OP_SELL  &&  atr < ATR_percents)  return (true);
   else if     (cmd == OP_BUY   &&  atr > ATR_percents)  return (true);
   else return (false);   
}


bool checkStochastic(int cmd) {  
   if          (Stochastic_k_period == 0) return (true);
   
   double      stochastic = iStochastic(NULL, 0, Stochastic_k_period, Stochastic_d_period, Stochastic_slowing, Stochastic_method, int(Stochastic_field), MODE_MAIN, 0);
   if (  
         (cmd == OP_SELL  &&  between(stochastic, 100-Stochastic_percents_top, Stochastic_percents_range))
            ||
         (cmd == OP_BUY   &&  between(stochastic, 100-Stochastic_percents_range, Stochastic_percents_top))   
      ) {
      if       (Stochastic_direction == 0)                                                                                                                                                                   return (true);
      else if  (Direction(cmd+Stochastic_direction, stochastic, iStochastic(NULL, 0, Stochastic_k_period, Stochastic_d_period, Stochastic_slowing, Stochastic_method, int(Stochastic_field), MODE_MAIN, 1))) return (true);
   }
   
   return (false);
}


bool checkWilliams(int cmd) {  
   if          (Williams_period == 0) return (true);
      
   double      williams = iWPR(NULL, 0, Williams_period, 1);  
   if (  
         (cmd == OP_SELL  &&  between(williams, -Williams_percents_top, Williams_percents_range-100))
            ||
         (cmd == OP_BUY   &&  between(williams, Williams_percents_top-100, -Williams_percents_range))   
      ) {
      if       (Williams_direction == 0)                                                                                                                                                                   return (true);
      else if  (Direction(cmd+Williams_direction, williams, iWPR(NULL, 0, Williams_period, 2))) return (true);
   }
   
   return (false);
}


bool checkFreeMargin(int cmd) {
   if (
         (
            (
               AccountStopoutMode() == 1
                  && 
               AccountFreeMarginCheck(NULL, cmd, tempLots) > AccountStopoutLevel()
            )
               || 
            (
               AccountStopoutMode() == 0
                  && 
               AccountFreeMarginCheck(NULL, cmd, tempLots)/AccountEquity() * 100 > AccountStopoutLevel()
            )
         ) 
            && 
         AccountFreeMarginCheck(NULL, cmd, tempLots) > 0
   ) return (true);
   return (false);
}



void CheckForOpen() {
   if (ordersType == 3  ||  ordersType == 1)
      if (checkIma_1_2(OP_BUY))
         if (checkRVI(OP_BUY))
            if (checkCCI(OP_BUY))
               if (checkRSI(OP_BUY))  
                  if (checkVolume()) 
                     if (checkMFI(OP_BUY))
                        if (checkBullsBears(OP_BUY))
                           if (checkSAR(OP_BUY)) 
                              if (checkATR(OP_BUY))
                                 if (checkStochastic(OP_BUY))
                                    if (checkWilliams(OP_BUY))
                                       if (checkAO()) {       
                                          OptimizeLots();
                                          if (checkFreeMargin(OP_BUY)) {
                                             closeTP = Ask+Takeprofit*Point;
                                             closeSL = Ask-Stoploss*Point;
                                             result = OrderSend(Symbol(), OP_BUY,  tempLots, Ask, 5*multi, closeSL, closeTP, "#"+string(magic_number), magic_number, 0, Red);                                       
                                             Profit();
                                          }
   }
   
   if (ordersType == 3  ||  ordersType == 2)
      if (checkIma_1_2(OP_SELL))
         if (checkRVI(OP_SELL))
            if (checkCCI(OP_SELL))
               if (checkRSI(OP_SELL)) 
                  if (checkVolume()) 
                     if (checkMFI(OP_SELL))
                        if (checkBullsBears(OP_SELL))
                           if (checkSAR(OP_SELL)) 
                              if (checkATR(OP_SELL))
                                 if (checkStochastic(OP_SELL)) 
                                    if (checkWilliams(OP_SELL))
                                       if (checkAO()) {                                                             
                                          OptimizeLots();                                              
                                          if (checkFreeMargin(OP_SELL)) {                    
                                             closeTP = Bid-Takeprofit*Point;
                                             closeSL = Bid+Stoploss*Point;                                             
                                             result = OrderSend(Symbol(), OP_SELL, tempLots, Bid, 5*multi, closeSL, closeTP, "#"+string(magic_number), magic_number, 0, Red);                                      
                                             Profit();
                                          }
   } 
   return;
}