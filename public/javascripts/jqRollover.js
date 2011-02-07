/**
 * zudolab jqRollover
 *
 * @version    1
 * @copyright    (c)2008 Takeshi Takatsudo (http://zudolab.net/)
 * @license    MIT (http://www.opensource.org/licenses/mit-license.php)
 */
(function(a){jqRollover=function(b){this.selector=b;this.elemSets=[];var c=this;a(function(){c.setup()})};jqRollover.prototype.setup=function(){this.prepareSets();if(!this.elemSets){return}this.preploadImgs();this.setEvents()};jqRollover.prototype.prepareSets=function(){var b=this;var c=a(b.selector);if(!c){return}c.each(function(){var d=a(this).find("img").eq(0).get(0);var f=d.src;if(f.indexOf("/off/")==-1){return}var e=f;var g=f.replace(/\/off\//,"/on/");b.elemSets.push({anchor:this,img:d,srcOff:e,srcOn:g})})};jqRollover.prototype.setEvents=function(){var b=this;for(var d=0,f;f=this.elemSets[d];d++){a(f.anchor).mouseover(function(){c(this)}).focus(function(){c(this)}).mouseout(function(){e(this)}).blur(function(){e(this)})}function c(h){var g=b.getElemSetFromAnchor(h);g.img.src=g.srcOn}function e(h){var g=b.getElemSetFromAnchor(h);g.img.src=g.srcOff}};jqRollover.prototype.preploadImgs=function(){for(var b=0,c;c=this.elemSets[b];b++){(new Image).src=c.srcOn}};jqRollover.prototype.getElemSetFromAnchor=function(b){for(var c=0,d;d=this.elemSets[c];c++){if(d.anchor==b){return d}}}})(jQuery);