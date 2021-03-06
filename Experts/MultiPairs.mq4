#property strict
#property stacksize                       8192
#property copyright                       "Perfilov Family © (2017)"
#property icon                            "Bookmark.ico"
#property version                         "17.08"
/*#property link                            "https://tr.im/aligarh"*/

#property description                     "contacts:  stanislav.perfilov@gmail.com"
#property description                     ""



input          ENUM_TIMEFRAMES   timeframe = 1;
input          int               middle    = 3;
input          double            koef      = 0.8;

                             

string valutes[8] = {"EUR", "GBP", "AUD", "NZD", "USD", "CAD", "CHF", /*"CZK", "DKK", "HKD", "HUF", "MXN", "NOK", "SEK", "SGD", "ZAR",*/ "JPY"}; 
string valute;
double values[8] = {0,0,0,0,0,0,0,0};
double prices[8][60];
double middle_exp_koef = 0;
string btnName = "reCalc";

int CommentPosX;
int CommentPosY;

void ShowComment(string symb, string str, color col) { 
   if (CommentPosY > 28) {
      CommentPosY = 1;
      CommentPosX++;
   }  
   ObjectCreate(symb, OBJ_LABEL, 0, 0, 0);
   ObjectSet(symb, OBJPROP_XDISTANCE, CommentPosX*180 + 5);
   ObjectSet(symb, OBJPROP_YDISTANCE, CommentPosY*20);
   ObjectSet(symb, OBJPROP_COLOR, col);
   ObjectSet(symb, OBJPROP_BORDER_TYPE, 2);
   ObjectSetText(symb, symb + ": " + str , 12, "Calibri");
   
   CommentPosY++;
}

void init() {
   for (int m=0; m<middle; m++) {
      middle_exp_koef += MathPow(koef, m);   // = 1 + 0.8 + 0.8*0.8 + 0.8*0.8*0.8 + ...
   }
   CreateButton();
   calc();
}
  
void start()   {
   calc();
}

void deinit() {
   //ObjectDelete(0, btnName);
}

void Error(string str) {   
   Comment(str);
   Print(str);
   
   ObjectCreate(str, OBJ_LABEL, 0, 0, 0);
   ObjectSet(str, OBJPROP_XDISTANCE, 5);
   ObjectSet(str, OBJPROP_YDISTANCE, 30);
   ObjectSet(str, OBJPROP_COLOR, Gold);
   ObjectSet(str, OBJPROP_BORDER_TYPE, 2);
   ObjectSetText(str, str , 18, "Calibri");
}

void DeleteError(string str) {
   ObjectDelete(str);
}

void calc() {

   CommentPosX = 0;
   CommentPosY = 1;
   //double values[8] = {0,0,0,0,0,0,0,0};

   MqlRates rates[];   
   ArraySetAsSeries(rates,true);
   
   // clear
   for(int k=0;k<8;k++) {
      for(int t=0;t<60;t++) {
         prices[k][t] = 0;
      } 
   }

   // fill valuta prices
   for (int k=0; k<7; k++) {
      for(int i=k+1;i<=7;i++) {
      
         valute = valutes[k]+valutes[i];
         double point = MarketInfo(valute, MODE_POINT);         
         double tickvalue = MarketInfo(valute, MODE_TICKVALUE);
         
         if (point == 0.0) {
            Alert("Add "+valute+" to the Market Watch");
            ExpertRemove();
         }
         //printf("%s %f", valute, tickvalue);
         
         CopyRates(valute, timeframe, 0, 60, rates);
         
         for(int t=0;t<60;t++) {
            double price = (rates[t].close - rates[t].open) / point * tickvalue;
            prices[k][t] += price;
            prices[i][t] -= price;
            //ShowComment(valute, IntegerToString(MathRound(price*10.0)), Gold);
         }         
      }
   }  
   
   
   int max_k = -1;
   int min_k = -1;
   
   int max_t = -1;
   int min_t = -1;
   
   int max_k_next = -1;
   int min_k_next = -1;      
   
   double max_value = 0;     
   double min_value = 0;
   
   double sum_max_value = 0;
   double sum_min_value = 0;
   
   double middle_sum = 0;
   
   int can_max = 1;
   int can_min = 1; 
   
   for(int t=0; t<60-middle; t++) {
      max_value = 0;     
      min_value = 0;
      
      if (can_max == 1 || can_min == 1) {   
         for (int k=0; k<8; k++) {            
            middle_sum = 0;
            for(int m=0; m<middle; m++) {
               middle_sum += prices[k][t+m] * MathPow(koef, m) / middle_exp_koef;
            }
            
            if (middle_sum > max_value) {
               if (t == 0) max_k = k;
               max_k_next = k;
               max_value = middle_sum;
            }
            if (middle_sum < min_value) {
               if (t == 0) min_k = k;
               min_k_next = k;
               min_value = middle_sum;
            }
         }
         
         if (max_k_next == max_k && can_max == 1) {
            sum_max_value += max_value;
            max_t = t;
         }
         else {
            can_max = 0;
         }
         
         if (min_k_next == min_k && can_min == 1) {
            sum_min_value += min_value;
            min_t = t;
         }
         else {
            can_min = 0;
         }
         
         if (can_max == 0 && can_min == 0) break;
      }
      
      max_value = 0;     
      min_value = 0;
   }
   printf("Max = %f %s %d", sum_max_value, valutes[max_k], max_t);
   printf("Min = %f %s %d", sum_min_value, valutes[min_k], min_t);
   
    
   
   
   
   //for (int k=0; k<8; k++) {
     // ShowComment(valutes[k], IntegerToString(values[k]), Pink);
   //}
   
  
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
   if(sparam == btnName) { // если нажали на кнопку "Try to open"      
      ObjectSetString(0, btnName,OBJPROP_TEXT, StringFormat("%s [%s]", btnName, TimeToStr(TimeCurrent(),TIME_SECONDS)));
      calc();
      ObjectSetInteger(0,btnName, OBJPROP_STATE,false);
   }
}