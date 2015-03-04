package com.leyou.ui.backpack {

	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.map.MapWnd;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Mount;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.ui.backpack.child.BackpackGrid;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class BackpackWnd extends BackpackWndView {

		private var firstOpen:Boolean=true;

		public function BackpackWnd() {
			super();
			this.init();
//			this.refresh();
		}

		private function init():void {

			EventManager.getInstance().addEvent(EventEnum.SCENE_LOADED, onComplete);
		}
 
		private function onComplete():void {

			if (SceneEnum.SCENE_TYPE_JSC == MapInfoManager.getInstance().type) {

				UIManager.getInstance().backpackWnd.setEnableItems(ItemEnum.ITEM_TYPE_YAOSHUI);
				UIManager.getInstance().taskTrack.hide()
				UIManager.getInstance().smallMapWnd.switchToType(2);
				UIManager.getInstance().rightTopWnd.hideBar(1);

				if (!UIManager.getInstance().isCreate(WindowEnum.ARENA))
					UIManager.getInstance().creatWindow(WindowEnum.ARENA);

				UIManager.getInstance().arenaWnd.setQuitBtnVisible(true);
				MapWnd.getInstance().hideSwitch();
			} else if (SceneEnum.SCENE_TYPE_RQCJ == MapInfoManager.getInstance().type) {
				UIManager.getInstance().smallMapWnd.switchToType(2);
				UIManager.getInstance().rightTopWnd.hideBar(1);
				MapWnd.getInstance().hideSwitch();
			} else if (SceneEnum.SCENE_TYPE_SGLX == MapInfoManager.getInstance().type) {
				UIManager.getInstance().smallMapWnd.switchToType(2);
				UIManager.getInstance().rightTopWnd.hideBar(1);
				MapWnd.getInstance().hideSwitch();
			}

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			UIManager.getInstance().hideWindow(WindowEnum.EQUIP);

//			Cmd_Role.cm_role();
//			Cmd_Role.cm_equip();

			if (this.firstOpen) {
				Cmd_Mount.cmMouInit();
				Cmd_Wig.cm_WigInit();
				this.firstOpen=false;
			}



		}

		override public function refresh():void {
			super.refresh();
			UIManager.getInstance().showPanelCallback(WindowEnum.BACKPACK);
		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;
			Cmd_Bag.cm_bagData();
			Cmd_Bag.cm_bagOpenGrid();

		}

		override public function hide():void {
			super.hide();

			if (!UIManager.getInstance().isCreate(WindowEnum.STOREGE))
				UIManager.getInstance().creatWindow(WindowEnum.STOREGE);

			UIManager.getInstance().storageWnd.cancelBatchStore();
			UILayoutManager.getInstance().composingWnd(WindowEnum.BACKPACK);

			if (UIManager.getInstance().isCreate(WindowEnum.SHOP) && UIManager.getInstance().shopWnd.visible)
				UILayoutManager.getInstance().composingWnd(WindowEnum.SHOP);

			if (UIManager.getInstance().isCreate(WindowEnum.STOREGE) && UIManager.getInstance().storageWnd.visible)
				UILayoutManager.getInstance().composingWnd(WindowEnum.STOREGE);

			BackpackGrid.menuState=-1;

			UIManager.getInstance().backAddWnd.hidewnd();
			UIManager.getInstance().backLotUseWnd.hide();
			UIManager.getInstance().backPackDropWnd.hide();
			UIManager.getInstance().backPackSplitWnd.hide();

			PopupManager.closeConfirm("backUsePay");
			GuideManager.getInstance().removeGuide(79);

			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.backpackBtn);
		}

		public function setPlayGuideMountItem(type:int=0):void {
			var num:int=MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.MountItem) + MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.MountbindItem);

			if (num >= 10) {

				switch (type) {
					case 0:
						GuideManager.getInstance().showGuide(86, UIManager.getInstance().toolsWnd);
						break;
					case 1:
						GuideManager.getInstance().removeGuide(86);
						GuideManager.getInstance().showGuide(87, UIManager.getInstance().roleWnd.getTabButton(1));
						break;
					case 2:
						GuideManager.getInstance().removeGuide(87);
						GuideManager.getInstance().showGuide(88, UIManager.getInstance().roleWnd);
						break;
					case 3:
						GuideManager.getInstance().removeGuide(88);
						GuideManager.getInstance().showGuide(89, UIManager.getInstance().mountLvUpwnd);
						break;
				}



			}

		}

		public function setPlayGuideWingItem():void {
			var num:int=MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.WingItem) + MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.WingbindItem);

			if (num >= 10) {
				if (UIManager.getInstance().roleWnd.openWing())
					GuideManager.getInstance().showGuide(90, UIManager.getInstance().toolsWnd);
			}
		}

		public function setPlayGuideEquipItem():void {
			var num:int=MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.StrengStone1) + MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.StrengStone2);

			if (num >= 20) {
				if (Core.me != null && Core.me.info.level >= ConfigEnum.EquipIntensifyOpenLv)
					GuideManager.getInstance().showGuide(94, UIManager.getInstance().toolsWnd);
			}
		}

		public function setPlayGuideLuckItem():void {
			var num:int=MyInfoManager.getInstance().getBagItemNumById(ConfigEnum.Luck_draw1);

			if (!UIManager.getInstance().isCreate(WindowEnum.LUCKDRAW))
				UIManager.getInstance().creatWindow(WindowEnum.LUCKDRAW);

			if (num >= 2) {
				GuideManager.getInstance().showGuides([97, 98], [UIManager.getInstance().rightTopWnd.getWidget("lotteryBtn"), UIManager.getInstance().luckDrawWnd]);
			}
		}

		public function resise():void {

			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;

			if (UIManager.getInstance().isCreate(WindowEnum.SHOP) && UIManager.getInstance().shopWnd.visible)
				UILayoutManager.getInstance().composingWnd(WindowEnum.SHOP);
			else if (UIManager.getInstance().isCreate(WindowEnum.STOREGE) && UIManager.getInstance().storageWnd.visible)
				UILayoutManager.getInstance().composingWnd(WindowEnum.STOREGE);
			else
				UILayoutManager.getInstance().composingWnd(WindowEnum.BACKPACK);

		}

	}
}
