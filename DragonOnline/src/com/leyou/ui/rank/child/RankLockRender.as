package com.leyou.ui.rank.child
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAchievementInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.achievement.child.AchievementEraItem;
	import com.leyou.utils.PropUtils;
	
	//榜未开启
	public class RankLockRender extends AutoSprite
	{
		private var titleImg:Image;
		
		private var thresholdLbl:Label;
		
		private var achievement:AchievementEraItem;
		
		private var _type:int = -1;
		
		public function RankLockRender(){
			super(LibManager.getInstance().getXML("config/ui/rank/rankLock.xml"));
			init();
		}
		
		public function init():void{
			titleImg = getUIbyID("titleImg") as Image;
			thresholdLbl = getUIbyID("thresholdLbl") as Label;
			achievement = new AchievementEraItem();
			addChild(achievement);
			achievement.x = 65;
			achievement.y = 272;
		}
		
		// (1总战斗力 2坐骑 3翅膀 4装备 5军衔 6等级 7财富)
		public function updateInfo(type:int):void{
			if(_type == type){
				return;
			}
			_type = type;
			var rankType:String;
			var titleUrl:String = "ui/rank/rank_{num}.png";
			var achievementId:int;
			switch(_type){
				case 1:
					rankType = PropUtils.getStringById(1528);
					achievementId = ConfigEnum.rank1;
					titleUrl = StringUtil.substitute(titleUrl, 2);
					break;
				case 2:
					rankType = PropUtils.getStringById(1859);
					achievementId = ConfigEnum.rank3;
					titleUrl = StringUtil.substitute(titleUrl, 4);
					break;
				case 3:
					rankType = PropUtils.getStringById(1786);
					achievementId = ConfigEnum.rank4;
					titleUrl = StringUtil.substitute(titleUrl, 5);
					break;
				case 4:
					rankType = PropUtils.getStringById(1609);
					achievementId = ConfigEnum.rank2;
					titleUrl = StringUtil.substitute(titleUrl, 3);
					break;
				case 5:
					rankType = PropUtils.getStringById(1860);
					achievementId = ConfigEnum.rank5;
					titleUrl = StringUtil.substitute(titleUrl, 6);
					break;
				case 6:
					rankType = PropUtils.getStringById(1868);
					achievementId = ConfigEnum.rank7;
					titleUrl = StringUtil.substitute(titleUrl, 1);
					break;
				case 7:
					rankType = PropUtils.getStringById(1861);
					achievementId = ConfigEnum.rank8;
					titleUrl = StringUtil.substitute(titleUrl, 7);
					break;
			}
			titleImg.updateBmp(titleUrl);
			var achievementInfo:TAchievementInfo = TableManager.getInstance().getAchievementInfo(achievementId);
			var content:String = TableManager.getInstance().getSystemNotice(5810).content;
			thresholdLbl.text = StringUtil.substitute(content, achievementInfo.name, rankType);
			achievement.updateForRank(achievementInfo);
		}
	}
}