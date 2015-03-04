package com.leyou.ui.otherPlayer {

	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.PnfUtil;
	import com.leyou.data.element.ElementInfo;
	import com.leyou.data.role.RoleInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Gem;
	import com.leyou.net.cmd.Cmd_Mount;
	import com.leyou.net.cmd.Cmd_Role;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.ui.gem.GemWnd;
	import com.leyou.ui.mount.MountWnd;
	import com.leyou.ui.role.child.ElementWnd;
	import com.leyou.ui.role.child.PropertyWnd;
	import com.leyou.ui.role.child.children.EquipGrid;
	import com.leyou.ui.role.child.children.PropertyNum;
	import com.leyou.ui.role.child.children.RoleEquipUpWnd;
	import com.leyou.ui.title.TitleWnd;
	import com.leyou.ui.wing.WingWnd;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	//格式化代码
	public class OtherPlayerWnd extends AutoWindow {

		private var roleTabBar:TabBar;

		//人物属性面板
		private var rolePropertyWnd:PropertyWnd;

		//元素面板
		public var elementWnd:ElementWnd;

		//坐骑面板
		private var mountWnd:MountWnd;
		private var wingWnd:WingWnd; //翅膀面板
		private var titleWnd:TitleWnd; //称号面板
		private var gemWnd:GemWnd; //称号面板

		private var fristF:Boolean; //是否第一次打开此面板

		private var info:RoleInfo;
		private var equip:Object;
		private var elementFlag:Boolean;

		private var otherPlayer:Boolean=true;

		private var bigAvatar:BigAvatar;

		private var roleEquipUp:RoleEquipUpWnd;
		private var propertyNum:PropertyNum;
		private var feachInfo:FeatureInfo;

		private var wingAvatar:SwfLoader;

		private var playName:String;

		private var equipBackEffect:SwfLoader;
		private var equipEffect:SwfLoader;

		private var bgsp:Sprite;
		
		public function OtherPlayerWnd() {
			super(LibManager.getInstance().getXML("config/ui/RoleWnd.xml"));
			this.init();
		}

		private function init():void {
			this.roleTabBar=this.getUIbyID("RoleTabBar") as TabBar;
			this.roleTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);

			this.rolePropertyWnd=new PropertyWnd(otherPlayer);
			this.roleTabBar.addToTab(this.rolePropertyWnd, 0);

			this.mountWnd=new MountWnd(otherPlayer);
			this.roleTabBar.addToTab(this.mountWnd, 1);
			
			this.gemWnd=new GemWnd(otherPlayer);
			this.roleTabBar.addToTab(this.gemWnd, 2);

			this.wingWnd=new WingWnd(otherPlayer);
			this.roleTabBar.addToTab(this.wingWnd, 6);

			this.propertyNum=new PropertyNum(otherPlayer);

			this.propertyNum.x=287;
			this.propertyNum.y=68;
			this.addChild(this.propertyNum);

			this.equipBackEffect=new SwfLoader();
			this.addChild(this.equipBackEffect);

			this.equipBackEffect.x=160;
			this.equipBackEffect.y=408;

			this.roleEquipUp=new RoleEquipUpWnd(otherPlayer);
			this.addChild(this.roleEquipUp);
			this.roleEquipUp.y=70;
			this.roleEquipUp.x=15;
			
//			this.roleEquipUp.mouseChildren=false;

			this.bigAvatar=new BigAvatar();
			this.bigAvatar.x=156;
			this.bigAvatar.y=411;
			this.addChild(this.bigAvatar);

			this.feachInfo=new FeatureInfo();

			this.wingAvatar=new SwfLoader();
			this.addChild(this.wingAvatar);

			this.wingAvatar.x=150;
			this.wingAvatar.y=408;

			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);

			this.equipEffect=new SwfLoader();
			this.addChild(this.equipEffect);

			this.equipEffect.x=155;
			this.equipEffect.y=248;

			this.equipEffect.mouseChildren=false;
			this.equipEffect.mouseEnabled=false;
			
//			bgsp=new Sprite();
//			bgsp.graphics.beginFill(0x000000);
//			bgsp.graphics.drawRect(0, 0, 143, 307);
//			bgsp.graphics.endFill();
//			
//			this.addChild(bgsp);
//			
//			bgsp.x=80;
//			bgsp.y=110;
//			bgsp.alpha=0;
			
//			bgsp.addEventListener(MouseEvent.CLICK, onEffClick);
			
		}

		private function onEffClick(e:MouseEvent):void {
			this.bigAvatar.showII(Core.me.info.featureInfo, true, Core.me.info.profession);
		}

		private function onMouseMove(e:MouseEvent):void {

			e.stopImmediatePropagation();
			e.stopPropagation();
			e.preventDefault();

			if (e.target is PropertyNum) {

				this.setChildIndex(this.propertyNum, 8);
				this.setChildIndex(this.roleEquipUp, 6);
				this.setChildIndex(this.bigAvatar, 7);

			} else if (e.target is EquipGrid) {

				this.setChildIndex(this.propertyNum, 6);
				this.setChildIndex(this.roleEquipUp, 8);
				this.setChildIndex(this.bigAvatar, 7);
			} else {

				this.setChildIndex(this.propertyNum, 6);
				this.setChildIndex(this.roleEquipUp, 7);
				this.setChildIndex(this.bigAvatar, 8);
			}


		}

		public function showPanel(playName:String):void {

			this.roleTabBar.turnToTab(0);

			Cmd_Role.cm_role(playName);
			Cmd_Role.cm_equip(playName);

//			Cmd_Element.cm_ele_s(playName);
//			Cmd_Element.cm_ele_c(playName);

			Cmd_Gem.cmGemInit(playName);
			Cmd_Mount.cmMouInit(playName);
			Cmd_Wig.cm_WigInit(playName);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			this.roleTabBar.setTabVisible(1, false);
			this.roleTabBar.setTabVisible(2, false);
			this.roleTabBar.setTabVisible(3, false);
			this.roleTabBar.setTabVisible(4, false);
			this.roleTabBar.setTabVisible(5, false);
			this.roleTabBar.setTabVisible(6, false);

//			Cmd_Role.cm_role();
//			Cmd_Role.cm_equip();
//			
//			Cmd_Element.cm_ele_s();
//			Cmd_Element.cm_ele_c();
//			
//			Cmd_Mount.cmMouInit();
//			Cmd_Wig.cm_WigInit();

			this.updateWingEffect(this.roleEquipUp.currentEquip);
//			this.updateWingEffect([99933, 99935]);

		}


		private function onTabBarChangeIndex(evt:Event):void {

//			if (this.roleTabBar.turnOnIndex == 3) {
//				Cmd_Wig.cm_WigInit(this.playName);
//			} else {
//			}
//			
//			if (this.roleTabBar.turnOnIndex == 2) {
//				Cmd_Mount.cmMouInit(playName);
//			} else {
//				UIManager.getInstance().mountLvUpwnd.hide();
//				UIManager.getInstance().mountTradeWnd.hide();
//			}

//			if (this.roleTabBar.turnOnIndex == 1) {
//				if (this.elementFlag == false) {
//					Cmd_Element.cm_ele_s();
//					Cmd_Element.cm_ele_c();
//					this.elementFlag=true;
//				}
//				
//			}

			if (this.roleTabBar.turnOnIndex == 6) {

//				Cmd_Wig.cm_WigInit();
				this.wingAvatar.visible=true;
				this.wingWnd.wingNameImg.visible=true;

			} else {

				if (UIManager.getInstance().wingLvUpWnd.visible)
					UIManager.getInstance().hideWindow(WindowEnum.WINGLVUP);

				this.wingAvatar.visible=false;
				this.wingWnd.wingNameImg.visible=false;
			}

			if (this.roleTabBar.turnOnIndex == 0) {
//				Cmd_Role.cm_role();
//				Cmd_Role.cm_equip();
//				this.bigAvatar.showII(Core.me.info.featureInfo);
				this.bigAvatar.visible=true;

				this.roleEquipUp.visible=true;
				this.propertyNum.visible=true;
				
				this.updateWingEffect(this.roleEquipUp.currentEquip);
				
//				this.bgsp.visible=true;
			} else {
				
//				this.bgsp.visible=false;
				
				this.bigAvatar.visible=false;
				this.roleEquipUp.visible=false;
				this.propertyNum.visible=false;

				this.equipBackEffect.visible=false;
				this.equipEffect.visible=false;
			}

		}


		/**
		 *更新人物信息
		 * @param info
		 *
		 */
		public function updateInfo(info:RoleInfo):void {
			this.info=info;
			this.rolePropertyWnd.updateInfo(info);
			this.roleEquipUp.updateInfo(info);
			this.propertyNum.updateInfo(info);
			this.showAvatar(info);
		}

		public function showAvatar(info:RoleInfo):void {

			var avtArr:Array=info.avt.split(",");

			this.feachInfo.clear();
			this.feachInfo.mount=avtArr[4];

			if (this.feachInfo.mount == 0) {
				this.feachInfo.weapon=PnfUtil.realAvtId(avtArr[1], false, info.sex);
				this.feachInfo.suit=PnfUtil.realAvtId(avtArr[2], false, info.sex);
				this.feachInfo.wing=PnfUtil.realWingId(avtArr[3], false, info.sex, info.race);

			} else {
				this.feachInfo.mountWeapon=PnfUtil.realAvtId(avtArr[1], true, info.sex);
				this.feachInfo.mountSuit=PnfUtil.realAvtId(avtArr[2], true, info.sex);
				this.feachInfo.mountWing=PnfUtil.realWingId(avtArr[3], true, info.sex, info.race);
				this.feachInfo.autoNormalInfo(true, info.race, info.sex);
			}

			this.bigAvatar.showII(this.feachInfo, false, info.race);
		}


		public function updateWingAvatar(pnfid:int):void {
			var pnid:int=38000 + (pnfid - 1);
			this.wingAvatar.update(pnid);
		}

		/**
		 *更新装备信息
		 *
		 */
		public function updateEquip():void {
			this.roleEquipUp.updateEquip(this.otherPlayer)
			this.updateWingEffect(this.roleEquipUp.currentEquip);
		}

		/**
		 *删除装备
		 * @param pos
		 *
		 */
		public function deleteEquip(pos:int):void {
			this.roleEquipUp.deleteEquip(pos);
			this.updateWingEffect(this.roleEquipUp.currentEquip);
		}

		/**
		 *元素的信息
		 * @return
		 *
		 */
		public function get elementInfo():ElementInfo {
			if (this.elementWnd.info == null)
				this.elementWnd.info=new ElementInfo();

			return this.elementWnd.info;
		}
		
		public function updatemountEquip(o:Array):void {
			this.mountWnd.updateEquipSlot(o);
			
		}

		/**
		 *更新元素信息
		 * @param info
		 *
		 */
		public function updateElement(info:ElementInfo):void {
			this.elementWnd.updateInfor(info);
		}
		
		public function updateGemInfo(o:Object):void{
			if (ConfigEnum.Gem1 <= this.info.lv) {
				this.roleTabBar.setTabVisible(2, true);
				this.gemWnd.updateInfo(o);
			} else
				this.roleTabBar.setTabVisible(2, false);
			
		}

		/**
		 *更新守护元素信息
		 * @param info
		 *
		 */
		public function updateGuildElement(info:ElementInfo):void {
			if (ConfigEnum.ElementOpenLv <= this.info.lv) {
				this.roleTabBar.setTabVisible(3, true);
				this.elementWnd.updateGuildElement(info);
			} else
				this.roleTabBar.setTabVisible(3, false);
		}

		public function updateMount(o:Object):void {
			//			trace(ConfigEnum.MountOpenLv, Core.me.info.level)
			if (ConfigEnum.MountOpenLv <= this.info.lv) {
				this.roleTabBar.setTabVisible(1, true);
				this.mountWnd.updateData(o);
				UIManager.getInstance().toolsWnd.mountBtn.setActive(true);
			} else {
				this.roleTabBar.setTabVisible(1, false);
				UIManager.getInstance().toolsWnd.mountBtn.setActive(false);
			}
		}

		/**
		 * 坐骑属性列表
		 * @param o
		 *
		 */
		public function updateMountProps(o:Object):void {
			this.mountWnd.updatePropList(o);
		}

		/**
		 * 改变坐骑状态
		 * @param o
		 */
		public function changeMountState(o:Object):void {
			this.mountWnd.changeMountState(o);
		}

		/**
		 * 更新数据
		 * @param o
		 *
		 */
		public function updateWig(o:Object):void {
			//			trace(Core.me.info.level, o.lv)
			if (o.hasOwnProperty("lv") && this.info.lv >= ConfigEnum.WingOpenLv) {
				this.wingWnd.updateInfo(o);
				this.roleTabBar.setTabVisible(6, true);
			} else {
				this.roleTabBar.setTabVisible(6, false);
			}
		}

		/**
		 *上下坐骑
		 *
		 */
		public function mountUpAndDown():void {
			this.mountWnd.UpAndDownMount();
		}

		/**
		 * 开启格子
		 * @param o
		 *
		 */
		public function updateWingGrid(o:Object):void {
			this.wingWnd.updateGrid(o);
		}

		/**
		 * @param o
		 */
		public function updateWingGridList(o:Object):void {
			this.wingWnd.updateGridList(o);
		}

		/**
		 *更新称号列表
		 * @param o
		 *
		 */
		public function updateTitleList(o:Object):void {
			if (ConfigEnum.NckOpenLv <= this.info.lv) {
				this.roleTabBar.setTabVisible(4, true);
				this.titleWnd.updateInfo(o);
			} else
				this.roleTabBar.setTabVisible(4, false);

		}

		public function get titlePanel():TitleWnd {
			return this.titleWnd;
		}

		/**
		 *更新人物avatar
		 *
		 */
		public function updateRoleAvatar():void {
			this.bigAvatar.showII(Core.me.info.featureInfo);
		}

		override public function hide():void {
			super.hide();
			this.equipBackEffect.visible=false;
			this.equipEffect.visible=false;
		}

		public function updateWingEffect(pid:Array):void {
			this.equipBackEffect.visible=false;
			this.equipEffect.visible=false;

			if (pid[0] != -1) {

				this.equipBackEffect.visible=true;
				this.equipBackEffect.update(pid[0], play1);

				function play1():void {
					if (visible)
						equipBackEffect.playAct(PlayerEnum.ACT_STAND, -1, true);
				}

			}

			if (pid[1] != -1) {

				this.equipEffect.visible=true;
				this.equipEffect.update(pid[1], play2);

				function play2():void {
					if (visible)
						equipEffect.playAct(PlayerEnum.ACT_STAND, -1, true);
				}
			}

			this.equipBackEffect.x=160;
			this.equipBackEffect.y=408;

			this.equipEffect.x=155;
			this.equipEffect.y=248;
		}

		public function resise():void {
			//			if (UIManager.getInstance().isCreate(WindowEnum.MOUTLVUP) && UIManager.getInstance().mountLvUpwnd.visible && UIManager.getInstance().isCreate(WindowEnum.MOUTTRADEUP) && UIManager.getInstance().mountTradeWnd.visible && UIManager.getInstance().isCreate(WindowEnum.WINGLVUP) && UIManager.getInstance().wingLvUpWnd.visible) {
			//				return ;
			//			} else {

//			if (UIManager.getInstance().mountLvUpwnd.visible && UIManager.getInstance().mountTradeWnd.visible && UIManager.getInstance().wingLvUpWnd.visible) {
//				this.x=(UIEnum.WIDTH - this.width) / 2;
//				this.y=(UIEnum.HEIGHT - this.height) / 2;
//			}

			//			}
		}


		override public function get width():Number {
			return 489;
		}

		override public function get height():Number {
			return 524;
		}

	}
}