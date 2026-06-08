const CACHE='tj-v3';
self.addEventListener('install',e=>e.waitUntil(self.skipWaiting()));
self.addEventListener('activate',e=>e.waitUntil(
  caches.keys()
    .then(ks=>Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k))))
    .then(()=>self.clients.claim())
));
self.addEventListener('fetch',e=>{
  if(e.request.method!=='GET')return;
  // HTML 페이지는 항상 네트워크 우선 (최신 코드 보장)
  if(e.request.mode==='navigate'){
    e.respondWith(fetch(e.request).catch(()=>caches.match(e.request)));
    return;
  }
  // 정적 에셋은 캐시 우선
  e.respondWith(caches.match(e.request).then(r=>r||fetch(e.request)).catch(()=>fetch(e.request)));
});
