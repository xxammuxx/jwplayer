package com.longtailvideo.jwplayer.view.components {
	import com.longtailvideo.jwplayer.model.Color;
	import com.longtailvideo.jwplayer.view.interfaces.ISkin;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	
	public class TooltipMenu extends TooltipOverlay {
		private var menuTop:DisplayObject;
		private var options:Vector.<TooltipOption>;
		private var outFormat:TextFormat;
		private var overFormat:TextFormat;
		private var activeFormat:TextFormat;
		private var settings:Object;
		private var clickHandler:Function;
		
		public function TooltipMenu(name:String, skin:ISkin, click:Function=null) {
			super(skin);
			
			options = new Vector.<TooltipOption>;
			
			menuTop = getSkinElement('menuTop'+name);
			addChild(menuTop);
			
			clickHandler = click;
			
			settings = {
				fontcase: null,
				fontcolor: 0xffffff,
				fontsize: 12,
				fontweight: null,
				activecolor: 0xffffff,
				overcolor: 0xffffff
			};
			
			for (var prop:String in settings) {
				if (getSkinSetting(prop)) {
					settings[prop] = getSkinSetting(prop);
				}
			} 
			
			
			outFormat = new TextFormat("_sans");
			outFormat.size = settings.fontsize;
			outFormat.color = new Color(settings.fontcolor).color;
			outFormat.bold = (String(settings.fontweight).toLowerCase() == "bold");

			overFormat = new TextFormat();
			overFormat.color = new Color(settings.overcolor).color;

			activeFormat = new TextFormat();
			activeFormat.color = new Color(settings.activecolor).color;

		}
		
		public function addOption(label:String, value:*):void {
			var option:TooltipOption = new TooltipOption(getSkinElement('menuOption'), getSkinElement('menuOptionOver'), getSkinElement('menuOptionActive'), 
														 outFormat, overFormat, activeFormat, 
														 (String(settings.fontcase).toLowerCase() == "upper"));
			option.y = menuTop.height + options.length * option.height;
			option.label = label;
			options.push(option);
			option.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void {
				if (clickHandler is Function) {
					clickHandler(value);
				}
			});
			addChild(option);
		}
		
		public function setActive(index:Number):void {
			if (index >= 0 && index < options.length) {
				for (var i:Number=0; i < options.length; i++) {
					options[i].active = (i == index);
				}
			}			
		}
		
		public function clearOptions():void {
			var i:TooltipOption;
			while(i = options.pop()) {
				removeChild(i);
			}
			this.height = menuTop.height;
		}
		
		override protected function resize(width:Number, height:Number):void {
			super.resize(width, height);			
		} 

	}

	

}

import flash.display.*;
import flash.events.*;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

internal class TooltipOption extends Sprite {
	private var outBack:DisplayObject;
	private var overBack:DisplayObject;
	private var activeBack:DisplayObject;
	private var isActive:Boolean = false;
	private var outFormat:TextFormat;
	private var overFormat:TextFormat;
	private var activeFormat:TextFormat;
	private var allcaps:Boolean = false;
	private var text:TextField;
	
	public function TooltipOption(out:DisplayObject, over:DisplayObject, active:DisplayObject, 
								  outFormat:TextFormat, overFormat:TextFormat, activeFormat:TextFormat, caps:Boolean):void {
		outBack = out;
		overBack = over;
		activeBack = active;
		this.outFormat = outFormat;
		this.overFormat = overFormat;
		this.activeFormat = activeFormat;
		this.allcaps = caps;
		
		addChild(outBack);
		mouseChildren = false;
		if (overBack) {
			overBack.visible = false;
			addChild(overBack);
			addEventListener(MouseEvent.MOUSE_OVER, overHandler);			
			addEventListener(MouseEvent.MOUSE_OUT, outHandler);			
		}
		if (activeBack) {
			activeBack.visible = false;
			addChild(activeBack);
		}
		text = new TextField();
		text.defaultTextFormat = outFormat;
		text.height = outBack.height;
		text.autoSize = TextFieldAutoSize.LEFT;
		text.x = outBack.width;
		addChild(text);
	}
	
	private function overHandler(evt:MouseEvent):void {
		if (isActive) return;
		if (outBack && overBack) {
			outBack.visible = false;
			overBack.visible = true;
		}
		text.textColor = overFormat.color as uint;
	}
	
	private function outHandler(evt:MouseEvent):void {
		if (isActive) return;
		if (outBack && overBack) {
			outBack.visible = true;
			overBack.visible = false;
		}
		text.textColor = outFormat.color as uint;
	}
	
	public function set label(s:String):void {
		if (allcaps) s = s.toUpperCase();
		text.text = s;
	}
	
	public function set value(v:*):void {
	}
	
	public function set active(a:Boolean):void {
		isActive = a;
		if (activeBack) {
			isActive = a;
			activeBack.visible = isActive;
			outBack.visible = !isActive;
			overBack.visible = false;
		}
		text.textColor = uint(isActive ? activeFormat.color : outFormat.color);
	} 
	
}