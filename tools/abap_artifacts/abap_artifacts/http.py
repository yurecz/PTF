from __future__ import annotations

from dataclasses import dataclass
from typing import Optional
from urllib.parse import urlparse

import requests

from .auth import Credentials


@dataclass(frozen=True)
class FetchResult:
    url: str
    status_code: int
    content_type: str
    text: str


def _same_origin(a: str, b: str) -> bool:
    pa = urlparse(a)
    pb = urlparse(b)
    return (pa.scheme, pa.netloc) == (pb.scheme, pb.netloc)


def fetch_text(
    *,
    url: str,
    creds: Optional[Credentials] = None,
    timeout_s: int = 30,
    verify_tls: bool = True,
    accept: str = "text/plain, text/html;q=0.9, */*;q=0.1",
) -> FetchResult:
    headers = {"Accept": accept}
    auth = None
    if creds is not None:
        if not _same_origin(url, creds.base_url):
            raise ValueError(f"Refusing to send credentials to different origin: {url}")
        auth = (creds.user, creds.password)

    resp = requests.get(url, headers=headers, auth=auth, timeout=timeout_s, verify=verify_tls)
    content_type = resp.headers.get("content-type", "")
    resp.encoding = resp.apparent_encoding or resp.encoding
    return FetchResult(url=url, status_code=resp.status_code, content_type=content_type, text=resp.text)

