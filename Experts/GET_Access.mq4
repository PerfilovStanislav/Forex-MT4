#property strict
#property stacksize                       8192
#property copyright                       "Perfilov Family © (2015)"
#property icon                            "Bookmark.ico"
#property version                         "15.04"
// 8631507    //8403221

sinput   string               name                 = "Перфилова Наталья Юрьевна";
sinput   int                  accountNumber        = 8225375;               

void init() {
   ObjectDelete("accountNumber");
   ObjectCreate("accountNumber", OBJ_LABEL, 0, 0, 0);
   ObjectSet("accountNumber", OBJPROP_XDISTANCE, 5);
   ObjectSet("accountNumber", OBJPROP_YDISTANCE, 30);
   ObjectSet("accountNumber", OBJPROP_COLOR, Gold);
   ObjectSet("accountNumber", OBJPROP_BORDER_TYPE, 2);
   ObjectSetText("accountNumber", IntegerToString(accountNumber) + ": " +  (), 18, "Calibri");
   
      
   
   string acName   = name;
   StringToLower(acName);
   
   string splitedAccName[];
   int namesInAccName = StringSplit(acName, 32, splitedAccName);
      
   ulong multipliers[];   
   ArrayResize(multipliers, namesInAccName);
   ArrayInitialize(multipliers, 1);
   
   for (int j=0; j<namesInAccName; j++) {
      for (int i=0; i<StringLen(splitedAccName[j]); i++) {
         multipliers[j] = (multipliers[j] * StringGetChar(splitedAccName[j], i)) % 0xEfCdAB896;
      }
   }
   
   for (int j=0; j<namesInAccName-1; j++) {      
      for (int k=j+1; k<namesInAccName; k++) {
         string str_kj = "name_"+IntegerToString(k) + "_" + IntegerToString(j);
         ObjectDelete(str_kj);
         ObjectCreate(str_kj, OBJ_LABEL, 0, 0, 0);
         ObjectSet(str_kj, OBJPROP_XDISTANCE, 5);
         ObjectSet(str_kj, OBJPROP_YDISTANCE, 30 + k * 30 + j * 30);
         ObjectSet(str_kj, OBJPROP_COLOR, Red);
         ObjectSet(str_kj, OBJPROP_BORDER_TYPE, 2);
         ObjectSetText(str_kj, splitedAccName[j] + " " + splitedAccName[k] + ": " + IntegerToString(multipliers[j] + multipliers[k]), 18, "Calibri");         
      }
   }
}

string  () { // 1  для номера аккаунта
   int acc = accountNumber;
   int len = StringLen(IntegerToString(acc));
   int sum_1 = 1;
   for (int i=1; i<=len; i++) 
   sum_1 = int(MathMod(sum_1 + int (2117483647 / (173+MathMod(MathMod(acc+sum_1, MathMod(MathPow(13, i), 2127483647))*(i), 2137483647))),2147483647));
   return IntegerToString(sum_1);
}