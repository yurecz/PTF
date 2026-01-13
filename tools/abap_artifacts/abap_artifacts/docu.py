from __future__ import annotations

from typing import Optional
from urllib.parse import urlencode

from .http import FetchResult, fetch_text


def fetch_keyword_docu(
    *,
    base_url: str,
    object_id: str,
    lang: str = "EN",
    client: str = "000",
    tree: str = "X",
    version: str = "X",
    verify_tls: bool = True,
) -> FetchResult:
    url = f"{base_url.rstrip('/')}/sap/public/bc/abap/docu?{urlencode({'sap-language': lang, 'tree': tree, 'version': version, 'sap-client': client, 'object': object_id})}"
    return fetch_text(url=url, creds=None, verify_tls=verify_tls, accept="text/html, */*;q=0.1")

