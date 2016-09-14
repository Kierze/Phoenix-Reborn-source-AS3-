package com.company.PhoenixRealmClient.net
{
    //import com.company.googleanalytics.GA;
import com.company.PhoenixRealmClient.util.Currency;

internal class netCurrency
    {

        public function netCurrency(_arg1:String, _arg2:int, _arg3:int, _arg4:Boolean)
        {
            this.id_ = _arg1;
            this.price_ = _arg2;
            this.currency_ = _arg3;
            this.converted_ = _arg4;
        }
        private var id_:String;
        private var price_:int;
        private var currency_:int;
        private var converted_:Boolean;

        public function gaCurrencyTrack():void
        {
            switch (this.currency_)
            {
                case Currency.CREDITS:
                    //GA.global().trackEvent("credits", ((this.converted_) ? "buyConverted" : "buy"), this.id_, this.price_);
                    return;
                case Currency.FAME:
                    //GA.global().trackEvent("credits", "buyFame", this.id_, this.price_);
                    return;
                case Currency.GUILDFAME:
                    //GA.global().trackEvent("credits", "buyGuildFame", this.id_, this.price_);
                    return;
                case Currency.SILVER:
                    //GA.global().trackEvent("credits", "buySilver", this.id_, this.price_);
                    return;
            }
        }

    }
}
