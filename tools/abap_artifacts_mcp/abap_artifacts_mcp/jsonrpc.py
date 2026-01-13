from __future__ import annotations

import json
import sys
from dataclasses import dataclass
from typing import Any, Optional


@dataclass(frozen=True)
class JsonRpcRequest:
    id: Optional[str | int]
    method: str
    params: Any


_LAST_MESSAGE_FRAMED: Optional[bool] = None


def _read_exact(n: int) -> bytes:
    data = b""
    while len(data) < n:
        chunk = sys.stdin.buffer.read(n - len(data))
        if not chunk:
            return b""
        data += chunk
    return data


def read_message() -> Optional[dict[str, Any]]:
    """
    Reads either:
    - LSP-style framed JSON-RPC messages (Content-Length headers), or
    - newline-delimited JSON objects (one JSON per line).
    """
    global _LAST_MESSAGE_FRAMED
    while True:
        first = sys.stdin.buffer.readline()
        if not first:
            return None
        line = first.decode("utf-8", errors="replace").strip("\r\n")
        if line:
            break

    # LSP-style framing (allow Content-Type before Content-Length)
    if line.lower().startswith(("content-length:", "content-type:")):
        _LAST_MESSAGE_FRAMED = True
        content_length = None

        def handle_header(header_line: str) -> None:
            nonlocal content_length
            if header_line.lower().startswith("content-length:"):
                try:
                    content_length = int(header_line.split(":", 1)[1].strip())
                except ValueError:
                    content_length = None

        handle_header(line)

        # Consume remaining headers until blank line
        while True:
            header = sys.stdin.buffer.readline()
            if not header:
                return None
            if header in (b"\r\n", b"\n"):
                break
            handle_header(header.decode("utf-8", errors="replace").strip("\r\n"))

        if content_length is None:
            return None

        body = _read_exact(content_length)
        if not body:
            return None
        return json.loads(body.decode("utf-8", errors="replace"))

    # NDJSON fallback (first line is the JSON)
    _LAST_MESSAGE_FRAMED = False
    return json.loads(line)


def last_message_framed() -> Optional[bool]:
    return _LAST_MESSAGE_FRAMED


def write_response(payload: dict[str, Any]) -> None:
    body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
    if last_message_framed() is False:
        sys.stdout.buffer.write(body + b"\n")
    else:
        header = f"Content-Length: {len(body)}\r\n\r\n".encode("ascii")
        sys.stdout.buffer.write(header)
        sys.stdout.buffer.write(body)
    sys.stdout.buffer.flush()


def jsonrpc_result(*, id: str | int | None, result: Any) -> dict[str, Any]:
    return {"jsonrpc": "2.0", "id": id, "result": result}


def jsonrpc_error(*, id: str | int | None, code: int, message: str, data: Any = None) -> dict[str, Any]:
    err: dict[str, Any] = {"code": code, "message": message}
    if data is not None:
        err["data"] = data
    return {"jsonrpc": "2.0", "id": id, "error": err}
