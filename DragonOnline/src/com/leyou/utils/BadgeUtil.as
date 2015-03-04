package com.leyou.utils {

	import com.ace.manager.LibManager;

	public class BadgeUtil {


		public function BadgeUtil() {


		}

		/**
		 *
		 * @param item item
		 * @param pindex 位置
		 * @param value
		 * @return
		 *
		 */
		public static function getColorByconfig(item:int, pindex:int, value:int):uint {
			var bldNode:XML=LibManager.getInstance().getXML("config/table/bloodNote.xml");

			var xml:XML;
			for each (xml in bldNode.bloodNote) {

				if (xml.@bloodId == item && xml.@attribute == pindex) {
					if (value >= xml.@lowMin && value <=xml.@lowMax)
						return 0x69e053;
					else if (value >= xml.@midMin && value <=xml.@midMax)
						return 0x3fa6ed;
					else if (value >= xml.@highMin && value <=xml.@highMax)
						return 0xcc54ea;
					else if (value == xml.@full)
						return 0xf6d654;
				}
			}

			return 0xffffff;
		}

		
		/**
		 * 
		 * @param item
		 * @param pindex
		 * @return 
		 * 
		 */		
		public static function getColorRect(item:int, pindex:int):Array {

			var bldNode:XML=LibManager.getInstance().getXML("config/table/bloodNote.xml");

			var xml:XML;
			for each (xml in bldNode.bloodNote) {
				if (xml.@bloodId == item && xml.@attribute == pindex) {
					return [xml.@lowMin, xml.@full]
				}
			}

			return [];
		}


		public static function getTypeByRate(r:int):String {
			var str:String;

			if (r == 100)
				str="必成";
			else if (r >= 90 && r < 100)
				str="极高";
			else if (r >= 70 && r < 90)
				str="较高";
			else if (r >= 50 && r < 70)
				str="高";
			else if (r >= 30 && r < 50)
				str="较低";
			else if (r >= 0 && r < 30)
				str="低";

			return str;
		}

	}
}