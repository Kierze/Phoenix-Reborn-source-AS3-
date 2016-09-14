/**
 * Created by Roxy on 12/29/2015.
 */
package com.company.PhoenixRealmClient.objects
{
public class Formula
    {
        public var Attribute:String;
        public var FormulaType:String;
        public var Base:int;
        public var Minimum:int;
        public var Maximum:int;
        public var Rounding:String;
        public var GainPerAP:Number;
        public var Exponent:Number;
        public var ExponentBase:Number;
        public var DecayExponent:Number;
        public var DecayExponentMultiplier:Number;
        public var ScaleFactor:Number;

        public function Formula(xml:XML)
        {
            this.Attribute = xml.toString();
            this.FormulaType = xml.@type;
            this.Base = xml.@base;
            this.Minimum = (xml.@min != null) ? xml.@min : this.Base;
            this.Maximum = (xml.@max != null) ? xml.@max : this.Base;
            this.Rounding = (xml.@rounding != null) ? xml.@rounding : "flat";
            this.GainPerAP = (xml.@perAp != null) ? xml.@perAp : 0;
            this.Exponent = (xml.@expo != null) ? xml.@expo : 0;
            this.ExponentBase = (xml.@expoBase != null) ? xml.@expoBase : 0;
            this.DecayExponent = (xml.@decayExpo != null) ? xml.@decayExpo : 0;
            this.DecayExponentMultiplier = (xml.@decayExpoMult != null) ? xml.@decayExpoMult : 0;
            this.ScaleFactor = (xml.@scaleFactor != null) ? xml.@scaleFactor : 0;
        }

        public static function RetrieveDescData(xml:XML, query:String, abilityPow:Number):Number
        {
            var formXml:XML;
            var formula:Formula;
            var output:Number = -123;

            for each (formXml in xml.Formula)
            {
                formula = new Formula(formXml);
                if (formula.Attribute == query)
                {
                    return Calculate(formula, abilityPow);
                }
            }
            //this is for the ActivateAbility duhhh
            if (xml.hasOwnProperty("ActivateAbility"))
            {
                var abilXml:XMLList = xml.ActivateAbility;
                if (abilXml.hasOwnProperty("Formula"))
                {
                    for each (var AbilFormulaXml:XML in abilXml.Formula)
                    {
                        if (String(AbilFormulaXml) == query) return Calculate(new Formula(AbilFormulaXml), abilityPow);
                    }
                }
            }

            //passive stufff woooooo i mean dorations wonk wnik
            if (xml.hasOwnProperty("AbilityPerTick"))
            {
                var abilTXml:XMLList = xml.AbilityPerTick;
                if (abilTXml.hasOwnProperty("Formula"))
                {
                    for each (var AbilTFormulaXml:XML in abilTXml.Formula)
                    {
                        if (String(AbilTFormulaXml) == query) return Calculate(new Formula(AbilTFormulaXml), abilityPow);
                    }
                }
            }
            //currently only supports 1 projectile, I will probably develop a ProjID system for the desc data but that's not a biggie priority atm -roxy
            if (xml.hasOwnProperty("Projectile"))
            {
                var projXml:XMLList = xml.Projectile;
                if (projXml.hasOwnProperty("Formula"))
                {
                    for each (var ProjFormulaXml:XML in projXml.Formula)
                    {
                        if (String(ProjFormulaXml) == query) return Calculate(new Formula(ProjFormulaXml), abilityPow);
                    }
                }
            }
            return output;
        }

        public static function Calculate(form:Formula, abilityPow:Number):Number
        {
            var output:Number = -123;
            var add:Number = 0;
            var count:int;

            switch (form.FormulaType)
            {
                case "flat":
                case "Flat":
                    return form.Base;
                    break;
                case "simple":
                case "Simple":
                    output = form.Base + (form.GainPerAP * abilityPow);
                    break;
                case "expogain":
                case "ExpoGain":
                    output = form.Base + Math.pow(abilityPow, form.Exponent);
                    break;
                case "increment":
                case "Increment":
                    for(count = 0; count < abilityPow; count++)
                    {
                        add += Math.pow(form.ExponentBase, (form.DecayExponent + (count * form.DecayExponentMultiplier)));
                    }
                    output = form.Base + add;
                    break;
                case "loggain":
                case "LogGain":
                    output = form.Base + Math.pow(form.ExponentBase, (abilityPow * form.ScaleFactor));
                    break;
                case "expogaincomposite":
                case "ExpoGainComposite":
                    output = form.Base + (form.GainPerAP * abilityPow) + Math.pow(abilityPow, form.Exponent);
                    break;
                case "incrementcomposite":
                case "IncrementComposite":
                    for(count = 0; count < abilityPow; count++)
                    {
                        add += Math.pow(form.ExponentBase, (form.DecayExponent + (count * form.DecayExponentMultiplier)));
                    }
                    output = form.Base + (form.GainPerAP * abilityPow) + add;
            }
            return CheckLimits(RoundByType(output, form.Rounding), form.Minimum, form.Maximum);
        }

        public static function RoundByType(input:Number, roundingType:String):Number
        {
            var output:Number = input;
            switch (roundingType)
            {
                case "True":
                case "Round":
                    output = int(Math.round(input));
                    break;
                case "Ceiling":
                    output = int(Math.ceil(input));
                    break;
                case "Floor":
                    output = int(Math.floor(input));
                    break;
                default:
                    output = input;
                    break;
            }
            return output;
        }

        public static function CheckLimits(input:Number, min:int, max:int):Number
        {
            var output:Number = input;
            if (output < min) output = min;
            if (output > max) output = max;
            return output;
        }

        public static function CalculateProjectileFormulas(proj:Projectile, abilityPower:Number):Projectile
        {
            var output:Projectile = proj;
            var form:Formula;
            if (proj.descs.Formulas != null)
            {
                for each (form in proj.descs.Formulas)
                {
                    switch (form.Attribute)
                    {
                        case "Speed":
                            output.descs.speed_ = int(Calculate(form, abilityPower));
                            break;
                        case "MinDamage":
                            output.descs.minDamage_ = int(Calculate(form, abilityPower));
                            break;
                        case "MaxDamage":
                            output.descs.maxDamage_ = int(Calculate(form, abilityPower));
                            break;
                        case "LifetimeMS":
                            output.descs.lifetime_ = int(Calculate(form, abilityPower));
                            break;
                        case "Amplitude":
                            output.descs.amplitude = Calculate(form, abilityPower);
                            break;
                        case "Frequency":
                            output.descs.frequency = Calculate(form, abilityPower);
                            break;
                        case "Penetration":
                            output.penetration_ = int(Calculate(form, abilityPower));
                            break;
                        default:
                            break;
                    }
                }
            }
            output.descs.Formulas = null;
            return output;
        }
    }
}
