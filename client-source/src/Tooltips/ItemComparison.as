// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_E_7.ItemComparison

package Tooltips {
import TooltipComparisons.CompareAPTooltip;
import TooltipComparisons.CompareArmorTooltip;
import TooltipComparisons.CompareWeaponTooltip;
import TooltipComparisons.TooltipComparison;

import com.company.PhoenixRealmClient.ui.Slot;

public class ItemComparison {

        public function ItemComparison() {
            var weapons_:CompareWeaponTooltip = new CompareWeaponTooltip();
            var armors_:CompareArmorTooltip = new CompareArmorTooltip();
            var abils_:CompareAPTooltip = new CompareAPTooltip();
            this.hash = {};

            /* Weapons */
            this.hash[Slot.staffWeaponSlot] = weapons_;
            this.hash[Slot.wandWeaponSlot] = weapons_;
    
            this.hash[Slot.bowWeaponSlot] = weapons_;

            this.hash[Slot.swordWeaponSlot] = weapons_;
            this.hash[Slot.daggerWeaponSlot] = weapons_;
            this.hash[Slot.katanaWeaponSlot] = weapons_;

            /* Armours */
            this.hash[Slot.robeArmorSlot] = armors_;
            this.hash[Slot.leatherArmorSlot] = armors_;
            this.hash[Slot.heavyArmorSlot] = armors_;

            /* Abilities */
            this.hash[Slot.priestAbilSlot] = abils_;
            this.hash[Slot.knightAbilSlot] = abils_;
            this.hash[Slot.wizardAbilSlot] = abils_;
            this.hash[Slot.paladinAbilSlot] = abils_;
            this.hash[Slot.rogueAbilSlot] = abils_;
            this.hash[Slot.archerAbilSlot] = abils_;
            this.hash[Slot.warriorAbilSlot] = abils_;
            this.hash[Slot.assassinAbilSlot] = abils_;
            this.hash[Slot.necromancerAbilSlot] = abils_;
            this.hash[Slot.huntressAbilSlot] = abils_;
            this.hash[Slot.mysticAbilSlot] = abils_;
            this.hash[Slot.tricksterAbilSlot] = abils_;
            this.hash[Slot.sorcererAbilSlot] = abils_;
        }
        private var hash:Object;

        public function _hS_(_arg1:XML, _arg2:XML, _arg3:Object, _arg4:Object):ComparisonTooltipBase {
            var _local3:int = int(_arg1.SlotType);
            var _local4:TooltipComparison = this.hash[_local3];
            var _local5:ComparisonTooltipBase = new ComparisonTooltipBase();
            if (_local4 != null) {
                _local4.CompareSlotTooltips(_arg1, _arg2);
                _local4._NQ_d_(_arg1, _arg2, _arg3, _arg4);
                _local5.text = _local4._t4;
                _local5.DictionaryA = _local4.DictionaryA;
                _local5.DictionaryB = _local4.DictionaryB;
            }
            return (_local5);
        }

    }
}//package _E_7

