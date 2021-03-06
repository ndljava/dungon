package com.leyou.ui.skill {

	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.data.playerSkill.SkillInfo;
	import com.leyou.data.playerSkill.TipSkillInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Link;
	import com.leyou.net.cmd.Cmd_Skill;
	import com.leyou.ui.skill.childs.PassiveSkill;
	import com.leyou.ui.skill.childs.SkillBar;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SkillWnd extends AutoWindow {

		public var currentIdx:int=-1;
		private var renderArr:Array=[];

//		private var skillFun:SkillFuWnd;
		private var skillOb:TipsSkillObWnd;
		public var confirmState:Boolean=false;
		public var selectIndex:int=-1;

		private var skllTabbar:TabBar;

		private var skillContiner:Sprite;
		private var passSkill:PassiveSkill;

		private var mainSkillBtn:ImgButton;
		private var passivitySkillBtn:ImgButton;

		public function SkillWnd() {
			super(LibManager.getInstance().getXML("config/ui/SkillWnd.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.mainSkillBtn=this.getUIbyID("mainSkillBtn") as ImgButton;
			this.passivitySkillBtn=this.getUIbyID("passivitySkillBtn") as ImgButton;

			this.skillContiner=new Sprite();
			this.addChild(this.skillContiner);
			this.skillContiner.x=100;
			this.skillContiner.y=100;

			this.passSkill=new PassiveSkill();
			this.addChild(this.passSkill);
			this.passSkill.x=65;
			this.passSkill.y=5;

//			this.passSkill.opaqueBackground=0xff0000;

			this.mainSkillBtn.addEventListener(MouseEvent.CLICK, onChange);
			this.passivitySkillBtn.addEventListener(MouseEvent.CLICK, onChange);

//			this.skillContiner.addEventListener(MouseEvent.CLICK, onGridListClick);
//			this.skillContiner.addEventListener(MouseEvent.MOUSE_OVER, onGridListOver);
//			this.skillContiner.addEventListener(MouseEvent.MOUSE_MOVE, onGridListOver);
//			this.skillContiner.addEventListener(MouseEvent.MOUSE_OUT, onGridListOut);

//			this.scrollRect=new Rectangle(0, 0, 574, 496);

			this.skillContiner.visible=true;
			this.passSkill.visible=false;

			this.mainSkillBtn.turnOn();
			this.passivitySkillBtn.turnOff();

			this.passivitySkillBtn.setToolTip(StringUtil.substitute(PropUtils.getStringById(2170), [ConfigEnum.skill4]));

//			this.skillFun=new SkillFuWnd();
//			LayerManager.getInstance().windowLayer.addChild(this.skillFun);
		}

		private function onChange(e:MouseEvent):void {

			switch (e.target.name) {
				case "mainSkillBtn":
					this.skillContiner.visible=true;
					this.passSkill.visible=false;
					this.mainSkillBtn.turnOn();
					this.passivitySkillBtn.turnOff();
					break;
				case "passivitySkillBtn":
					if (Core.me.info.level < ConfigEnum.skill4) {
						this.skillContiner.visible=true;
						this.passSkill.visible=false;
						this.mainSkillBtn.turnOn();
						this.passivitySkillBtn.turnOff();
					} else {
						this.skillContiner.visible=false;
						this.passSkill.visible=true;
						this.mainSkillBtn.turnOff();
						this.passivitySkillBtn.turnOn();
					}
					break;
			}

		}

		public function setTabIndex(i:int):void {
			switch (i) {
				case 0:
					this.skillContiner.visible=true;
					this.passSkill.visible=false;
					this.mainSkillBtn.turnOn();
					this.passivitySkillBtn.turnOff();
					break;
				case 1:
					if (Core.me.info.level < ConfigEnum.skill4) {
						this.skillContiner.visible=true;
						this.passSkill.visible=false;
						this.mainSkillBtn.turnOn();
						this.passivitySkillBtn.turnOff();
					} else {
						this.skillContiner.visible=false;
						this.passSkill.visible=true;
						this.mainSkillBtn.turnOff();
						this.passivitySkillBtn.turnOn();
					}
					break;
			}

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
//			NetGate.getInstance().send("help");

			GuideManager.getInstance().removeGuide(63);
			GuideManager.getInstance().removeGuide(35);

			super.show(toTop, $layer, toCenter);

			if (15 == MyInfoManager.getInstance().skilldata.skillItems[1][2])
				GuideManager.getInstance().showGuide(37, this.renderArr[1].fuwenImg2);

//			if (!UIManager.getInstance().isCreate(WindowEnum.RUNE))
//				UIManager.getInstance().creatWindow(WindowEnum.RUNE);
//
//			UILayoutManager.getInstance().show(WindowEnum.SKILL, WindowEnum.RUNE, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);
////			UIManager.getInstance().skillFuWnd.show();
//			this.selectIndex=1;
//			this.renderArr[this.selectIndex].hight=true;
//			UIManager.getInstance().skillFuWnd.updateInfo(MyInfoManager.getInstance().skilldata.skillItems[this.selectIndex]);

			if (!MyInfoManager.getInstance().isTaskOk && MyInfoManager.getInstance().currentTaskId == 16)
				TweenLite.delayedCall(ConfigEnum.autoTask3, this.autoTaskComplete);

			if (!MyInfoManager.getInstance().isTaskOk && MyInfoManager.getInstance().currentTaskId == 77)
				TweenLite.delayedCall(ConfigEnum.autoTask3, this.autoTaskComplete);
		}

		private function autoTaskComplete():void {
			if (this.visible) {

				if (!MyInfoManager.getInstance().isTaskOk && MyInfoManager.getInstance().currentTaskId == 16)
					SkillBar(this.renderArr[1]).dispAutoEvent();
				else if (!MyInfoManager.getInstance().isTaskOk && MyInfoManager.getInstance().currentTaskId == 77) {
					this.passSkill.upgradeBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}

			}
		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;

			if (!this.visible) {
				Cmd_Skill.cm_sklView();
				Cmd_Link.cm_linkSearch();
			}

			UIManager.getInstance().showPanelCallback(WindowEnum.SKILL);
		}

		/**
		 *	更新信息显示
		 * @param info
		 */
		public function updateInfo():void {

			var key:String;
			var skill:SkillInfo;

			if (this.renderArr.length == 0) {

				var render:SkillBar;

				skill=MyInfoManager.getInstance().skilldata;

				var i:int=0;
				for (key in skill.skillItems) {

					render=new SkillBar((i != 0));

					render.updateInfo(skill.skillItems[key]);

					render.y=i * 80 - 40;
//					render.x=75;
//					render.visible=false;

					this.renderArr[int(key)]=render;
					this.skillContiner.addChild(render);

					if (skill.skillItems[key][0] == 0)
						render.enable=true;
					else
						render.enable=false;

					i++;
				}

			} else {

				skill=MyInfoManager.getInstance().skilldata;
				for (key in skill.skillItems) {
					this.renderArr[int(key)].updateInfo(skill.skillItems[key]);

					if (skill.skillItems[key][0] == 0)
						this.renderArr[int(key)].enable=true;
					else
						this.renderArr[int(key)].enable=false;
				}

				if (UIManager.getInstance().isCreate(WindowEnum.RUNE) && UIManager.getInstance().skillFuWnd.visible) {
//					UIManager.getInstance().skillFuWnd.hide();

//					UILayoutManager.getInstance().show(WindowEnum.SKILL, WindowEnum.RUNE);\
//					if (UIManager.getInstance().skillFuWnd.isShow)
//						UIManager.getInstance().skillFuWnd.hide();
//					else

//					UILayoutManager.getInstance().show(WindowEnum.SKILL, WindowEnum.RUNE, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);

					if (this.selectIndex != -1)
						UIManager.getInstance().skillFuWnd.updateInfo(MyInfoManager.getInstance().skilldata.skillItems[this.selectIndex]);
				}

				UIManager.getInstance().toolsWnd.setAutoMagicList();
			}

			if (Core.me.info.level >= ConfigEnum.skill4) {
				this.passivitySkillBtn.setToolTip("");
				this.passivitySkillBtn.setActive(true, 1, true);
			} else {
				this.passivitySkillBtn.setActive(false, 0.6, true);
			}

			if (this.visible && 15 == MyInfoManager.getInstance().skilldata.skillItems[1][2])
				GuideManager.getInstance().showGuide(37, this.renderArr[1].fuwenImg2);
		}

		public function updateSkill(o:Object):void {
			this.passSkill.updateInfo(o);
		}

		public function setautoMagic(skid:int, st:Boolean):void {

			var key:String;
			var skill:SkillInfo;

			skill=MyInfoManager.getInstance().skilldata;

			for (key in skill.skillItems) {

				if (skill.skillItems[key][1] == skid) {
					this.renderArr[int(key)].setAutoMagicEffect(st);
					break;
				}
			}

		}

		private function onGridListClick(evt:MouseEvent):void {

			if (evt.target is SkillBar) {

				if (this.selectIndex != -1)
					this.renderArr[this.selectIndex].hight=false;

				this.selectIndex=this.renderArr.indexOf(evt.target);
				this.onGridListOver(evt);

				if (this.selectIndex != 0)
					GuideManager.getInstance().removeGuide(37);

				if (!UIManager.getInstance().isCreate(WindowEnum.RUNE))
					UIManager.getInstance().creatWindow(WindowEnum.RUNE);

				if (MyInfoManager.getInstance().skilldata.skillItems[this.selectIndex][0] == 1) {
//					UIManager.getInstance().skillFuWnd.hide();

					if (!UIManager.getInstance().skillFuWnd.visible)
						UILayoutManager.getInstance().show(WindowEnum.SKILL, WindowEnum.RUNE, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);
					UIManager.getInstance().skillFuWnd.updateInfo(MyInfoManager.getInstance().skilldata.skillItems[this.selectIndex]);
				}

			}
		}

		private function onGridListOver(evt:MouseEvent):void {

//			trace("111", evt.target, evt.currentTarget.name);

			if (evt.target is SkillBar) {
				SkillBar(evt.target).hight=true;

				var skill:Array=TableManager.getInstance().getSkillArr(MyInfoManager.getInstance().skilldata.skillItems[this.renderArr.indexOf(evt.target)][1]);
				skill.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

				var skills:Array=MyInfoManager.getInstance().skilldata.skillItems[this.renderArr.indexOf(evt.target)];
				var k:int=skills.indexOf(2, 3) - 2;

				if (k < 0 && skills.length == 7 && (skills[6]).split("_")[1] == 2) {
					k=(skills[6]).split("_")[0];
				}

				k=k < 0 ? 0 : k;

				var tipInfo:TipSkillInfo=new TipSkillInfo();
				tipInfo.skillInfo=skill[k];

				tipInfo.hasRune=false;
//				tipInfo.level=MyInfoManager.getInstance().skilldata.skillItems[this.renderArr.indexOf(evt.target)][2];
				tipInfo.level=int(tipInfo.skillInfo.autoLv);
				tipInfo.skillLv=int(tipInfo.skillInfo.autoLv);

//				tipInfo.runde=MyInfoManager.getInstance().skilldata.skillItems[this.renderArr.indexOf(evt.target)].indexOf(2, 3) - 2;

				tipInfo.runde=skill.indexOf(tipInfo.skillInfo);

				if (tipInfo.runde <= 0)
					ToolTipManager.getInstance().show(TipEnum.TYPE_SKILL, tipInfo, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
				else
					ToolTipManager.getInstance().showII([TipEnum.TYPE_SKILL, TipEnum.TYPE_RUNE], [tipInfo, tipInfo], PlayerEnum.DIR_S, new Point(0, 0), new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));

			}

		}

		private function onGridListOut(evt:MouseEvent):void {

			if (evt.target is SkillBar && this.selectIndex != this.renderArr.indexOf(evt.target)) {
				SkillBar(evt.target).hight=false;
			}

		}

		/**
		 * 切换符文
		 */
		public function setChangeRune():void {
			UIManager.getInstance().skillFuWnd.setChangeRune();
		}

		/**
		 *获取开启的符文技能
		 * @param skid
		 * @return
		 *
		 */
		public function getOpenSkill(skid:int):TSkillInfo {

			var sk:Array=TableManager.getInstance().getSkillArr(skid);
//			sk.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			var skl:Array=MyInfoManager.getInstance().skilldata.skillItems;

			var k:int;
			var key:String;
			for (key in skl) {
				if (int(skl[key][1]) == skid) {
					k=skl[key].indexOf(2, 3) - 2;

					if (k < 0 && skl[key].length == 7 && (skl[key][6]).split("_")[1] == 2) {
						k=(skl[key][6]).split("_")[0];
					}

					break;
				}
			}

			return sk[k < 0 ? 0 : k];
		}

		/**
		 *
		 * @param skid
		 * @return
		 *
		 */
		public function getSkillArrByID(skid:int):Array {
			var skl:Array=MyInfoManager.getInstance().skilldata.skillItems;

			var k:int;
			var key:String;
			for (key in skl) {
				if (int(skl[key][1]) == skid) {
					return skl[key];
				}
			}

			return [];
		}



		public function showGetPanel(o:Object):void {
			this.skillOb=new TipsSkillObWnd();
			LayerManager.getInstance().windowLayer.addChild(this.skillOb);

			this.skillOb.showPanel(o);

			SoundManager.getInstance().play(18);

		}

		public function getSkillObIndex():int {

			if (this.skillOb == null)
				return -1;

			return this.skillOb.toolsEffectIndex;
		}

		public function setSkillObIndex():void {

			if (this.skillOb != null)
				this.skillOb.toolsEffectIndex=-1;
		}

		override public function hide():void {
			super.hide();

			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.skillBtn);
			GuideManager.getInstance().removeGuide(37);

			UIManager.getInstance().hideWindow(WindowEnum.RUNE);
//			UIManager.getInstance().hideWindow(WindowEnum.MESSAGE);

			PopupManager.closeConfirm("changeRune");
			UIManager.getInstance().hideWindow(WindowEnum.QUICK_BUY);

			if (this.selectIndex != -1)
				this.renderArr[this.selectIndex].hight=false;

			this.selectIndex=-1;

			GuideArrowDirectManager.getInstance().delArrow(WindowEnum.SKILL + "");
		}

		override public function onWndMouseMove($x:Number, $y:Number):void {
			super.onWndMouseMove($x, $y);

			if (!UIManager.getInstance().isCreate(WindowEnum.RUNE))
				UIManager.getInstance().creatWindow(WindowEnum.RUNE);

			if (UIManager.getInstance().skillFuWnd.visible) {
				if (this.x + this.width + UIManager.getInstance().skillFuWnd.width >= UIEnum.WIDTH)
					this.x=UIEnum.WIDTH - this.width - UIManager.getInstance().skillFuWnd.width;

				UIManager.getInstance().skillFuWnd.x=this.x + this.width + UILayoutManager.SPACE_X;
				UIManager.getInstance().skillFuWnd.y=this.y + UILayoutManager.SPACE_Y;
			}

		}

		public function resize():void {

			this.y=(UIEnum.HEIGHT - this.height) / 2;

			if (UIManager.getInstance().isCreate(WindowEnum.RUNE) && UIManager.getInstance().skillFuWnd.visible) {
//				if (this.x + this.width + UIManager.getInstance().skillFuWnd.width >= UIEnum.WIDTH)
				this.x=UIEnum.WIDTH - this.width - UIManager.getInstance().skillFuWnd.width >> 1;

				UIManager.getInstance().skillFuWnd.x=this.x + this.width + UILayoutManager.SPACE_X;
				UIManager.getInstance().skillFuWnd.y=this.y + UILayoutManager.SPACE_Y;
			} else {
				this.x=(UIEnum.WIDTH - this.width) / 2;
			}
		}

		override public function getUIbyID(id:String):DisplayObject {
			var ds:DisplayObject=super.getUIbyID(id);

			if (ds == null) {

				if (this.skillContiner.visible) {
					var skl:Array=MyInfoManager.getInstance().skilldata.skillItems;

					var k:int;
					var key:String;
					for (key in skl) {
						if (skl[key][2] < Core.me.info.level) {
							ds=this.renderArr[int(key)].getUIbyID(id);
							break;
						}
					}
				} else {
					return this.passSkill.upgradeBtn;
				}
			}

			return ds;
		}

		override public function get height():Number {
			return 584;
		}

		override public function get width():Number {
			return 888 + 67;
		}

	}
}
