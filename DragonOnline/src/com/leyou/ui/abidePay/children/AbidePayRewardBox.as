package com.leyou.ui.abidePay.children {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.table.TAbidePayInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.abidePay.AbidePayData;
	import com.leyou.data.combineData.CombineData;
	import com.leyou.ui.market.child.MarketGrid;

	import flash.events.MouseEvent;

	public class AbidePayRewardBox extends AutoSprite {
		// 1--开服连冲 2--合服连冲 3--台湾连冲
		private var _belongType:int;

		private var _type:int;

		private var _day:int;

		private var _id:int;

		private var grid:MarketGrid;

		private var flagImg:Image;

		private var receivebtn:NormalButton;

		public function AbidePayRewardBox() {
			super(LibManager.getInstance().getXML("config/ui/abidePay/lxczbtn.xml"));
			init();
		}

		public function get belongType():int {
			return _belongType;
		}

		public function get id():int {
			return _id;
		}

		public function get type():int {
			return _type;
		}

		public function get day():int {
			return _day;
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			grid=new MarketGrid();
			grid.isShowPrice=false;
			receivebtn=getUIbyID("receivebtn") as NormalButton;
			flagImg=getUIbyID("flagImg") as Image;
			addChild(grid);
			swapChildren(grid, receivebtn);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			flagImg.x-=9;
			receivebtn.x-=10;
			addChild(flagImg);
			flagImg.visible=false;
			receivebtn.visible=false;
		}

		protected function onMouseClick(event:MouseEvent):void {
//			if(TweenMax.isTweening(this)){
//				TweenMax.killTweensOf(this);
//				this.filters = [];
//			}
			UIManager.getInstance().showWindow(WindowEnum.ABIDE_BOX);
			if (1 == _belongType) {
				UIManager.getInstance().abidePayBoxWnd.updateInfo(this);
			} else {
				UIManager.getInstance().abidePayBoxWnd.updateCombineInfo(this);
			}
		}

		public function updateContent(tdata:TAbidePayInfo, $day:int, belongType:int):void {
			_day=$day;
			_id=tdata.id;
			_type=tdata.ib;
			_belongType=belongType;
			if (1 == _belongType) {
				grid.updataById(tdata.getRewardByDay($day));
			} else if (2 == _belongType) {
				grid.updataById(tdata.getCombineReward($day));
			} else if (3 == _belongType) {
				grid.updataById(tdata.getLCTWReward($day));
			}
			grid.stopMc();
		}

		public function reset():void {
			flagImg.visible=false;
			receivebtn.visible=false;
		}

		public function updateCombineInfo(data:CombineData):void {
			if (data.isReceive(_day, _type)) {
				flagImg.visible=true;
				receivebtn.visible=false;
				flagImg.updateBmp("ui/lxcz/icon_ylq.png");
				return;
			}
			var rd:int=data.getAbideDay(_type);
			if (rd >= _day) {
				receivebtn.visible=true;
			}
		}

		public function updateInfo(data:AbidePayData):Boolean {
			if (data.isReceive(_day, _type)) {
				flagImg.visible=true;
				receivebtn.visible=false;
				flagImg.updateBmp("ui/lxcz/icon_ylq.png");
				return false;
			}
			if (!data.isEnable(_day, _type)) {
				flagImg.visible=true;
				receivebtn.visible=false;
				flagImg.updateBmp("ui/lxcz/icon_ysx.png");
				return false;
			}
			var rd:int=data.getAbideDay(_type);
			if (rd == _day) {
				receivebtn.visible=true;
				return true;
//				if(!TweenMax.isTweening(this)){
//					TweenMax.to(this, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 10, blurY: 10, strength: 2}, yoyo: true, repeat: -1});
//				}
			}
			return false;
		}
	}
}
