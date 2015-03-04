package com.leyou.ui.tips {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;

	public class TipsBadgeWnd2 extends AutoWindow {

		private var nameLbl:Label;
		
		private var prop1Lbl:Label;
		private var prop2Lbl:Label;
		private var prop3Lbl:Label;
		private var prop4Lbl:Label;
		private var prop5Lbl:Label;
		private var prop6Lbl:Label;
		
		private var value1Lbl:Label;
		private var value2Lbl:Label;
		private var value3Lbl:Label;
		private var value4Lbl:Label;
		private var value5Lbl:Label;
		private var value6Lbl:Label;
		

		public function TipsBadgeWnd2() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsEquipWnd.xml"));
			this.init();
		}
		
		private function init():void{
			
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			
			this.prop1Lbl=this.getUIbyID("prop1Lbl") as Label;
			this.prop2Lbl=this.getUIbyID("prop2Lbl") as Label;
			this.prop3Lbl=this.getUIbyID("prop3Lbl") as Label;
			this.prop4Lbl=this.getUIbyID("prop4Lbl") as Label;
			this.prop5Lbl=this.getUIbyID("prop5Lbl") as Label;
			this.prop6Lbl=this.getUIbyID("prop6Lbl") as Label;
			
			this.value1Lbl=this.getUIbyID("value1Lbl") as Label;
			this.value2Lbl=this.getUIbyID("value2Lbl") as Label;
			this.value3Lbl=this.getUIbyID("value3Lbl") as Label;
			this.value4Lbl=this.getUIbyID("value4Lbl") as Label;
			this.value5Lbl=this.getUIbyID("value5Lbl") as Label;
			this.value6Lbl=this.getUIbyID("value6Lbl") as Label;
			
			
			
		}



	}
}
