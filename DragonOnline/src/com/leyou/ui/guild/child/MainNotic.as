package com.leyou.ui.guild.child {

	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class MainNotic extends AutoSprite {

		private var contentLbl:TextArea;
		private var editBtn:NormalButton;
		private var lastTimeLbl:Label;

		private var editState:Boolean=false;

		public function MainNotic() {
			super(LibManager.getInstance().getXML("config/ui/guild/mainNotic.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.contentLbl=this.getUIbyID("contentLbl") as TextArea;
			this.editBtn=this.getUIbyID("editBtn") as NormalButton;
			this.lastTimeLbl=this.getUIbyID("lastTimeLbl") as Label;

			this.contentLbl.visibleOfBg=false;
			this.editBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.contentLbl.tf.wordWrap=true;
			this.contentLbl.tf.multiline=true;

			this.contentLbl.width=590;

//			this.contentLbl.tf.defaultTextFormat.size=18;
			this.contentLbl.tf.defaultTextFormat=new TextFormat("微软雅黑",18,null,null,null,null,null,null,null,null,null,null,2);
			this.contentLbl.tf.maxChars=700;
			 
			this.contentLbl.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.contentLbl.addEventListener(Event.CHANGE, onKeyDown);

//			this.contentLbl.addEventListener(MouseEvent.CLICK,onLbL);
//			this.contentLbl.editable=false;

			this.x-=10;
		}

		private function onLbL(e:Event):void {
			this.stage.focus=this.contentLbl.tf;
		}

		private function onKeyDown(e:Event):void {

			this.updateContent();
			e.stopImmediatePropagation();
		}

		private function updateContent():void {

//				trace(this.contentLbl.tf.numLines,"line")
//				
//				if(this.contentLbl.tf.numLines==10)
//				trace(this.contentLbl.tf.getLineLength(9),this.contentLbl.tf.getLineOffset(9),this.contentLbl.tf.getLineText(9));

			var str:String;
			if (this.contentLbl.tf.numLines >= 7) {
				str=this.contentLbl.tf.text.substring(0, this.contentLbl.tf.getLineOffset(6) + this.contentLbl.tf.getLineLength(6));
			} else {
				str=this.contentLbl.tf.text;
			}

			this.contentLbl.tf.text=StringUtil_II.getGuildFilterWord(str);
		}

		private function onKeyUp(e:KeyboardEvent):void {
			e.stopImmediatePropagation();
		}

		private function onClick(e:MouseEvent):void {

			if (this.editState) {

				if (this.contentLbl.text != "") {
					Cmd_Guild.cm_GuildEditNotice(UIManager.getInstance().guildWnd.guildId, 1, this.contentLbl.text);
				}

				this.editBtn.text=PropUtils.getStringById(1753);
				this.contentLbl.editable=false;

			} else {

				this.editBtn.text=PropUtils.getStringById(1742);

				this.contentLbl.editable=true;
				this.stage.focus=this.contentLbl.tf;
			}

			this.editState=!this.editState;
		}

		public function setEidtBtnState(v:Boolean):void {
			this.editBtn.visible=(v);
		}

		public function updateInfo(o:Object):void {

			var str:String=o.notice;
			str=str.replace(/\\r/g, "\r");

			this.contentLbl.editable=true;
			this.contentLbl.setText(str + "");
			this.contentLbl.editable=false;

			this.updateContent();
			this.lastTimeLbl.text="" + o.time;
			this.editBtn.text=PropUtils.getStringById(1753);

//			this.editBtn.text=" ";
//			this.editBtn.width=200;

			this.editState=false;
		}

	}
}
