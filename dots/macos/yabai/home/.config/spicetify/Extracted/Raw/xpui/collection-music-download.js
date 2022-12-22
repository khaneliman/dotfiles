"use strict";(("undefined"!=typeof self?self:global).webpackChunkopen=("undefined"!=typeof self?self:global).webpackChunkopen||[]).push([[4246],{54543:(e,a,t)=>{t.d(a,{q:()=>T});var r=t(67154),n=t.n(r),i=t(67294),s=t(69518),l=t.n(s),d=t(63495),c=t(36590),o=t(51079),m=t(47418),u=t(11186);const g=({name:e="",uri:a="",images:t=[],isHero:r,onClick:n,testId:s,index:l})=>r?i.createElement(m.Z,{featureIdentifier:"unknown",index:l,onClick:n,headerText:e,uri:a,isPlayable:!1,renderCardImage:()=>i.createElement(o.x,{isHero:r,images:t}),renderSubHeaderContent:()=>i.createElement(u.k,null),testId:s}):i.createElement(c.C,{index:l,featureIdentifier:"unknown",onClick:n,headerText:e,uri:a,isPlayable:!1,renderCardImage:()=>i.createElement(o.x,{isHero:r,images:t}),renderSubHeaderContent:()=>i.createElement("span",null),testId:s});var E=t(73425),p=t(143),I=t(64269),C=t(3634),f=t(89477),x=t(16061),y=t(46309),h=t(30523),b=t(52778),k=t(95332),v=t(46327);const T=({entity:e,index:a,testId:t,isHero:r=!1})=>{const s=(l().from(e.uri)||{}).type,c={testId:t,isHero:r,index:a,sharingInfo:e.sharingInfo};switch(s){case l().Type.ALBUM:case l().Type.COLLECTION_ALBUM:{const a=e;return i.createElement(C.r,n()({},c,{name:a.name,uri:a.uri,images:a.images,artists:a.artists}))}case l().Type.ARTIST:{const a=e;return i.createElement(f.I,n()({},c,{name:a.name,uri:a.uri,images:a.images}))}case l().Type.EPISODE:{var o,m;const a=e;return i.createElement(x.B,n()({},c,{name:a.name,uri:a.uri,images:a.images,showImages:(null===(o=a.show)||void 0===o?void 0:o.images)||[],durationMilliseconds:a.duration_ms,releaseDate:a.release_date,resume_point:a.resume_point,description:a.description,isExplicit:a.explicit,is19PlusOnly:!(null===(m=a.tags)||void 0===m||!m.includes("MOGEF-19+"))}))}case l().Type.PLAYLIST:case l().Type.PLAYLIST_V2:{var u,T;const a=e,t=(null===(u=a.owner)||void 0===u?void 0:u.display_name)||(null===(T=e.owner)||void 0===T?void 0:T.displayName)||"";return i.createElement(y.Z,n()({},c,{name:a.name,uri:a.uri,images:a.images,description:a.description,authorName:t}))}case l().Type.USER:return i.createElement(h.P,n()({},c,{name:e.name,uri:e.uri,images:e.images}));case l().Type.SHOW:{var w;const a=e;return i.createElement(k._,n()({},c,{name:a.name,uri:a.uri,images:a.images,publisher:a.publisher,mediaType:null!==(w={audio:p.E.AUDIO,video:p.E.VIDEO,mixed:p.E.MIXED}[a.media_type])&&void 0!==w?w:p.E.AUDIO}))}case l().Type.APPLICATION:return i.createElement(d.s,n()({},c,{name:e.name,uri:e.uri,images:e.images,description:e.description}));case l().Type.RADIO:return i.createElement(b.I,{testId:t,index:a,name:e.name,uri:e.uri,images:e.images});case l().Type.TRACK:{var H,N;const a=e;return i.createElement(v.G,n()({},c,{name:a.name,uri:a.uri,images:(null===(H=a.album)||void 0===H?void 0:H.images)||[],artists:a.artists,album:a.album,isExplicit:a.explicit,is19PlusOnly:null===(N=a.tags)||void 0===N?void 0:N.includes("MOGEF-19+")}))}case l().Type.COLLECTION:return e.uri.endsWith("your-episodes")?i.createElement(I.T,{index:a}):i.createElement(E.p,{index:a});default:return console.warn("Rendering a generic Card for unknown type:",s),i.createElement(g,n()({},c,{name:e.name,uri:e.uri,images:e.images}))}}},16061:(e,a,t)=>{t.d(a,{B:()=>O});var r=t(67154),n=t.n(r),i=t(67294),s=t(20657),l=t(18261),d=t(87257),c=t(57978),o=t(80418),m=t(34325),u=t(43315),g=t(49961),E=t(25988),p=t(36590),I=t(51079),C=t(6479),f=t.n(C),x=t(28760),y=t(97605),h=t(85392);const b="z4popIk32AsyDKlV1o1v",k="_xxuonqkZEQ7pCffxlUD",v=["src","description"],T=i.memo((e=>{const{src:a,description:t}=e,r=f()(e,v),[s,l]=(0,i.useState)("inherit");return(0,i.useEffect)((()=>{a&&async function(e){const{colorRaw:a}=await(0,h.b)(e),{h:t,s:r,l:n}=a.hsl,i=`hsl(${360*t}, ${100*r}%, ${Math.min(100*n,30)}%)`;l(i)}(a)}),[a]),a?i.createElement("div",{className:b,style:{backgroundColor:s},"data-testid":"episode-fallback-image-container"},i.createElement("div",{className:k},i.createElement(x.Dy,{as:"p",variant:"canon"},t))):i.createElement(y.J,n()({},r,{iconSize:64}))}));var w=t(47418),H=t(11186);const N="x1FErCk9Xh9VumpOLyfm",P="heeHk6hz8sAXLIU6P6an",S="Hhfi1xnYwoHoMP2rcltS",O=({description:e,isExplicit:a,images:t,name:r,uri:C,durationMilliseconds:f,releaseDate:x,resume_point:y,showImages:h,sharingInfo:b,is19PlusOnly:k,isHero:v,onClick:O,testId:_,index:D,requestId:L})=>{let q;const A=x?new Date(x):void 0,M=A&&!isNaN(A.getTime())&&!isNaN(f),z=(0,g.X)(h,{desiredSize:48}),F=(0,m.G3)(C,null==A?void 0:A.toISOString(),null==y?void 0:y.resume_position_ms,null==y?void 0:y.fully_played);return q=v?i.createElement(w.Z,{index:D,onClick:O,headerText:r,featureIdentifier:"episode",uri:C,isPlayable:!1,isDownloadable:!0,hasNewEpisodeIndicator:F,renderCardImage:()=>i.createElement(I.x,{isHero:!0,images:t,FallbackComponent:a=>i.createElement(T,n()({},a,{description:e,src:z&&z.url}))},z&&i.createElement(o.E,{loading:"lazy",src:z.url,className:N,radius:4})),renderSubHeaderContent:()=>i.createElement(i.Fragment,null,a&&!k&&i.createElement(d.N,{className:P}),k&&i.createElement(c.X,{size:16,className:P}),M&&i.createElement("span",{className:S},A&&(0,u.rL)(A)," ·"," ",s.ag.get("episode.length",Math.floor(f/6e4))),i.createElement(H.k,null,s.ag.get("card.tag.episode"))),testId:_,requestId:L}):i.createElement(p.C,{index:D,onClick:O,headerText:r,featureIdentifier:"episode",uri:C,isPlayable:!1,isDownloadable:!0,hasNewEpisodeIndicator:F,renderCardImage:()=>i.createElement(I.x,{images:t,FallbackComponent:a=>i.createElement(T,n()({},a,{description:e,src:z&&z.url}))},z&&i.createElement(o.E,{loading:"lazy",src:z.url,className:N,radius:4,testid:"episode-card-show-image"})),renderSubHeaderContent:()=>i.createElement(i.Fragment,null,a&&!k&&i.createElement(d.N,{className:P}),k&&i.createElement(c.X,{size:16,className:P}),M&&i.createElement("span",{className:S},A&&(0,u.rL)(A)," ·"," ",s.ag.get("episode.length",Math.floor(f/6e4)))),testId:_,requestId:L}),i.createElement(l._,{menu:i.createElement(E.k,{uri:C,sharingInfo:b})},q)}},63495:(e,a,t)=>{t.d(a,{s:()=>c});var r=t(67294),n=t(20657),i=t(36590),s=t(51079),l=t(47418),d=t(11186);const c=({name:e,uri:a,images:t,isHero:c,onClick:o,testId:m,description:u,index:g,requestId:E})=>c?r.createElement(l.Z,{featureIdentifier:"genre",index:g,onClick:o,headerText:e,uri:a,isPlayable:!1,renderCardImage:()=>r.createElement(s.x,{isHero:c,images:t}),renderSubHeaderContent:()=>r.createElement(d.k,null,u||n.ag.get("card.tag.genre")),testId:m,requestId:E}):r.createElement(i.C,{index:g,featureIdentifier:"genre",onClick:o,headerText:e,uri:a,isPlayable:!1,renderCardImage:()=>r.createElement(s.x,{isHero:c,images:t}),renderSubHeaderContent:()=>r.createElement("span",null,u||""),testId:m,requestId:E})},30523:(e,a,t)=>{t.d(a,{P:()=>E});var r=t(67154),n=t.n(r),i=t(67294),s=t(5843),l=t(20657),d=t(18261),c=t(43480),o=t(36590),m=t(51079),u=t(47418),g=t(11186);const E=i.memo((e=>{const{images:a,name:t,uri:r,onClick:E,isHero:p,testId:I,index:C,requestId:f}=e;let x;const y=(0,i.useCallback)((()=>i.createElement(m.x,{isCircular:!0,isHero:p,images:a,FallbackComponent:e=>i.createElement(s.a,n()({iconSize:64},e))})),[a,p]),h=(0,i.useCallback)((()=>p?i.createElement(g.k,null,l.ag.get("card.tag.profile")):l.ag.get("card.tag.profile")),[p]);return x=p?i.createElement(u.Z,{index:C,onClick:E,headerText:t,featureIdentifier:"profile",uri:r,isPlayable:!1,renderCardImage:y,renderSubHeaderContent:h,testId:I,requestId:f}):i.createElement(o.C,{index:C,onClick:E,headerText:t,featureIdentifier:"profile",uri:r,isPlayable:!1,renderCardImage:y,renderSubHeaderContent:h,testId:I,requestId:f}),i.createElement(d._,{menu:i.createElement(c.I,{uri:r})},x)}))},33377:(e,a,t)=>{t.r(a),t.d(a,{LibraryMusicDownloads:()=>u,default:()=>g});var r=t(67294),n=t(28760),i=t(20657),s=t(54543),l=t(1663),d=t(63926),c=t(42922),o=t(26010),m=t(37999);const u=r.memo((()=>{const{useOfflineEntities:e}=(0,r.useContext)(o.I),[a,t]=e();return t?r.createElement(l.h,{hasError:!1,errorMessage:i.ag.get("error.request-collection-music-downloads-failure")}):r.createElement(r.Fragment,null,r.createElement(n.Dy,{as:"h1",variant:"canon",className:m.Z.header},i.ag.get("music_downloads")),r.createElement(c.ZP,{value:"EntitiesGrid"},r.createElement(d.T,{render:()=>a.map(((e,a)=>r.createElement(c.ZP,{key:e.uri,value:"card",index:a},r.createElement(s.q,{entity:e,index:a}))))})))})),g=u}}]);
//# sourceMappingURL=collection-music-download.js.map