package com.leyou.manager {
	import com.ace.enum.PopWndEnum;
	import com.ace.enum.UIEnum;
	import com.ace.ui.window.children.PopRadioWnd;
	import com.ace.ui.window.children.PopRadioWnd_II;
	import com.ace.ui.window.children.PopWindow;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.ace.utils.DebugUtil;
	import com.leyou.utils.PropUtils;

	public class PopupManager {
		
		{
			PopWindow.registerWnd(PopWndEnum.TYPE_RADIO, PopRadioWnd);
			PopWindow.registerWnd(PopWndEnum.TYPE_RADIO_II, PopRadioWnd_II);
		}

		public static function showAlert(txt:String, okfunc:Function=null, ismodel:Boolean=false, id:String="", title:String=""):SimpleWindow {
			var w:WindInfo=WindInfo.getAlertInfo(txt, okfunc);
			if(null == title || "" == title){
				title = PropUtils.getStringById(1549);
			}
			w.title=title;
			w.isModal=ismodel;
			if ("" == id) {
				DebugUtil.throwError("Function = showAlert必须指定id"); //20140811
			}

			return PopWindow.showWnd(UIEnum.WND_TYPE_ALERT, w, id);
		}

		public static function showConfirm(txt:String, okfunc:Function=null, cancelfunc:Function=null, ismodel:Boolean=false, id:String="", title:String=""):SimpleWindow {
			var w:WindInfo=WindInfo.getConfirmInfo(txt, okfunc, cancelfunc);
			w.isModal=ismodel;
			w.title=title;
			if ("" == id) {
				DebugUtil.throwError("Function = showConfirm必须指定id"); //20140811
			}

			return PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, w, id);
		}
		
		public static function showRadioConfirm(text:String, r1Text:String, r2Text:String, okFun:Function=null, cancelFun:Function=null, isModel:Boolean=false, id:String=""):SimpleWindow{
			var w:WindInfo=WindInfo.getRadioInfo(text, okFun, cancelFun);
			w.isModal = isModel;
			w.radioTex1 = "   "+r1Text;
			w.radioTex2 = "   "+r2Text;
			if ("" == id) {
				DebugUtil.throwError("Function = showRadioConfirm.必须指定id"); //20141014
			}
			return PopWindow.showWnd(PopWndEnum.TYPE_RADIO, w, id);
		}
		
		public static function showRadioIIConfirm(text:String, r1Text:String, itemId:int, okFun:Function=null, cancelFun:Function=null, isModel:Boolean=false, id:String=""):SimpleWindow{
			var w:WindInfo=WindInfo.getRadioIIInfo(text, okFun, cancelFun);
			w.isModal = isModel;
			w.radioTex1 = "   " + r1Text;
			w.itemId = itemId;
			if ("" == id) {
				DebugUtil.throwError("Function = showRadioIIConfirm.必须指定id"); //20141014
			}
			return PopWindow.showWnd(PopWndEnum.TYPE_RADIO_II, w, id);
		}

		public static function closeConfirm(id:String):void {
			PopWindow.closeWnd(id);
		}

	}
}
