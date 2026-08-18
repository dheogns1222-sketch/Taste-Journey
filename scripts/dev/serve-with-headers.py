# 로컬 프리뷰: docs/ 를 서빙하면서 docs/vercel.json 의 headers 를 그대로 붙인다 (CSP 검증용).
# 실행: python scripts/dev/serve-with-headers.py [port]
import json, sys, os
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DOCS = os.path.join(ROOT, 'docs')
with open(os.path.join(DOCS, 'vercel.json'), encoding='utf-8') as f:  # Vercel Root Directory = docs
    HEADERS = [(h['key'], h['value']) for rule in json.load(f).get('headers', []) for h in rule['headers']]

class H(SimpleHTTPRequestHandler):
    def __init__(self, *a, **k): super().__init__(*a, directory=DOCS, **k)
    def end_headers(self):
        for k, v in HEADERS: self.send_header(k, v)
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()

port = int(sys.argv[1]) if len(sys.argv) > 1 else 8123
print(f'serving {DOCS} on http://localhost:{port} with {len(HEADERS)} vercel headers')
ThreadingHTTPServer(('', port), H).serve_forever()
