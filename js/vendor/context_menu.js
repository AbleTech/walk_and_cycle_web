/*
  ContextMenu v1.0

  A context menu for Google Maps API v3
  http://code.martinpearman.co.uk/googlemapsapi/contextmenu/

  Copyright Martin Pearman
  Last updated 21st November 2011

  developer@martinpearman.co.uk

  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
function ContextMenu(e,t){t=t||{},this.setMap(e),this.classNames_=t.classNames||{},this.map_=e,this.mapDiv_=e.getDiv(),this.menuItems_=t.menuItems||[],this.pixelOffset=t.pixelOffset||new google.maps.Point(10,-5)}ContextMenu.prototype=new google.maps.OverlayView,ContextMenu.prototype.draw=function(){if(this.isVisible_){var e=new google.maps.Size(this.mapDiv_.offsetWidth,this.mapDiv_.offsetHeight),t=new google.maps.Size(this.menu_.offsetWidth,this.menu_.offsetHeight),i=this.getProjection().fromLatLngToDivPixel(this.position_),s=i.x,n=i.y;i.x>e.width-t.width-this.pixelOffset.x?s=s-t.width-this.pixelOffset.x:s+=this.pixelOffset.x,i.y>e.height-t.height-this.pixelOffset.y?n=n-t.height-this.pixelOffset.y:n+=this.pixelOffset.y,this.menu_.style.left=s+"px",this.menu_.style.top=n+"px"}},ContextMenu.prototype.getVisible=function(){return this.isVisible_},ContextMenu.prototype.hide=function(){this.isVisible_&&(this.menu_.style.display="none",this.isVisible_=!1)},ContextMenu.prototype.onAdd=function(){function e(e){var t=document.createElement("li");return t.innerHTML=e.label,e.className&&(t.className=e.className),e.id&&(t.id=e.id),t.style.cssText="cursor:pointer; white-space:nowrap",t.onclick=function(){google.maps.event.trigger(i,"menu_item_selected",i.position_,e.eventName)},t}function t(){var e=document.createElement("li");return i.classNames_.menuSeparator&&(e.className=i.classNames_.menuSeparator),e}var i=this,s=document.createElement("ul");this.classNames_.menu&&(s.className=this.classNames_.menu),s.style.cssText="display:none; position:absolute";for(var n=0,o=this.menuItems_.length;o>n;n++)this.menuItems_[n].label&&this.menuItems_[n].eventName?s.appendChild(e(this.menuItems_[n])):s.appendChild(t());delete this.classNames_,delete this.menuItems_,this.isVisible_=!1,this.menu_=s,this.position_=new google.maps.LatLng(0,0),google.maps.event.addListener(this.map_,"click",function(){i.hide()}),this.getPanes().floatPane.appendChild(s)},ContextMenu.prototype.onRemove=function(){this.menu_.parentNode.removeChild(this.menu_),delete this.mapDiv_,delete this.menu_,delete this.position_},ContextMenu.prototype.show=function(e){this.isVisible_||(this.menu_.style.display="block",this.isVisible_=!0),this.position_=e,this.draw()};