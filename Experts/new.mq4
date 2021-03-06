#property strict
#property stacksize                       8192
#property copyright                       "Perfilov Family © (2017)"
#property icon                            "Bookmark.ico"
#property version                         "17.08"
/*#property link                            "https://tr.im/aligarh"*/

#property description                     "contacts:  stanislav.perfilov@gmail.com"
#property description                     ""



input          ENUM_TIMEFRAMES   timeframe = 0;

                             

string valutes[8] = {"EUR", "GBP", "AUD", "NZD", "USD", "CAD", "CHF", /*"CZK", "DKK", "HKD", "HUF", "MXN", "NOK", "SEK", "SGD", "ZAR",*/ "JPY"}; 
double values[8] = {0,0,0,0,0,0,0,0};
double prices[8][8];

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
   /*CommentPosX = 0;
   CommentPosY = 1;
   double values[8] = {0,0,0,0,0,0,0,0};

   MqlRates rates[];

   for (int k=0; k<7; k++) {
      for(int i=k+1;i<=7;i++) {
         CopyRates(valutes[k]+valutes[i], timeframe, 0, 1, rates);
         double dif = (rates[0].close - rates[0].open) / MarketInfo(valutes[k]+valutes[i], MODE_POINT);
         double price = dif * MarketInfo(valutes[k]+valutes[i], MODE_TICKVALUE);
         values[k] += price;
         values[i] -= price;
         prices[k][i] = price;
         ShowComment(valutes[k]+valutes[i], IntegerToString(MathRound(price*10.0)), Gold);
      }
   }   
   
   for (int k=0; k<8; k++) {
      ShowComment(valutes[k], IntegerToString(values[k]), Pink);
   }*/
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
  
void start()   {
   CommentPosX = 0;
   CommentPosY = 1;
   double values[8] = {0,0,0,0,0,0,0,0};

   MqlRates rates[];

   for (int k=0; k<7; k++) {
      for(int i=k+1;i<=7;i++) {
         CopyRates(valutes[k]+valutes[i], timeframe, 0, 1, rates);
         double dif = (rates[0].close - rates[0].open) / MarketInfo(valutes[k]+valutes[i], MODE_POINT);
         double price = dif * MarketInfo(valutes[k]+valutes[i], MODE_TICKVALUE);
         values[k] += price;
         values[i] -= price;
         prices[k][i] = price;
         ShowComment(valutes[k]+valutes[i], IntegerToString(MathRound(price*10.0)), Gold);
      }
   }   
   
   for (int k=0; k<8; k++) {
      ShowComment(valutes[k], IntegerToString(values[k]), Pink);
   }
}
