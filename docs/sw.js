const CACHE='tj-v6';
self.addEventListener('install',e=>e.waitUntil(self.skipWaiting()));
self.addEventListener('activate',e=>e.waitUntil(
  caches.keys()
    .then(ks=>Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k))))
    .then(()=>self.clients.claim())
));
self.addEventListener('fetch',e=>{
  if(e.request.method!=='GET')return;
  const url=new URL(e.request.url);
  // Firebase 동기화 요청은 캐시 대상 아님 (실시간 데이터)
  if(url.hostname.endsWith('firebasedatabase.app'))return;
  // HTML 페이지는 항상 네트워크 우선 (최신 코드 보장) + 성공 응답은 오프라인 대비 저장
  if(e.request.mode==='navigate'){
    e.respondWith(
      fetch(e.request).then(res=>{
        if(res.ok){const cp=res.clone();caches.open(CACHE).then(c=>c.put(e.request,cp));}
        return res;
      }).catch(()=>caches.match(e.request))
    );
    return;
  }
  // 같은 출처 정적 에셋(아이콘·레시피 이미지 등)은 캐시 우선 + 최초 응답 저장
  if(url.origin===location.origin){
    e.respondWith(
      caches.match(e.request).then(r=>r||fetch(e.request).then(res=>{
        if(res.ok){const cp=res.clone();caches.open(CACHE).then(c=>c.put(e.request,cp));}
        return res;
      }))
    );
  }
});
