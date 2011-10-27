SC.stringsFor("English",{});CC=SC.Object.create({NAMESPACE:"CC",VERSION:"0.1.0"});
CC.Question=SC.Object.extend({prompt:"This is a prompt",input:"This in an input"});
CC.AppletView=SC.View.extend({jarUrls:"",code:"",params:"",codebase:"",width:600,height:400,appletInstance:function(){return this.$("#"+this.get("appletId"))[0]
},render:function(a,b){this.renderAppletHtml(a)},renderAppletHtml:function(b){var a=b.begin("applet");
a.attr("id",this.get("appletId"));a.attr("archive",this.get("jarUrls"));a.attr("code",this.get("code"));
a.attr("codebase",this.get("codebase"));a.attr("width","100%");a.attr("height",this.get("height"));
a.attr("MAYSCRIPT","true");a.push(this.get("params"));a.end()},classNames:"applet",layout:{centerX:0,centerY:0,width:600,height:400},appletId:function(){return this.get("layerId")+"-applet"
}.property("layerId").cacheable(),run:function(a){a(this.appletInstance())}});CC.AutoScrollView=SC.ScrollView.extend({autoScrollTrigger:null,autoScroll:function(){var a=this;
function b(){var c=a.get("maximumVerticalScrollOffset");a.set("verticalScrollOffset",c)
}a.invokeLast(function(){a.invokeLast(b)})}.observes("autoScrollTrigger")});CC.QuestionView=SC.StackedView.extend(SC.StaticLayout,{layout:{top:0,left:0,right:0},classNames:["question","open-response-question"],contentDisplayProperties:"prompt".w(),prompt:"[prompt]",useStaticLayout:NO,childViews:"promptView inputView".w(),promptView:SC.LabelView.design(SC.StaticLayout,{classNames:"question-prompt",useStaticLayout:YES,escapeHTML:NO,layout:{left:5,right:5},valueBinding:"*parentView.prompt"}),inputView:SC.View.design(SC.StaticLayout,{layout:{left:20,top:5,width:600,height:95},useStaticLayout:YES,childViews:"textFieldView".w(),textFieldView:SC.TextFieldView.design({classNames:"question-input",isTextArea:YES})})});
require("views/question");CC.MultipleChoiceQuestionView=CC.QuestionView.extend({classNames:["question","multiple-choice-question"],choices:"1 2 3 4".w(),canSelectMultipleAnswers:NO,inputView:SC.RadioView.design(SC.StaticLayout,{layout:{left:20,top:5,width:600,height:95},useStaticLayout:YES,classNames:"question-input",itemsBinding:"*parentView.choices",itemsChanged:function(){this.replaceLayer()
}.observes("items")})});CC.MwAppletView=CC.AppletView.extend({cmlUrl:"",params:function(){return'<param name="script" value="page:0:import '+this.get("cmlUrl")+'"/>'
}.property("cmlUrl"),jarUrls:"http://mw2.concord.org/public/lib/mwapplet.jar",code:"org.concord.modeler.MwApplet",width:600,height:400,classNames:"mw-applet",layout:{centerX:0,centerY:0,width:600,height:400}});
sc_require("views/applet");CC.SensorAppletView=CC.AppletView.extend({listenerPath:"defaultDataListener",safariSensorStatePath:null,dataReceived:function(a,c,b){},dataStreamEvent:function(a,c,b){},sensorsReady:function(){},render:function(a,b){arguments.callee.base.apply(this,arguments);
this.startSensorAppletInitialization()},_sensorAppletTimer:false,startSensorAppletInitialization:function(){var a=this;
window.setTimeout(function(){a.initializeSensorInterface()},250)},initializeSensorInterface:function(){var d=this.get("listenerPath");
var b=this.appletInstance();var c=NO;try{c=b.initSensorInterface(d)}catch(f){}if(c){if(this._sensorAppletTimer){window.clearInterval(this._sensorAppletTimer);
this._sensorAppletTimer=false}this.set("sensorsReady",YES)}else{if(!this._sensorAppletTimer){var a=this;
this._sensorAppletTimer=window.setInterval(function(){a.initializeSensorInterface()
},250)}}},resourcePath:"/distance.otml",isSafari:function(){if(typeof navigator!=="undefined"&&typeof navigator.vendor!=="undefined"&&navigator.vendor.indexOf("Apple")!=-1){return YES
}return NO}(),sensorStatePath:function(){if(this.get("isSafari")){return this.get("safariSensorStatePath")
}return null}.property("isSafari","safariSensorStatePath"),sensorState:"ready",params:function(){var a=['<param name="resource" value="'+this.get("resourcePath")+'" />','<param name="listenerPath" value="'+this.get("listenerPath")+'" />','<param name="name" value="'+this.get("appletId")+'" />'];
if(this.get("sensorStatePath")!==null){a.pushObject('<param name="sensorStatePath" value="'+this.get("sensorStatePath")+'" />')
}return a.join("")}.property("resourcePath"),jarUrls:["org/concord/sensor-native/sensor-native.jar","org/concord/otrunk/otrunk.jar","org/concord/framework/framework.jar","org/concord/frameworkview/frameworkview.jar","jug/jug/jug.jar","jdom/jdom/jdom.jar","org/concord/sensor/sensor.jar","org/concord/data/data.jar","org/concord/sensor/sensor-applets/sensor-applets.jar"].join(", "),codebase:"/jnlp",code:"org.concord.sensor.applet.OTSensorApplet",width:160,height:40,classNames:"sensor-applet",layout:{centerX:0,centerY:0,width:160,height:40},start:function(){this.set("sensorState","running");
if(this.get("isSafari")==NO||this.get("sensorStatePath")===null){return this._tryToStartApplet()
}},stop:function(){this.set("sensorState","stopped");if(this.get("isSafari")==NO||this.get("sensorStatePath")===null){return this._tryToStopApplet()
}},reset:function(){this.set("sensorState","ready");if(this.get("isSafari")==NO||this.get("sensorStatePath")===null){return this._tryToStopApplet()
}},_tryToStopApplet:function(){var a=this.appletInstance();try{a.stopCollecting();
return YES}catch(b){return NO}},_tryToStartApplet:function(){var a=this.appletInstance();
try{a.startCollecting();return YES}catch(b){return NO}}});if((typeof SC!=="undefined")&&SC&&SC.bundleDidLoad){SC.bundleDidLoad("cc/cc")
};